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

-- Copiando estrutura para tabela prod_kls.mdl_project
CREATE TABLE IF NOT EXISTS `mdl_project` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `course` bigint(10) NOT NULL DEFAULT '0',
  `format` varchar(28) NOT NULL DEFAULT 'standard',
  `formatsend` varchar(28) NOT NULL DEFAULT 'standard',
  `name` varchar(255) NOT NULL DEFAULT '',
  `intro` longtext,
  `introformat` smallint(4) NOT NULL DEFAULT '0',
  `timeopen` bigint(10) NOT NULL DEFAULT '0',
  `timeclose` bigint(10) NOT NULL DEFAULT '0',
  `timelimitcorrection` bigint(10) NOT NULL DEFAULT '0',
  `maxfiles` smallint(4) NOT NULL DEFAULT '0',
  `maxbytes` bigint(10) NOT NULL DEFAULT '0',
  `maxgrade` smallint(4) NOT NULL DEFAULT '0',
  `attemptsnumber` smallint(4) NOT NULL DEFAULT '0',
  `studentmail` tinyint(1) NOT NULL DEFAULT '0',
  `studentmessage` longtext,
  `studentmessageformat` smallint(4) NOT NULL DEFAULT '0',
  `hasterm` tinyint(1) NOT NULL DEFAULT '0',
  `term` longtext,
  `termformat` smallint(4) NOT NULL DEFAULT '0',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  `continuedactive` tinyint(1) NOT NULL DEFAULT '0',
  `continuedperiod` smallint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_proj_for_ix` (`format`),
  KEY `mdl_proj_for2_ix` (`formatsend`),
  KEY `mdl_proj_cou_ix` (`course`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Defines project';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
