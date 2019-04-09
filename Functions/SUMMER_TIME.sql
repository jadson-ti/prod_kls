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

-- Copiando estrutura para função prod_kls.SUMMER_TIME
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `SUMMER_TIME`(
	`DT_` VARCHAR (50)
) RETURNS tinyint(1)
BEGIN

	DECLARE summer_ TINYINT(1);

	SET @ano := (SELECT EXTRACT(YEAR FROM FROM_UNIXTIME(DT_, '%Y-%m-%d')));
	
	SET @mes := (SELECT EXTRACT(MONTH FROM FROM_UNIXTIME(DT_, '%Y-%m-%d')));
	
	SET @dia := (SELECT EXTRACT(DAY FROM FROM_UNIXTIME(DT_, '%Y-%m-%d')));


	IF ((@mes = 11) OR (@mes = 12) OR (@mes = 1)) THEN
		RETURN 1;
	
	ELSEIF ((@mes = 10) AND (@dia > 25)) THEN
		RETURN 1;
		
	ELSEIF ((@mes = 10) AND (@dia > 5)) THEN
		
		SELECT 1 
		  INTO summer_ 
		  FROM tbl_summer_time 
		 WHERE ANO = @ano 
		   AND FROM_UNIXTIME(DT_, '%Y-%m-%d') BETWEEN DT_INI AND DT_FIM;
		
		IF summer_ = 1 THEN
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
	
	ELSEIF ((@mes = 2) AND (@dia < 5)) THEN
		RETURN 1;
	
	ELSEIF ((@mes = 2) AND (@dia < 25)) THEN
	
		SET summer_ := 0;
		
		SELECT 1 
		  INTO summer_ 
		  FROM tbl_summer_time 
		 WHERE ANO = (@ano - 1) 
		   AND FROM_UNIXTIME(DT_, '%Y-%m-%d') BETWEEN DT_INI AND DT_FIM;
		
		IF summer_ = 1 THEN
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
		
	ELSE
		RETURN 0;
		
	END IF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
