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

-- Copiando estrutura para tabela prod_kls.KLS_REPRESADOS_KHUB
CREATE TABLE IF NOT EXISTS `KLS_REPRESADOS_KHUB` (
  `LG_DS_ORIGEM` varchar(4) DEFAULT NULL,
  `LG_CD_PESSOA` varchar(20) DEFAULT NULL,
  `LG_NM_PESSOA` varchar(100) DEFAULT NULL,
  `LG_NR_CPF` varchar(11) DEFAULT NULL,
  `LG_LOGIN` varchar(50) DEFAULT NULL,
  `LG_CD_UNIDADE_ALUNO` varchar(10) DEFAULT NULL,
  `LG_NM_UNIDADE_ALUNO` varchar(100) DEFAULT NULL,
  `LG_CD_TURMA_ALUNO` varchar(30) DEFAULT NULL,
  `LG_CD_CURSO_ALUNO` varchar(30) DEFAULT NULL,
  `LG_NM_CURSO_ALUNO` varchar(100) DEFAULT NULL,
  `LG_TP_CURSO_ALUNO` varchar(1) DEFAULT NULL,
  `LG_CD_UNIDADE_DISC` varchar(10) DEFAULT NULL,
  `LG_NM_UNIDADE_DISC` varchar(100) DEFAULT NULL,
  `LG_CD_TURMA_DISC` varchar(30) DEFAULT NULL,
  `LG_CD_CURSO_DISC` varchar(30) DEFAULT NULL,
  `LG_NM_CURSO_DISC` varchar(100) DEFAULT NULL,
  `LG_TP_CURSO_DISC` varchar(1) DEFAULT NULL,
  `LG_IC_HORARIOCORRETO` varchar(1) DEFAULT NULL,
  `LG_IC_HORARIOCONFIRMADO` varchar(1) DEFAULT NULL,
  `LG_IC_ASISITUACAO` varchar(200) DEFAULT NULL,
  `LG_IC_ADISITUACAO` varchar(200) DEFAULT NULL,
  `LG_CD_DISCIPLINA` varchar(20) DEFAULT NULL,
  `LG_DS_DISCIPLINA` varchar(100) DEFAULT NULL,
  `LG_TP_DISCIPLINA` varchar(1) DEFAULT NULL,
  `LG_TP_OFERTA_DISCIPLINA` varchar(255) DEFAULT NULL,
  `LG_IC_OFERTA_DEPENDENCIA` varchar(100) DEFAULT NULL,
  `LG_CD_AREA_CON_ED_DISCIPLINA` varchar(255) DEFAULT NULL,
  `LG_CD_DEPARTAM_DISCIPLINA` varchar(255) DEFAULT NULL,
  `LG_TP_MODELO_DISCIPLINAR` varchar(12) DEFAULT NULL,
  `LG_TP_MATRICULA` varchar(12) DEFAULT NULL,
  `LG_CD_GRADE_ALUNO` int(11) DEFAULT NULL,
  `LG_SHORTNAME_CURSO_DISCIPLINA` varchar(100) DEFAULT NULL,
  `ST_HORARIO` varchar(255) DEFAULT NULL,
  `ST_DISCIPLINA` varchar(255) DEFAULT NULL,
  `ST_LOGIN` varchar(255) DEFAULT NULL,
  `ST_TURMA` varchar(255) DEFAULT NULL,
  `ST_ALUNO_DISCIPLINA` varchar(255) DEFAULT NULL,
  `ST_ALUNO_CURSO` varchar(255) DEFAULT NULL,
  `ST_ALUNO_NOME_CPF` varchar(255) DEFAULT NULL,
  `MO_ID_PESSOA` int(11) DEFAULT NULL,
  `MO_ID_IES_ALUNO` int(11) DEFAULT NULL,
  `MO_ID_CURSO_ALUNO` int(11) DEFAULT NULL,
  `MO_ID_IES_DISC` int(11) DEFAULT NULL,
  `MO_ID_CURSO_DISC` int(11) DEFAULT NULL,
  `MO_ID_DISCIPLINA` int(11) DEFAULT NULL,
  `MO_ID_TURMA_DISC` int(11) DEFAULT NULL,
  `MO_ID_CURSO_DISCIPLINA` int(11) DEFAULT NULL,
  `MO_ID_PES_CUR_DISC` int(11) DEFAULT NULL,
  `MO_ID_PES_TURMA_DISCIPLINA` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;