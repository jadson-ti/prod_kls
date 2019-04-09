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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_MSG
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INDICADORES_MSG`()
BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;

 	DECLARE v_finished 	TINYINT(1) DEFAULT 0;
	DECLARE FROMU		BIGINT(10);
	DECLARE TOU			BIGINT(10);
	DECLARE LASTU		BIGINT(10);
    
   DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;
		

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
   SELECT MAX(id) INTO LASTU FROM sgt_usuario;
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_MSG', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	
	DROP TABLE IF EXISTS tbl_rel_msg1;
	
	CREATE TABLE tbl_rel_msg1 (
											PAPEL 			VARCHAR(10),
											ID_TUTOR 		BIGINT(10),
											LOGIN_TUTOR 	VARCHAR(150),
											TUTOR 			VARCHAR(200),
											QTD_RECEBIDA 	INT
									  );
									 
	
	CREATE INDEX idx_TUTOR_MSG1 ON tbl_rel_msg1 (ID_TUTOR);
	
	
	DROP TABLE IF EXISTS tbl_rel_msg2;
	
	CREATE TABLE tbl_rel_msg2 (
											PAPEL 			VARCHAR(10),
											ID_TUTOR 		BIGINT(10),
											LOGIN_TUTOR 	VARCHAR(150),
											TUTOR 			VARCHAR(200),
											QTD_RESPONDIDA	INT
									  );
									 
	
	CREATE INDEX idx_TUTOR_MSG2 ON tbl_rel_msg2 (ID_TUTOR);
	
	
	
	DROP TABLE IF EXISTS tbl_rel_msg3;
	
	CREATE TABLE tbl_rel_msg3 (
											PAPEL 			VARCHAR(10),
											ID_TUTOR 		BIGINT(10),
											LOGIN_TUTOR 	VARCHAR(150),
											TUTOR 			VARCHAR(200),
											QTD_ENVIADAS 	INT
									  );
									 
	
	CREATE INDEX idx_TUTOR_MSG3 ON tbl_rel_msg3 (ID_TUTOR);
	
	
	DROP TABLE IF EXISTS tbl_indicadores_msg;
	
	CREATE TABLE tbl_indicadores_msg (
													PAPEL 			VARCHAR(10),
													ID_TUTOR 		BIGINT(10),
													LOGIN_TUTOR 	VARCHAR(150),
													TUTOR 			VARCHAR(200),
													QTD_RECEBIDA 	INT,
													QTD_RESPONDIDA	INT,
													PERC_RESPOND	DECIMAL(3,1),
													QTD_ENVIADAS 	INT
									 	  		);
	
	CREATE INDEX idx_TUTOR_MSG ON tbl_indicadores_msg (ID_TUTOR);
	
	SET FROMU=1;
	SET TOU=100;
	
	 tutores: LOOP
	
	
	
		START TRANSACTION;
		
			INSERT INTO tbl_rel_msg1
				SELECT 'Tutor' AS PAPEL,
						 ur.userid AS ID_TUTOR,
						 um.mdl_username AS LOGIN_TUTOR,
						 u.nome AS TUTOR,
						 COUNT(ur.id) AS QTD_RECEBIDA
				  FROM mdl_local_mail_messages m
				 INNER JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
				 INNER JOIN sgt_usuario_moodle um ON um.mdl_user_id = ur.userid
				 INNER JOIN sgt_usuario u ON u.id = um.id_usuario_id
				 INNER JOIN mdl_groups_members gm_destino ON gm_destino.userid = ur.userid
				 INNER JOIN mdl_groups_members gm_origem ON gm_origem.userid = ur.id_from 
				 													 AND gm_origem.groupid = gm_destino.groupid
				 INNER JOIN mdl_groups g ON g.id = gm_destino.groupid
				 INNER JOIN tbl_mdl_course co ON co.id = g.courseid
				 INNER JOIN mdl_context c ON c.instanceid = co.id
				 INNER JOIN mdl_role_assignments ra ON c.id = ra.contextid 
				 											  AND ra.userid = ur.id_from
				 INNER JOIN mdl_user us ON us.id = ur.id_from
				 INNER JOIN mdl_enrol e ON e.courseid = co.id
				 INNER JOIN mdl_user_enrolments ue ON ue.userid = ur.id_from 
				 											 AND ue.enrolid = e.id
				 WHERE ur.role = 'to'
					AND ur.id_from IS NOT NULL
					AND m.draft = 0
					AND u.id_perfil = 1
					AND u.`status` = 'A'
					AND ue.`status` = 0
					AND c.contextlevel = 50
					AND ra.roleid = 5
					AND us.deleted = 0
					AND u.id BETWEEN FROMU AND TOU
				 GROUP BY ur.userid;
				 
				 
				 GET DIAGNOSTICS REGISTROS_ = ROW_COUNT;
	
	
		COMMIT;
	
	
	
	
	
		START TRANSACTION;
		
			INSERT INTO tbl_rel_msg2
				SELECT 'Tutor' AS PAPEL,
						 ur.userid AS ID_TUTOR,
						 um.mdl_username AS LOGIN_TUTOR,
						 u.nome AS TUTOR,
						 COUNT(ur.id) AS QTD_RESPONDIDA
				  FROM mdl_local_mail_messages m
				 INNER JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
				 INNER JOIN sgt_usuario_moodle um ON um.mdl_user_id = ur.userid
				 INNER JOIN sgt_usuario u ON u.id = um.id_usuario_id
				 INNER JOIN mdl_groups_members gm_destino ON gm_destino.userid = ur.userid
				 INNER JOIN mdl_groups_members gm_origem ON gm_origem.userid = ur.id_from 
				 													 AND gm_origem.groupid = gm_destino.groupid
				 INNER JOIN mdl_groups g ON g.id = gm_destino.groupid
				 INNER JOIN mdl_course co ON co.id = g.courseid
				 INNER JOIN mdl_context c ON c.instanceid = co.id
				 INNER JOIN mdl_role_assignments ra ON c.id = ra.contextid 
				 											  AND ra.userid = ur.id_from
				 INNER JOIN mdl_user us ON us.id = ur.id_from
				 INNER JOIN mdl_enrol e ON e.courseid = co.id
				 INNER JOIN mdl_user_enrolments ue ON ue.userid = ur.id_from 
				 											 AND ue.enrolid = e.id
				 WHERE ur.role = 'to'
				   AND ur.id_from IS NOT NULL
				   AND m.draft = 0
				   AND u.id_perfil = 1
				   AND u.`status` = 'A'
				   AND ue.`status` = 0
					AND u.id BETWEEN FROMU AND TOU
				   AND c.contextlevel = 50
				   AND ra.roleid = 5
				   AND us.deleted = 0
				   AND EXISTS (SELECT DISTINCT ref.id
				                 FROM mdl_local_mail_message_refs ref
				                WHERE ref.reference = m.id)
				 GROUP BY ur.userid;
				 
				 
				 GET DIAGNOSTICS REGISTROS_ = ROW_COUNT;
	
	
		COMMIT; 
	
	
	
	
	
		START TRANSACTION;
		
			INSERT INTO tbl_rel_msg3
				SELECT 'Tutor' AS PAPEL,
						 ur.id_from AS ID_TUTOR,
						 um.mdl_username AS LOGIN_TUTOR,
						 u.nome AS TUTOR,
						 COUNT(IFNULL(ur.id, 0)) AS QTD_ENVIADAS
				  FROM mdl_local_mail_messages m
				 INNER JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
				 INNER JOIN sgt_usuario_moodle um ON um.mdl_user_id = ur.id_from
				 INNER JOIN sgt_usuario u ON u.id = um.id_usuario_id
				 INNER JOIN mdl_groups_members gm_destino ON gm_destino.userid = ur.id_from
				 INNER JOIN mdl_groups_members gm_origem ON gm_origem.userid = ur.userid 
				 													 AND gm_origem.groupid = gm_destino.groupid
			 	 INNER JOIN mdl_groups g ON g.id = gm_destino.groupid
				 INNER JOIN mdl_course co ON co.id = g.courseid
				 INNER JOIN mdl_context c ON c.instanceid = co.id
				 INNER JOIN mdl_role_assignments ra ON c.id = ra.contextid 
				 											  AND ra.userid = ur.userid
				 INNER JOIN mdl_user us ON us.id = ur.userid
				 INNER JOIN mdl_enrol e ON e.courseid = co.id
				 INNER JOIN mdl_user_enrolments ue ON ue.userid = ur.userid 
				 											 AND ue.enrolid = e.id
				 WHERE ur.role = 'to'
				   AND ur.id_from IS NOT NULL
				   AND m.draft = 0
				   AND u.id_perfil = 1
				   AND u.`status` = 'A'
				   AND ue.`status` = 0
					AND u.id BETWEEN FROMU AND TOU
				   AND c.contextlevel = 50
				   AND ra.roleid = 5
				   AND us.deleted = 0
				 GROUP BY ur.id_from;
				 
				 
				 GET DIAGNOSTICS REGISTROS_ = ROW_COUNT;
	
	
		COMMIT;
		
		IF (TOU>=LASTU) THEN LEAVE tutores; END IF;
		
		SET FROMU=FROMU+100;
		SET TOU=TOU+100;
		

	END LOOP tutores;
 

	
	
	
	
		START TRANSACTION;
		
			INSERT INTO tbl_indicadores_msg
				SELECT t1.PAPEL,
						 t1.ID_TUTOR,
						 t1.LOGIN_TUTOR,
						 t1.TUTOR,
						 t1.QTD_RECEBIDA,
						 t2.QTD_RESPONDIDA,
						 ROUND(((t2.QTD_RESPONDIDA / t1.QTD_RECEBIDA) * 100), 1) AS PERC_RESPOND,
						 t3.QTD_ENVIADAS
				  FROM tbl_rel_msg1 t1
				 INNER JOIN tbl_rel_msg2 t2 ON t2.ID_TUTOR = t1.ID_TUTOR
				 INNER JOIN tbl_rel_msg3 t3 ON t3.ID_TUTOR = t1.ID_TUTOR
				 GROUP BY t1.ID_TUTOR;
				 
				 
				 GET DIAGNOSTICS REGISTROS_ = ROW_COUNT;
	
	
		COMMIT;


	DROP TABLE IF EXISTS tbl_rel_msg1;
	DROP TABLE IF EXISTS tbl_rel_msg2;
	DROP TABLE IF EXISTS tbl_rel_msg3;
	
 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = (SELECT COUNT(1) FROM tbl_indicadores_msg),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
