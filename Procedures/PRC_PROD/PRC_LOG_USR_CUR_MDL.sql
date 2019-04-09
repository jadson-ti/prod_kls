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

-- Copiando estrutura para procedure prod_kls.PRC_LOG_USR_CUR_MDL
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_LOG_USR_CUR_MDL`()
BEGIN

	DECLARE nowid_ INT(15);
	DECLARE maxid_	INT(15);
	
	DECLARE courseid_		BIGINT(10);
	DECLARE finished_		TINYINT DEFAULT 0;
	
	
	DECLARE c_cursos CURSOR FOR 
          SELECT DISTINCT c.id
			   FROM mdl_course c;


	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET finished_ = 1;
	
	
	OPEN c_cursos;
	  
	  get_CURSOS: LOOP
	  
	  FETCH c_cursos INTO courseid_;
	  									 
	  IF finished_ = 1 THEN 
	  		LEAVE get_CURSOS;
	  END IF;
	
	
		SELECT IFNULL(MAX(t.id), 0) INTO nowid_ 
		  FROM tbl_log_usr_cur_mdl t 
		 WHERE t.COURSE = courseid_;
		
		SELECT MAX(t.id) INTO maxid_ 
		  FROM mdl_logstore_standard_log t
		 WHERE t.courseid = courseid_
					 	AND t.eventname='\core\event\course_viewed' and action='viewed';
		
		WHILE nowid_ <  maxid_ DO
			
		
			START TRANSACTION;
			
				INSERT INTO tbl_log_usr_cur_mdl
					SELECT t.id,
							 t.userid,
							 t.courseid,
							 t.contextinstanceid,
							 t.timecreated
					  FROM mdl_logstore_standard_log t 
					 WHERE t.courseid = courseid_
					 	AND t.eventname='\core\event\course_viewed'  and action='viewed'
					 	AND t.id > nowid_
					 ORDER BY t.id
					 LIMIT 0, 100000;
			
			COMMIT;
		
			
			SELECT MAX(t.id) INTO nowid_ 
			  FROM tbl_log_usr_cur_mdl t 
			 WHERE t.COURSE = courseid_;
			
		
		END WHILE;


	END LOOP get_CURSOS;
 
	CLOSE c_cursos;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
