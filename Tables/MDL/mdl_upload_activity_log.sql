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

-- Copiando estrutura para tabela prod_kls.mdl_upload_activity_log
CREATE TABLE IF NOT EXISTS `mdl_upload_activity_log` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `course` bigint(18) DEFAULT NULL,
  `shortname` varchar(50) DEFAULT NULL,
  `id_studiare` bigint(18) DEFAULT NULL,
  `initialtext` longtext,
  `finaltext` longtext,
  `userid` bigint(18) DEFAULT NULL,
  `timecreated` bigint(18) DEFAULT NULL,
  `timemodified` bigint(18) DEFAULT NULL,
  `log` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mdl_uploactilog_id_uix` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='registry of uploaded/upgraded activities';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
