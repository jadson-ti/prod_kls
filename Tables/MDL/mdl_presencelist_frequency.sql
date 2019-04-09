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

-- Copiando estrutura para tabela prod_kls.mdl_presencelist_frequency
CREATE TABLE IF NOT EXISTS `mdl_presencelist_frequency` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `userid` bigint(10) NOT NULL DEFAULT '0',
  `presencelist_id` bigint(10) NOT NULL DEFAULT '0',
  `enrol_presential_calendar_id` bigint(10) NOT NULL DEFAULT '0',
  `presence` bigint(10) NOT NULL DEFAULT '0',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  `userid_update` bigint(10) NOT NULL DEFAULT '0',
  `period1` bigint(10) DEFAULT '0',
  `period2` bigint(10) DEFAULT '0',
  `period3` bigint(10) DEFAULT '0',
  `period4` bigint(10) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_presfreq_id_ix` (`id`),
  KEY `mdl_presfreq_id2_ix` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Info about frequency';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
