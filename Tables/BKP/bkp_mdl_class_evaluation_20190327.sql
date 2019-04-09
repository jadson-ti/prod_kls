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

-- Copiando estrutura para tabela prod_kls.bkp_mdl_class_evaluation_20190327
CREATE TABLE IF NOT EXISTS `bkp_mdl_class_evaluation_20190327` (
  `id` bigint(10) NOT NULL DEFAULT '0',
  `courseid` bigint(11) DEFAULT NULL,
  `userid` bigint(11) DEFAULT NULL,
  `teacherid` bigint(11) DEFAULT NULL,
  `dateclass` bigint(11) DEFAULT NULL,
  `wenttoclass` tinyint(1) DEFAULT NULL,
  `gaveclass` tinyint(1) DEFAULT NULL,
  `evaluation` tinyint(2) DEFAULT NULL,
  `comment` longtext CHARACTER SET utf8,
  `timecreated` bigint(11) DEFAULT NULL,
  `timemodified` bigint(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
