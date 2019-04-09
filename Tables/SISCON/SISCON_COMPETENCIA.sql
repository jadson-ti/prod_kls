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

-- Copiando estrutura para tabela prod_kls.SISCON_COMPETENCIA
CREATE TABLE IF NOT EXISTS `SISCON_COMPETENCIA` (
  `ID_COMPETENCIA` int(11) NOT NULL AUTO_INCREMENT,
  `CD_COMPETENCIA` int(11) NOT NULL,
  `DSC_COMPETENCIA` text,
  `TP_COMPETENCIA` int(11) NOT NULL,
  `TIPO_SISCON` int(11) DEFAULT NULL,
  `HASH` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_COMPETENCIA`,`TP_COMPETENCIA`),
  KEY `fk_SISCON_COMPETENCIAS_SISCON_TIPO_COMPETENCIA1` (`TP_COMPETENCIA`)
) ENGINE=InnoDB AUTO_INCREMENT=30152 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
