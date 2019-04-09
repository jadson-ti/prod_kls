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

-- Copiando estrutura para tabela prod_kls.mdl_teaching_plan_parts
CREATE TABLE IF NOT EXISTS `mdl_teaching_plan_parts` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `teaching_plan_id` bigint(11) NOT NULL,
  `part_type` varchar(50) NOT NULL DEFAULT '',
  `html` longtext NOT NULL,
  `hours` int(8) DEFAULT '0',
  `origin` varchar(50) DEFAULT 'siscon',
  `has_changed` varchar(10) NOT NULL DEFAULT 'no',
  `active` varchar(10) DEFAULT 'yes',
  `creation_date` datetime DEFAULT '0000-00-00 00:00:00',
  `modification_date` datetime DEFAULT '0000-00-00 00:00:00',
  `removal_date` datetime DEFAULT '0000-00-00 00:00:00',
  `order` bigint(11) DEFAULT NULL,
  `digital` mediumint(6) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_teacplanpart_tea_ix` (`teaching_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1363337 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
