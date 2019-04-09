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

-- Copiando estrutura para tabela prod_kls.mdl_block_configurable_reports
CREATE TABLE IF NOT EXISTS `mdl_block_configurable_reports` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `courseid` bigint(11) NOT NULL,
  `ownerid` bigint(11) NOT NULL,
  `visible` smallint(4) NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT '',
  `summary` longtext,
  `summaryformat` smallint(4) NOT NULL DEFAULT '0',
  `type` varchar(128) NOT NULL DEFAULT '',
  `pagination` smallint(4) DEFAULT NULL,
  `components` longtext,
  `export` varchar(255) DEFAULT NULL,
  `jsordering` smallint(4) DEFAULT NULL,
  `global` smallint(4) DEFAULT NULL,
  `lastexecutiontime` bigint(10) DEFAULT NULL,
  `cron` smallint(4) NOT NULL DEFAULT '0',
  `category_id` smallint(4) NOT NULL DEFAULT '0',
  `remote` smallint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_blocconfrepo_cou_ix` (`courseid`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COMMENT='block_configurable_reports table retrofitted from MySQL';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
