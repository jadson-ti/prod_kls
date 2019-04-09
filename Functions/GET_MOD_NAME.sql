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

-- Copiando estrutura para função prod_kls.GET_MOD_NAME
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `GET_MOD_NAME`(
	`P_MODULE` VARCHAR(50),
	`P_INSTANCE` BIGINT(10)



) RETURNS varchar(255) CHARSET utf8
BEGIN

DECLARE V_NAME VARCHAR(255);

IF P_MODULE='assign' THEN 
	SELECT name INTO V_NAME FROM mdl_assign WHERE id=P_INSTANCE;
ELSEIF P_MODULE='quiz' THEN 
	SELECT name INTO V_NAME FROM mdl_quiz WHERE id=P_INSTANCE;
ELSEIF P_MODULE='url' THEN 
	SELECT name INTO V_NAME FROM mdl_url WHERE id=P_INSTANCE;
ELSEIF P_MODULE='pde' THEN 
	SELECT name INTO V_NAME FROM mdl_pde WHERE id=P_INSTANCE;
ELSEIF P_MODULE='sthree' THEN 
	SELECT name INTO V_NAME FROM mdl_sthree WHERE id=P_INSTANCE;
ELSEIF P_MODULE='label' THEN 
	SELECT name INTO V_NAME FROM mdl_label WHERE id=P_INSTANCE;
ELSEIF P_MODULE='feedback' 
	THEN SELECT name INTO V_NAME FROM mdl_feedback WHERE id=P_INSTANCE;
ELSEIF P_MODULE='forum' 
	THEN SELECT name INTO V_NAME FROM mdl_forum WHERE id=P_INSTANCE;
ELSEIF P_MODULE='activityvideo' 
	THEN SELECT name INTO V_NAME FROM mdl_activityvideo WHERE id=P_INSTANCE;
ELSE 
	SET V_NAME=P_MODULE;
END IF;

RETURN V_NAME;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
