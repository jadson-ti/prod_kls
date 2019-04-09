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

-- Copiando estrutura para tabela prod_kls.mdl_message_my_students
CREATE TABLE IF NOT EXISTS `mdl_message_my_students` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `parent` bigint(10) NOT NULL,
  `userid_from` bigint(10) NOT NULL,
  `userid_to` bigint(10) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `message` longtext NOT NULL,
  `order_msg` bigint(10) DEFAULT '0',
  `read_msg` bigint(10) DEFAULT '0',
  `like_msg` bigint(10) DEFAULT '0',
  `public` varchar(40) DEFAULT '0',
  `type_post` varchar(10) DEFAULT '0',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_messmystud_par_ix` (`parent`),
  KEY `mdl_messmystud_use_ix` (`userid_from`),
  KEY `mdl_messmystud_use2_ix` (`userid_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Lista de Usuarios do Recado do tutor';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
