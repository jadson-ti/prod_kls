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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_ED4
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_ED4`()
BEGIN


	DECLARE v_finished 	   INT DEFAULT 0;
	DECLARE SHORTNAME_		VARCHAR(100);
	DECLARE QTD_ALU_			BIGINT;
	DECLARE COUNT_COMMIT_   BIGINT;
	DECLARE COUNT_LIMIT_		BIGINT;


	DECLARE c_cursos CURSOR FOR

             SELECT DISTINCT ed1.SHORTNAME
					FROM tbl_retorno_nt2_ed4 ed1;


	DECLARE c_shortname CURSOR FOR

				 SELECT ed1.SHORTNAME, COUNT(ed1.USERNAME) AS QTD_GRP
				   FROM tbl_retorno_nt2_ed4 ed1
				  GROUP BY ed1.SHORTNAME
				  ORDER BY QTD_GRP;



   DECLARE CONTINUE HANDLER

     FOR NOT FOUND SET v_finished = 1;
     

	DROP TABLE IF EXISTS tbl_retorno_base_ausenc;


	CREATE TABLE tbl_retorno_base_ausenc (
															SHORTNAME			VARCHAR(100),
															FULLNAME				VARCHAR(200),
															USERID				BIGINT,
															USERNAME				VARCHAR(100),
															CH						BIGINT,
															DISCIPLINA			VARCHAR(100),
															ITEM					VARCHAR(200),
															PA						DECIMAL(4,1)
									 				);



	CREATE INDEX idx_BASE ON tbl_retorno_base_ausenc (SHORTNAME);
	
	
	
	DROP TABLE IF EXISTS tbl_retorno_base_ausenc2;

	CREATE TABLE tbl_retorno_base_ausenc2 (
															SHORTNAME			VARCHAR(100),
															FULLNAME				VARCHAR(200),
															USERID				BIGINT,
															USERNAME				VARCHAR(100),
															CH						BIGINT,
															DISCIPLINA			VARCHAR(100),
															RANK					SMALLINT,
															ITEM					VARCHAR(200),
															PA						DECIMAL(4,1),
															NOTA					DECIMAL(10,5)
									 				);

	CREATE INDEX idx_BASE ON tbl_retorno_base_ausenc2 (SHORTNAME);
		
	
	
	DROP TABLE IF EXISTS tbl_retorno_base2;


	CREATE TABLE tbl_retorno_base2 (
												UNIDADE			VARCHAR(100),
												SHORTNAME		VARCHAR(100),
												USERNAME			VARCHAR(100),
												ITEM				VARCHAR(200),
												PA					DECIMAL(4,1),
												AUSENCIA			INT,
												NOTA				DECIMAL(4,1)
						 				    );


	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME);
	
	

	DROP TABLE IF EXISTS tbl_retorno_nt2_ed4;


	CREATE TABLE tbl_retorno_nt2_ed4 (
													CD_INSTITUICAO			VARCHAR(20),
												   NM_IES					VARCHAR(200),
													CD_PESSOA				VARCHAR(100),
													USERNAME					VARCHAR(200),
													NOME_USUARIO			VARCHAR(200),
													COURSE_ID				BIGINT,
													SHORTNAME				VARCHAR(200),
													FULLNAME					VARCHAR(200),
													CD_CURSO					VARCHAR(100),
													CURSO						VARCHAR(200),
													CD_DISCIPLINA			VARCHAR(100),
													DISCIPLINA				VARCHAR(200),
													TURMA						VARCHAR(100),
												 	ORIGEM					VARCHAR(100),
													CARGA_HORARIA			SMALLINT(10),
													AUSENCIA_SIAE			BIGINT,
													AUSENCIA_OLIMPO		DECIMAL(4,1) DEFAULT 100,
													NOTA						DECIMAL(3,1) DEFAULT 0
											   );


   CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_ed4 (SHORTNAME);



	
	
		INSERT INTO tbl_retorno_nt2_ed4 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA,
												  AUSENCIA_SIAE)
					SELECT i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							 p.nm_pessoa AS NOME_USUARIO,
							 tc.id AS COURSE_ID,
							 tc.shortname,
							 tc.fullname,
							 c.cd_curso AS COD_CURSO,
							 c.nm_curso AS CURSO,
							 d.cd_disciplina AS CD_DISCIPLINA,
							 d.ds_disciplina AS DISCIPLINA,
							 IFNULL(t.cd_turma, '') AS TURMA,
							 'OLIMPO' AS ORIGEM,
							 cd.carga_horaria,
							 cd.id_curso_disciplina AS AUSENCIA_SIAE
					  FROM kls_lms_pessoa p
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
					  JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
					  JOIN mdl_course tc ON tc.shortname = cd.shortname
					  LEFT JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc
					  LEFT JOIN kls_lms_turmas t on t.id_turma=pt.id_turma and t.fl_etl_atu REGEXP '[NA]'
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname = 'ED_FOR'
			  			AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd1.id_cd_remarc 
						  												 FROM kls_lms_curso_disciplina cd1 
																		WHERE cd1.id_cd_remarc > 0
																		AND cd1.fl_etl_atu != 'E')
					   AND d.id_tp_modelo = 5
  					   AND d.id_disciplina NOT IN (SELECT d1.id_disciplina_remarc 
						  									   FROM kls_lms_disciplina d1 
															  WHERE d1.id_disciplina_remarc > 0
															    AND d1.fl_etl_atu != 'E')
						AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd2.id_curso_disciplina
																	  FROM kls_lms_curso_disciplina cd2 
																	 WHERE cd2.id_curso_disciplina = cd.ID_CURSO_DISCIPLINA
																	   AND cd2.id_cd_remarc > 0 
																	   AND cd2.fl_etl_atu = 'E'
																	   AND EXISTS (SELECT 1 
																						  FROM kls_lms_curso_disciplina cd3
																						 WHERE cd3.id_curso_disciplina = cd2.id_cd_remarc
																						   AND cd3.fl_etl_atu != 'E'))
					 GROUP BY i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							 
							 tc.id,
							 tc.shortname,
							 tc.fullname,
							 c.cd_curso,
							 c.nm_curso,
							 d.cd_disciplina,
							 d.ds_disciplina,
							 cd.carga_horaria;

		DELETE ed1 FROM tbl_retorno_nt2_ed4 ed1
		  JOIN mdl_course mc ON mc.shortname = ed1.SHORTNAME
		 WHERE mc.visible = 0;

		UPDATE tbl_retorno_nt2_ed4 ed1
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ed1.AUSENCIA_SIAE
		   SET ed1.TURMA = t.cd_turma
		 WHERE ed1.TURMA = '';

		 UPDATE tbl_retorno_nt2_ed4 ed1
		  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = ed1.AUSENCIA_SIAE
		   SET ed1.AUSENCIA_SIAE = cd.carga_horaria;

	OPEN c_cursos;


	  get_CURSOS: LOOP


	  FETCH c_cursos INTO SHORTNAME_;


	  IF v_finished = 1 THEN

	  		LEAVE get_CURSOS;

	  END IF;
	
 
		

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Cultura Escolar' AS ITEM
						 ,15 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'quiz'
												 AND gi.itemname = 'Simulado Parcial'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
				   							      AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Expectativas' AS ITEM
						 ,15 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'quiz'
												 AND gi.itemname = 'Simulado Parcial'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
				   							      AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
		
		
		
		

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Leitura' AS ITEM
						 ,15 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'quiz'
												 AND gi.itemname = 'Simulado Parcial'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
	

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Perguntas e Intervenções' AS ITEM
						 ,15 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'quiz'
												 AND gi.itemname = 'Simulado Parcial'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
		
 
		
		


	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,SUBSTR(gi.itemname, INSTR(gi.itemname, '-') + 2) AS ITEM
						 ,20 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'quiz'
												 AND gi.itemname REGEXP '^Simulado Geral'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
				   							      AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA, gi.itemname;
				 
		
		
 
		
		

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Cultura Escolar' AS ITEM
						 ,25 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'assign'
												 AND gi.itemname REGEXP 'Discursiva 1$'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
				   							      AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
		
		
		
		

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Expectativas' AS ITEM
						 ,25 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'assign'
												 AND gi.itemname REGEXP 'Discursiva 1$'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid  AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Leitura' AS ITEM
						 ,25 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'assign'
												 AND gi.itemname REGEXP 'Discursiva 1$'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
				   							      AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 

	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,'Perguntas e Intervenções' AS ITEM
						 ,25 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'assign'
												 AND gi.itemname REGEXP 'Discursiva 1$'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;
				 
		
		
 
		
		


	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)

				SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed1.CARGA_HORARIA AS CH
						 ,ed1.DISCIPLINA
						 ,SUBSTR(gi.itemname, INSTR(gi.itemname, '-') + 2) AS ITEM
						 ,25 AS PA
				  FROM tbl_retorno_nt2_ed4 ed1
				  JOIN mdl_user u ON u.username = ed1.USERNAME
				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
				  JOIN mdl_grade_items gi ON gi.courseid = c.id
												 AND gi.itemtype = 'mod'
												 AND gi.itemmodule = 'assign'
												 AND gi.itemname REGEXP 'Discursiva 2'
												 AND gi.hidden != 1
				  JOIN mdl_course_modules cm ON cm.course = c.id
				  									 AND cm.instance = gi.iteminstance
				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id
				 WHERE ed1.SHORTNAME = SHORTNAME_
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA, gi.itemname;
				 
		


		
		
		
			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
			
				SELECT DISTINCT 
						  UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed3.CARGA_HORARIA AS CH
						 ,ed3.DISCIPLINA
						 ,'Cultura Escolar' AS ITEM
						 ,7.5 AS PA
				  FROM mdl_coursemoduleuserview_records r
				 INNER JOIN mdl_course_modules cm ON cm.id=r.cmid 
				 								         AND cm.module=38
				 INNER JOIN mdl_course c ON c.id=cm.course
				 INNER JOIN mdl_url url ON url.course=c.id 
											  AND url.name REGEXP 'dia$' 
											  AND url.id=cm.instance
				 INNER JOIN mdl_user u ON u.id = r.userid
				 INNER JOIN tbl_retorno_nt2_ed4 ed3 ON ed3.COURSE_ID = c.id AND ed3.USERNAME = u.username
				 WHERE ed3.SHORTNAME = SHORTNAME_;
		
			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
				SELECT DISTINCT 
						  UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed3.CARGA_HORARIA AS CH
						 ,ed3.DISCIPLINA
						 ,'Expectativas' AS ITEM
						 ,7.5 AS PA
				  FROM mdl_coursemoduleuserview_records r
				 INNER JOIN mdl_course_modules cm ON cm.id=r.cmid 
				 								         AND cm.module=38
				 INNER JOIN mdl_course c ON c.id=cm.course
				 INNER JOIN mdl_url url ON url.course=c.id 
											  AND url.name REGEXP 'dia$' 
											  AND url.id=cm.instance
				 INNER JOIN mdl_user u ON u.id = r.userid
				 INNER JOIN tbl_retorno_nt2_ed4 ed3 ON ed3.COURSE_ID = c.id 
				 											  AND ed3.USERNAME = u.username
				 WHERE ed3.SHORTNAME = SHORTNAME_;
		
		
		
		
		
		
			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
			
				SELECT DISTINCT 
						  UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed3.CARGA_HORARIA AS CH
						 ,ed3.DISCIPLINA
						 ,'Leitura' AS ITEM
						 ,7.5 AS PA
				  FROM mdl_coursemoduleuserview_records r
				 INNER JOIN mdl_course_modules cm ON cm.id=r.cmid 
				 								         AND cm.module=38
				 INNER JOIN mdl_course c ON c.id=cm.course
				 INNER JOIN mdl_url url ON url.course=c.id 
											  AND url.name REGEXP 'dia$' 
											  AND url.id=cm.instance
				 INNER JOIN mdl_user u ON u.id = r.userid
				 INNER JOIN tbl_retorno_nt2_ed4 ed3 ON ed3.COURSE_ID = c.id 
				 											  AND ed3.USERNAME = u.username
				 WHERE ed3.SHORTNAME = SHORTNAME_;
		
		
		
		
		
		
			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
			
				SELECT DISTINCT 
						  UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed3.CARGA_HORARIA AS CH
						 ,ed3.DISCIPLINA
						 ,'Perguntas e Intervenções' AS ITEM
						 ,7.5 AS PA
				  FROM mdl_coursemoduleuserview_records r
				 INNER JOIN mdl_course_modules cm ON cm.id=r.cmid 
				 								         AND cm.module=38
				 INNER JOIN mdl_course c ON c.id=cm.course
				 INNER JOIN mdl_url url ON url.course=c.id 
											  AND url.name REGEXP 'dia$' 
											  AND url.id=cm.instance
				 INNER JOIN mdl_user u ON u.id = r.userid
				 INNER JOIN tbl_retorno_nt2_ed4 ed3 ON ed3.COURSE_ID = c.id 
				 											  AND ed3.USERNAME = u.username
				 WHERE ed3.SHORTNAME = SHORTNAME_;
		
		


		
		
		
			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, ITEM, PA)
			
				SELECT DISTINCT 
						  UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed3.CARGA_HORARIA AS CH
						 ,ed3.DISCIPLINA
						 ,SUBSTR(url.name, INSTR(url.name, '-') + 2) AS ITEM
						 ,7.5 AS PA
				  FROM mdl_coursemoduleuserview_records r
				 INNER JOIN mdl_course_modules cm ON cm.id=r.cmid 
				 								         AND cm.module=38
				 INNER JOIN mdl_course c ON c.id=cm.course
				 INNER JOIN mdl_url url ON url.course=c.id 
											  AND url.name REGEXP 'dia - ' 
											  AND url.id=cm.instance
				 INNER JOIN mdl_user u ON u.id = r.userid
				 INNER JOIN tbl_retorno_nt2_ed4 ed3 ON ed3.COURSE_ID = c.id 
				 											  AND ed3.USERNAME = u.username
				 WHERE ed3.SHORTNAME = SHORTNAME_
				 GROUP BY c.fullname, u.id, ed3.DISCIPLINA, url.name;


	  		INSERT INTO tbl_retorno_base_ausenc2 (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, RANK, ITEM, PA, NOTA)

				SELECT rba.SHORTNAME
				       ,rba.FULLNAME
						 ,rba.USERID
						 ,rba.USERNAME
						 ,rba.CH
						 ,rba.DISCIPLINA
						 ,COUNT(rba.ITEM) AS RANK
						 ,rba.ITEM
						 ,SUM(rba.PA) AS PA
						 ,IFNULL((SELECT MAX(gg.FINALGRADE) 
						 	  FROM mdl_course c 
							  JOIN mdl_grade_items gi ON gi.courseid = c.id
																  AND gi.itemtype = 'mod'
																  AND gi.itemmodule = 'quiz'
																  AND gi.itemname REGEXP '^Avalia'
																  AND gi.hidden != 1
							  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
							 WHERE c.shortname = rba.SHORTNAME
							   AND gg.userid = rba.USERID
								AND SUBSTR(gi.itemname, INSTR(gi.itemname, '-') + 2) = rba.ITEM), 0) AS NOTA
				  FROM tbl_retorno_base_ausenc rba
				 WHERE rba.SHORTNAME = SHORTNAME_
				 GROUP BY rba.FULLNAME, rba.USERID, rba.DISCIPLINA, rba.ITEM;
				 

			INSERT INTO tbl_retorno_base2
		
							SELECT ed1.CD_INSTITUICAO AS UNIDADE
									 ,ed1.SHORTNAME
									 ,ed1.USERNAME
									 ,rba2.ITEM
									 ,(100 - MAX(rba2.PA)) AS PA
									 ,(FLOOR(IFNULL((100 - MAX(rba2.PA)), 0) * (rba2.CH / 100))) AS AUSENCIA
									 ,MAX(rba2.NOTA) AS NOTA
							  FROM tbl_retorno_nt2_ed4 ed1						  
							  JOIN tbl_retorno_base_ausenc2 rba2 ON rba2.SHORTNAME = ed1.SHORTNAME
							  												AND rba2.USERNAME = ed1.USERNAME
							 WHERE ed1.SHORTNAME = SHORTNAME_
							   AND rba2.PA >= 75
							 GROUP BY ed1.CD_INSTITUICAO, ed1.SHORTNAME, ed1.USERNAME;

		
		
		
		
		
			INSERT INTO tbl_retorno_base2
		
							SELECT ed1.CD_INSTITUICAO AS UNIDADE
									 ,ed1.SHORTNAME
									 ,ed1.USERNAME
									 ,rba2.ITEM
									 ,(100 - MAX(rba2.PA)) AS PA
									 ,(FLOOR(IFNULL((100 - MAX(rba2.PA)), 0) * (rba2.CH / 100))) AS AUSENCIA
									 ,MAX(rba2.NOTA) AS NOTA
							  FROM tbl_retorno_nt2_ed4 ed1						  
							  JOIN tbl_retorno_base_ausenc2 rba2 ON rba2.SHORTNAME = ed1.SHORTNAME
							  												AND rba2.USERNAME = ed1.USERNAME
							 WHERE ed1.SHORTNAME = SHORTNAME_
							   AND rba2.PA < 75
							   AND NOT EXISTS (SELECT 1 FROM tbl_retorno_base2 rb2
													  WHERE rb2.UNIDADE = ed1.CD_INSTITUICAO
													    AND rb2.SHORTNAME = ed1.SHORTNAME
														 AND rb2.USERNAME = ed1.USERNAME)
							 GROUP BY ed1.CD_INSTITUICAO, ed1.SHORTNAME, ed1.USERNAME;

	
	END LOOP get_CURSOS;

 	CLOSE c_cursos;
 	


	

		UPDATE tbl_retorno_nt2_ed4 ed1
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.SHORTNAME = 'ED_FOR'
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ed1.USERNAME
						  AND nt.SHORTNAME = 'ED_FOR'
			SET ed1.NOTA = nt.NOTA,
				 ed1.AUSENCIA_SIAE = nt.AUSENCIA,
				 ed1.AUSENCIA_OLIMPO = nt.PA
			WHERE ed1.SHORTNAME = 'ED_FOR';

	
	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
