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

-- Copiando estrutura para tabela prod_kls.aluno_tutor_di
CREATE TABLE IF NOT EXISTS `aluno_tutor_di` (
  `username` varchar(35) NOT NULL,
  `tutor` varchar(35) DEFAULT NULL,
  `tutor_id` int(11) NOT NULL DEFAULT '0',
  `id_area_formacao` int(11) NOT NULL,
  PRIMARY KEY (`username`,`id_area_formacao`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
/*!50100 PARTITION BY RANGE (id_area_formacao)
(PARTITION p0 VALUES LESS THAN (26) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (41) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (51) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (76) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN (101) ENGINE = InnoDB,
 PARTITION p5 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
