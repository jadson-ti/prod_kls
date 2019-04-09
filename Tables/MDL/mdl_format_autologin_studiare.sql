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

-- Copiando estrutura para tabela prod_kls.mdl_format_autologin_studiare
CREATE TABLE IF NOT EXISTS `mdl_format_autologin_studiare` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `courseid` bigint(10) NOT NULL DEFAULT '0',
  `userid` bigint(10) NOT NULL DEFAULT '0',
  `cpf` varchar(11) NOT NULL DEFAULT '0',
  `cod_unidade` varchar(10) NOT NULL DEFAULT '0',
  `cod_turma` varchar(255) NOT NULL DEFAULT '0',
  `cod_disciplina` varchar(100) NOT NULL DEFAULT '0',
  `cod_curso` varchar(100) NOT NULL DEFAULT '0',
  `periodo` varchar(7) NOT NULL DEFAULT '20162',
  `nome_unidade` varchar(50) NOT NULL DEFAULT '0',
  `nome_curso` varchar(100) NOT NULL DEFAULT '0',
  `cod_aluno` varchar(50) NOT NULL DEFAULT '0',
  `nome_aluno` varchar(100) NOT NULL DEFAULT '0',
  `email` varchar(100) NOT NULL DEFAULT '0',
  `nome_disciplina` varchar(150) DEFAULT '',
  `ra_aluno` varchar(50) NOT NULL DEFAULT '0',
  `situacao_aluno` varchar(50) NOT NULL DEFAULT 'ATIVO',
  `senha` varchar(80) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mdl_formautostud_use_ix` (`userid`),
  KEY `mdl_formautostud_cou_ix` (`courseid`),
  KEY `mdl_formautostud_cpf_ix` (`cpf`),
  KEY `mdl_formautostud_cod_ix` (`cod_curso`),
  KEY `mdl_formautostud_cod2_ix` (`cod_disciplina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Check change configuration blocks';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
