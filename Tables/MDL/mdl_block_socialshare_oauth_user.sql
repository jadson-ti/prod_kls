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

-- Copiando estrutura para tabela prod_kls.mdl_block_socialshare_oauth_user
CREATE TABLE IF NOT EXISTS `mdl_block_socialshare_oauth_user` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `userid` bigint(10) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `socialshare_username` varchar(255) DEFAULT NULL,
  `socialshare_userid` varchar(255) DEFAULT NULL,
  `oauth_token_secret` varchar(100) DEFAULT NULL,
  `oauth_verifier` varchar(100) DEFAULT NULL,
  `oauth_token` varchar(100) DEFAULT NULL,
  `access_token` varchar(200) DEFAULT NULL,
  `expires_in` varchar(10) DEFAULT NULL,
  `updatekey` varchar(100) DEFAULT NULL,
  `updateurl` varchar(200) DEFAULT NULL,
  `tmp_titlebadge` varchar(200) DEFAULT NULL,
  `tmp_submitted_url` varchar(200) DEFAULT NULL,
  `tmp_submitted_image` varchar(200) DEFAULT NULL,
  `tmp_lastsubmit` bigint(10) DEFAULT NULL,
  `message` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_blocsocioautuser_use_ix` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Defines students data';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
