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

-- Copiando estrutura para tabela prod_kls.dup_local_mail_massive
CREATE TABLE IF NOT EXISTS `dup_local_mail_massive` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `messageid` bigint(10) NOT NULL DEFAULT '0',
  `massiveid` bigint(10) NOT NULL DEFAULT '0',
  `userid` bigint(10) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(4) NOT NULL DEFAULT 'to',
  `courseid` bigint(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_locamailmass_mes_ix` (`messageid`),
  KEY `mdl_locamailmass_mas_ix` (`massiveid`),
  KEY `mdl_locamailmass_use_ix` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=5963963 DEFAULT CHARSET=utf8 COMMENT='Table of massive mail';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
