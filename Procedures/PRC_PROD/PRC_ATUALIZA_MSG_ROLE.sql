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

-- Copiando estrutura para procedure prod_kls.PRC_ATUALIZA_MSG_ROLE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ATUALIZA_MSG_ROLE`()
BEGIN

INSERT INTO tmp_local_mail_mu
SELECT 
	messageid,
	ur1.roleid as 'from',
	ur2.roleid as 'to',
	count(1)
FROM mdl_local_mail_message_users base 
JOIN tmp_user_role ur1 on base.userid=ur1.userid
JOIN tmp_user_role ur2 on base.id_from=ur2.userid
WHERE ROLE='to' AND messageid>(SELECT MAX(messageid) FROM tmp_local_mail_mu)
GROUP BY messageid;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
