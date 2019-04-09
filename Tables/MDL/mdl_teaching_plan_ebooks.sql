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

-- Copiando estrutura para tabela prod_kls.mdl_teaching_plan_ebooks
CREATE TABLE IF NOT EXISTS `mdl_teaching_plan_ebooks` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `isbn` varchar(80) DEFAULT '',
  `autor` varchar(200) DEFAULT '',
  `titulo` varchar(500) DEFAULT '',
  `editora` varchar(80) DEFAULT '',
  `cidade` varchar(50) DEFAULT '',
  `selo` varchar(80) DEFAULT '',
  `data` varchar(20) DEFAULT '',
  `paginas` varchar(50) DEFAULT NULL,
  `edicao` varchar(50) DEFAULT NULL,
  `formato_abnt` longtext,
  `unidade` varchar(15) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59266 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
