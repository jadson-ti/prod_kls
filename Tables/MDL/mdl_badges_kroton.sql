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

-- Copiando estrutura para tabela prod_kls.mdl_badges_kroton
CREATE TABLE IF NOT EXISTS `mdl_badges_kroton` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `courseid` bigint(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `title_notification_new` varchar(255) DEFAULT 'Um novo badge foi adicionado',
  `title_notification_award` varchar(255) DEFAULT 'Nova conquista',
  `description` longtext,
  `descriptionformat` bigint(11) DEFAULT NULL,
  `consulta` longtext,
  `visible` tinyint(1) DEFAULT NULL,
  `type_notification` varchar(255) DEFAULT NULL,
  `public_target` tinyint(1) DEFAULT NULL,
  `timecreated` bigint(11) DEFAULT NULL,
  `timemodified` bigint(11) DEFAULT NULL,
  `order_field` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_badgkrot_cou_ix` (`courseid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table badges';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
