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

-- Copiando estrutura para tabela prod_kls.sgt_aloc_det
CREATE TABLE IF NOT EXISTS `sgt_aloc_det` (
  `username` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `nm_pessoa` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `sigla` varchar(30) DEFAULT NULL,
  `shortname` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `fullname` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `codigo_disciplina` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `nome_disciplina` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `tutor` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `matricula` date DEFAULT NULL,
  `bloqueio` date DEFAULT NULL,
  `situacao` varchar(10) CHARACTER SET latin1 DEFAULT NULL,
  `ativo` varchar(3) CHARACTER SET latin1 DEFAULT NULL,
  KEY `sgt_aloc_detIDX1` (`username`),
  KEY `sgt_aloc_detIDX2` (`matricula`),
  KEY `sgt_aloc_detIDX3` (`ativo`),
  KEY `sgt_aloc_detIDX4` (`tutor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
