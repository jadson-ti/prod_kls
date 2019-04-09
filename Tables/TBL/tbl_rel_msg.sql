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

-- Copiando estrutura para tabela prod_kls.tbl_rel_msg
CREATE TABLE IF NOT EXISTS `tbl_rel_msg` (
  `AREA_CONHECIMENTO` varchar(200) DEFAULT NULL,
  `CATEGORIA` varchar(100) DEFAULT 'HOME',
  `CODIGO_CURSO` bigint(10) DEFAULT NULL,
  `CURSO` varchar(200) DEFAULT 'HOME',
  `DATA_ENVIO` datetime DEFAULT NULL,
  `QUEM_MANDOU` bigint(10) DEFAULT NULL,
  `PAPEL` varchar(50) DEFAULT NULL,
  `LOGIN_ALUNO` varchar(200) DEFAULT NULL,
  `ALUNO` varchar(200) DEFAULT NULL,
  `QUEM_RECEBEU` bigint(10) DEFAULT NULL,
  `LOGIN_TUTOR` varchar(200) DEFAULT NULL,
  `TUTOR` varchar(200) DEFAULT NULL,
  `QTD_MSG` int(11) DEFAULT NULL,
  KEY `idx_CODIGO_CURSO` (`CODIGO_CURSO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
