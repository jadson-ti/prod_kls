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

-- Copiando estrutura para tabela prod_kls.mdl_block_kce_student
CREATE TABLE IF NOT EXISTS `mdl_block_kce_student` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `alias` varchar(75) DEFAULT '0',
  `cd_pessoa` varchar(75) NOT NULL DEFAULT '0',
  `login` varchar(100) NOT NULL DEFAULT '0',
  `unitcode` varchar(75) NOT NULL DEFAULT '0',
  `disciplinecode` varchar(15) NOT NULL DEFAULT '0',
  `semester` mediumint(5) NOT NULL DEFAULT '0',
  `shortname` varchar(255) NOT NULL DEFAULT '0',
  `classcode` varchar(20) NOT NULL DEFAULT '0',
  `usernameprofessor` varchar(100) NOT NULL DEFAULT '0',
  `uniqueid` varchar(255) DEFAULT NULL,
  `score` varchar(10) DEFAULT NULL,
  `absent` tinyint(1) DEFAULT NULL,
  `pub` tinyint(1) DEFAULT NULL,
  `rectification` varchar(255) DEFAULT NULL,
  `justify` longtext,
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176427 DEFAULT CHARSET=utf8 COMMENT='Define blocks/kcontinuousevaluation students table';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
