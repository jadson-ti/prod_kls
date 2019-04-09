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

-- Copiando estrutura para tabela prod_kls.mdl_block_videolibrary
CREATE TABLE IF NOT EXISTS `mdl_block_videolibrary` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `videoid` varchar(20) DEFAULT NULL,
  `projectid` bigint(11) DEFAULT NULL,
  `categoryid` bigint(11) DEFAULT NULL,
  `subcategoryid` bigint(11) DEFAULT NULL,
  `description` longtext,
  `visible` tinyint(1) DEFAULT '1',
  `tags` longtext,
  `public_target` tinyint(1) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `notification` bigint(11) DEFAULT '1',
  `notification_title` longtext,
  `notification_image` longtext,
  `title` longtext,
  `duration` bigint(11) DEFAULT '0',
  `views_audience` bigint(11) DEFAULT '0',
  `timecreated` bigint(11) DEFAULT NULL,
  `timemodified` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Default comment for block_videolibrary, please edit me';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
