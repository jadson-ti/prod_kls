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

-- Copiando estrutura para função prod_kls.FNC_QTD_ALOC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `FNC_QTD_ALOC`(
	`USERNAME_` VARCHAR(100)

) RETURNS int(11)
BEGIN 

	DECLARE QTD_		INT DEFAULT 0;
	
		SELECT COUNT(DISTINCT gm.userid) AS QTD
		  INTO QTD_
		  FROM mdl_groups g
		  JOIN mdl_groups_members gm ON gm.groupid = g.id
		  JOIN mdl_role_assignments ra ON ra.userid = gm.userid 
		  										AND ra.roleid = 5
		 WHERE g.name = CONCAT('GRUPO_', USERNAME_);

	RETURN QTD_;
			
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
