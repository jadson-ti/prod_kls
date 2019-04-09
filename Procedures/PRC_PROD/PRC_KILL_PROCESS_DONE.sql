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

-- Copiando estrutura para procedure prod_kls.PRC_KILL_PROCESS_DONE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_KILL_PROCESS_DONE`()
BEGIN

	DECLARE v_finished 	 INT DEFAULT 0;   
   DECLARE PROCESS_ID_	 BIGINT;
   

	DECLARE c_process CURSOR FOR 
          SELECT DISTINCT p.id
				FROM information_schema.`PROCESSLIST` p
			  WHERE p.DB = 'prod_kls'
			    AND (p.STATE = 'delayed send ok done' 
				 		OR p.STATE = 'cleaned up'
				 		OR p.STATE = 'delayed commit ok done')
				 AND p.COMMAND = 'Sleep'
				 AND p.TIME > 100
				 AND p.USER != 'kls_dblink'
				 AND p.INFO IS NULL;
			    
			    
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;


	OPEN c_process;
	  
	   get_PROCESS: LOOP
	  
	   FETCH c_process INTO PROCESS_ID_;
	  									 
	   IF v_finished = 1 THEN 
	  		LEAVE get_PROCESS;
	   END IF;


			CALL mysql.rds_kill(PROCESS_ID_);


		END LOOP get_PROCESS;
 
 	CLOSE c_process;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
