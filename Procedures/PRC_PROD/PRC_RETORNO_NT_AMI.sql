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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT_AMI`()
BEGIN

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

	DECLARE v_finished 	   TINYINT(1) DEFAULT 0;
	DECLARE CURSOS_			BIGINT(10);
	DECLARE COURSE_ID_		BIGINT(10);
	DECLARE SHORTNAME_		VARCHAR(100);
	DECLARE QTD_ATIVIDADE_	INT(3);
	DECLARE QTD_ALU_			INT;


	DECLARE c_shortname CURSOR FOR
             SELECT ami.COURSE_ID,
             		  COUNT(ami.USERNAME) AS QTD_GRP
					FROM tbl_retorno_nt_ami ami
				  GROUP BY ami.COURSE_ID
				  ORDER BY QTD_GRP;


	DECLARE c_cursos CURSOR FOR
		SELECT tc.id, tc.shortname, COUNT(gi.id) AS QTD_ATIVIDADES
		  FROM tbl_shortname_nt_ami sna
		  JOIN tbl_mdl_course tc ON tc.shortname = sna.SHORTNAME
		  JOIN tbl_mdl_grade_items gi ON gi.courseid = tc.id
		 WHERE  tc.id != 697
		   AND (gi.itemname REGEXP '^U1'
		     OR gi.itemname REGEXP '^U2')
		   AND (gi.itemname REGEXP 'dade$'
		     OR gi.itemname REGEXP 'agem$'
		     OR gi.itemname REGEXP 'tica$')
		 GROUP BY tc.id, tc.shortname;
                
                
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;
     

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_RETORNO_NT_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;


	DROP TABLE IF EXISTS tbl_retorno_base1;

	CREATE TABLE tbl_retorno_base1 (
													COURSEID			BIGINT,
													SHORTNAME		VARCHAR(100),
													BIMESTRE			INT,
													ITEMNAMEID		BIGINT,
													ITEMNAME			VARCHAR(200),
													USERID			BIGINT,
													USERNAME			VARCHAR(100),
													BONUS				DECIMAL(3,1)
							 				  );
							 				  
	CREATE INDEX idx_RB1_AMI ON tbl_retorno_base1 (COURSEID);
	
	

	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
												COURSEID		BIGINT,
												BIMESTRE		INT,
												USERNAME		VARCHAR(100),
												BONUS			DECIMAL(3,1)
										 );

	CREATE INDEX idx_RB2_AMI ON tbl_retorno_base2 (COURSEID);
	
	
	
	DROP TABLE IF EXISTS tbl_retorno_nt_ami;

	CREATE TABLE tbl_retorno_nt_ami (
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
													AUSENCIA					BIGINT,
													NOTA						DECIMAL(3,1) DEFAULT 0												
											 );

 	CREATE INDEX idx_NT1_AMI ON tbl_retorno_nt_ami (COURSE_ID, ORIGEM);
											 

	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt_ami (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
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
					 	WHEN p.id_pessoa > 100000000 THEN
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
			  JOIN tbl_shortname_nt_ami st ON st.shortname = tc.shortname
			 WHERE pcd.id_papel = 1
	  			AND cd.shortname != ''
	  			AND cd.shortname != 'A DEFINIR'
			   AND tm.sigla REGEXP '^AMI'
			   
			   AND d.fl_etl_atu != 'E'
			   AND tc.id != 697
			  
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
	
		UPDATE tbl_retorno_nt_ami ami
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ami.AUSENCIA
		   SET ami.TURMA = t.cd_turma
		 WHERE ami.TURMA = '';
	
	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt_ami ami
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
					  FROM tbl_mdl_course c
					  JOIN mdl_context ct ON ct.contextlevel = 50
					 						   AND ct.instanceid = c.id
					  JOIN mdl_role_assignments ra ON ra.contextid = ct.id
					 									   AND ra.roleid = 5
					  JOIN tbl_mdl_user u ON u.id = ra.userid
					  JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
														  AND gi.courseid = c.id
														  AND (UPPER(gi.itemname) REGEXP '^U1'
														   OR  UPPER(gi.itemname) REGEXP '^U2')
					  JOIN tbl_notas gg ON gg.USERID = u.id
					  								  		AND gi.id = gg.ITEMID
					 WHERE c.id = CURSOS_
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

				UPDATE tbl_retorno_nt_ami ami
				  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami.USERNAME
												   AND rb.COURSEID = ami.COURSE_ID
				   SET ami.NOTA = rb.BONUS
				 WHERE ami.COURSE_ID = COURSE_ID_
				   AND ami.ORIGEM = 'SIAE';

			COMMIT;
			
			
			START TRANSACTION;
		
					UPDATE tbl_retorno_nt_ami ami
					  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami.USERNAME
													   AND rb.COURSEID = ami.COURSE_ID
					   SET ami.NOTA = (rb.BONUS * 5)
					 WHERE ami.COURSE_ID = COURSE_ID_ 
					   AND ami.ORIGEM = 'OLIMPO';
		
			COMMIT;
			
		END IF;


	END LOOP get_SHORTNAME;

 	CLOSE c_shortname;
 	

	




	
	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_retorno_nt_ami)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
