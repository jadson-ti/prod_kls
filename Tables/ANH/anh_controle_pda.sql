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

-- Copiando estrutura para tabela prod_kls.anh_controle_pda
CREATE TABLE IF NOT EXISTS `anh_controle_pda` (
  `unidade` varchar(10) NOT NULL,
  `origem` varchar(20) NOT NULL,
  `curso` varchar(30) NOT NULL,
  `disciplina` varchar(30) NOT NULL,
  `curriculo` varchar(30) NOT NULL,
  `shortname` varchar(255) NOT NULL,
  `flag_disciplina` varchar(2) NOT NULL,
  `data_alteracao` datetime DEFAULT NULL,
  `situacao` tinyint(1) DEFAULT NULL,
  UNIQUE KEY `uk_control_pda` (`unidade`,`origem`,`curso`,`disciplina`,`curriculo`,`shortname`,`flag_disciplina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
