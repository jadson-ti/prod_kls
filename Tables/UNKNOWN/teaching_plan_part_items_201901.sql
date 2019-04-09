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

-- Copiando estrutura para tabela prod_kls.teaching_plan_part_items_201901
CREATE TABLE IF NOT EXISTS `teaching_plan_part_items_201901` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `teaching_plan_part_id` bigint(16) DEFAULT NULL,
  `description` longtext NOT NULL,
  `active` varchar(10) NOT NULL DEFAULT 'yes',
  `creation_date` datetime NOT NULL,
  `modification_date` datetime NOT NULL,
  `removal_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_teacplanpartitem_tea_ix` (`teaching_plan_part_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1897851 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
