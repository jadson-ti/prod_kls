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

-- Copiando estrutura para tabela prod_kls.tbl_indicadores_ami
CREATE TABLE IF NOT EXISTS `tbl_indicadores_ami` (
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
  `ID_GRUPO` bigint(10) DEFAULT NULL,
  `GRUPO` varchar(200) DEFAULT NULL,
  `USERID` bigint(10) DEFAULT NULL,
  `LOGIN` varchar(100) DEFAULT NULL,
  `NOME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `DataVinculoDisciplina` varchar(100) DEFAULT NULL,
  `PrimeiroAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `UltimoAcessoDisciplina` varchar(100) DEFAULT 'Nunca Acessou',
  `QuantDiasAcesso` bigint(20) DEFAULT '0',
  `ATIVIDADE_1_ALUNO` varchar(100) DEFAULT 'PENDENTE',
  `QUIZ_U1S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S4_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U1` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S4_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U2` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S4_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U3` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S1_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S1_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S2_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S2_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S3_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S3_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S4_DIAGNOSTICA` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4S4_APRENDIZAGEM` decimal(3,1) DEFAULT '0.0',
  `QUIZ_U4` decimal(3,1) DEFAULT '0.0',
  `TUTOR_ID` bigint(10) DEFAULT '0',
  `TUTOR_LOGIN` varchar(100) DEFAULT 'Sem Professor',
  `TUTOR_EMAIL` varchar(100) DEFAULT 'Sem E-mail',
  `TUTOR_DataVinculo` varchar(100) DEFAULT 'Sem Vínculo',
  `TUTOR_NOME` varchar(200) DEFAULT 'Sem Nome',
  `TUTOR_PrimeiroAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `TUTOR_UltimoAcesso` varchar(100) DEFAULT 'Nunca Acessou',
  `ATIVIDADE_1_AVALIACAO` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_1_NOTA` decimal(3,1) DEFAULT '0.0',
  KEY `idx_CURGRP_AMI` (`ID_CURSO`,`ID_GRUPO`),
  KEY `idx_CUR_AMI` (`ID_CURSO`),
  KEY `idx_GRP_AMI` (`ID_GRUPO`),
  KEY `idx_GRP_LOGIN` (`LOGIN`),
  KEY `idx_GRP_UC` (`USERID`,`ID_CURSO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
