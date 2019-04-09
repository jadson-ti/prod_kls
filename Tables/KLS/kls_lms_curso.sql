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

-- Copiando estrutura para tabela prod_kls.kls_lms_curso
CREATE TABLE IF NOT EXISTS `kls_lms_curso` (
  `id_curso` bigint(20) NOT NULL,
  `id_ies` bigint(20) NOT NULL,
  `cd_curso` varchar(100) DEFAULT NULL,
  `nm_curso` varchar(255) DEFAULT NULL,
  `turno` varchar(10) DEFAULT NULL,
  `tp_curso` varchar(10) DEFAULT NULL,
  `cd_agrupamento` varchar(100) DEFAULT NULL,
  `titulacao` varchar(1) DEFAULT NULL,
  `create_dat` datetime DEFAULT NULL,
  `update_dat` datetime DEFAULT NULL,
  `fl_etl_atu` varchar(2) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  `motivo_etl_atu` varchar(150) DEFAULT NULL,
  `cd_eng` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_curso`),
  KEY `IDX_KLS_CD_CURSO` (`cd_curso`),
  KEY `IDX_KLS_IDIESFK` (`id_ies`),
  KEY `idx_agrupamento` (`cd_agrupamento`),
  CONSTRAINT `fk_unidade_curso` FOREIGN KEY (`id_ies`) REFERENCES `kls_lms_instituicao` (`id_ies`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
