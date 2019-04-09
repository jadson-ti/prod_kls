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

-- Copiando estrutura para tabela prod_kls.mdl_sgt_af_conhecimento
CREATE TABLE IF NOT EXISTS `mdl_sgt_af_conhecimento` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `id_area_formacao` bigint(11) NOT NULL,
  `id_area_conhecimento` bigint(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_sgtafconh_id__ix` (`id_area_formacao`),
  KEY `mdl_sgtafconh_id_2_ix` (`id_area_conhecimento`),
  KEY `mdl_sgtafconh_id_3_ix` (`id_area_conhecimento`),
  KEY `mdl_sgtafconh_id_4_ix` (`id_area_formacao`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
