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

-- Copiando estrutura para tabela prod_kls.mdl_manager_banner
CREATE TABLE IF NOT EXISTS `mdl_manager_banner` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `instanceid` bigint(10) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT 'none',
  `banner` varchar(255) NOT NULL DEFAULT '',
  `link` longtext NOT NULL,
  `target` varchar(20) NOT NULL DEFAULT '',
  `description` longtext,
  `text_slide` longtext,
  `openbanner` bigint(10) DEFAULT NULL,
  `closebanner` bigint(10) DEFAULT NULL,
  `categoryid` bigint(10) NOT NULL DEFAULT '0',
  `courseid` varchar(255) NOT NULL DEFAULT '''1''',
  `institution` varchar(200) DEFAULT NULL,
  `clickcount` bigint(10) DEFAULT '0',
  `rotation` tinyint(1) DEFAULT '0',
  `sortorder` tinyint(1) DEFAULT '0',
  `role` mediumint(5) NOT NULL DEFAULT '0',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  `ispublictarget` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='Cadastro de Banners';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
