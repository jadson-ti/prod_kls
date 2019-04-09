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

-- Copiando estrutura para tabela prod_kls.rel_recursos
CREATE TABLE IF NOT EXISTS `rel_recursos` (
  `module` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `course` bigint(10) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `shortname` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `nome_curso` varchar(254) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `section_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `same_section` varchar(1) CHARACTER SET utf8mb4 DEFAULT NULL,
  `topico` bigint(20) NOT NULL DEFAULT '0',
  `seq` int(3) DEFAULT NULL,
  `nome_recurso` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `etapa` longtext CHARACTER SET utf8mb4,
  `config_rating` varchar(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
