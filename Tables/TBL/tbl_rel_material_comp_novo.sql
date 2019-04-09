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

-- Copiando estrutura para tabela prod_kls.tbl_rel_material_comp_novo
CREATE TABLE IF NOT EXISTS `tbl_rel_material_comp_novo` (
  `REGIONAL` varchar(50) DEFAULT NULL,
  `CODIGO_UNIDADE` varchar(15) DEFAULT NULL,
  `INSTITUICAO` varchar(255) DEFAULT NULL,
  `PROFESSOR` varchar(255) DEFAULT NULL,
  `COORDENADOR` varchar(255) DEFAULT NULL,
  `CODIGO_CURSO` varchar(20) DEFAULT NULL,
  `NOME_CURSO` varchar(255) DEFAULT NULL,
  `CODIGO_TURMA` varchar(100) NOT NULL DEFAULT '',
  `SERIE_TURMA` varchar(15) DEFAULT NULL,
  `CODIGO_DISCIPLINA` varchar(30) DEFAULT NULL,
  `NOME_DISCIPLINA` varchar(255) DEFAULT NULL,
  `SHORTNAME` varchar(50) NOT NULL DEFAULT '',
  `GRUPO` varchar(255) NOT NULL DEFAULT '',
  `ENCONTRO` int(11) NOT NULL DEFAULT '0',
  `QTD_PRE` int(11) DEFAULT NULL,
  `TEMPO_PRE` int(11) DEFAULT NULL,
  `QTD_AULA` int(11) DEFAULT NULL,
  `TEMPO_AULA` int(11) DEFAULT NULL,
  `QTD_POS` int(11) DEFAULT NULL,
  `TEMPO_POS` int(11) DEFAULT NULL,
  `CARGA_HORARIA` int(11) DEFAULT NULL,
  PRIMARY KEY (`SHORTNAME`,`CODIGO_TURMA`,`GRUPO`,`ENCONTRO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
