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

-- Copiando estrutura para tabela prod_kls.mdl_certificate
CREATE TABLE IF NOT EXISTS `mdl_certificate` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `course` bigint(10) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `intro` longtext,
  `introformat` smallint(4) NOT NULL DEFAULT '0',
  `emailteachers` tinyint(1) NOT NULL DEFAULT '0',
  `emailothers` longtext,
  `savecert` tinyint(1) NOT NULL DEFAULT '0',
  `reportcert` tinyint(1) NOT NULL DEFAULT '0',
  `delivery` smallint(3) NOT NULL DEFAULT '0',
  `requiredtime` bigint(10) NOT NULL DEFAULT '0',
  `certificatetype` varchar(50) NOT NULL DEFAULT '',
  `orientation` varchar(10) NOT NULL DEFAULT '',
  `borderstyle` varchar(255) NOT NULL DEFAULT '0',
  `bordercolor` varchar(30) NOT NULL DEFAULT '0',
  `printwmark` varchar(255) NOT NULL DEFAULT '0',
  `printwmark2` varchar(255) NOT NULL DEFAULT '0',
  `printdate` bigint(10) NOT NULL DEFAULT '0',
  `datefmt` bigint(10) NOT NULL DEFAULT '0',
  `printnumber` tinyint(1) NOT NULL DEFAULT '0',
  `printgrade` bigint(10) NOT NULL DEFAULT '0',
  `gradefmt` bigint(10) NOT NULL DEFAULT '0',
  `printoutcome` bigint(10) NOT NULL DEFAULT '0',
  `printhours` varchar(255) DEFAULT NULL,
  `printteacher` bigint(10) NOT NULL DEFAULT '0',
  `customtext` longtext,
  `printsignature` varchar(255) NOT NULL DEFAULT '0',
  `printseal` varchar(255) NOT NULL DEFAULT '0',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Defines certificates';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
