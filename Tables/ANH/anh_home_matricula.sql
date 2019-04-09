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

-- Copiando estrutura para tabela prod_kls.anh_home_matricula
CREATE TABLE IF NOT EXISTS `anh_home_matricula` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_MATRICULA_ATUAL` int(11) NOT NULL,
  `USERNAME` varchar(50) NOT NULL,
  `SHORTNAME` varchar(150) NOT NULL,
  `ROLE` varchar(50) NOT NULL,
  `DATA_MATRICULA` date NOT NULL,
  `ORIGEM` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_anh_home_matricula_grupo` (`USERNAME`,`SHORTNAME`,`ROLE`),
  KEY `idx_home_shortname` (`SHORTNAME`),
  KEY `idx_home_username` (`USERNAME`),
  KEY `fk_home_matricula` (`ID_MATRICULA_ATUAL`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
