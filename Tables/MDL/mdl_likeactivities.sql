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

-- Copiando estrutura para tabela prod_kls.mdl_likeactivities
CREATE TABLE IF NOT EXISTS `mdl_likeactivities` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `course` bigint(10) NOT NULL,
  `enabled` smallint(4) NOT NULL DEFAULT '1',
  `buttonstype` varchar(6) NOT NULL DEFAULT 'icon',
  `backgroundcolour` varchar(20) DEFAULT '#ffffff',
  `customusebackground` smallint(4) NOT NULL DEFAULT '1',
  `homebuttonshow` smallint(4) NOT NULL DEFAULT '0',
  `homebuttontype` smallint(4) NOT NULL DEFAULT '1',
  `firstbuttonshow` smallint(4) NOT NULL DEFAULT '0',
  `firstbuttontype` smallint(4) NOT NULL DEFAULT '2',
  `prevbuttonshow` smallint(4) NOT NULL DEFAULT '0',
  `nextbuttonshow` smallint(4) NOT NULL DEFAULT '0',
  `lastbuttonshow` smallint(4) NOT NULL DEFAULT '0',
  `lastbuttontype` smallint(4) DEFAULT '2',
  `extra1show` smallint(4) NOT NULL DEFAULT '1',
  `extra1link` longtext,
  `extra1title` longtext,
  `extra1openin` smallint(4) NOT NULL DEFAULT '1',
  `extra2show` smallint(4) NOT NULL DEFAULT '1',
  `extra2link` longtext,
  `extra2title` longtext,
  `extra2openin` smallint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Per-course settings for the navigation buttons to appear und';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
