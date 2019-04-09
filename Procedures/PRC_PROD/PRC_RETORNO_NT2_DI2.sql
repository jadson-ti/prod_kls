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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_DI2
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_DI2`()
BEGIN


	DECLARE v_finished 	   TINYINT(1) DEFAULT 0;
	DECLARE SHORTNAME_		VARCHAR(255);
	DECLARE AUSENCIA_			INT(10);
	DECLARE QTD_ALU_			BIGINT(10);
	DECLARE COUNT_COMMIT_   BIGINT(10);
	DECLARE COUNT_LIMIT_		BIGINT(10);



	DECLARE c_cursos CURSOR FOR
		SELECT DISTINCT di1.SHORTNAME
		 					 ,(SELECT COUNT(gi.itemname)
								  FROM mdl_course c
								  JOIN mdl_grade_items gi ON gi.courseid = c.id
																 AND gi.itemtype = 'mod'
																 AND gi.itemmodule = 'quiz'
															    AND gi.itemtype = 'mod'
															    AND gi.itemmodule = 'quiz'
															    AND (gi.itemname REGEXP 'Aprendizagem'
															      OR gi.itemname REGEXP 'Unidade')
															    AND gi.hidden != 1
								 WHERE c.shortname = di1.SHORTNAME) AS AUSENCIA
					FROM tbl_retorno_nt2_di2 di1;
	


	DECLARE c_shortname CURSOR FOR

				 SELECT di1.SHORTNAME, COUNT(di1.USERNAME) AS QTD_GRP
				   FROM tbl_retorno_nt2_di2 di1
				  GROUP BY di1.SHORTNAME
				  ORDER BY QTD_GRP;



   DECLARE CONTINUE HANDLER

     FOR NOT FOUND SET v_finished = 1;




	DROP TABLE IF EXISTS tbl_retorno_base_ausenc;


	CREATE TABLE tbl_retorno_base_ausenc (
														SHORTNAME			VARCHAR(255),
														FULLNAME				VARCHAR(255),
														USERID				BIGINT(10),
														USERNAME				VARCHAR(100),
														CH						BIGINT(10),
														DISCIPLINA			VARCHAR(255),
														QTD_TENTATIVA		INT(2),
														PA						DECIMAL(4,1),
														AUSENCIA				INT(10)
								 				    );



	CREATE INDEX idx_BASE ON tbl_retorno_base_ausenc (SHORTNAME, DISCIPLINA, USERNAME);




	DROP TABLE IF EXISTS tbl_retorno_base;


	CREATE TABLE tbl_retorno_base (
												UNIDADE			VARCHAR(255),
												SHORTNAME		VARCHAR(255),
												FULLNAME			VARCHAR(255),
												USERID			BIGINT(10),
												USERNAME			VARCHAR(100),
												ITEMNAME			VARCHAR(255),
												NOTA				DECIMAL(4,1)
						 				    );



	CREATE INDEX idx_BASE ON tbl_retorno_base (SHORTNAME);



	DROP TABLE IF EXISTS tbl_retorno_base1;



	CREATE TABLE tbl_retorno_base1 (
												UNIDADE			VARCHAR(255),
												SHORTNAME		VARCHAR(255),
												USERNAME			VARCHAR(100),
												ITEMNAME			VARCHAR(255),
												NOTA				DECIMAL(4,1)
						 				    );



	CREATE INDEX idx_BASE1 ON tbl_retorno_base1 (SHORTNAME);




	DROP TABLE IF EXISTS tbl_retorno_base2;



	CREATE TABLE tbl_retorno_base2 (
												UNIDADE			VARCHAR(255),
												SHORTNAME		VARCHAR(255),
												USERNAME			VARCHAR(100),
												NOTA				DECIMAL(4,1)
						 				    );


	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME, USERNAME);



	DROP TABLE IF EXISTS tbl_retorno_nt2_di2;


	CREATE TABLE tbl_retorno_nt2_di2 (
													CD_INSTITUICAO			VARCHAR(20),
												   NM_IES					VARCHAR(255),
													CD_PESSOA				VARCHAR(255),
													USERNAME					VARCHAR(100),
													NOME_USUARIO			VARCHAR(255),
													COURSE_ID				BIGINT(10),
													SHORTNAME				VARCHAR(255),
													FULLNAME					VARCHAR(255),
													CD_CURSO					VARCHAR(255),
													CURSO						VARCHAR(255),
													CD_DISCIPLINA			VARCHAR(255),
													DISCIPLINA				VARCHAR(255),
													TURMA						VARCHAR(255),
												 	ORIGEM					VARCHAR(255),
													CARGA_HORARIA			SMALLINT(10),
													AUSENCIA					BIGINT(10),
													NOTA						DECIMAL(3,1) DEFAULT 0
											   );


   CREATE INDEX idx_NT_DI1 ON tbl_retorno_nt2_di2 (SHORTNAME, DISCIPLINA);



	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt2_di2 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA,
												  AUSENCIA)
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
							 cd.id_curso_disciplina AS AUSENCIA
					  FROM kls_lms_pessoa p
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
					  LEFT JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
					  							       AND t.fl_etl_atu != 'E'
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
					  JOIN tbl_mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
					  JOIN tbl_mdl_course tc ON tc.shortname = cd.shortname
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname != ''
			  			AND cd.shortname != 'A DEFINIR'
					   AND d.id_tp_modelo = 3
					   
				
					   
					   
	
					   AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd1.id_cd_remarc 
						  												 FROM kls_lms_curso_disciplina cd1 
																		WHERE cd1.id_cd_remarc > 0
																		AND cd1.fl_etl_atu != 'E')
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


	COMMIT;



	START TRANSACTION;

		DELETE di1 FROM tbl_retorno_nt2_di2 di1
		JOIN mdl_course mc ON mc.shortname = di1.SHORTNAME
		JOIN mdl_course_categories cc ON mc.category = cc.id
		WHERE (cc.name REGEXP '1.0$' OR cc.name REGEXP '1.0 - Blended$' OR cc.name REGEXP '2.0 - Blended$');

	COMMIT;
	

	START TRANSACTION;

		DELETE di1 FROM tbl_retorno_nt2_di2 di1
		JOIN mdl_course mc ON mc.shortname = di1.SHORTNAME
		WHERE mc.visible = 0;

	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_di2 di
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = di.AUSENCIA
		   SET di.TURMA = t.cd_turma
		 WHERE di.TURMA = '';
	
	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_di2 di
		  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = di.AUSENCIA
		   SET di.AUSENCIA = cd.carga_horaria;
	
	COMMIT;






	OPEN c_cursos;



	  get_CURSOS: LOOP



	  FETCH c_cursos INTO SHORTNAME_, AUSENCIA_;



	  IF v_finished = 1 THEN

	  		LEAVE get_CURSOS;

	  END IF;





	  START TRANSACTION;



	  		INSERT INTO tbl_retorno_base_ausenc (SHORTNAME, FULLNAME, USERID, USERNAME, CH, DISCIPLINA, QTD_TENTATIVA, PA)
	  		
	  			SELECT UPPER(c.shortname) AS SHORTNAME
				       ,UPPER(c.fullname) AS FULLNAME
						 ,u.id AS USERID
						 ,u.username AS USERNAME
						 ,ed2.CARGA_HORARIA AS CH
						 ,ed2.DISCIPLINA
						 ,COUNT(DISTINCT gi.itemname) AS QTD_TENTATIVA
						 ,AUSENCIA_ AS PA
				  FROM tbl_mdl_grade_items gi
				 INNER JOIN tbl_retorno_nt2_di2 ed2 ON ed2.COURSE_ID = gi.courseid 
				 INNER JOIN tbl_mdl_user u ON u.username = ed2.USERNAME
				 INNER JOIN tbl_mdl_course c ON c.id = ed2.COURSE_ID
				 INNER JOIN mdl_course_modules cm ON cm.course = ed2.COURSE_ID
												         AND cm.instance = gi.iteminstance
				 INNER JOIN tbl_notas gg ON gi.id = gg.itemid
											              AND gg.userid = u.id
				 WHERE ed2.SHORTNAME = SHORTNAME_
				   AND gi.itemtype = 'mod'
				   AND gi.itemmodule = 'quiz'
				   AND (gi.itemname REGEXP 'Aprendizagem'
				     OR gi.itemname REGEXP 'Unidade')
				   AND gi.hidden != 1
				   AND cm.visible = 1
				 GROUP BY c.fullname, u.id, ed2.DISCIPLINA;




	  COMMIT;

	
	  START TRANSACTION;

			UPDATE tbl_retorno_base_ausenc t
			   
			   SET t.PA = IFNULL(((t.QTD_TENTATIVA * 100) / AUSENCIA_), 0)
			 WHERE t.SHORTNAME = SHORTNAME_;

  	  COMMIT;
	  

	  START TRANSACTION;
	  
	  		UPDATE tbl_retorno_base_ausenc t
			   SET t.AUSENCIA = ((100 - IFNULL(t.PA, 0)) * (t.CH / 100))
			 WHERE t.SHORTNAME = SHORTNAME_;
	  
	  COMMIT;


	  START TRANSACTION;

			INSERT INTO tbl_retorno_base

					SELECT di1.CD_INSTITUICAO AS UNIDADE,
							 UPPER(c.shortname) AS SHORTNAME,
					       UPPER(c.fullname) AS FULLNAME,
							 u.id AS USERID,
							 u.username AS USERNAME,
							 UPPER(gi.itemname) AS ITEMNAME,
							 CASE 
							 	WHEN MAX(gg.finalgrade) = 1 THEN
							 		0
							 	WHEN MAX(gg.finalgrade) = 2 THEN
							 		5
							 	WHEN MAX(gg.finalgrade) = 3 THEN
							 		10
							 	WHEN MAX(gg.finalgrade) = 4 THEN
							 		15
							 	WHEN MAX(gg.finalgrade) = 5 THEN
							 		20
							 	WHEN MAX(gg.finalgrade) = 6 THEN
							 		25
							 	WHEN MAX(gg.finalgrade) = 7 THEN
							 		30
							 END AS NOTA
					  FROM tbl_retorno_nt2_di2 di1
					  JOIN tbl_mdl_user u ON u.username = di1.USERNAME
					  JOIN tbl_mdl_course c ON c.shortname = di1.SHORTNAME
					  JOIN tbl_mdl_grade_items gi ON gi.courseid = c.id
													 	  AND gi.itemtype = 'mod'
													 	  AND gi.itemmodule = 'assign'
					  JOIN mdl_course_modules cm ON cm.course = c.id
					  									 AND cm.instance = gi.iteminstance
					  JOIN tbl_notas gg ON gi.id = gg.itemid
					  								  AND gg.userid = u.id
					 WHERE di1.SHORTNAME = SHORTNAME_
					   AND gg.finalgrade IS NOT NULL
					   AND gg.finalgrade > 0
					   AND cm.visible = 1
					 GROUP BY c.fullname, u.id, gi.itemname, di1.CD_INSTITUICAO;

		COMMIT;





	END LOOP get_CURSOS;



 	CLOSE c_cursos;




   START TRANSACTION;

			INSERT INTO tbl_retorno_base1(UNIDADE, SHORTNAME, USERNAME, ITEMNAME, NOTA)

						SELECT tb.UNIDADE,
								 tb.SHORTNAME,
								 tb.USERNAME,
								 tb.ITEMNAME,
								 MAX(tb.NOTA) AS NOTA
						  FROM tbl_retorno_base tb
						 GROUP BY tb.UNIDADE, tb.SHORTNAME, tb.USERNAME, tb.ITEMNAME;

	COMMIT;


	START TRANSACTION;


			INSERT INTO tbl_retorno_base2(UNIDADE, SHORTNAME, USERNAME, NOTA)

						SELECT tb.UNIDADE,
								 tb.SHORTNAME,
								 tb.USERNAME,
								 ROUND((tb.NOTA / 3), 1) AS NOTA
						  FROM tbl_retorno_base1 tb
						 WHERE (UPPER(tb.UNIDADE) REGEXP '^OLIM'
						    OR  UPPER(tb.UNIDADE) REGEXP '^FAMA')
						 GROUP BY tb.UNIDADE, tb.SHORTNAME, tb.USERNAME;

	COMMIT;


   START TRANSACTION;


			INSERT INTO tbl_retorno_base2(UNIDADE, SHORTNAME, USERNAME, NOTA)

						SELECT tb.UNIDADE,
								 tb.SHORTNAME,
								 tb.USERNAME,
								 ROUND((tb.NOTA / 10), 1) AS NOTA
						  FROM tbl_retorno_base1 tb
						 WHERE UPPER(tb.UNIDADE) NOT REGEXP '^OLIM'
						   AND UPPER(tb.UNIDADE) NOT REGEXP '^FAMA'
						 GROUP BY tb.UNIDADE, tb.SHORTNAME, tb.USERNAME;

	COMMIT;



	SET v_finished = 0;



	OPEN c_shortname;



	  get_SHORTNAME: LOOP



	  FETCH c_shortname INTO SHORTNAME_, QTD_ALU_;



	  IF v_finished = 1 THEN

	  		LEAVE get_SHORTNAME;

	  END IF;



			IF QTD_ALU_ <= 150000 THEN



				START TRANSACTION;

					UPDATE tbl_retorno_nt2_di2 di1
					  JOIN tbl_retorno_base2 rb ON rb.SHORTNAME = di1.SHORTNAME
													   AND rb.USERNAME = di1.USERNAME
					   SET di1.NOTA = rb.NOTA
					 WHERE di1.SHORTNAME = SHORTNAME_;

				COMMIT;



				START TRANSACTION;

					UPDATE tbl_retorno_nt2_di2 di1
					  JOIN tbl_retorno_base_ausenc rba ON  rba.SHORTNAME = di1.SHORTNAME
											      			 AND rba.DISCIPLINA = di1.DISCIPLINA						  
											      			 AND rba.USERNAME = di1.USERNAME
					   SET di1.AUSENCIA = rba.AUSENCIA
					 WHERE di1.SHORTNAME = SHORTNAME_
					   AND UPPER(di1.CD_INSTITUICAO) NOT REGEXP '^OLIM'
						AND UPPER(di1.CD_INSTITUICAO) NOT REGEXP '^FAMA';

				COMMIT;


			END IF;


	END LOOP get_SHORTNAME;


 	CLOSE c_shortname;

	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_di2 di1
		   SET di1.AUSENCIA = 0
		 WHERE (UPPER(di1.CD_INSTITUICAO) REGEXP '^OLIM'
			 OR UPPER(di1.CD_INSTITUICAO) REGEXP '^FAMA');			

	COMMIT;
	




	

	UPDATE tbl_retorno_nt2_di2 t
	SET t.AUSENCIA = 0
	WHERE t.SHORTNAME = 'DI_GES_QUA';
	
	UPDATE tbl_retorno_nt2_di2 t
	SET t.AUSENCIA = 0
	WHERE t.SHORTNAME = 'DI_PSI_APL_ACO';

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
