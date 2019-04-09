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

-- Copiando estrutura para tabela prod_kls.tbl_indicadores_est
CREATE TABLE IF NOT EXISTS `tbl_indicadores_est` (
  `COD_UNIDADE` varchar(100) DEFAULT 'Nenhum Encontrado',
  `UNIDADE` varchar(100) DEFAULT 'Nenhuma Encontrada',
  `ID_CURSO_KLS` bigint(20) DEFAULT '0',
  `COD_CURSO_KLS` varchar(100) DEFAULT NULL,
  `NOME_CURSO_KLS` varchar(200) DEFAULT NULL,
  `ID_CURSO` bigint(20) DEFAULT NULL,
  `NOME_CURSO` varchar(100) DEFAULT NULL,
  `FULLNAME` varchar(200) DEFAULT NULL,
  `ID_Categoria` bigint(20) DEFAULT NULL,
  `Nome_Categoria` varchar(100) DEFAULT NULL,
  `ID_GRUPO` bigint(20) DEFAULT NULL,
  `GRUPO` varchar(100) DEFAULT NULL,
  `USERID` bigint(20) DEFAULT NULL,
  `LOGIN` varchar(100) DEFAULT NULL,
  `NOME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `DataVinculoDisciplina` varchar(100) DEFAULT NULL,
  `PrimeiroAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `UltimoAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `QuantDiasAcesso` bigint(20) DEFAULT '0',
  `ATIVIDADE_1_ALUNO` varchar(100) DEFAULT 'Pendente',
  `ATIVIDADE_2_ALUNO` varchar(100) DEFAULT 'Pendente',
  `ATIVIDADE_3_ALUNO` varchar(100) DEFAULT 'Pendente',
  `ATIVIDADE_4_ALUNO` varchar(100) DEFAULT 'Pendente',
  `ATIVIDADE_5_ALUNO` varchar(100) DEFAULT 'Pendente',
  `TUTOR_ID` bigint(20) DEFAULT '0',
  `TUTOR_LOGIN` varchar(100) DEFAULT 'Sem Tutor',
  `TUTOR_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `TUTOR_DataVinculo` varchar(100) DEFAULT 'Sem VÃ­nculo',
  `TUTOR_NOME` varchar(200) DEFAULT 'Sem Nome',
  `TUTOR_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `TUTOR_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `ATIVIDADE_1_AVALIACAO_PENAL` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_1_NOTA_PENAL` varchar(50) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_AVALIACAO_PENAL` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_NOTA_PENAL` varchar(50) DEFAULT 'PENDENTE',
  `ATIVIDADE_3_AVALIACAO_PENAL` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_3_NOTA_PENAL` varchar(50) DEFAULT 'PENDENTE',
  `ATIVIDADE_4_AVALIACAO_PENAL` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_4_NOTA_PENAL` varchar(50) DEFAULT 'PENDENTE',
  `ATIVIDADE_5_AVALIACAO_PENAL` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_5_NOTA_PENAL` varchar(50) DEFAULT 'PENDENTE',
  KEY `idx_USERID` (`ID_CURSO`,`ID_GRUPO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
