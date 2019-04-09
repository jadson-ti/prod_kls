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

-- Copiando estrutura para tabela prod_kls.bkp_local_mail_messages
CREATE TABLE IF NOT EXISTS `bkp_local_mail_messages` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `courseid` bigint(10) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `content` longtext NOT NULL,
  `format` smallint(4) NOT NULL,
  `attachments` smallint(4) NOT NULL DEFAULT '0',
  `draft` tinyint(1) NOT NULL,
  `time` bigint(10) NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  `parent` bigint(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `id_role` bigint(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_locamailmess_cou_ix` (`courseid`),
  KEY `mdl_locamailmess_par_ix` (`parent`),
  KEY `mdl_locamailmess_iddra_ix` (`id`,`draft`)
) ENGINE=InnoDB AUTO_INCREMENT=336327 DEFAULT CHARSET=utf8 COMMENT='-';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
