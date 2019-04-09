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

-- Copiando estrutura para função prod_kls.FNC_FULL_NAME_QUEST_CAT
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `FNC_FULL_NAME_QUEST_CAT`(
	`category_` BIGINT(10)






) RETURNS text CHARSET utf8
BEGIN

DECLARE name_ 			VARCHAR(255);
DECLARE parent_ 		BIGINT(10) DEFAULT 1;

DECLARE fullname_		TEXT DEFAULT '';


	WHILE parent_ > 0 DO
	
		SELECT qc.name, qc.parent 
		  INTO name_, parent_
		  FROM mdl_question_categories qc 
		 WHERE qc.id = category_;
		 
		SET category_ = parent_;
		SET fullname_ = CONCAT(name_, ' > ', fullname_);
	
	END WHILE;


	RETURN fullname_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
