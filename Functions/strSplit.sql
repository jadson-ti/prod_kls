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

-- Copiando estrutura para função prod_kls.strSplit
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `strSplit`(
	`x` TEXT,
	`delim` VARCHAR(12),
	`pos` INT
) RETURNS varchar(100) CHARSET utf8
BEGIN


	DECLARE output TEXT;

	SET output = REPLACE(
								SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
							   LENGTH(SUBSTRING_INDEX(x, delim, pos - 1)) + 1), 
								delim, 
								''
							  );

	IF output = '' THEN 
		SET output = null; 
	END IF;


	RETURN output;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
