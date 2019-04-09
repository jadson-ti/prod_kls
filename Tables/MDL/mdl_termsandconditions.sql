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

-- Copiando estrutura para tabela prod_kls.mdl_termsandconditions
CREATE TABLE IF NOT EXISTS `mdl_termsandconditions` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `course` bigint(18) NOT NULL DEFAULT '0',
  `user` bigint(18) NOT NULL,
  `sthree` bigint(18) NOT NULL,
  `timemodified` bigint(18) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_term_cou_ix` (`course`),
  KEY `mdl_term_use_ix` (`user`),
  KEY `mdl_term_sth_ix` (`sthree`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='termsandconditions table';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
