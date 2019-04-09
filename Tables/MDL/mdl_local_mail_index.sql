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

-- Copiando estrutura para tabela prod_kls.mdl_local_mail_index
CREATE TABLE IF NOT EXISTS `mdl_local_mail_index` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `userid` bigint(10) NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  `item` bigint(10) NOT NULL,
  `messageid` bigint(10) NOT NULL,
  `time` bigint(10) NOT NULL,
  `unread` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_locamailinde_mesuse_ix` (`messageid`,`userid`),
  KEY `mdl_locamailinde_usetypitet_ix` (`userid`,`type`,`item`,`time`),
  KEY `mdl_locamailinde_usetypiteu_ix` (`userid`,`type`,`item`,`unread`),
  KEY `mdl_locamailinde_typmesite_ix` (`type`,`messageid`,`item`),
  KEY `mdl_locamailinde_usetypunr_ix` (`userid`,`type`,`unread`)
) ENGINE=InnoDB AUTO_INCREMENT=15248162 DEFAULT CHARSET=utf8 COMMENT='-';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
