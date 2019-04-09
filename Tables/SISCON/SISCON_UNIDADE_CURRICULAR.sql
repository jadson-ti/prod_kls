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

-- Copiando estrutura para tabela prod_kls.SISCON_UNIDADE_CURRICULAR
CREATE TABLE IF NOT EXISTS `SISCON_UNIDADE_CURRICULAR` (
  `ID_UC` int(11) NOT NULL AUTO_INCREMENT,
  `ID_UC_ORIGINAL` varchar(50) NOT NULL,
  `ID_UC_PRINCIPAL` varchar(50) DEFAULT NULL,
  `NOME_UNIDADE_CURRICULAR` varchar(200) DEFAULT NULL,
  `TIPO_SISCON` int(11) DEFAULT NULL,
  `VIGENCIA` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_UC`),
  KEY `Index 2` (`ID_UC`,`NOME_UNIDADE_CURRICULAR`,`TIPO_SISCON`),
  KEY `Index 3` (`NOME_UNIDADE_CURRICULAR`)
) ENGINE=InnoDB AUTO_INCREMENT=24580 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
