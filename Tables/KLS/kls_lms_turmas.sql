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

-- Copiando estrutura para tabela prod_kls.kls_lms_turmas
CREATE TABLE IF NOT EXISTS `kls_lms_turmas` (
  `id_turma` bigint(20) NOT NULL,
  `id_curso_disciplina` bigint(20) NOT NULL,
  `cd_turma` varchar(20) CHARACTER SET utf8 NOT NULL,
  `periodo_letivo` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `termo_turma` varchar(255) CHARACTER SET utf8 NOT NULL,
  `shortname` varchar(255) CHARACTER SET utf8 NOT NULL,
  `data_ini` datetime DEFAULT NULL,
  `data_fim` datetime DEFAULT NULL,
  `create_dat` datetime DEFAULT NULL,
  `update_dat` datetime DEFAULT NULL,
  `fl_etl_atu` varchar(2) CHARACTER SET utf8 DEFAULT NULL,
  `status` varchar(2) CHARACTER SET utf8 DEFAULT NULL,
  `motivo_etl_atu` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `turma_especial` varchar(2) DEFAULT NULL,
  `tipo_avaliacao` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id_turma`),
  KEY `FK_KLS_CDTURMA` (`cd_turma`),
  KEY `FK_KLS_IDCRSDISTRM` (`id_curso_disciplina`),
  KEY `FK_KLS_SHORTNAME` (`shortname`),
  KEY `idx_tipo_avalia` (`tipo_avaliacao`),
  CONSTRAINT `FK_KLS_LMS_TURMAS_KLS_LMS_CURSO_DISCIPLINA` FOREIGN KEY (`id_curso_disciplina`) REFERENCES `kls_lms_curso_disciplina` (`id_curso_disciplina`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
