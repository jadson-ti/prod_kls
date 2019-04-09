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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG_OLD
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG_OLD`()
BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;

 	DECLARE v_finished 	INT DEFAULT 0;
	DECLARE CURSOS_		BIGINT;
    
    
	DECLARE c_cursos CURSOR FOR 
             SELECT DISTINCT t.CODIGO_CURSO
					FROM tbl_rel_msg t;
					
	
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
		SELECT database(), 'PRC_REL_MSG', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		
	  
	DROP TABLE IF EXISTS tbl_rel_msg;
	
	CREATE TABLE tbl_rel_msg (
											CATEGORIA				VARCHAR(100) DEFAULT 'HOME',
											CODIGO_CURSO			BIGINT,
											CURSO						VARCHAR(200) DEFAULT 'HOME',
											ID_ORIGEM				BIGINT,
											LOGIN_ORIGEM			VARCHAR(200) DEFAULT 'ND',
											NOME_ORIGEM				VARCHAR(200),
											PERFIL_ORIGEM 			VARCHAR(100) DEFAULT 'Tutor',
											ID_DESTINO				BIGINT,
											LOGIN_DESTINO			VARCHAR(200) DEFAULT NULL,
											NOME_DESTINO			VARCHAR(200) DEFAULT NULL,
											PERFIL_DESTINO			VARCHAR(100) DEFAULT ' ',
											FILTROS					LONGTEXT DEFAULT NULL,
											FILTROS_TST				LONGTEXT DEFAULT NULL,
											QTD_MSG					INT,
											QTD_MSG_N_LIDA			INT,
											DT_ULTIMA_MSG			DATETIME
									 );
	
	CREATE INDEX idx_CODIGO_CURSO ON tbl_rel_msg (CODIGO_CURSO);



	START TRANSACTION;
	
		INSERT INTO tbl_rel_msg (CODIGO_CURSO, ID_DESTINO, ID_ORIGEM, NOME_ORIGEM, FILTROS, FILTROS_TST, QTD_MSG, QTD_MSG_N_LIDA, DT_ULTIMA_MSG)
			SELECT mm.courseid AS CODIGO_CURSO
				  , mu.userid AS ID_DESTINO
				  , mu.id_from AS ID_ORIGEM
				  , mu.fullname_tutor AS NOME_ORIGEM
				  , mm.filters AS FILTROS
				  , mm.filters AS FILTROS_TST
				  , COUNT(DISTINCT mu.id) AS QTD_MSG
				  , SUM(mu.unread) AS QTD_MSG_N_LIDA
				  , MAX(FROM_UNIXTIME(mm.time)) AS DT_ULTIMA_MSG
			 FROM mdl_local_mail_message_users mu
			INNER JOIN mdl_local_mail_messages mm ON mm.id = mu.messageid
			WHERE mu.role = 'to' 
			  AND mu.id_from IS NOT NULL
			  AND mu.userid IS NOT NULL
			  AND mm.draft = 0
			  
			GROUP BY mm.courseid, mu.userid, mu.id_from;
	
	
		 GET DIAGNOSTICS REGISTROS_ = ROW_COUNT;
	
	COMMIT;
	 			
	
	OPEN c_cursos;
	  
	  get_CURSOS: LOOP
	  
	  FETCH c_cursos INTO CURSOS_;
	  									 
	  IF v_finished = 1 THEN 
	  		LEAVE get_CURSOS;
	  END IF;
	
	
	
		START TRANSACTION;
				
			UPDATE tbl_rel_msg t
			  JOIN mdl_course c ON c.id = t.CODIGO_CURSO
			  JOIN mdl_course_categories cc ON cc.id = c.category
			   SET t.CURSO = c.fullname, t.CATEGORIA = cc.name
			 WHERE t.CODIGO_CURSO = CURSOS_;
		
		COMMIT;
		
	
	
		START TRANSACTION;
				
			UPDATE tbl_rel_msg t
			  JOIN tbl_mdl_user u ON u.id = t.ID_ORIGEM
			   SET t.LOGIN_ORIGEM = u.username
			 WHERE t.CODIGO_CURSO = CURSOS_;
		
		COMMIT;
		
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			  JOIN mdl_context ct ON ct.instanceid = t.CODIGO_CURSO 
			  							AND ct.contextlevel = 50
			  JOIN mdl_role_assignments ra ON ra.userid = t.ID_ORIGEM
			  										AND ra.contextid = ct.id
			  JOIN mdl_role r ON r.id = ra.roleid
			   SET t.PERFIL_ORIGEM = r.name
			 WHERE t.CODIGO_CURSO = CURSOS_;
		
		COMMIT;
	
	
	
		START TRANSACTION;
				
			UPDATE tbl_rel_msg t
			  JOIN tbl_mdl_user u ON u.id = t.ID_DESTINO
			   SET t.LOGIN_DESTINO = u.username, 
					 t.NOME_DESTINO = CONCAT(u.firstname, ' ', u.lastname)
			 WHERE t.CODIGO_CURSO = CURSOS_;
		
		COMMIT;

	
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			  JOIN mdl_context ct ON ct.instanceid = t.CODIGO_CURSO 
			  							AND ct.contextlevel = 50
			  JOIN mdl_role_assignments ra ON ra.userid = t.ID_DESTINO
			  										AND ra.contextid = ct.id
			  JOIN mdl_role r ON r.id = ra.roleid
			   SET t.PERFIL_DESTINO = r.name
			 WHERE t.CODIGO_CURSO = CURSOS_;
		
		COMMIT;
		
		
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			   SET t.FILTROS = REPLACE((
									  SUBSTR(t.FILTROS, 
				  								 (INSTR(t.FILTROS, '"ava_course":"') + LENGTH('"ava_course":"') + 1),
				  								 (INSTR(SUBSTR(t.FILTROS,(INSTR(t.FILTROS, '"ava_course":"') + LENGTH('"ava_course":"') + 1)), "'") - 1)
							 				  )
									 ),'\'','')			
			 WHERE t.CODIGO_CURSO = CURSOS_
			   AND t.FILTROS IS NOT NULL
				AND t.FILTROS != '';
		
		COMMIT;	
		
	
	END LOOP get_CURSOS;
 
 	CLOSE c_cursos;
	
		START TRANSACTION;
		
			UPDATE tbl_rel_msg SET FILTROS = REPLACE(FILTROS, '\\', '');
		
		COMMIT;
	
	
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			  JOIN tbl_mdl_course c ON c.shortname = t.FILTROS
			   SET t.FILTROS = c.id;
		
		COMMIT;
		

		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			   SET t.CODIGO_CURSO = t.FILTROS		
			 WHERE t.FILTROS IS NOT NULL
			   AND t.FILTROS != '';
		
		COMMIT;
		
		
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			   SET t.CURSO = (SELECT fullname FROM mdl_course WHERE id = t.FILTROS)
			 WHERE t.FILTROS IS NOT NULL
			   AND t.FILTROS != '';
		
		COMMIT;
		
		
		START TRANSACTION;
		
			UPDATE tbl_rel_msg t
			   SET t.CATEGORIA = (SELECT cc.name 
										   FROM mdl_course c
										   JOIN mdl_course_categories cc ON cc.id = c.category
										  WHERE c.id = t.FILTROS)
			 WHERE t.FILTROS IS NOT NULL
			   AND t.FILTROS != '';
		
		COMMIT;
	
	
	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_rel_msg)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
