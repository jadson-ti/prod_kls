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

-- Copiando estrutura para tabela prod_kls.kls_lms_contexto
CREATE TABLE IF NOT EXISTS `kls_lms_contexto` (
  `id_contexto` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pes_turma_disciplina` int(11) NOT NULL,
  `id_ies` int(11) NOT NULL,
  `id_pessoa` int(11) NOT NULL,
  `id_pessoa_papel` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `id_pessoa_curso` int(11) NOT NULL,
  `id_disciplina` int(11) NOT NULL,
  `id_curso_disciplina` int(11) NOT NULL,
  `id_turma` int(11) NOT NULL,
  `id_pes_cur_disc` int(11) NOT NULL,
  `nm_arquivo` varchar(255) DEFAULT NULL,
  `create_dat` date DEFAULT NULL,
  `update_data` date DEFAULT NULL,
  `fl_etl_atu` varchar(2) DEFAULT NULL,
  `id_tracker_contx` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_contexto`),
  UNIQUE KEY `ui_id_tracker_cx` (`id_tracker_contx`),
  KEY `fk_id_ies_cntx` (`id_ies`),
  KEY `fk_id_pes_cntx` (`id_pessoa`),
  KEY `fk_id_ppl_cntx` (`id_pessoa_papel`),
  KEY `fk_id_crs_cntx` (`id_curso`),
  KEY `fk_id_pcr_cntx` (`id_pessoa_curso`),
  KEY `fk_id_dis_cntx` (`id_disciplina`),
  KEY `fk_id_cds_cntx` (`id_curso_disciplina`),
  KEY `fk_id_itr_cntx` (`id_turma`),
  KEY `fk_id_pds_cntx` (`id_pes_cur_disc`),
  KEY `fk_id_tds_cntx` (`id_pes_turma_disciplina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
