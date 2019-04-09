-- --------------------------------------------------------
-- Servidor:                     cm-kls.cluster-cu0eljf5y2ht.us-east-1.rds.amazonaws.com
-- Versão do servidor:           5.6.10-log - MySQL Community Server (GPL)
-- OS do Servidor:               Linux
-- HeidiSQL Versão:              10.1.0.5484
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Copiando estrutura para procedure prod_kls.PRC_CONTEUDO_AMP_VINC
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_CONTEUDO_AMP_VINC`()
BEGIN

	DECLARE ID_LOG_       INT(10);
	DECLARE CODE_         VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_          VARCHAR(200);
	DECLARE REGISTROS_    BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME INT;
	DECLARE FUSOHORARIO INT DEFAULT 10800;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN

		GET DIAGNOSTICS CONDITION 1
		CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
		
		SET CODE_ = CONCAT('ERRO - ', CODE_);

	END;

	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT DATABASE(), 'PRC_CONTEUDO_AMP_VINC', USER(), SYSDATE(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();

   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;	

	DROP TABLE IF EXISTS tbl_tmp_aula_vinc ;
	
	CREATE TABLE tbl_tmp_aula_vinc (
				ID                BIGINT(10),
				DISCIPLINA        VARCHAR(200),
				CS_SHORTNAME      VARCHAR(50),
				TURMA             VARCHAR(100),
				ENCONTRO          SMALLINT,
				GRUPO             BIGINT(10),
				PROFESSORES       BIGINT(10),
				INDEX idx_cs_shortname (CS_SHORTNAME),
				INDEX idx_encontro (CS_SHORTNAME, TURMA, ENCONTRO, GRUPO)
	);
	
	DROP TABLE IF EXISTS tbl_tmp_conteudo_vinc_vinculado;
	
	CREATE TABLE tbl_tmp_conteudo_vinc_vinculado(
						COURSE     		BIGINT(10),
						GROUPID    		BIGINT(10),
						ENCONTRO       BIGINT(10),
						PROFESSOR  		BIGINT(10),
						QTE_CONTEUDO   SMALLINT,
						INDEX idx_course (COURSE, GROUPID)
	);
	

	DROP TABLE IF EXISTS tbl_tmp_conteudo_vinc ;

	CREATE TABLE tbl_tmp_conteudo_vinc (
												DISCIPLINA        VARCHAR(200),
												TURMA             VARCHAR(100),
												ENCONTRO          BIGINT(10),
												CS_SHORTNAME      VARCHAR(255),
												PROFESSOR         BIGINT(10),
												QTD_CONT          SMALLINT
											);
	
	DROP TABLE IF EXISTS tbl_conteudo_amp_novo;
	
	CREATE TABLE tbl_conteudo_amp_novo(
												REGIONAL       VARCHAR(100),
												NOME_INST      VARCHAR(200),
												COD_INST       VARCHAR(100),
												PROFESSOR      LONGTEXT,
												COORDENADOR    LONGTEXT,
												COD_CURSO      VARCHAR(100),
												CURSO          VARCHAR(100),
												COD_TURMA      VARCHAR(100),
												SERIE          VARCHAR(100),
												DISCIPLINA     VARCHAR(200),
												TURMA          VARCHAR(100),
												ENCONTRO       SMALLINT,
												QTD_CONTEUDO   SMALLINT,
												CARGA_HORARIA  SMALLINT,
												PRI_ACESSO_PR  VARCHAR(50),
												ULT_ACESSO_PR  VARCHAR(50),
												PRI_ACESSO_CD  VARCHAR(50),
												ULT_ACESSO_CD  VARCHAR(50),
												SHORTNAME 		VARCHAR(50)
											);

   DROP TABLE IF EXISTS carga_base_professor_coord;
 
    CREATE TABLE carga_base_professor_coord (
					PROFESSOR_ID               BIGINT, 
               PROFESSOR_LOGIN            VARCHAR(100), 
               PROFESSOR_EMAIL            VARCHAR(100), 
               COURSE                 		BIGINT,
					GROUP_ID           	  		BIGINT, 
               PROFESSOR_DataVinculo      VARCHAR(100),
               PROFESSOR_NOME             VARCHAR(200),
               PROFESSOR_PrimeiroAcesso   VARCHAR(100),
               PROFESSOR_UltimoAcesso     VARCHAR(100),
					ROLEID			 				int,
					INDEX idx_CUR_BT (COURSE, GROUP_ID),
					INDEX idx_GROUP_BT (GROUP_ID)
					);
 
	INSERT INTO carga_base_professor_coord (PROFESSOR_ID ,
														 PROFESSOR_LOGIN,
														 PROFESSOR_EMAIL,
														 COURSE,
														 GROUP_ID,
														 PROFESSOR_DataVinculo,
														 PROFESSOR_NOME ,
														 PROFESSOR_PrimeiroAcesso,
														 PROFESSOR_UltimoAcesso,
														 ROLEID
													)
							                SELECT DISTINCT u.id AS PROFESSOR_ID, u.username AS PROFESSOR_LOGIN, u.email AS PROFESSOR_EMAIL, 
												 					  c.id AS COURSE, g.id AS GROUP_ID, 
							               					  DATE_FORMAT(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO),'%d/%m/%Y %H:%i:%s') AS PROFESSOR_DataVinculo,
							                                UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS PROFESSOR_NOME,
											           			  IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO), 'Nunca Acessou') AS PROFESSOR_PrimeiroAcesso,
																	  IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO), 'Nunca Acessou')	AS PROFESSOR_UltimoAcesso,
                                              		  ra.roleid AS ROLEID
							        FROM mdl_course c
							        JOIN mdl_context ct ON ct.instanceid = c.id AND ct.contextlevel = 50
							        JOIN mdl_course_categories cc ON cc.id = c.category
							        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
							        JOIN mdl_role r on r.id=ra.roleid and r.shortname in ('coordteacher','editingteacher')
							        JOIN mdl_user u ON u.id = ra.userid
							        JOIN mdl_groups g ON g.courseid = c.id
							        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
							        LEFT JOIN tbl_login l ON l.USERID=u.id AND l.COURSE=c.id
									  WHERE c.shortname REGEXP '^AMP|^HAMP|^ESTP|^TCCP'
									  GROUP BY c.id, g.id, r.id;
	

	INSERT INTO tbl_tmp_aula_vinc 
	SELECT DISTINCT c.id,
						 c.fullname AS 'Disciplina',
						 c.shortname,
						 g.description AS 'Turma',
						 if(c.shortname REGEXP '^HAMP',cs.section-1,cs.section) AS 'Encontro',
						 g.id AS grupo,
							 (
							 	SELECT GROUP_CONCAT(u.id)
							 	FROM kls_lms_turmas tu
							 	JOIN kls_lms_pessoa_turma pt on pt.id_turma=tu.id_turma and pt.fl_etl_atu REGEXP '[NA]'
							 	JOIN kls_lms_pessoa_curso_disc pcd on pt.id_pes_cur_disc=pcd.id_pes_cur_disc and pcd.fl_etl_atu REGEXP '[NA]'  
							 	JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
							 	JOIN kls_lms_pessoa p on pcd.id_pessoa=p.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
								JOIN tbl_mdl_user u ON p.login=u.username								 	
							 	WHERE tu.id_turma=t.id_turma 
							 ) as professores
	FROM mdl_course c
	INNER JOIN mdl_course_sections cs ON cs.course = c.id AND cs.section>0 AND cs.section<=17
	INNER JOIN mdl_course_modules cm ON cm.course = c.id AND 
													cm.section = cs.id AND
													cm.deletioninprogress=0 AND
													cm.visible=1
	INNER JOIN mdl_modules m ON m.id=cm.module AND m.NAME='label'
	INNER JOIN mdl_groups g ON g.courseid = c.id
	INNER JOIN mdl_groups_members gm ON gm.groupid = g.id
	JOIN kls_lms_turmas t on t.shortname=g.description and t.fl_etl_atu<>'E'
	WHERE  c.shortname REGEXP '^AMP|^TCCP|^ESTP|^HAMP' AND c.visible = 1;

-- (4 min 12.78 sec)
			
	INSERT INTO tbl_tmp_conteudo_vinc_vinculado
						SELECT cs.course AS courseid,
								 tcc.groupid 			AS groupid,
								 if(c.shortname REGEXP '^HAMP',cs.section-1,cs.section) 	AS encontroid,
								 null 			AS professor,
								 	count(distinct tcc.contentid) AS qte_conteudo
						FROM mdl_teacher_class_content tcc
						JOIN mdl_course c on c.id=tcc.courseid
						JOIN mdl_course_sections cs ON cs.id=tcc.sectionid 
						GROUP BY cs.course, tcc.groupid, cs.section;

-- (3.30 sec)
		
		CREATE INDEX idx_aula ON tbl_tmp_aula_vinc  (ID, ENCONTRO, GRUPO);
		CREATE INDEX idx_aula_turma ON tbl_tmp_aula_vinc  (TURMA);
		CREATE INDEX idx_matcomplvinc ON tbl_tmp_conteudo_vinc_vinculado (COURSE, ENCONTRO, GROUPID);
		
-- (0.61 sec)

		INSERT INTO tbl_tmp_conteudo_vinc 
			SELECT aula.Disciplina,
					 aula.Turma,
					 aula.Encontro,
					 aula.CS_SHORTNAME,
					 tbl.PROFESSOR_NOME professor,
					 IFNULL(conteu_vinc.qte_conteudo, 0) AS QuantidadeConteudo
			  FROM tbl_tmp_aula_vinc  aula
			  JOIN carga_base_professor_coord tbl on tbl.GROUP_ID = aula.grupo 
			  JOIN mdl_role r on r.id=tbl.ROLEID and r.shortname='editingteacher'
			  LEFT JOIN tbl_tmp_conteudo_vinc_vinculado conteu_vinc ON aula.id = conteu_vinc.COURSE
																				AND aula.encontro = conteu_vinc.encontro
																				AND aula.grupo = conteu_vinc.groupid; 
																				
-- (5.87 sec)
		
		CREATE INDEX idx_tmp_conteudo ON tbl_tmp_conteudo_vinc  (CS_SHORTNAME, TURMA);
		
			INSERT INTO tbl_conteudo_amp_novo
				SELECT 	rg.nm_regional AS 'Regional',
							i.nm_ies AS  'Nome Instituição',
							i.cd_instituicao AS 'Código Instituição',
							IFNULL(pp.PROFESSOR_NOME, '') AS PROFESSOR,
							IFNULL(pc.PROFESSOR_NOME, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS 'Curso',
							t.cd_turma AS 'Código Turma',
							t.termo_turma AS 'Série',
							tm.Disciplina,
							tm.Turma,
							tm.Encontro,
							tm.QTD_CONT,
							cd.carga_horaria AS CARGA_HORARIA,
							IFNULL(pp.PROFESSOR_PrimeiroAcesso,'Nunca Acessou') AS PRI_ACESSO_PR,
							IFNULL(pp.PROFESSOR_UltimoAcesso,'Nunca Acessou')  AS ULT_ACESSO_PR,
							IFNULL(pc.PROFESSOR_PrimeiroAcesso,'Nunca Acessou') AS PRI_ACESSO_CD,
							IFNULL(pc.PROFESSOR_UltimoAcesso,'Nunca Acessou')  AS ULT_ACESSO_CD,
							cd.shortname
				  FROM tbl_tmp_conteudo_vinc  tm
				  INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = tm.CS_SHORTNAME
				  INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				  INNER JOIN kls_lms_turmas t ON t.shortname = tm.turma  AND t.id_curso_disciplina= cd.id_curso_disciplina
				  INNER JOIN mdl_course mdlc ON mdlc.shortname=cd.shortname 
				  INNER JOIN mdl_groups g on g.description=t.shortname and g.courseid=mdlc.id
				  INNER JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
				  INNER JOIN kls_lms_regional rg ON rg.id_regional = i.id_regional
				  LEFT JOIN carga_base_professor_coord pc ON pc.GROUP_ID=g.id and pc.ROLEID=(select id from mdl_role where shortname='coordteacher')
				  LEFT JOIN carga_base_professor_coord pp ON pp.GROUP_ID=g.id and pp.ROLEID=(select id from mdl_role where shortname='editingteacher')
				  WHERE mdlc.shortname REGEXP '^TCCP|^AMP|^HAMP|^ESTP'
				    AND cd.fl_etl_atu REGEXP '[NA]'
				    AND d.fl_etl_atu REGEXP '[NA]'
					 AND c.fl_etl_atu REGEXP '[NA]' 
					 AND t.fl_etl_atu REGEXP '[NA]'
					 AND i.fl_etl_atu REGEXP '[NA]'
				  GROUP BY rg.nm_regional, i.nm_ies, i.cd_instituicao, c.cd_curso, c.nm_curso, t.cd_turma, t.termo_turma,
				           tm.Disciplina, tm.Turma, tm.Encontro, tm.QTD_CONT, cd.carga_horaria, cd.shortname;
	

				INSERT INTO tbl_conteudo_amp_novo
				SELECT 	rg.nm_regional AS REGIONAL,
							ins.nm_ies AS NOME_INST,
							ins.cd_instituicao AS COD_INST,
							'' AS PROFESSOR,
							'' AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS CURSO,
							t.cd_turma AS COD_TURMA,
							t.termo_turma AS SERIE, 
							d.ds_disciplina,
							t.shortname,
							-1 AS ENCONTRO,
							0 AS QTD_PRE,
							cd.carga_horaria AS CARGA_HORARIA,
							'Nunca Acessou' PRI_ACESSO_PR,
							'Nunca Acessou' ULT_ACESSO_PR,
							'Nunca Acessou' PRI_ACESSO_CD,
							'Nunca Acessou' ULT_ACESSO_CD,
							cd.shortname
				FROM kls_lms_curso_disciplina cd 
				INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				INNER JOIN kls_lms_tipo_modelo tm on tm.id_tp_modelo=d.id_tp_modelo
				INNER JOIN kls_lms_turmas t ON cd.id_curso_disciplina = t.id_curso_disciplina
				INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies AND ins.id_ies = d.id_ies 
				INNER JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
				WHERE cd.shortname IN ('A DEFINIR','ESTP','TCCP')
				  AND tm.sigla IN ('AMP','TCC','EST','HIB') 
				  AND cd.fl_etl_atu REGEXP '[NA]'
				  AND c.fl_etl_atu REGEXP '[NA]'
				  AND d.fl_etl_atu REGEXP '[NA]'
				  AND t.fl_etl_atu REGEXP '[NA]'
				  AND ins.fl_etl_atu REGEXP '[NA]'
				GROUP BY rg.nm_regional, ins.nm_ies, ins.cd_instituicao, c.nm_curso, t.shortname, t.cd_turma, t.termo_turma, 
					cd.carga_horaria, cd.shortname;

		UPDATE tbl_prc_log pl
		   SET pl.FIM = sysdate(),
				 pl.`STATUS` = CODE_,
				 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_conteudo_amp_novo)),
			    pl.INFO = MSG_
		 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
