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

-- Copiando estrutura para procedure prod_kls.PRC_CUR_SEC_3
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CUR_SEC_3`()
BEGIN

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;
	
	DECLARE v_finished 	 TINYINT(1) DEFAULT 0;   
   DECLARE CURSOS_		 BIGINT(10);
   
   DECLARE c_cursos CURSOR FOR 
          SELECT DISTINCT c.id
			   FROM mdl_course c
			  WHERE c.shortname REGEXP '^DI\_';
			  
			  
	DECLARE c_cursos_ami CURSOR FOR 
          SELECT DISTINCT c.id
			   FROM mdl_course c
			  WHERE c.shortname REGEXP '^AMI\_';


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
		SELECT DATABASE(), 'PRC_CUR_SEC_3', USER(), SYSDATE(), 'PROCESSANDO' FROM DUAL;

	
	DROP TABLE IF EXISTS tbl_cur_sec_3;
	
	CREATE TABLE tbl_cur_sec_3(
											DISCIPLINA_PAI VARCHAR(200),
											DISCIPLINA	 VARCHAR(200),
											COD_DISC	    VARCHAR(100),
											DSC_TP_DISC  VARCHAR(200),
											SIGLA			 VARCHAR(10),
											CURSO	   	 VARCHAR(200),
											COD_CUR	    VARCHAR(100),
											TURMA	   	 VARCHAR(100),
											DSC_MARCA	 VARCHAR(200),
											UNIDADE	    VARCHAR(200),
											COD_UND	    VARCHAR(100)
									  );


	OPEN c_cursos;
	  
		get_CURSOS: LOOP
	  
		FETCH c_cursos INTO CURSOS_;
	  									 
		IF v_finished = 1 THEN 
	  		LEAVE get_CURSOS;
	   END IF;

		START TRANSACTION;
	
			INSERT INTO tbl_cur_sec_3
				SELECT c.fullname,
						 d.ds_disciplina, 
						 d.cd_disciplina,
						 tp.ds_tipo_disciplina,
						 tp.sigla, 
						 lc.nm_curso, 
						 lc.cd_curso, 
						 t.cd_turma,
						 i.ds_marca,  
						 i.nm_ies, 
						 i.cd_instituicao
				  FROM tbl_mdl_course c
				  JOIN mdl_course_sections cs ON cs.course = c.id
				  JOIN mdl_label l ON l.course = c.id
				  JOIN kls_lms_curso_disciplina cd ON cd.shortname = c.shortname
				  JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  JOIN kls_lms_tipo_modelo tp ON tp.id_tp_modelo = d.id_tp_modelo
				  JOIN kls_lms_curso lc ON lc.id_curso = cd.id_curso
				  JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
				  JOIN kls_lms_instituicao i ON i.id_ies = lc.id_ies
				 WHERE c.id = CURSOS_
				 GROUP BY d.cd_disciplina, lc.cd_curso, t.cd_turma, i.cd_instituicao
				HAVING COUNT(DISTINCT l.id) = 12;
	
		COMMIT;


		END LOOP get_CURSOS;
 
 	CLOSE c_cursos;


	SET v_finished = 0;


	OPEN c_cursos_ami;
	  
		get_CURSOS: LOOP
	  
		FETCH c_cursos_ami INTO CURSOS_;
	  									 
		IF v_finished = 1 THEN 
	  		LEAVE get_CURSOS;
	   END IF;

		START TRANSACTION;
	
			INSERT INTO tbl_cur_sec_3
				SELECT c.fullname,
						 d.ds_disciplina, 
						 d.cd_disciplina,
						 tp.ds_tipo_disciplina,
						 tp.sigla, 
						 lc.nm_curso, 
						 lc.cd_curso, 
						 t.cd_turma,
						 i.ds_marca,  
						 i.nm_ies, 
						 i.cd_instituicao
				  FROM tbl_mdl_course c
				  JOIN mdl_course_sections cs ON cs.course = c.id
				  JOIN tbl_mdl_grade_items gi ON gi.courseid = c.id
				  JOIN kls_lms_curso_disciplina cd ON cd.shortname = c.shortname
				  JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
				  JOIN kls_lms_tipo_modelo tp ON tp.id_tp_modelo = d.id_tp_modelo
				  JOIN kls_lms_curso lc ON lc.id_curso = cd.id_curso
				  JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
				  JOIN kls_lms_instituicao i ON i.id_ies = lc.id_ies
				 WHERE c.id = CURSOS_
					AND (gi.itemname REGEXP 'dade$'
			        OR gi.itemname REGEXP 'agem$'
			        OR gi.itemname REGEXP 'tica$')
				 GROUP BY d.cd_disciplina, lc.cd_curso, t.cd_turma, i.cd_instituicao
				HAVING COUNT(DISTINCT gi.id) = 28;
	
		COMMIT;


		END LOOP get_CURSOS;
 
 	CLOSE c_cursos_ami;


	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_cur_sec_3)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
