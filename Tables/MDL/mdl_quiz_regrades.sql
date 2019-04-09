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

-- Copiando estrutura para tabela prod_kls.mdl_quiz_regrades
CREATE TABLE IF NOT EXISTS `mdl_quiz_regrades` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `instance` bigint(10) DEFAULT NULL,
  `quiz` bigint(10) DEFAULT NULL,
  `questionid` bigint(10) DEFAULT NULL,
  `questionattemptid` bigint(10) DEFAULT NULL,
  `quizattemptid` bigint(10) DEFAULT NULL,
  `userid` bigint(10) DEFAULT NULL,
  `courseid` bigint(10) DEFAULT NULL,
  `quizname` varchar(255) NOT NULL DEFAULT '',
  `attempt` longtext,
  `fl_on` bigint(10) NOT NULL DEFAULT '0',
  `timecron` bigint(10) NOT NULL DEFAULT '0',
  `timefinished` varchar(255) DEFAULT 'null',
  `numberattempt` bigint(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List information to regrade grades of quiz';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
