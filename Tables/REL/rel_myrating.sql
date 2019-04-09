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

-- Copiando estrutura para tabela prod_kls.rel_myrating
CREATE TABLE IF NOT EXISTS `rel_myrating` (
  `cod_unidade` varchar(15) DEFAULT NULL,
  `nome_unidade` varchar(255) DEFAULT NULL,
  `nome_categoria` varchar(255) NOT NULL DEFAULT '',
  `cod_disciplina` varchar(255) NOT NULL DEFAULT '',
  `nome_disciplina` varchar(254) NOT NULL DEFAULT '',
  `login_aluno` varchar(100) NOT NULL DEFAULT '',
  `nome_aluno` varchar(201) NOT NULL DEFAULT '',
  `email_aluno` varchar(100) NOT NULL DEFAULT '',
  `perfil_pessoa` varchar(100) NOT NULL DEFAULT '',
  `nome_conteudo` varchar(255) DEFAULT NULL,
  `tipo_material` varchar(20) NOT NULL DEFAULT '',
  `assunto` varchar(150) DEFAULT '',
  `descricao` varchar(1024) NOT NULL DEFAULT '',
  `nota` varchar(23) CHARACTER SET utf8mb4 DEFAULT NULL,
  `data_avaliacao` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
