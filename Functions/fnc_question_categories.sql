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

-- Copiando estrutura para função prod_kls.fnc_question_categories
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `fnc_question_categories`(
	`PId_category` INTEGER


) RETURNS longtext CHARSET latin1
BEGIN
	
    DECLARE VRet 		LONGTEXT DEFAULT NULL;
    DECLARE VFound 		LONGTEXT DEFAULT NULL;
    DECLARE VContextId 	INTEGER  DEFAULT NULL;
    DECLARE VParent 	INTEGER DEFAULT PId_category;
    DECLARE Vexit_loop	BOOLEAN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Vexit_loop = TRUE;
    
    
    v_loop:loop
		
		SELECT CONCAT(id, ' - ', name) AS name, parent, contextid 
		  INTO VFound, VParent, VContextId
		  FROM mdl_question_categories 
		 WHERE id = VParent 
		   AND (contextid = VContextId OR VContextId IS NULL);
        
        
		IF Vexit_loop THEN
		  LEAVE v_loop;
		END IF;
        
		
		SET VRet = CONCAT_WS(' > ',VFound,VRet);

    END loop v_loop;
    
    
	RETURN VRet;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
