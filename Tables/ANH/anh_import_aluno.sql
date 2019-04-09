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

-- Copiando estrutura para tabela prod_kls.anh_import_aluno
CREATE TABLE IF NOT EXISTS `anh_import_aluno` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ORIGEM` varchar(15) DEFAULT NULL,
  `USERNAME` varchar(30) DEFAULT NULL,
  `PASSWORD` varchar(255) DEFAULT NULL,
  `FIRSTNAME` varchar(50) DEFAULT NULL,
  `LASTNAME` varchar(150) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `CITY` varchar(50) DEFAULT NULL,
  `UNIDADE` varchar(100) DEFAULT NULL,
  `CURSO` varchar(100) DEFAULT NULL,
  `MARCA` varchar(50) DEFAULT NULL,
  `DATA_IMPORTACAO` date DEFAULT NULL,
  `SITUACAO` varchar(10) DEFAULT NULL,
  `STATUS` varchar(15) DEFAULT NULL,
  `NOVA_TENTATIVA` date DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `USERNAME` (`USERNAME`),
  KEY `DATA_IMPORTACAO` (`DATA_IMPORTACAO`,`STATUS`),
  KEY `idx_status` (`STATUS`)
) ENGINE=InnoDB AUTO_INCREMENT=624023 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
