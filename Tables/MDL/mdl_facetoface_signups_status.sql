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

-- Copiando estrutura para tabela prod_kls.mdl_facetoface_signups_status
CREATE TABLE IF NOT EXISTS `mdl_facetoface_signups_status` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `signupid` bigint(10) NOT NULL,
  `statuscode` bigint(10) NOT NULL,
  `superceded` tinyint(1) NOT NULL,
  `grade` decimal(10,5) DEFAULT NULL,
  `note` longtext,
  `advice` longtext,
  `createdby` bigint(10) NOT NULL,
  `timecreated` bigint(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_facesignstat_sig_ix` (`signupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User/session signup status';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
