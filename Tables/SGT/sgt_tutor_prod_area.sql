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

-- Copiando estrutura para tabela prod_kls.sgt_tutor_prod_area
CREATE TABLE IF NOT EXISTS `sgt_tutor_prod_area` (
  `sigla` varchar(3) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `tutoralocado` varchar(3) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `produto` varchar(17) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `username` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `nome` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `area_formacao` text CHARACTER SET utf8mb4 NOT NULL,
  `Limite_ED` bigint(20) DEFAULT NULL,
  `Limite_DI` bigint(20) DEFAULT NULL,
  `Limite_DIB` bigint(20) DEFAULT NULL,
  `Limite_TCC` bigint(20) DEFAULT NULL,
  `Limite_NPJ` bigint(20) DEFAULT NULL,
  `Limite_EST` bigint(20) DEFAULT NULL,
  `Limite_HIB` bigint(20) DEFAULT NULL,
  `qtd` bigint(20) DEFAULT NULL,
  `sgt_user_id` bigint(20) NOT NULL DEFAULT '0',
  KEY `stg_tutor_grupo_areaIX` (`username`),
  KEY `stg_tutor_grupo_areaIX1` (`produto`),
  KEY `stg_tutor_grupo_areaIX2` (`sgt_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
