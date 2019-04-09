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

-- Copiando estrutura para tabela prod_kls.SISCON_CURSO
CREATE TABLE IF NOT EXISTS `SISCON_CURSO` (
  `ID_CURSO` int(11) NOT NULL AUTO_INCREMENT,
  `ID_CURSO_ORIGINAL` varchar(50) NOT NULL,
  `NOME_CURSO` varchar(200) DEFAULT NULL,
  `NUMERO_MATRIZ` varchar(50) DEFAULT NULL,
  `PERFIL_EGRESSO` text,
  `VIGENCIA` varchar(50) DEFAULT NULL,
  `TIPO_SISCON` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_CURSO`),
  UNIQUE KEY `SISCON_CURSO_ID_UNIQUE` (`ID_CURSO_ORIGINAL`),
  UNIQUE KEY `ID_CURSO_UNIQUE` (`ID_CURSO`)
) ENGINE=InnoDB AUTO_INCREMENT=703 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
