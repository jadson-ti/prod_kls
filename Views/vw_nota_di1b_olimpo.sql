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

-- Copiando estrutura para tabela prod_kls.vw_nota_di1b_olimpo
CREATE TABLE IF NOT EXISTS `vw_nota_di1b_olimpo` (
  `CODIGO_MATRICULA` varchar(100) DEFAULT NULL,
  `COD_CURSO` varchar(100) DEFAULT NULL,
  `COD_DISCIPLINA` varchar(100) DEFAULT NULL,
  `TURMA` varchar(100) DEFAULT NULL,
  `DISTIPO` varchar(1) CHARACTER SET utf8mb4 NOT NULL,
  `TITULO_AVALIACAO` varchar(11) CHARACTER SET utf8mb4 NOT NULL,
  `NOTA` decimal(3,1) DEFAULT NULL,
  `PELCOD` int(5) NOT NULL,
  `TPRCOD` varchar(2) CHARACTER SET utf8mb4 NOT NULL,
  `CHAMADA` int(1) NOT NULL,
  `TITULOAPLICACAO` char(0) CHARACTER SET utf8mb4 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
