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

-- Copiando estrutura para tabela prod_kls.kls_lms_pessoa_turma
CREATE TABLE IF NOT EXISTS `kls_lms_pessoa_turma` (
  `id_pes_turma_disciplina` bigint(20) NOT NULL,
  `id_pes_cur_disc` bigint(20) NOT NULL,
  `id_turma` bigint(20) NOT NULL,
  `create_dat` date DEFAULT NULL,
  `update_dat` date DEFAULT NULL,
  `fl_etl_atu` varchar(2) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  `motivo_etl_atu` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_pes_turma_disciplina`),
  KEY `FK_KLS_LMS_PESSOA_TURMA_KLS_LMS_PESSOA_CURSO_DISC` (`id_pes_cur_disc`),
  KEY `FK_KLS_LMS_PESSOA_TURMA_KLS_LMS_TURMAS` (`id_turma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
