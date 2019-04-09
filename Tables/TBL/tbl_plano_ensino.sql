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

-- Copiando estrutura para tabela prod_kls.tbl_plano_ensino
CREATE TABLE IF NOT EXISTS `tbl_plano_ensino` (
  `Id` int(11) DEFAULT NULL,
  `Regional` varchar(200) DEFAULT NULL,
  `Marca` varchar(200) DEFAULT NULL,
  `Instituicao` varchar(200) DEFAULT NULL,
  `Nome_Instituicao` varchar(200) DEFAULT NULL,
  `Codigo_Curso` varchar(200) DEFAULT NULL,
  `Nome_Curso` text,
  `Disciplina` varchar(200) DEFAULT NULL,
  `Modelo` varchar(100) DEFAULT NULL,
  `Professor` text,
  `Login_Professor` text,
  `Coordenador` text,
  `Login_Coordenador` text,
  `Turmas` text,
  `Status` varchar(100) DEFAULT NULL,
  `CriadoPor` varchar(100) DEFAULT NULL,
  `CriadoPor_Nome` varchar(100) DEFAULT NULL,
  `AprovadoPor` varchar(100) DEFAULT NULL,
  `AprovadoPor_Nome` varchar(100) DEFAULT NULL,
  `AtualizadoPor` varchar(100) DEFAULT NULL,
  `AtualizadoPor_Nome` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
