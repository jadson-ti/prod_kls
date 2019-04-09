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

-- Copiando estrutura para procedure prod_kls.PRC_MATERIAL_COMP_AMP_NOVO
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_MATERIAL_COMP_AMP_NOVO`()
BEGIN

	DECLARE ID_LOG_       INT(10);
	DECLARE CODE_         VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_          VARCHAR(200);
	DECLARE REGISTROS_    BIGINT DEFAULT NULL;
	
	
	DECLARE v_finished 	 TINYINT(1) DEFAULT 0;   
   DECLARE CURSOS_		 BIGINT(10);
   DECLARE CURSOS_MAT_	 VARCHAR(200);

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN

		GET DIAGNOSTICS CONDITION 1
		CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;

		SET CODE_ = CONCAT('ERRO - ', CODE_);

	END;


	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_MATERIAL_COMP_AMP', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	SET AUTOCOMMIT = 0;



	DROP TABLE IF EXISTS tbl_tmp_aula;

	CREATE TEMPORARY TABLE tbl_tmp_aula(
														ID                MEDIUMINT,
														DISCIPLINA        VARCHAR(200),
														CS_SHORTNAME      VARCHAR(255),
														TURMA             VARCHAR(100),
														ENCONTRO          SMALLINT,
														GR_DESCRIPTION    LONGTEXT,
														GRUPO             MEDIUMINT,
														PROFESSORES			VARCHAR(255)
														
												  );												  
												  												  
	CREATE INDEX idx_aula ON tbl_tmp_aula (ID, ENCONTRO, GRUPO);




	DROP TABLE IF EXISTS tbl_tmp_matcomplementar;
	
	CREATE TABLE tbl_tmp_matcomplementar(
																	COURSE     MEDIUMINT,
																	GROUPID    MEDIUMINT,
																	TEMPO      BIGINT,
																	SECTION    SMALLINT,
																	AULACOD    SMALLINT,
																	PROFESSOR  BIGINT(10),
																	QTE        SMALLINT
																 );
																 
	CREATE INDEX idx_matcompl ON tbl_tmp_matcomplementar (COURSE, SECTION, GROUPID);


	DROP TABLE IF EXISTS tbl_tmp_material;
	
	CREATE TABLE tbl_tmp_material(
												DISCIPLINA        VARCHAR(200),
												TURMA             VARCHAR(100),
												ENCONTRO          SMALLINT,
												CS_SHORTNAME      VARCHAR(255),
												GR_DESCRIPTION    VARCHAR(255),
												AULACOD           SMALLINT,
												PROFESSOR 	  	   BIGINT(10),
												QTD_MAT           SMALLINT,
												TEMPO             BIGINT
											);

	CREATE INDEX idx_material ON tbl_tmp_material (CS_SHORTNAME,GR_DESCRIPTION);

	
	DROP TABLE IF EXISTS tbl_material_comp_amp;

	CREATE TABLE tbl_material_comp_amp(
														REGIONAL          VARCHAR(100),
														NOME_INST         VARCHAR(200),
														COD_INST          VARCHAR(100),
														PROFESSOR         VARCHAR(255),
														COORDENADOR       VARCHAR(200),
														COD_CURSO			VARCHAR(100),
														CURSO             VARCHAR(100),
														COD_TURMA         VARCHAR(100),
														SERIE             VARCHAR(100),
														DISCIPLINA        VARCHAR(200),
														SHORTNAME         VARCHAR(200),
														TURMA             VARCHAR(100),
														ENCONTRO          SMALLINT,
														QTD_PRE           SMALLINT,
														QTD_AULA          SMALLINT,
														QTD_POS           SMALLINT,
														TEMPO_PRE         BIGINT(10),
														TEMPO_AULA        BIGINT(10),
														TEMPO_POS         BIGINT(10),
														CARGA_HORARIA     SMALLINT
												 );

	
	DROP TABLE IF EXISTS tbl_prof_amp;
	
	CREATE TEMPORARY TABLE tbl_prof_amp AS (
		SELECT GROUP_CONCAT(DISTINCT p.nm_pessoa ORDER BY p.nm_pessoa ASC) AS nm_pessoa, 
				 cd.shortname, 
				 t.shortname AS grupo
		  FROM kls_lms_pessoa p
		 INNER JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
   	 INNER JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
		 INNER JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
		 INNER JOIN kls_lms_pessoa_turma pt ON pt.id_pes_cur_disc = pcd.id_pes_cur_disc
		 INNER JOIN kls_lms_turmas t ON t.id_turma = pt.id_turma 
		 									 AND t.id_curso_disciplina = cd.id_curso_disciplina
		 INNER JOIN tbl_mdl_user u ON u.username = p.login
		 INNER JOIN tbl_mdl_course c ON c.SHORTNAME = cd.shortname
		 WHERE p.fl_etl_atu REGEXP '[NA]'
		   AND pcd.fl_etl_atu REGEXP '[NA]'
		   AND (cd.shortname REGEXP '^AM[PI]' OR cd.shortname REGEXP '^TCCP' OR cd.shortname REGEXP '^ESTP')
			AND cd.fl_etl_atu REGEXP '[NA]'
		   AND pt.fl_etl_atu REGEXP '[NA]'
		   AND t.fl_etl_atu REGEXP '[NA]'
		   GROUP BY cd.shortname, t.shortname);
	
	CREATE INDEX idx_prof_amp ON tbl_prof_amp (shortname, grupo);
	
	
	DROP TABLE IF EXISTS tbl_coord_amp;
	
	CREATE TEMPORARY TABLE tbl_coord_amp AS (
		SELECT GROUP_CONCAT(DISTINCT p.nm_pessoa ORDER BY p.nm_pessoa ASC) AS nm_pessoa, 
				 cd.shortname, 
				 t.shortname AS grupo
		  FROM kls_lms_pessoa p
		 INNER JOIN kls_lms_pessoa_curso pc ON pc.id_pessoa = p.id_pessoa
		 INNER JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel='COORDENADOR DE CURSO'
		 INNER JOIN kls_lms_curso_disciplina cd ON cd.id_curso = pc.id_curso
		 INNER JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
		 INNER JOIN tbl_mdl_user u ON u.username = p.login
		 INNER JOIN tbl_mdl_course c ON c.SHORTNAME = cd.shortname
		 WHERE p.fl_etl_atu REGEXP '[NA]'
		   AND pc.fl_etl_atu REGEXP '[NA]'
			AND t.fl_etl_atu REGEXP '[NA]'
		   AND (cd.shortname REGEXP '^AM[PI]' OR cd.shortname REGEXP '^TCCP' OR cd.shortname REGEXP '^ESTP')
			AND cd.fl_etl_atu REGEXP '[NA]'
			AND u.mnethostid = 1
		   GROUP BY cd.shortname, t.shortname);
	
	CREATE INDEX idx_coord_amp ON tbl_coord_amp (shortname, grupo);

		
			INSERT INTO tbl_tmp_aula
				SELECT DISTINCT 
								c.id,
								c.fullname AS 'Disciplina',
								c.shortname,
								g.description AS 'Turma',
								cs.section AS 'Encontro',
								g.description,
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
				 INNER JOIN mdl_course_modules cm ON cm.course = c.id
				 INNER JOIN mdl_course_sections cs ON cs.course = c.id AND cs.id = cm.section
				 INNER JOIN mdl_groups g ON g.courseid = c.id
				 INNER JOIN mdl_groups_members gm ON gm.groupid = g.id
  			  	INNER JOIN kls_lms_turmas t on t.shortname=g.description and t.fl_etl_atu REGEXP '[NA]'
				 WHERE c.visible = 1
				   AND (c.shortname REGEXP '^AM[PI]' OR c.shortname REGEXP '^TCCP' OR c.shortname REGEXP '^ESTP')
				   AND cm.module IN (SELECT id FROM mdl_modules WHERE name = 'label')
				   AND cs.section != 0
				 ORDER BY g.description, cs.section;
	


			INSERT INTO tbl_tmp_matcomplementar
				SELECT mt.course, 
						 mt.groupid, 
						 SUM(mt.time) AS tempo, 
						 mt.section, 
						 mt.aulacod, 
						 mt.professor,
						 SUM(mt.qte) AS qte 
			  FROM (
			  
						select tc.courseid as course, 
								 g.id as groupid, 
								 SUM(tc.workload) AS time,
								 cs.section, 
								 FIND_IN_SET(tc.cmid, cs.sequence) AS aulacod,
								 tc.userid as professor,
								 count(distinct tc.cmid) qte
						from mdl_teacher_class tc
						JOIN mdl_course_sections cs on cs.course=tc.courseid and cs.id=tc.sectionid
						JOIN mdl_teacher_class_group tcg on tcg.cmid=tc.cmid 
						JOIN mdl_groups g on g.id=tcg.groupid
						JOIN mdl_groups_members gm on gm.userid=tc.userid
						where tc.visible=1 
						group by tc.courseid, 
								 g.id, 
								 cs.section, 
								 tc.userid			  
				) mt
				GROUP BY mt.course, mt.groupid, mt.section, mt.aulacod
				ORDER BY mt.course, mt.groupid, mt.section, mt.aulacod;
			
				
		INSERT INTO tbl_tmp_material
			SELECT aula.Disciplina,
					 aula.Turma,
					 aula.Encontro,
					 aula.CS_SHORTNAME,
					 aula.GR_DESCRIPTION,
					 IFNULL(matcomplementar.aulacod, '') AS aulacod,
					 matcomplementar.professor,
					 IFNULL(matcomplementar.qte, 0) AS QuantidadeMaterial,
					 IFNULL(matcomplementar.tempo, 0) AS tempo
			  FROM tbl_tmp_aula aula
			 INNER JOIN tbl_tmp_matcomplementar matcomplementar ON aula.id = matcomplementar.course
			   																AND aula.Encontro = matcomplementar.section
																				AND aula.grupo = matcomplementar.groupid
																				AND FIND_IN_SET(matcomplementar.professor, aula.professores);
																				
	
			INSERT INTO tbl_material_comp_amp
				SELECT 	rg.nm_regional AS REGIONAL,
							ins.nm_ies AS NOME_INST,
							ins.cd_instituicao AS COD_INST,
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS CURSO,
							t.cd_turma AS COD_TURMA,
							t.termo_turma AS SERIE, 
							material.Disciplina,
							cd.shortname,
							material.Turma,
							material.Encontro,
						   material.QTD_MAT AS QTD_PRE, 
							0 AS QTD_AULA,
							0 AS QTD_POS,
							material.tempo AS TEMPO_PRE,
							0 AS TEMPO_AULA,
							0 AS TEMPO_POS,
							cd.carga_horaria AS CARGA_HORARIA
				 FROM tbl_tmp_material material
				INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = material.CS_SHORTNAME
				INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				INNER JOIN kls_lms_turmas t ON t.shortname = material.GR_DESCRIPTION
													AND cd.id_curso_disciplina = t.id_curso_disciplina
				INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies 
															 AND ins.id_ies = d.id_ies 
				INNER JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
				 LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				 LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				 
				 LEFT JOIN anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina)

				WHERE material.aulacod=2
				  AND (cd.shortname REGEXP '^AM[PI]' or cd.shortname REGEXP '^ESTP' or cd.shortname REGEXP '^TCCP')
				  AND cd.fl_etl_atu REGEXP '[NA]'
				  AND c.fl_etl_atu REGEXP '[NA]'
				  AND d.fl_etl_atu  REGEXP '[NA]'
				  AND t.fl_etl_atu  REGEXP '[NA]'
				  AND ins.fl_etl_atu REGEXP '[NA]'
				  AND temp.id_disciplina is null 
				 
				GROUP BY rg.nm_regional, ins.nm_ies, ins.cd_instituicao, c.nm_curso, t.cd_turma, t.termo_turma, material.Turma, 
				         material.Encontro, material.aulacod, cd.carga_horaria;
				      

			INSERT INTO tbl_material_comp_amp
				SELECT 	rg.nm_regional AS REGIONAL,
							ins.nm_ies AS NOME_INST,
							ins.cd_instituicao AS COD_INST,
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS CURSO,
							t.cd_turma AS COD_TURMA,
							t.termo_turma AS SERIE, 
							material.Disciplina,
							cd.shortname,
							material.Turma,
							material.Encontro,
							0 AS QTD_PRE, 
							material.QTD_MAT AS QTD_AULA,
							0 AS QTD_POS,
							0 AS TEMPO_PRE,
							material.tempo AS TEMPO_AULA,
							0 AS TEMPO_POS,
							cd.carga_horaria AS CARGA_HORARIA
				 FROM tbl_tmp_material material
				INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = material.CS_SHORTNAME
				INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				INNER JOIN kls_lms_turmas t ON t.shortname = material.GR_DESCRIPTION
													AND cd.id_curso_disciplina = t.id_curso_disciplina
				INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies 
															 AND ins.id_ies = d.id_ies 
				INNER JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
				 LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				 LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				 
				 LEFT JOIN anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina)
						 
				WHERE material.aulacod = 4
				  AND (cd.shortname REGEXP '^AM[PI]' or cd.shortname REGEXP '^ESTP' or cd.shortname REGEXP '^TCCP')
				  AND cd.fl_etl_atu REGEXP '[NA]'
				  AND c.fl_etl_atu REGEXP '[NA]'
				  AND d.fl_etl_atu REGEXP '[NA]'
				  AND t.fl_etl_atu REGEXP '[NA]'
				  AND ins.fl_etl_atu REGEXP '[NA]'
				  AND temp.id_disciplina is null 
				GROUP BY rg.nm_regional, ins.nm_ies, ins.cd_instituicao, c.nm_curso, t.cd_turma, t.termo_turma, material.Turma, 
				         material.Encontro, material.aulacod, cd.carga_horaria;
				      
		
			INSERT INTO tbl_material_comp_amp
				SELECT 	rg.nm_regional AS REGIONAL,
							ins.nm_ies AS NOME_INST,
							ins.cd_instituicao AS COD_INST,
							IFNULL(pa.nm_pessoa, '') AS PROFESSOR,
							IFNULL(ca.nm_pessoa, '') AS COORDENADOR,
							c.cd_curso AS COD_CURSO,
							c.nm_curso AS CURSO,
							t.cd_turma AS COD_TURMA,
							t.termo_turma AS SERIE, 
							material.Disciplina,
							cd.shortname,
							material.Turma,
							material.Encontro,
							0 AS QTD_PRE, 
							0 AS QTD_AULA,
							material.QTD_MAT AS QTD_POS,
							0 AS TEMPO_PRE,
							0 AS TEMPO_AULA,
							material.tempo AS TEMPO_POS,
							cd.carga_horaria AS CARGA_HORARIA
				 FROM tbl_tmp_material material
				INNER JOIN kls_lms_curso_disciplina cd ON cd.shortname = material.CS_SHORTNAME
				INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
				INNER JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				INNER JOIN kls_lms_turmas t ON t.shortname = material.GR_DESCRIPTION
													AND cd.id_curso_disciplina = t.id_curso_disciplina
				INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies 
															 AND ins.id_ies = d.id_ies 
				INNER JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
				 LEFT JOIN tbl_prof_amp pa ON pa.shortname = cd.shortname AND pa.grupo = t.shortname
				 LEFT JOIN tbl_coord_amp ca ON ca.shortname = cd.shortname AND ca.grupo = t.shortname
				 
				 LEFT JOIN anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina)
				 
				WHERE material.aulacod = 6
				  AND (cd.shortname REGEXP '^AM[PI]' or cd.shortname REGEXP '^ESTP' or cd.shortname REGEXP '^TCCP')
				  AND cd.fl_etl_atu REGEXP '[NA]'
				  AND c.fl_etl_atu REGEXP '[NA]'
				  AND d.fl_etl_atu REGEXP '[NA]'
				  AND t.fl_etl_atu REGEXP '[NA]'
				  AND ins.fl_etl_atu REGEXP '[NA]'
				  AND temp.id_disciplina is null 
				GROUP BY rg.nm_regional, ins.nm_ies, ins.cd_instituicao, c.nm_curso, t.cd_turma, t.termo_turma, material.Turma, 
				material.Encontro, material.aulacod, cd.carga_horaria;

 
		
	COMMIT;
	
		
		UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
		pl.`STATUS` = CODE_,
		pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_material_comp_amp)),
		pl.INFO = MSG_
		WHERE pl.ID = ID_LOG_;
	


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
