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

-- Copiando estrutura para tabela prod_kls.sgt_questionario_associado
CREATE TABLE IF NOT EXISTS `sgt_questionario_associado` (
  `ID_CATEGORIA_CURSO` bigint(10) DEFAULT NULL,
  `NOME_CATEGORIA_CURSO` varchar(255) DEFAULT NULL,
  `ID_CURSO` bigint(10) DEFAULT NULL,
  `DISCIPLINA` varchar(254) DEFAULT NULL,
  `SHORTNAME` varchar(255) DEFAULT NULL,
  `ID_QUESTIONARIO` bigint(10) DEFAULT NULL,
  `NOME_QUIZ` varchar(255) DEFAULT NULL,
  `ID_QUESTAO` bigint(10) DEFAULT NULL,
  `NOME_QUESTAO` varchar(255) DEFAULT NULL,
  `TIPO` varchar(20) DEFAULT NULL,
  `TEXTO_QUESTAO` longtext,
  `DATA_MODIFICACAO` varchar(15) DEFAULT NULL,
  `CAMINHO` longtext,
  `STATUS` varchar(50) DEFAULT NULL,
  KEY `sgt_questionario_associadoIX` (`ID_CURSO`),
  KEY `sgt_questionario_associadoIX1` (`DISCIPLINA`),
  KEY `sgt_questionario_associadoIX2` (`SHORTNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
