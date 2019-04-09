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

-- Copiando estrutura para tabela prod_kls.mdl_teaching_plan
CREATE TABLE IF NOT EXISTS `mdl_teaching_plan` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(11) NOT NULL DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'partial_linked',
  `who_approved` varchar(50) DEFAULT NULL,
  `observation` longtext,
  `active` varchar(10) DEFAULT 'yes',
  `creation_date` datetime NOT NULL,
  `modification_date` datetime NOT NULL,
  `removal_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `siscon_discipline_id` bigint(11) DEFAULT NULL,
  `who_created` varchar(50) DEFAULT NULL,
  `who_updated` varchar(50) DEFAULT NULL,
  `who_approved_name` varchar(255) DEFAULT NULL,
  `who_created_name` varchar(255) DEFAULT NULL,
  `who_updated_name` varchar(255) DEFAULT NULL,
  `reassociation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `mdl_teacplan_sta_ix` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=74202 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
