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

-- Copiando estrutura para tabela prod_kls.mdl_block_ppc_template_document
CREATE TABLE IF NOT EXISTS `mdl_block_ppc_template_document` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `template` bigint(18) NOT NULL,
  `files` bigint(10) DEFAULT NULL,
  `draft` bigint(18) DEFAULT NULL,
  `type` varchar(25) NOT NULL DEFAULT '',
  `text` longtext NOT NULL,
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `timemodified` bigint(10) NOT NULL DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `mdl_blocppctempdocu_typ_ix` (`type`),
  KEY `mdl_blocppctempdocu_vis_ix` (`visible`),
  KEY `mdl_blocppctempdocu_dra_ix` (`draft`),
  KEY `mdl_blocppctempdocu_tem_ix` (`template`),
  KEY `mdl_blocppctempdocu_fil_ix` (`files`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='PPC Template Document';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
