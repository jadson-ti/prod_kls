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

-- Copiando estrutura para tabela prod_kls.mdl_sgt_usuario_moodle
CREATE TABLE IF NOT EXISTS `mdl_sgt_usuario_moodle` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario_id` bigint(11) NOT NULL DEFAULT '0',
  `mdl_user_id` bigint(20) DEFAULT NULL,
  `mdl_username` varchar(100) DEFAULT NULL,
  `flag_informativo_alocacao` varchar(1) DEFAULT NULL,
  `data_informativo_alocacao` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mdl_sgtusuamood_id__uix` (`id_usuario_id`),
  KEY `mdl_sgtusuamood_mdl_ix` (`mdl_user_id`),
  KEY `mdl_sgtusuamood_mdl2_ix` (`mdl_username`)
) ENGINE=InnoDB AUTO_INCREMENT=3796 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
