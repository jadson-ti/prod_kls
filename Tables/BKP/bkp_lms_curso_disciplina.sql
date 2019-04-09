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

-- Copiando estrutura para tabela prod_kls.bkp_lms_curso_disciplina
CREATE TABLE IF NOT EXISTS `bkp_lms_curso_disciplina` (
  `id_curso_disciplina` bigint(20) NOT NULL,
  `id_disciplina` bigint(20) NOT NULL,
  `id_curso` bigint(20) NOT NULL,
  `create_dat` datetime DEFAULT NULL,
  `update_dat` datetime DEFAULT NULL,
  `fl_etl_atu` varchar(2) CHARACTER SET utf8 DEFAULT NULL,
  `id_cd_remarc` bigint(20) DEFAULT NULL,
  `cd_curriculo` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `shortname` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `motivo_etl_atu` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `carga_horaria` double DEFAULT NULL,
  `status` varchar(2) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
