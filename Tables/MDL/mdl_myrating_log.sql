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

-- Copiando estrutura para tabela prod_kls.mdl_myrating_log
CREATE TABLE IF NOT EXISTS `mdl_myrating_log` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `userid` bigint(10) NOT NULL,
  `coursemodule` bigint(10) NOT NULL,
  `rating` tinyint(1) NOT NULL,
  `subject` bigint(10) NOT NULL,
  `comment` varchar(1024) NOT NULL DEFAULT '',
  `timecreated` bigint(10) NOT NULL DEFAULT '0',
  `cod_unidade` varchar(255) DEFAULT NULL,
  `nome_unidade` varchar(255) DEFAULT NULL,
  `nome_categoria` varchar(255) DEFAULT NULL,
  `cod_disciplina` varchar(255) DEFAULT NULL,
  `nome_disciplina` varchar(255) DEFAULT NULL,
  `login_aluno` varchar(255) DEFAULT NULL,
  `email_aluno` varchar(255) DEFAULT NULL,
  `perfil_pessoa` varchar(255) DEFAULT NULL,
  `tipo_material` varchar(255) DEFAULT NULL,
  `assunto` tinyint(1) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `nota` varchar(255) DEFAULT NULL,
  `avaliado_em` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mdl_myralog_usecoutim_uix` (`userid`,`coursemodule`,`timecreated`),
  KEY `mdl_myralog_tim_ix` (`timecreated`),
  KEY `mdl_myralog_sub_ix` (`subject`)
) ENGINE=InnoDB AUTO_INCREMENT=42601 DEFAULT CHARSET=utf8 COMMENT='tabela de logs de todas as notas dadas';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
