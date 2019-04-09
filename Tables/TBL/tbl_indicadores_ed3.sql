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

-- Copiando estrutura para tabela prod_kls.tbl_indicadores_ed3
CREATE TABLE IF NOT EXISTS `tbl_indicadores_ed3` (
  `COD_UNIDADE` varchar(100) DEFAULT 'Nenhum Encontrado',
  `UNIDADE` varchar(100) DEFAULT 'Nenhuma Encontrada',
  `ID_CURSO_KLS` bigint(20) DEFAULT '0',
  `COD_CURSO_KLS` varchar(100) DEFAULT NULL,
  `NOME_CURSO_KLS` varchar(200) DEFAULT NULL,
  `ID_CURSO` bigint(10) DEFAULT NULL,
  `NOME_CURSO` varchar(100) DEFAULT NULL,
  `FULLNAME` varchar(200) DEFAULT NULL,
  `ID_Categoria` bigint(10) DEFAULT NULL,
  `Nome_Categoria` varchar(100) DEFAULT NULL,
  `ID_GRUPO` bigint(10) DEFAULT NULL,
  `GRUPO` varchar(100) DEFAULT NULL,
  `USERID` bigint(10) DEFAULT NULL,
  `LOGIN` varchar(100) DEFAULT NULL,
  `NOME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `DataVinculoDisciplina` varchar(100) DEFAULT NULL,
  `PrimeiroAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `UltimoAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `QuantDiasAcesso` bigint(20) DEFAULT '0',
  `ATIVIDADE_1_ALUNO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_ALUNO` varchar(100) DEFAULT 'PENDENTE',
  `SIMULADO_PARCIAL` varchar(50) DEFAULT 'PENDENTE',
  `SIMULADO_GERAL` varchar(50) DEFAULT 'PENDENTE',
  `AVALIACAO_ONLINE` varchar(50) DEFAULT 'PENDENTE',
  `TUTOR_ID` bigint(20) DEFAULT '0',
  `TUTOR_LOGIN` varchar(100) DEFAULT 'Sem Tutor',
  `TUTOR_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `TUTOR_DataVinculo` varchar(100) DEFAULT 'Sem Vínculo',
  `TUTOR_NOME` varchar(200) DEFAULT 'Sem Nome',
  `TUTOR_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `TUTOR_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `ATIVIDADE_1_AVALIACAO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_1_NOTA` varchar(50) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_AVALIACAO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_NOTA` varchar(50) DEFAULT 'PENDENTE',
  KEY `idx_CURSO` (`ID_CURSO`,`ID_GRUPO`),
  KEY `idx_USERCURSO` (`USERID`,`ID_CURSO`),
  KEY `idx_USER` (`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
