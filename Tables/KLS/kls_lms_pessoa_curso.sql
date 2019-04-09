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

-- Copiando estrutura para tabela prod_kls.kls_lms_pessoa_curso
CREATE TABLE IF NOT EXISTS `kls_lms_pessoa_curso` (
  `id_pessoa_curso` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_curso` bigint(20) NOT NULL,
  `id_pessoa` bigint(20) NOT NULL,
  `id_papel` bigint(20) NOT NULL,
  `cd_turma_mat` varchar(20) DEFAULT NULL,
  `termo_turma` varchar(20) DEFAULT NULL,
  `create_dat` datetime DEFAULT NULL,
  `update_dat` datetime DEFAULT NULL,
  `fl_etl_atu` varchar(2) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id_pessoa_curso`),
  KEY `IDX_CURSO` (`id_curso`),
  KEY `IDX_PAPEL` (`id_papel`),
  KEY `IDX_PESSOA` (`id_pessoa`),
  CONSTRAINT `FK_CURSO` FOREIGN KEY (`id_curso`) REFERENCES `kls_lms_curso` (`id_curso`),
  CONSTRAINT `FK_PAPEL` FOREIGN KEY (`id_papel`) REFERENCES `kls_lms_papel` (`id_papel`)
) ENGINE=InnoDB AUTO_INCREMENT=10000000 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
