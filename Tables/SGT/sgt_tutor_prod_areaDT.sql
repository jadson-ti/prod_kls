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

-- Copiando estrutura para tabela prod_kls.sgt_tutor_prod_areaDT
CREATE TABLE IF NOT EXISTS `sgt_tutor_prod_areaDT` (
  `shortname` varchar(255) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `cd_instituicao` varchar(255) DEFAULT NULL,
  `nm_ies` varchar(255) DEFAULT NULL,
  `cd_curso` varchar(255) DEFAULT NULL,
  `nm_curso` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `nm_pessoa` varchar(255) DEFAULT NULL,
  `tutor` varchar(255) DEFAULT NULL,
  KEY `stg_tutor_grupo_areaDTIX` (`tutor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
