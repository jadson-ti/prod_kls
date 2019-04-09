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

-- Copiando estrutura para tabela prod_kls.bkp20190220_mdl_import_categories_quiz
CREATE TABLE IF NOT EXISTS `bkp20190220_mdl_import_categories_quiz` (
  `id` bigint(10) NOT NULL DEFAULT '0',
  `id_categoria_curso` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `nome_categoria_curso` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `categoria_principal` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `categoria_disciplina` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `categoria_unidade` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `categoria_secao` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT 'manual',
  `categoria_quiz` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `id_curso` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `shortname` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `disciplina` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `id_questionario` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `nome_quiz` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `id_questao` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `nome_questao` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `tipo` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `concluido` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
