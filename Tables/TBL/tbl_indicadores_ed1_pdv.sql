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

-- Copiando estrutura para tabela prod_kls.tbl_indicadores_ed1_pdv
CREATE TABLE IF NOT EXISTS `tbl_indicadores_ed1_pdv` (
  `COD_UNIDADE` varchar(100) DEFAULT 'Nenhum Encontrado',
  `UNIDADE` varchar(100) DEFAULT 'Nenhuma Encontrada',
  `ID_CURSO_KLS` bigint(20) DEFAULT '0',
  `COD_CURSO_KLS` varchar(100) DEFAULT NULL,
  `NOME_CURSO_KLS` varchar(200) DEFAULT NULL,
  `ID_CURSO` bigint(10) DEFAULT NULL,
  `NOME_CURSO` varchar(100) DEFAULT NULL,
  `FULLNAME` varchar(200) DEFAULT NULL,
  `ID_CATEGORIA` bigint(20) DEFAULT NULL,
  `NOME_CATEGORIA` varchar(100) DEFAULT NULL,
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
  `ATIVIDADE_1_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_2_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_3_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_4_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_5_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_6_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_7_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `ATIVIDADE_8_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `FEEDBACK_1_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `FEEDBACK_2_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `FEEDBACK_3_ENTREGA` varchar(100) DEFAULT 'PENDENTE',
  `CERTIFICADO` varchar(100) DEFAULT 'NÃO POSSUI',
  KEY `idx_CURSO` (`ID_CURSO`,`ID_GRUPO`),
  KEY `idx_USER` (`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
