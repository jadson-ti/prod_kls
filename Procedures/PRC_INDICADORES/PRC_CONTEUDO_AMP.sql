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

-- Copiando estrutura para procedure prod_kls.PRC_CONTEUDO_AMP
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CONTEUDO_AMP`()
BEGIN

	DECLARE ID_LOG_       INT(10);
	DECLARE CODE_         VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_          VARCHAR(200);
	DECLARE REGISTROS_    BIGINT DEFAULT NULL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN

		GET DIAGNOSTICS CONDITION 1
		CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
		
		SET CODE_ = CONCAT('ERRO - ', CODE_);

	END;


	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT DATABASE(), 'PRC_CONTEUDO_AMP', USER(), SYSDATE(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();

	DROP TABLE IF EXISTS tbl_tmp_aula;
	
	CREATE TABLE tbl_tmp_aula(
														ID                MEDIUMINT,
														DISCIPLINA        VARCHAR(200),
														CS_SHORTNAME      VARCHAR(255),
														TURMA             VARCHAR(100),
														ENCONTRO          SMALLINT,
														GRUPO             MEDIUMINT,
														PROFESSORES			VARCHAR(255)
														
												  );
												  
	CREATE INDEX idx_aula ON tbl_tmp_aula (ID, ENCONTRO, GRUPO);

	DROP TABLE IF EXISTS tbl_tmp_matcomplementar;
	CREATE TABLE tbl_tmp_matcomplementar(
														COURSE          MEDIUMINT,
														GROUPID         MEDIUMINT,
														ENCONTROID      MEDIUMINT,
														PROFESSOR		 BIGINT(10),
														QTE             SMALLINT
													);

	CREATE INDEX idx_matcompl ON tbl_tmp_matcomplementar (COURSE, ENCONTROID, GROUPID);

	DROP TABLE IF EXISTS tbl_tmp_material;
	
	CREATE TABLE tbl_tmp_material(
												DISCIPLINA        VARCHAR(200),
												TURMA             VARCHAR(100),
												ENCONTRO          SMALLINT,
												CS_SHORTNAME      VARCHAR(255),
												PROFESSOR			BIGINT(10),
												QTD_MAT           SMALLINT
											);

	CREATE INDEX idx_material ON tbl_tmp_material (CS_SHORTNAME, TURMA);

	DROP TABLE IF EXISTS tbl_conteudo_amp;
	
	CREATE TABLE tbl_conteudo_amp(
												REGIONAL       VARCHAR(100),
												NOME_INST      VARCHAR(200),
												COD_INST       VARCHAR(100),
												PROFESSOR      LONGTEXT,
												COORDENADOR    LONGTEXT,
												COD_CURSO		VARCHAR(100),
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

	
	DROP TABLE IF EXISTS tbl_prof_amp;
	
	CREATE TABLE tbl_prof_amp AS (
		 SELECT GROUP_CONCAT(DISTINCT p.nm_pessoa ORDER BY p.nm_pessoa ASC) AS nm_pessoa, 
				 cd.shortname, 
				 t.shortname AS grupo, 
				 IFNULL(FROM_UNIXTIME(MIN(l.timecreated), '%Y-%m-%d'), 'Nunca Acessou') AS first_access, 
				 IFNULL(FROM_UNIXTIME(MAX(l.timecreated), '%Y-%m-%d'), 'Nunca Acessou') AS last_access
		 FROM kls_lms_pessoa p
		 INNER JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
		 INNER JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
		 INNER JOIN kls_lms_pessoa_turma pt ON pt.id_pes_cur_disc = pcd.id_pes_cur_disc
		 INNER JOIN kls_lms_turmas t ON t.id_turma = pt.id_turma 
		 									 AND t.id_curso_disciplina = cd.id_curso_disciplina
		 INNER JOIN tbl_mdl_user u ON u.username = p.login
		 INNER JOIN tbl_mdl_course c ON c.SHORTNAME = cd.shortname
		 LEFT JOIN mdl_logstore_standard_log l ON l.USERID = u.id 
		 	AND l.COURSEid = c.id
		 WHERE p.fl_etl_atu != 'E'
		   AND pcd.id_papel = 3
		   AND pcd.fl_etl_atu != 'E'
		   AND (cd.shortname REGEXP '^AMP' OR cd.shortname REGEXP '^TCCP' OR cd.shortname REGEXP '^ESTP')
			AND cd.fl_etl_atu != 'E'
		   AND pt.fl_etl_atu != 'E'
		   AND t.fl_etl_atu != 'E'
		   AND u.mnethostid = 1
		 GROUP BY cd.shortname, t.shortname);
	
	CREATE INDEX idx_prof_amp ON tbl_prof_amp (shortname, grupo);
	
	DROP TABLE IF EXISTS tbl_coord_amp;
	
	CREATE TABLE tbl_coord_amp AS (
		SELECT GROUP_CONCAT(DISTINCT p.nm_pessoa ORDER BY p.nm_pessoa ASC) AS nm_pessoa, 
				 cd.shortname, 
				 t.shortname AS grupo, 
				 IFNULL(FROM_UNIXTIME(MIN(l.timecreated), '%Y-%m-%d'), 'Nunca Acessou') AS first_access, 
				 IFNULL(FROM_UNIXTIME(MAX(l.timecreated), '%Y-%m-%d'), 'Nunca Acessou') AS last_access
		  FROM kls_lms_pessoa p
		 INNER JOIN kls_lms_pessoa_curso pc ON pc.id_pessoa = p.id_pessoa
		 INNER JOIN kls_lms_curso_disciplina cd ON cd.id_curso = pc.id_curso
		 INNER JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
		 INNER JOIN tbl_mdl_user u ON u.username = p.login
		 INNER JOIN tbl_mdl_course c ON c.SHORTNAME = cd.shortname
		  LEFT JOIN mdl_logstore_standard_log l ON l.USERID = u.id
		  									      AND l.COURSEid = c.id
		 WHERE p.fl_etl_atu != 'E'
		   AND pc.id_papel = 4
		   AND pc.fl_etl_atu != 'E'
		   AND (cd.shortname REGEXP '^AMP' OR cd.shortname REGEXP '^TCCP' OR cd.shortname REGEXP '^ESTP')
			AND cd.fl_etl_atu != 'E'
			AND t.fl_etl_atu != 'E'			
			AND u.mnethostid = 1
		   GROUP BY cd.shortname, t.shortname);
	
	CREATE INDEX idx_coord_amp ON tbl_coord_amp (shortname, grupo);
	

		INSERT INTO tbl_tmp_aula
			SELECT DISTINCT c.id,
								 c.fullname AS 'Disciplina',
								 c.shortname,
								 g.description AS 'Turma',
								 cs.section AS 'Encontro',
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
				FROM tbl_mdl_course c
			  INNER JOIN mdl_course_sections cs ON cs.course = c.id
			  INNER JOIN mdl_course_modules cm ON cm.course = c.id
				 										 AND cm.section = cs.id
			  INNER JOIN mdl_groups g ON g.courseid = c.id
			  INNER JOIN mdl_groups_members gm ON gm.groupid = g.id
			  
			  JOIN kls_lms_turmas t on t.shortname=g.description and t.fl_etl_atu<>'E'
			  
			  WHERE (c.shortname REGEXP '^AMP' OR c.shortname REGEXP '^TCCP' OR c.shortname REGEXP '^ESTP')
				 AND c.visible = 1
				 AND cs.section != 0
				 AND cm.module IN (SELECT id FROM mdl_modules WHERE name = 'label')
			  ORDER BY g.description, cs.section;
	
	INSERT INTO tbl_tmp_matcomplementar
		SELECT conteudo.courseid, 
				 conteudo.groupid, 
				 conteudo.encontroid,
				 conteudo.professor,
				 SUM(conteudo.qtd) AS qte 
		  FROM (
		  
						select tc.courseid, 
								 g.id as groupid, 
								 cs.section as encontroid, 
								 tc.userid as professor,
								 count(distinct tc.cmid) qtd
						from mdl_teacher_class tc
						JOIN mdl_course_sections cs on cs.course=tc.courseid and cs.id=tc.sectionid
						JOIN mdl_teacher_class_group tcg on tcg.cmid=tc.cmid 
						JOIN mdl_groups g on g.id=tcg.groupid
						JOIN mdl_groups_members gm on gm.userid=tc.userid
						where tc.visible=1 
						group by 
								 tc.courseid, 
								 g.id, 
								 cs.section 

				  ) conteudo
					  
		GROUP BY conteudo.courseid, conteudo.groupid, conteudo.encontroid, conteudo.professor;
		
		
		INSERT INTO tbl_tmp_material
			SELECT aula.Disciplina,
					 aula.Turma,
					 aula.Encontro,
					 aula.CS_SHORTNAME,
					 matcomplementar.professor,
					 IFNULL(matcomplementar.qte, 0) AS QuantidadeConteudo
			  FROM tbl_tmp_aula aula
			  LEFT JOIN tbl_tmp_matcomplementar matcomplementar ON aula.id = matcomplementar.COURSE
																				AND aula.Encontro = matcomplementar.encontroid
																				AND aula.grupo = matcomplementar.groupid 
																				AND FIND_IN_SET(matcomplementar.professor, aula.professores);
	
	
			INSERT INTO tbl_conteudo_amp
				SELECT 	rg.nm_regional AS 'Regional',
							i.nm_ies AS  'Nome Instituição',
							i.cd_instituicao AS 'Código Instituição',
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS 'Curso',
							t.cd_turma AS 'Código Turma',
							t.termo_turma AS 'Série',
							tm.Disciplina,
							tm.Turma,
							tm.Encontro,
							tm.QTD_MAT,
							cd.carga_horaria AS CARGA_HORARIA,
							IFNULL(pa.first_access,'Nunca Acessou') AS PRI_ACESSO_PR,
							IFNULL(pa.last_access,'Nunca Acessou')  AS ULT_ACESSO_PR,
							IFNULL(ca.first_access,'Nunca Acessou') AS PRI_ACESSO_CD,
							IFNULL(ca.last_access,'Nunca Acessou')  AS ULT_ACESSO_CD,
							cd.shortname
				  FROM tbl_tmp_material tm
				  INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = tm.CS_SHORTNAME
				  INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				  INNER JOIN kls_lms_turmas t ON t.shortname = tm.turma 
				  									  AND t.id_curso_disciplina= cd.id_curso_disciplina
				  INNER JOIN tbl_mdl_course mdlc ON mdlc.shortname=cd.shortname 
				  INNER JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
				  INNER JOIN kls_lms_regional rg ON rg.id_regional = i.id_regional
				  LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				  LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				  WHERE tm.CS_SHORTNAME REGEXP '^AMP'
				    AND cd.fl_etl_atu REGEXP '[NA]'
				    AND d.fl_etl_atu REGEXP '[NA]'
					 AND c.fl_etl_atu REGEXP '[NA]' 
					 AND t.fl_etl_atu REGEXP '[NA]'
					 AND i.fl_etl_atu REGEXP '[NA]'
				  GROUP BY rg.nm_regional, i.nm_ies, i.cd_instituicao, c.cd_curso, c.nm_curso, t.cd_turma, t.termo_turma,
				           tm.Disciplina, tm.Turma, tm.Encontro, tm.QTD_MAT, cd.carga_horaria, cd.shortname;
	
	
			INSERT INTO tbl_conteudo_amp
				SELECT 	rg.nm_regional AS 'Regional',
							i.nm_ies AS  'Nome Instituição',
							i.cd_instituicao AS 'Código Instituição',
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS 'Curso',
							t.cd_turma AS 'Código Turma',
							t.termo_turma AS 'Série',
							tm.Disciplina,
							tm.Turma,
							tm.Encontro,
							tm.QTD_MAT,
							cd.carga_horaria AS CARGA_HORARIA,
							IFNULL(pa.first_access,'Nunca Acessou') AS PRI_ACESSO_PR,
							IFNULL(pa.last_access,'Nunca Acessou')  AS ULT_ACESSO_PR,
							IFNULL(ca.first_access,'Nunca Acessou') AS PRI_ACESSO_CD,
							IFNULL(ca.last_access,'Nunca Acessou')  AS ULT_ACESSO_CD,
							cd.shortname
					FROM tbl_tmp_material tm
				  INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = tm.CS_SHORTNAME
				  INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				  INNER JOIN kls_lms_turmas t ON t.shortname = tm.turma 
				  									  AND t.id_curso_disciplina= cd.id_curso_disciplina
				  INNER JOIN tbl_mdl_course mdlc ON mdlc.shortname=cd.shortname 
				  INNER JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
				  INNER JOIN kls_lms_regional rg ON rg.id_regional = i.id_regional
				   LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				   LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				  WHERE tm.CS_SHORTNAME REGEXP '^ESTP' 
				    AND cd.fl_etl_atu REGEXP '[NA]'
				    AND d.fl_etl_atu REGEXP '[NA]'
					 AND c.fl_etl_atu REGEXP '[NA]'
					 AND t.fl_etl_atu REGEXP '[NA]'
					 AND i.fl_etl_atu REGEXP '[NA]'
				  GROUP BY rg.nm_regional, i.nm_ies, i.cd_instituicao, c.cd_curso, c.nm_curso, t.cd_turma, t.termo_turma,
				           tm.Disciplina, tm.Turma, tm.Encontro, tm.QTD_MAT, cd.carga_horaria, cd.shortname;

	

			INSERT INTO tbl_conteudo_amp
				SELECT 	rg.nm_regional AS 'Regional',
							i.nm_ies AS  'Nome Instituição',
							i.cd_instituicao AS 'Código Instituição',
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS 'Curso',
							t.cd_turma AS 'Código Turma',
							t.termo_turma AS 'Série',
							tm.Disciplina,
							tm.Turma,
							tm.Encontro,
							tm.QTD_MAT,
							cd.carga_horaria AS CARGA_HORARIA,
						   IFNULL(pa.first_access,'Nunca Acessou') AS PRI_ACESSO_PR,
							IFNULL(pa.last_access,'Nunca Acessou')  AS ULT_ACESSO_PR,
							IFNULL(ca.first_access,'Nunca Acessou') AS PRI_ACESSO_CD,
							IFNULL(ca.last_access,'Nunca Acessou')  AS ULT_ACESSO_CD,
							cd.shortname
					FROM tbl_tmp_material tm
				  INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = tm.CS_SHORTNAME
				  INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				  INNER JOIN kls_lms_turmas t ON t.shortname = tm.turma 
				  									  AND t.id_curso_disciplina= cd.id_curso_disciplina
				  INNER JOIN tbl_mdl_course mdlc ON mdlc.shortname=cd.shortname 
				  INNER JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
				  INNER JOIN kls_lms_regional rg ON rg.id_regional = i.id_regional
				   LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				   LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				  WHERE tm.CS_SHORTNAME REGEXP '^TCCP'
				    AND cd.fl_etl_atu REGEXP '[NA]'
				    AND d.fl_etl_atu REGEXP '[NA]'
					 AND c.fl_etl_atu REGEXP '[NA]' 
					 AND t.fl_etl_atu REGEXP '[NA]'
					 AND i.fl_etl_atu REGEXP '[NA]'
				  GROUP BY rg.nm_regional, i.nm_ies, i.cd_instituicao, c.cd_curso, c.nm_curso, t.cd_turma, t.termo_turma,
				           tm.Disciplina, tm.Turma, tm.Encontro, tm.QTD_MAT, cd.carga_horaria, cd.shortname;
	
				INSERT INTO tbl_conteudo_amp
				SELECT 	rg.nm_regional AS REGIONAL,
							ins.nm_ies AS NOME_INST,
							ins.cd_instituicao AS COD_INST,
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS CURSO,
							t.cd_turma AS COD_TURMA,
							t.termo_turma AS SERIE, 
							d.ds_disciplina,
							t.shortname,
							-1 AS ENCONTRO,
							0 AS QTD_PRE, 
							cd.carga_horaria AS CARGA_HORARIA,
							
							
							
							CASE 
								WHEN pa.first_access = '0000-00-00' THEN
									'Nunca Acessou'
								ELSE	
									IFNULL(pa.first_access,'Nunca Acessou')
							END PRI_ACESSO_PR,

							
							CASE 
								WHEN pa.last_access = '0000-00-00' THEN
									'Nunca Acessou'
								ELSE	
									IFNULL(pa.first_access,'Nunca Acessou')
							END ULT_ACESSO_PR,
							
							
							CASE 
								WHEN ca.first_access = '0000-00-00' THEN
									'Nunca Acessou'
								ELSE	
									IFNULL(ca.first_access,'Nunca Acessou')
							END PRI_ACESSO_CD,

							
							CASE 
								WHEN ca.last_access = '0000-00-00' THEN
									'Nunca Acessou'
								ELSE	
									IFNULL(ca.first_access,'Nunca Acessou')
							END ULT_ACESSO_CD,
							cd.shortname
				FROM kls_lms_curso_disciplina cd 
				INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				INNER JOIN kls_lms_tipo_modelo tm on tm.id_tp_modelo=d.id_tp_modelo
				INNER JOIN kls_lms_turmas t ON cd.id_curso_disciplina = t.id_curso_disciplina
				INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies
					AND ins.id_ies = d.id_ies 
				INNER JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
				LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname 
					AND pa.grupo = t.shortname
				LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname 
					AND ca.grupo = t.shortname
				WHERE cd.shortname IN ('A DEFINIR','ESTP','TCCP') 
				  AND tm.sigla IN ('AMP','TCC','EST') 
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
				 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_conteudo_amp)),
			    pl.INFO = MSG_
		 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
