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

-- Copiando estrutura para tabela prod_kls.mdl_local_kssmn_modcertificate
CREATE TABLE IF NOT EXISTS `mdl_local_kssmn_modcertificate` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `userid` bigint(18) NOT NULL DEFAULT '0',
  `issueid` bigint(18) NOT NULL DEFAULT '0',
  `certificateid` bigint(18) NOT NULL DEFAULT '0',
  `certificatecode` varchar(40) NOT NULL DEFAULT '',
  `status` varchar(5) NOT NULL DEFAULT 'new',
  `timecreated` bigint(18) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_locakssmmodc_use_ix` (`userid`),
  KEY `mdl_locakssmmodc_sta_ix` (`status`),
  KEY `mdl_locakssmmodc_cer_ix` (`certificateid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Define mod/certificate table';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
