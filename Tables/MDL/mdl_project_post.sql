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

-- Copiando estrutura para tabela prod_kls.mdl_project_post
CREATE TABLE IF NOT EXISTS `mdl_project_post` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `project` bigint(10) NOT NULL DEFAULT '0',
  `itemid` bigint(10) NOT NULL DEFAULT '0',
  `userid` bigint(10) NOT NULL DEFAULT '0',
  `parent` bigint(10) NOT NULL DEFAULT '0',
  `mail` tinyint(1) NOT NULL DEFAULT '0',
  `term` tinyint(1) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `title` varchar(255) NOT NULL DEFAULT '',
  `comment` longtext,
  `commentformat` smallint(4) NOT NULL DEFAULT '0',
  `grade` decimal(10,5) NOT NULL DEFAULT '-1.00000',
  `time` bigint(10) NOT NULL DEFAULT '0',
  `tipoavaliacao` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_projpost_mai_ix` (`mail`),
  KEY `mdl_projpost_sta_ix` (`status`),
  KEY `mdl_projpost_pro_ix` (`project`),
  KEY `mdl_projpost_ite_ix` (`itemid`),
  KEY `mdl_projpost_use_ix` (`userid`),
  KEY `mdl_projpost_par_ix` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Defines project_post';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
