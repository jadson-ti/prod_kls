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

-- Copiando estrutura para procedure prod_kls.PRC_LOGIN_LOG
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_LOGIN_LOG`()
BEGIN

	DECLARE nowid_ INT(15);
	DECLARE maxid_	INT(15);
	
	SELECT IFNULL(MAX(t.id), 0) INTO nowid_ FROM tbl_login t;
	SELECT MAX(t.id) INTO maxid_ FROM mdl_logstore_standard_log t;
	
	
			INSERT INTO tbl_login
				SELECT t.id,
						 t.userid,
						 t.courseid,
						 t.timecreated
				  FROM mdl_logstore_standard_log t
				 WHERE t.action REGEXP 'viewed'
				   AND t.id > nowid_;
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
