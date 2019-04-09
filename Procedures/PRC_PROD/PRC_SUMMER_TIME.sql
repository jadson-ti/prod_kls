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

-- Copiando estrutura para procedure prod_kls.PRC_SUMMER_TIME
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_SUMMER_TIME`()
BEGIN

	DECLARE ano_ 		SMALLINT(4) DEFAULT 0;
	DECLARE dt_ini_	DATE;
	DECLARE dt_fim_	DATE;
	DECLARE semana_ 	TINYINT(1) DEFAULT 0;
	DECLARE dia_	 	TINYINT(2) DEFAULT 0;

	SELECT IFNULL(ANO, 0),
			 IFNULL(DT_INI, 0), 
			 IFNULL(DT_FIM, 0)
			 INTO ano_, dt_ini_, dt_fim_
	  FROM tbl_summer_time 
	 WHERE ANO = (SELECT EXTRACT(YEAR FROM CURDATE()));

	IF ano_ = 0 THEN

		INSERT INTO tbl_summer_time (ANO)
			SELECT EXTRACT(YEAR FROM CURDATE());

	END IF;
	
	
	
	IF dt_ini_ = 0 THEN
	
		WHILE semana_ < 3 DO
			
			SET dia_ := dia_ + 1;
			
			IF (SELECT DAYOFWEEK(CONCAT(ano_,'-10-',dia_))) = 1 THEN
				SET semana_ := semana_ + 1;
			END IF;		
			
		END WHILE;
		
		SET dt_ini_ = CONCAT(ano_,'-10-',dia_);
		
		UPDATE tbl_summer_time
		   SET DT_INI = dt_ini_
		 WHERE ANO = ano_;
		
	END IF;


	

	IF dt_fim_ = 0 THEN
	
		SET dia_ := 0;
		SET semana_ := 0;
		SET ano_ := ano_ + 1;
	
		WHILE semana_ < 3 DO
			
			SET dia_ := dia_ + 1;
			
			IF (SELECT DAYOFWEEK(CONCAT(ano_,'-02-',dia_))) = 1 THEN
				SET semana_ := semana_ + 1;
			END IF;		
			
		END WHILE;
		
		SET dt_fim_ = CONCAT(ano_,'-02-',dia_);
		
		UPDATE tbl_summer_time
		   SET DT_FIM = dt_fim_
		 WHERE ANO = (ano_ - 1);
	
	END IF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
