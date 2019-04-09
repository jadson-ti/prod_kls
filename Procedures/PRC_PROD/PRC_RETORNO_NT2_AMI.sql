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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_AMI`()
BEGIN

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

	DECLARE v_finished 	   TINYINT DEFAULT 0;
	DECLARE CURSOS_			BIGINT(10);
	DECLARE COURSE_ID_		BIGINT(10);
	DECLARE SHORTNAME_		VARCHAR(255);
	DECLARE QTD_ATIVIDADE_	INT(3);
	DECLARE QTD_ALU_			INT;


	DECLARE c_shortname CURSOR FOR
             SELECT ami.COURSE_ID,
             		  COUNT(ami.USERNAME) AS QTD_GRP
					FROM tbl_retorno_nt2_ami ami
				  GROUP BY ami.COURSE_ID
				  ORDER BY QTD_GRP;


	DECLARE c_cursos CURSOR FOR
       SELECT tc.id, tc.shortname, COUNT(gi.id) AS QTD_ATIVIDADES
		   FROM tbl_mdl_course tc
		   JOIN tbl_shortname_nt_ami st ON st.shortname = tc.shortname
		   JOIN tbl_mdl_grade_items gi ON gi.courseid = tc.id
		  WHERE tc.id != 425
		    AND (gi.itemname REGEXP '^U3'
		      OR gi.itemname REGEXP '^U4')
		    AND (gi.itemname REGEXP 'dade$'
		      OR gi.itemname REGEXP 'agem$'
		      OR gi.itemname REGEXP 'tica$')
		  GROUP BY tc.id, tc.shortname;
		  

  DECLARE CONTINUE HANDLER
     FOR NOT FOUND SET v_finished = 1;
     
   
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_RETORNO_NT2_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		

	DROP TABLE IF EXISTS tbl_retorno_base1;

	CREATE TABLE tbl_retorno_base1 (
													COURSEID			BIGINT(10),
													SHORTNAME		VARCHAR(255),
													BIMESTRE			INT,
													ITEMNAMEID		BIGINT(10),
													ITEMNAME			VARCHAR(255),
													USERID			BIGINT(10),
													USERNAME			VARCHAR(100),
													BONUS				DECIMAL(3,1)
							 				  );
							 				  
	CREATE INDEX idx_RB1_AMI ON tbl_retorno_base1 (COURSEID);
	
	

	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
												COURSEID		BIGINT(10),
												BIMESTRE		INT,
												USERNAME		VARCHAR(100),
												BONUS			DECIMAL(3,1)
										 );

	CREATE INDEX idx_RB2_AMI ON tbl_retorno_base2 (COURSEID);
	
	
	
	DROP TABLE IF EXISTS tbl_retorno_nt2_ami;

	CREATE TABLE tbl_retorno_nt2_ami (
													CD_INSTITUICAO			VARCHAR(20),
												   NM_IES					VARCHAR(200),
													CD_PESSOA				VARCHAR(100),
													USERNAME					VARCHAR(100),
													NOME_USUARIO			VARCHAR(200),
													COURSE_ID				BIGINT(10),
													SHORTNAME				VARCHAR(255),
													FULLNAME					VARCHAR(200),
													CD_CURSO					VARCHAR(100),
													CURSO						VARCHAR(200),
													CD_DISCIPLINA			VARCHAR(100),
													DISCIPLINA				VARCHAR(200),
													TURMA						VARCHAR(100),
												 	ORIGEM					VARCHAR(100),
													CARGA_HORARIA			SMALLINT(10),
													AUSENCIA					BIGINT(20),
													NOTA						DECIMAL(3,1) DEFAULT 0												
											 );

 	CREATE INDEX idx_NT1_AMI ON tbl_retorno_nt2_ami (COURSE_ID, ORIGEM);
											 

	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt2_ami (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA, AUSENCIA)
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
					 CASE
					 	WHEN (p.id_pessoa > 100000000) AND (p.id_pessoa < 800000000) THEN
					 		'SIAE'
					 	ELSE
					 		'OLIMPO'
					 END AS ORIGEM,
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
			  JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
			  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
			  JOIN tbl_mdl_course tc ON tc.shortname = cd.shortname
			  JOIN tbl_mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
			  JOIN tbl_shortname_nt_ami st ON st.SHORTNAME = tc.shortname
			 WHERE pcd.id_papel = 1
	  			AND cd.shortname != ''
	  			AND cd.shortname != 'A DEFINIR'
			   AND tm.sigla REGEXP '^AMI'
			   AND i.cd_instituicao != 'OLIM-697'
			   AND tc.id != 425
			   
				
					   
					   
	
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
	
		UPDATE tbl_retorno_nt2_ami ami
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ami.AUSENCIA
		   SET ami.TURMA = t.cd_turma
		 WHERE ami.TURMA = '';
	
	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_ami ami
		   SET ami.AUSENCIA = 0;
	
	COMMIT;
	


	OPEN c_cursos;

	  get_CURSOS: LOOP

	  FETCH c_cursos INTO CURSOS_, SHORTNAME_, QTD_ATIVIDADE_;

	  IF v_finished = 1 THEN
	  		LEAVE get_CURSOS;
	  END IF;


	START TRANSACTION;

		INSERT INTO tbl_retorno_base1
					SELECT c.id AS COURSEID,
							 c.shortname,
							 CASE
							   WHEN IFNULL(SUBSTR(gi.itemname,2,1), 1) IN (1,2) THEN
							   	1
							   ELSE
							  		2
							 END AS BIMESTRE,
							 gi.id,
							 gi.itemname,
							 u.id,
							 u.username,
							 CASE
							 	WHEN (gg.finalgrade >= (gi.grademax * 0.6)) THEN
									2
							 	WHEN (gg.finalgrade < (gi.grademax * 0.6)) THEN
									1
							 	ELSE
									0
							 END AS BONUS
					  FROM tbl_retorno_nt2_ami di1
					 
					  JOIN tbl_mdl_course c ON c.shortname = di1.SHORTNAME
					  JOIN tbl_mdl_user u ON u.username = di1.USERNAME
					  JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
														  AND gi.courseid = c.id
														  AND (UPPER(gi.itemname) REGEXP '^U3'
														   OR  UPPER(gi.itemname) REGEXP '^U4')
					  JOIN mdl_course_modules cm ON cm.course = c.id
					  	 								 AND cm.module IN (select id from mdl_modules where name='quiz')
					  									 AND cm.instance = gi.iteminstance
					  JOIN tbl_notas gg ON gg.userid = u.id
					  								  		AND gi.id = gg.itemid
					 WHERE c.id = CURSOS_
					   AND cm.visible = 1
					 GROUP BY c.id, c.shortname, u.id, u.username, gi.itemname;

	COMMIT;

	IF QTD_ATIVIDADE_ > 0 THEN
	
		START TRANSACTION;
	
			INSERT INTO tbl_retorno_base2
						SELECT a.COURSEID,
								 a.BIMESTRE,
								 a.USERNAME,
								 IFNULL(ROUND((SUM(a.nota) / QTD_ATIVIDADE_), 1), 0) AS BONUS
						  FROM (SELECT rb1.COURSEID,
											rb1.SHORTNAME,
											rb1.ITEMNAME,
											rb1.USERID,
											rb1.USERNAME,
											rb1.BIMESTRE,
											rb1.BONUS AS nota
									 FROM tbl_retorno_base1 rb1
									WHERE rb1.COURSEID = CURSOS_
									GROUP BY rb1.COURSEID, rb1.SHORTNAME, rb1.USERID, rb1.USERNAME, rb1.ITEMNAME) a
						GROUP BY a.COURSEID, a.BIMESTRE, a.USERNAME;
	
		COMMIT;



		START TRANSACTION;
		
			UPDATE tbl_shortname_nt_ami sna
			   SET sna.`STATUS` = 'SUCESSO'
			 WHERE sna.SHORTNAME = SHORTNAME_;
			 
		 COMMIT;

	ELSE
		
		START TRANSACTION;
		
			UPDATE tbl_shortname_nt_ami sna
			   SET sna.`STATUS` = CONCAT('ERRO - Quantidade de Atividades: ', QTD_ATIVIDADE_)
			 WHERE sna.SHORTNAME = SHORTNAME_;
		
		COMMIT;
		
	END IF;
	
	
	END LOOP get_CURSOS;

 	CLOSE c_cursos;
	

	
	SET v_finished = 0;


	OPEN c_shortname;

	  get_SHORTNAME: LOOP

	  FETCH c_shortname INTO COURSE_ID_, QTD_ALU_;

	  IF v_finished = 1 THEN
	  		LEAVE get_SHORTNAME;
	  END IF;
	  
	  
	  	IF QTD_ALU_ <= 10000 THEN

			START TRANSACTION;

				UPDATE tbl_retorno_nt2_ami ami
				  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami.USERNAME
												   AND rb.COURSEID = ami.COURSE_ID
				   SET ami.NOTA = rb.BONUS
				 WHERE ami.COURSE_ID = COURSE_ID_
				   AND ami.ORIGEM = 'SIAE';

			COMMIT;
			
			
			START TRANSACTION;
		
					UPDATE tbl_retorno_nt2_ami ami
					  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami.USERNAME
													   AND rb.COURSEID = ami.COURSE_ID
					   SET ami.NOTA = (rb.BONUS * 5)
					 WHERE ami.COURSE_ID = COURSE_ID_ 
					   AND ami.ORIGEM = 'OLIMPO';
		
			COMMIT;
			
		END IF;


	END LOOP get_SHORTNAME;

 	CLOSE c_shortname;
 	
 	
 	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 18
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 18
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 18
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 18
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 60
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 60
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 60
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 60
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;

	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 25
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 25
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 25
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 25
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 476
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 476
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 476
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 476
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 525
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 525
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 525
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 525
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 519
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 519
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 519
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 519
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 47
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 47
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 47
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 47
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	

	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 8
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 8
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 8
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 8
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 494
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 494
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 494
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 494
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 615
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 615
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 615
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 615
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 486
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 486
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 486
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 486
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 533
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 533
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 533
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 533
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 413
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 413
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 413
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 413
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 52
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 52
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 52
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 52
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 593
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 593
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 593
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 593
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 523
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 523
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 523
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 523
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 532
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 532
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 532
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 532
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 624
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = nt.BONUS
		 WHERE ami.COURSE_ID = 624
			AND ami.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami ami
			JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.COURSEID = 624
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ami.USERNAME
						  AND nt.COURSEID = ami.COURSE_ID
			SET ami.NOTA = (nt.BONUS * 5)
		 WHERE ami.COURSE_ID = 624
			AND ami.ORIGEM = 'OLIMPO';

	COMMIT;
	

	
	

	


	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_retorno_nt2_ami)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
