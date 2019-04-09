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

-- Copiando estrutura para procedure prod_kls.PRC_REL_NUCLEO_RETENCAO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_NUCLEO_RETENCAO`()
BEGIN
drop table if exists rel_nucleo_retencao;
create table rel_nucleo_retencao as 
SELECT 
cr.id AS 'courseid', cr.fullname AS 'coursename',
us.id AS 'userid', us.username, concat(us.firstname, ' ', us.lastname) usuario, us.email, 
lg.eventname, lg.component, lg.action, lg.target, FROM_UNIXTIME(lg.timecreated) AS 'logdate', lg.ip
FROM mdl_logstore_standard_log lg
INNER JOIN mdl_user us ON us.id = lg.userid
INNER JOIN mdl_course cr ON cr.id = lg.courseid
WHERE lg.ip IN 
(
'10.100.102.59', '10.100.102.43', '10.100.102.46', '10.100.102.61',
'10.100.102.110', '10.100.102.40', '10.100.102.91', '10.100.102.99',
'10.100.102.47', '10.100.102.53', '10.100.102.48', '10.100.102.57',
'10.100.102.89', '10.100.102.50', '10.100.102.98', '10.100.102.88',
'10.100.102.83', '10.100.102.74', '10.100.102.82', '10.100.36.87',
'10.100.102.106', '10.100.102.29', '10.100.102.41', '10.100.102.28',
'10.100.102.104', '10.100.102.80', '10.100.102.55', '10.100.102.81',
'10.100.102.60', '10.100.102.86', '10.100.102.97', '10.100.102.76',
'10.100.102.13', '10.100.102.85', '10.100.102.42', '10.100.102.101',
'10.100.102.79', '10.100.102.49', '10.100.102.77', '10.100.102.96',
'10.100.36.83', '10.100.102.95','10.100.102.39', '10.100.102.68',
'10.100.102.108', '10.100.102.78'
);
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
