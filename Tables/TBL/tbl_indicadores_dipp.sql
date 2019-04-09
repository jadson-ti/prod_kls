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

-- Copiando estrutura para tabela prod_kls.tbl_indicadores_dipp
CREATE TABLE IF NOT EXISTS `tbl_indicadores_dipp` (
  `COD_UNIDADE` varchar(100) DEFAULT 'Nenhum Encontrado',
  `UNIDADE` varchar(100) DEFAULT 'Nenhuma Encontrada',
  `ID_CURSO_KLS` bigint(20) DEFAULT '0',
  `COD_CURSO_KLS` varchar(100) DEFAULT NULL,
  `NOME_CURSO_KLS` varchar(255) DEFAULT NULL,
  `ID_CURSO` bigint(10) DEFAULT NULL,
  `NOME_CURSO` varchar(100) DEFAULT NULL,
  `FULLNAME` varchar(200) DEFAULT NULL,
  `ID_CATEGORIA` bigint(10) DEFAULT NULL,
  `NOME_CATEGORIA` varchar(100) DEFAULT NULL,
  `IDNUMBER_GRUPO` varchar(200) DEFAULT NULL,
  `ID_GRUPO_PRESENCIAL` bigint(10) DEFAULT NULL,
  `ID_GRUPO_VIRTUAL` bigint(10) DEFAULT NULL,
  `GRUPO_PRESENCIAL` varchar(200) DEFAULT NULL,
  `GRUPO_TUTOR` varchar(100) DEFAULT NULL,
  `USERID` bigint(10) DEFAULT NULL,
  `LOGIN` varchar(100) DEFAULT NULL,
  `NOME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `DataVinculoDisciplina` varchar(100) DEFAULT NULL,
  `PrimeiroAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `UltimoAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `QuantDiasAcesso` bigint(20) DEFAULT '0',
  `ATIVIDADE_1_ALUNO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_1_AVALIACAO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_1_NOTA` decimal(3,1) DEFAULT '0.0',
  `ATIVIDADE_2_ALUNO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_AVALIACAO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_NOTA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4` decimal(3,1) DEFAULT '0.0',
  `PROF_ID` bigint(10) DEFAULT '0',
  `PROF_LOGIN` varchar(100) DEFAULT 'Sem Professor',
  `PROF_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `PROF_DataVinculo` varchar(100) DEFAULT 'Sem Vínculo',
  `PROF_NOME` varchar(200) DEFAULT 'Sem Nome',
  `PROF_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `PROF_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `TUTOR_ID` bigint(10) DEFAULT '0',
  `TUTOR_LOGIN` varchar(100) DEFAULT 'Sem Tutor',
  `TUTOR_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `TUTOR_DataVinculo` varchar(100) DEFAULT 'Sem Vínculo',
  `TUTOR_NOME` varchar(200) DEFAULT 'Sem Nome',
  `TUTOR_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `TUTOR_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `COORD_ID` bigint(10) DEFAULT '0',
  `COORD_LOGIN` varchar(100) DEFAULT 'Sem Tutor',
  `COORD_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `COORD_DataVinculo` varchar(100) DEFAULT 'Sem Vínculo',
  `COORD_NOME` varchar(200) DEFAULT 'Sem Nome',
  `COORD_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `COORD_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  KEY `idx_CUR_dipp` (`ID_CURSO`),
  KEY `idx_GRP_LOGIN` (`LOGIN`),
  KEY `idx_GRP_UC` (`USERID`,`ID_CURSO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
