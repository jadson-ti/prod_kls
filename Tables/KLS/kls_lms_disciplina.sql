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

-- Copiando estrutura para tabela prod_kls.kls_lms_disciplina
CREATE TABLE IF NOT EXISTS `kls_lms_disciplina` (
  `id_disciplina` bigint(20) NOT NULL,
  `id_ies` bigint(20) NOT NULL,
  `cd_disciplina` varchar(255) DEFAULT NULL,
  `ds_disciplina` varchar(255) DEFAULT NULL,
  `id_tp_modelo` bigint(20) NOT NULL,
  `tp_disciplina` varchar(7) DEFAULT NULL,
  `create_dat` datetime DEFAULT NULL,
  `update_dat` datetime DEFAULT NULL,
  `fl_etl_atu` varchar(2) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  `id_disciplina_remarc` bigint(20) DEFAULT NULL,
  `motivo_etl_atu` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_disciplina`),
  UNIQUE KEY `UK_IES_DISCIPLINA` (`id_ies`,`fl_etl_atu`,`cd_disciplina`,`id_tp_modelo`),
  KEY `IDX_KLS_CDDSCFK` (`cd_disciplina`),
  KEY `IDX_KLS_IDIESDSCFK` (`id_ies`),
  KEY `IDX_KLS_TPDSCFK` (`id_tp_modelo`,`id_disciplina`),
  CONSTRAINT `fk_disciplina_ies` FOREIGN KEY (`id_ies`) REFERENCES `kls_lms_instituicao` (`id_ies`),
  CONSTRAINT `fk_disciplina_modelo` FOREIGN KEY (`id_tp_modelo`) REFERENCES `kls_lms_tipo_modelo` (`id_tp_modelo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
