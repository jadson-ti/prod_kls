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

-- Copiando estrutura para tabela prod_kls.mdl_batimento
CREATE TABLE IF NOT EXISTS `mdl_batimento` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `lg_ds_origem` varchar(100) DEFAULT 'false',
  `lg_cd_pessoa` varchar(200) DEFAULT 'false',
  `lg_nm_pessoa` varchar(100) DEFAULT 'false',
  `lg_nr_cpf` varchar(11) DEFAULT 'false',
  `lg_login` varchar(50) DEFAULT 'false',
  `lg_cd_unidade_aluno` varchar(100) DEFAULT 'false',
  `lg_nm_unidade_aluno` varchar(100) DEFAULT 'false',
  `lg_cd_turma_aluno` varchar(100) DEFAULT 'false',
  `lg_cd_curso_aluno` varchar(100) DEFAULT 'false',
  `lg_nm_curso_aluno` varchar(100) DEFAULT 'false',
  `lg_tp_curso_aluno` varchar(100) DEFAULT 'f',
  `lg_cd_unidade_disc` varchar(100) DEFAULT 'false',
  `lg_nm_unidade_disc` varchar(100) DEFAULT 'false',
  `lg_cd_turma_disc` varchar(100) DEFAULT 'false',
  `lg_cd_curso_disc` varchar(100) DEFAULT 'false',
  `lg_nm_curso_disc` varchar(100) DEFAULT 'false',
  `lg_tp_curso_disc` varchar(100) DEFAULT 'f',
  `lg_ic_horariocorreto` varchar(100) DEFAULT 'f',
  `lg_ic_horarioconfirmado` varchar(100) DEFAULT 'f',
  `lg_ic_asisituacao` varchar(200) DEFAULT 'false',
  `lg_ic_adisituacao` varchar(255) DEFAULT 'false',
  `lg_cd_disciplina` varchar(100) DEFAULT 'false',
  `lg_ds_disciplina` varchar(100) DEFAULT 'false',
  `lg_tp_disciplina` varchar(100) DEFAULT 'f',
  `lg_tp_oferta_disciplina` varchar(255) DEFAULT 'false',
  `lg_ic_oferta_dependencia` varchar(100) DEFAULT 'false',
  `lg_cd_area_con_ed_disciplina` varchar(255) DEFAULT 'false',
  `lg_cd_departam_disciplina` varchar(255) DEFAULT 'false',
  `lg_tp_modelo_disciplinar` varchar(12) DEFAULT 'false',
  `lg_tp_matricula` varchar(12) DEFAULT 'false',
  `lg_cd_grade_aluno` bigint(10) DEFAULT '0',
  `lg_shortname_curso_disciplina` varchar(255) DEFAULT 'false',
  `st_horario` varchar(255) DEFAULT 'false',
  `st_disciplina` varchar(255) DEFAULT 'false',
  `st_login` varchar(255) DEFAULT 'false',
  `st_turma` varchar(255) DEFAULT 'false',
  `st_aluno_disciplina` varchar(255) DEFAULT 'false',
  `st_aluno_curso` varchar(255) DEFAULT 'false',
  `st_aluno_nome_cpf` varchar(255) DEFAULT 'false',
  `mo_id_pessoa` bigint(10) DEFAULT '0',
  `mo_id_ies_aluno` bigint(10) DEFAULT '0',
  `mo_id_curso_aluno` bigint(10) DEFAULT '0',
  `mo_id_ies_disc` bigint(10) DEFAULT '0',
  `mo_id_curso_disc` bigint(10) DEFAULT '0',
  `mo_id_disciplina` bigint(10) DEFAULT '0',
  `mo_id_turma_disc` bigint(10) DEFAULT '0',
  `mo_id_curso_disciplina` bigint(10) DEFAULT '0',
  `mo_id_pes_cur_disc` bigint(10) DEFAULT '0',
  `mo_id_pes_turma_disciplina` bigint(10) DEFAULT '0',
  `dt_batimento` varchar(255) DEFAULT 'false',
  `lg_nr_periodo_letivo` mediumint(6) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7405456 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
