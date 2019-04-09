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

-- Copiando estrutura para função prod_kls.FNC_RMV_ESPEC_CHAR
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `FNC_RMV_ESPEC_CHAR`(TEXTO_ TEXT) RETURNS text CHARSET utf8
BEGIN
    
    
    
    
    SET TEXTO_ := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TEXTO_,'á','a'),'à','a'),'â','a'),'ã','a'),'ä','a');
    SET TEXTO_ := REPLACE(REPLACE(REPLACE(REPLACE(TEXTO_,'é','e'),'è','e'),'ê','e'),'ë','e');
    SET TEXTO_ := REPLACE(REPLACE(REPLACE(REPLACE(TEXTO_,'í','i'),'ì','i'),'î','i'),'ï','i');
    SET TEXTO_ := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TEXTO_,'ó','o'),'ò','o'),'ô','o'),'õ','o'),'ö','o');
    SET TEXTO_ := REPLACE(REPLACE(REPLACE(REPLACE(TEXTO_,'ú','u'),'ù','u'),'û','u'),'ü','u');
    
    
    
    
    SET TEXTO_ := REPLACE(TEXTO_,'ý','y');
    SET TEXTO_ := REPLACE(TEXTO_,'ñ','n');
    SET TEXTO_ := REPLACE(TEXTO_,'ç','c');
    
    RETURN UPPER(TEXTO_);
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
