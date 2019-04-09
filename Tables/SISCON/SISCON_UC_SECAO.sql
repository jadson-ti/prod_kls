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

-- Copiando estrutura para tabela prod_kls.SISCON_UC_SECAO
CREATE TABLE IF NOT EXISTS `SISCON_UC_SECAO` (
  `ID_UC_SECAO` int(11) NOT NULL AUTO_INCREMENT,
  `ID_UC` int(11) NOT NULL,
  `ID_SECAO` int(11) NOT NULL,
  PRIMARY KEY (`ID_UC_SECAO`),
  KEY `fk_SISCON_UNIDADE_CURRICULAR_has_SISCON_SECAO_SISCON_UNIDADE_1` (`ID_UC`),
  KEY `fk_SISCON_UNIDADE_CURRICULAR_has_SISCON_SECAO_SISCON_SECAO1` (`ID_SECAO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;