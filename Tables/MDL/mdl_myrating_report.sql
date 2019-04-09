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

-- Copiando estrutura para tabela prod_kls.mdl_myrating_report
CREATE TABLE IF NOT EXISTS `mdl_myrating_report` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `requestby` bigint(10) DEFAULT NULL,
  `requestid` varchar(50) DEFAULT NULL,
  `started` bigint(10) DEFAULT NULL,
  `finished` bigint(10) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  UNIQUE KEY `mdl_myrating_report_id_IDX` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
