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

-- Copiando estrutura para tabela prod_kls.alunos_tardios
CREATE TABLE IF NOT EXISTS `alunos_tardios` (
  `IUNICODEMPRESA` bigint(20) DEFAULT NULL,
  `Codigo` varchar(100) DEFAULT NULL,
  `Nome_Aluno` varchar(255) DEFAULT NULL,
  `Cod_Curso` bigint(20) DEFAULT NULL,
  `Curso` varchar(255) DEFAULT NULL,
  `TMACOD` varchar(255) DEFAULT NULL,
  `Horario_Confirmado` char(2) DEFAULT NULL,
  KEY `Codigo` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='* Tabela de testes, criação solicitada pela Claudia Soares';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
