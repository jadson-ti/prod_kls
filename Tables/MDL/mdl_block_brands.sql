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

-- Copiando estrutura para tabela prod_kls.mdl_block_brands
CREATE TABLE IF NOT EXISTS `mdl_block_brands` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `brand` varchar(100) NOT NULL DEFAULT 'none',
  `theme` varchar(11) NOT NULL DEFAULT '',
  `brand_image` longtext,
  `brand_image_contrast` longtext,
  `brand_image_small` longtext,
  `brand_image_small_contrast` longtext,
  `brand_image_mobile` longtext,
  `brand_image_mobile_contrast` longtext,
  `brand_logo_sidebar` longtext,
  `brand_logo_sidebar_contrast` longtext,
  `brand_url_logout` longtext,
  `sortorder` tinyint(1) DEFAULT '0',
  `timecreated` bigint(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='Tabela de Marcas';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
