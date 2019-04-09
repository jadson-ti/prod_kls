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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_ED3
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_ED3`()
BEGIN





	DECLARE v_finished 	   INT DEFAULT 0;

	DECLARE SHORTNAME_		VARCHAR(100);

	DECLARE QTD_ALU_			BIGINT;

	DECLARE COUNT_COMMIT_   BIGINT;

	DECLARE COUNT_LIMIT_		BIGINT;





	DECLARE c_cursos CURSOR FOR



             SELECT DISTINCT ed1.SHORTNAME

					FROM tbl_retorno_nt2_ed3 ed1;





	DECLARE c_shortname CURSOR FOR



				 SELECT ed1.SHORTNAME, COUNT(ed1.USERNAME) AS QTD_GRP

				   FROM tbl_retorno_nt2_ed3 ed1

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

															PA						DECIMAL(4,1),

															AUSENCIA				INT

									 				);







	CREATE INDEX idx_BASE ON tbl_retorno_base_ausenc2 (SHORTNAME);

	

	

	

	

	DROP TABLE IF EXISTS tbl_retorno_base2;





	CREATE TABLE tbl_retorno_base2 (

												UNIDADE			VARCHAR(100),

												SHORTNAME		VARCHAR(100),

												USERNAME			VARCHAR(100),

												NOTA				DECIMAL(4,1)

						 				    );





	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME);

	

	



	DROP TABLE IF EXISTS tbl_retorno_nt2_ed3;





	CREATE TABLE tbl_retorno_nt2_ed3 (

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





   CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_ed3 (SHORTNAME);







	

	

		INSERT INTO tbl_retorno_nt2_ed3 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,

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

					  LEFT JOIN kls_lms_turmas t ON t.id_turma=pt.id_turma AND t.fl_etl_atu != 'E'

					 WHERE pcd.id_papel = 1

			  			AND cd.shortname IN ('ED_EMP','ED_EPD','ED_EDU','ED_POL','ED_DEM','ED_CIE','ED_RES')

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





	







	



		DELETE ed1 FROM tbl_retorno_nt2_ed3 ed1

		  JOIN mdl_course mc ON mc.shortname = ed1.SHORTNAME

		 WHERE mc.visible = 0;



	





	

	

		UPDATE tbl_retorno_nt2_ed3 ed1

		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ed1.AUSENCIA_SIAE

		   SET ed1.TURMA = t.cd_turma

		 WHERE ed1.TURMA = '';

	

	





	

	

		UPDATE tbl_retorno_nt2_ed3 ed1

		  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = ed1.AUSENCIA_SIAE

		   SET ed1.AUSENCIA_SIAE = cd.carga_horaria;

	

	

 	

	



	OPEN c_cursos;





	  get_CURSOS: LOOP





	  FETCH c_cursos INTO SHORTNAME_;





	  IF v_finished = 1 THEN



	  		LEAVE get_CURSOS;



	  END IF;

	  

	  



				INSERT INTO tbl_retorno_base2

	

						SELECT ed1.CD_INSTITUICAO AS UNIDADE,

								 UPPER(c.shortname) AS SHORTNAME,

								 u.username AS USERNAME,

								 gg.finalgrade AS NOTA

						  FROM tbl_retorno_nt2_ed3 ed1

						  JOIN tbl_mdl_user u ON u.username = ed1.USERNAME

						  JOIN tbl_mdl_course c ON c.shortname = ed1.SHORTNAME

						  JOIN tbl_mdl_grade_items gi ON gi.courseid = c.id

															  AND gi.itemtype = 'mod'

															  AND gi.itemmodule = 'quiz'

															  AND gi.itemname REGEXP '^Avalia'

															  AND gi.hidden != 1

						  JOIN mdl_course_modules cm ON cm.course = c.id

						  									 AND cm.instance = gi.iteminstance

						  JOIN tbl_notas gg ON gi.id = gg.itemid

						  								  AND gg.userid = u.id

						 WHERE ed1.SHORTNAME = SHORTNAME_

						   AND gg.finalgrade IS NOT NULL

						   AND gg.finalgrade > 0

						   AND cm.visible = 1

						 GROUP BY ed1.CD_INSTITUICAO, c.shortname, u.username, gg.finalgrade;



		

	

	

		





	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)



				SELECT UPPER(c.shortname) AS SHORTNAME

				       ,UPPER(c.fullname) AS FULLNAME

						 ,u.id AS USERID

						 ,u.username AS USERNAME

						 ,ed1.CARGA_HORARIA AS CH

						 ,ed1.DISCIPLINA

						 ,15 AS PA

				  FROM tbl_retorno_nt2_ed3 ed1

				  JOIN mdl_user u ON u.username = ed1.USERNAME

				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME

				  JOIN mdl_grade_items gi ON gi.courseid = c.id

												 AND gi.itemtype = 'mod'

												 AND gi.itemmodule = 'quiz'

												 AND gi.itemname REGEXP 'Parcial$'

												 AND gi.hidden != 1

				  JOIN mdl_course_modules cm ON cm.course = c.id

				  									 AND cm.instance = gi.iteminstance

				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid

				   							      AND gg.userid = u.id

				   							      AND gg.finalgrade IS NOT NULL

				 WHERE ed1.SHORTNAME = SHORTNAME_

				   AND cm.visible = 1

				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;

				 



			 INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)



				SELECT UPPER(c.shortname) AS SHORTNAME

				       ,UPPER(c.fullname) AS FULLNAME

						 ,u.id AS USERID

						 ,u.username AS USERNAME

						 ,ed1.CARGA_HORARIA AS CH

						 ,ed1.DISCIPLINA

						 ,20 AS PA

				  FROM tbl_retorno_nt2_ed3 ed1

				  JOIN mdl_user u ON u.username = ed1.USERNAME

				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME

				  JOIN mdl_grade_items gi ON gi.courseid = c.id

												 AND gi.itemtype = 'mod'

												 AND gi.itemmodule = 'quiz'

												 AND gi.itemname REGEXP 'Geral$'

												 AND gi.hidden != 1

				  JOIN mdl_course_modules cm ON cm.course = c.id

				  									 AND cm.instance = gi.iteminstance

				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id AND gg.finalgrade IS NOT NULL

				 WHERE ed1.SHORTNAME = SHORTNAME_

				   AND cm.visible = 1

				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;





	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)



				SELECT UPPER(c.shortname) AS SHORTNAME

				       ,UPPER(c.fullname) AS FULLNAME

						 ,u.id AS USERID

						 ,u.username AS USERNAME

						 ,ed1.CARGA_HORARIA AS CH

						 ,ed1.DISCIPLINA

						 ,25 AS PA

				  FROM tbl_retorno_nt2_ed3 ed1

				  JOIN mdl_user u ON u.username = ed1.USERNAME

				  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME

				  JOIN mdl_grade_items gi ON gi.courseid = c.id

												 AND gi.itemtype = 'mod'

												 AND gi.itemmodule = 'assign'

												 AND gi.itemname REGEXP '1$'

												 AND gi.hidden != 1

				  JOIN mdl_course_modules cm ON cm.course = c.id

				  									 AND cm.instance = gi.iteminstance

				  JOIN mdl_grade_grades gg ON gi.id = gg.itemid AND gg.userid = u.id AND gg.finalgrade IS NOT NULL

				 WHERE ed1.SHORTNAME = SHORTNAME_

				   AND cm.visible = 1

				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;



	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)



				SELECT UPPER(c.shortname) AS SHORTNAME

				       ,UPPER(c.fullname) AS FULLNAME

						 ,u.id AS USERID

						 ,u.username AS USERNAME

						 ,ed1.CARGA_HORARIA AS CH

						 ,ed1.DISCIPLINA

						 ,25 AS PA

				  FROM tbl_retorno_nt2_ed3 ed1

				 INNER JOIN mdl_user u ON u.username = ed1.USERNAME

				 INNER JOIN mdl_course c ON c.shortname = ed1.SHORTNAME

				 INNER JOIN mdl_grade_items gi ON gi.courseid = c.id

												 AND gi.itemtype = 'mod'

												 AND gi.itemmodule = 'assign'

												 AND gi.itemname REGEXP '2$'

												 AND gi.hidden != 1

				 INNER JOIN mdl_course_modules cm ON cm.course = c.id

				  									 AND cm.instance = gi.iteminstance

				 INNER JOIN mdl_grade_grades gg ON gi.id = gg.itemid

				   							      AND gg.userid = u.id AND gg.finalgrade IS NOT NULL

				 WHERE ed1.SHORTNAME = SHORTNAME_

				   AND cm.visible = 1

				 GROUP BY c.fullname, u.id, ed1.DISCIPLINA;

				 

		

			INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)

			

				SELECT DISTINCT 

						  UPPER(c.shortname) AS SHORTNAME

				       ,UPPER(c.fullname) AS FULLNAME

						 ,u.id AS USERID

						 ,u.username AS USERNAME

						 ,0 AS CH

						 ,ed3.DISCIPLINA

						 ,15 AS PA

				  FROM mdl_logstore_standard_log r

				 INNER JOIN mdl_course_modules cm ON cm.id=r.contextinstanceid

				 											AND r.contextlevel=70

				 INNER JOIN mdl_modules m on m.id=cm.module and m.name='url'

				 INNER JOIN mdl_course c ON c.id=cm.course

				 INNER JOIN mdl_url url ON url.course=c.id 

											  AND url.name REGEXP '^Atividade Mult' 

											  AND url.id=cm.instance

				 INNER JOIN mdl_user u ON u.id = r.userid

				 INNER JOIN tbl_retorno_nt2_ed3 ed3 ON ed3.COURSE_ID = c.id 

				 											  AND ed3.USERNAME = u.username

				 WHERE ed3.SHORTNAME = SHORTNAME_;

		



	  		INSERT INTO tbl_retorno_base_ausenc2 (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, PA)



				SELECT rba.SHORTNAME

				       ,rba.FULLNAME

						 ,rba.USERID

						 ,rba.USERNAME

						 ,rba.CH

						 ,rba.DISCIPLINA

						 ,(100 - SUM(rba.PA)) AS PA

				  FROM tbl_retorno_base_ausenc rba

				 WHERE rba.SHORTNAME = SHORTNAME_

				 GROUP BY rba.FULLNAME, rba.USERID, rba.DISCIPLINA;

				 

		

		

		

		

	  

	  		UPDATE tbl_retorno_base_ausenc2 t

			   SET t.AUSENCIA = FLOOR(IFNULL(t.PA, 0) * (t.CH / 100))

			 WHERE t.SHORTNAME = SHORTNAME_;

	  

	   

	  

	  

	

	END LOOP get_CURSOS;



 	CLOSE c_cursos;

 	





	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_EMP'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_EMP'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_EMP';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_EDU'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_EDU'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_EDU';





	

	

	



	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_POL'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_POL'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_POL';





	

	





	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_DEM'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_DEM'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_DEM';





	

	

	



	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_EPD'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_EPD'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_EPD';





	

	



	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_CIE'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_CIE'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_CIE';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1



			JOIN (SELECT rb.*



			       FROM tbl_retorno_base2 rb



			      WHERE rb.SHORTNAME = 'ED_RES'



					LIMIT 0, 100000



				 ) AS nt ON nt.USERNAME = ed1.USERNAME



						  AND nt.SHORTNAME = 'ED_RES'



			SET ed1.NOTA = nt.NOTA



			WHERE ed1.SHORTNAME = 'ED_RES';





	





	



		UPDATE tbl_retorno_nt2_ed3 ed1

			  JOIN (SELECT rb.*

			          FROM tbl_retorno_base_ausenc2 rb

			         WHERE rb.SHORTNAME = 'ED_EMP'

						LIMIT 0, 100000

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

							  AND nt.SHORTNAME = 'ED_EMP'

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

			 WHERE ed1.SHORTNAME = 'ED_EMP';



	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_EDU'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_EDU'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_EDU';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_POL'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_POL'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_POL';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_DEM'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_DEM'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_DEM';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_EPD'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_EPD'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_EPD';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_CIE'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_CIE'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_CIE';





	

	

	

	





		UPDATE tbl_retorno_nt2_ed3 ed1

	

			  JOIN (SELECT rb.*

	

			          FROM tbl_retorno_base_ausenc2 rb

	

			         WHERE rb.SHORTNAME = 'ED_RES'

	

						LIMIT 0, 100000

	

					 ) AS nt ON nt.USERNAME = ed1.USERNAME

	

							  AND nt.SHORTNAME = 'ED_RES'

	

							  AND nt.DISCIPLINA = ed1.DISCIPLINA

	

				SET ed1.AUSENCIA_SIAE = nt.AUSENCIA,

					 ed1.AUSENCIA_OLIMPO = nt.PA

	

			 WHERE ed1.SHORTNAME = 'ED_RES';





	

	





END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
