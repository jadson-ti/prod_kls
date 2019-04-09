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

-- Copiando estrutura para tabela prod_kls.bkp_local_mail_message_users
CREATE TABLE IF NOT EXISTS `bkp_local_mail_message_users` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `messageid` bigint(10) NOT NULL,
  `userid` bigint(10) NOT NULL,
  `role` varchar(4) NOT NULL DEFAULT '',
  `unread` tinyint(1) NOT NULL,
  `starred` tinyint(1) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `id_from` bigint(10) DEFAULT NULL,
  `fullname_tutor` varchar(255) DEFAULT NULL,
  `lock_reply` bigint(10) DEFAULT NULL,
  `courseid` bigint(10) DEFAULT NULL,
  `analytics` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_locamailmessuser_mes_ix` (`messageid`),
  KEY `mdl_locamailmessuser_usemes_ix` (`userid`,`messageid`),
  KEY `mdl_locamailmessuser_useme2_ix` (`userid`,`messageid`,`role`),
  KEY `mdl_locamailmessuser_userol_ix` (`userid`,`role`),
  KEY `mdl_locamailmessuser_usero2_ix` (`userid`,`role`,`deleted`),
  KEY `mdl_locamailmessuser_use_ix` (`userid`),
  KEY `mdl_locamailmessuser_cou_ix` (`courseid`)
) ENGINE=InnoDB AUTO_INCREMENT=4195171 DEFAULT CHARSET=utf8 COMMENT='-';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
