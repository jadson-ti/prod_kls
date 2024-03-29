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

-- Copiando estrutura para tabela prod_kls.anh_academico_matricula
CREATE TABLE IF NOT EXISTS `anh_academico_matricula` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_MATRICULA_ATUAL` int(11) NOT NULL,
  `ID_PESSOA_CURSO` int(11) NOT NULL DEFAULT '0',
  `ID_PES_CUR_DISC` int(11) NOT NULL DEFAULT '0',
  `ID_PESSOA_TURMA` int(11) NOT NULL DEFAULT '0',
  `UNIDADE` varchar(20) DEFAULT NULL,
  `CURSO` varchar(20) DEFAULT NULL,
  `USERNAME` varchar(50) NOT NULL,
  `SHORTNAME` varchar(50) NOT NULL,
  `ROLE` varchar(50) NOT NULL,
  `GRUPO` varchar(50) NOT NULL,
  `DATA_MATRICULA` date NOT NULL,
  `ORIGEM` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `SIGLA` varchar(5) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`,`SIGLA`),
  KEY `idx_academico_shortname` (`SHORTNAME`,`GRUPO`),
  KEY `idx_academico_user` (`USERNAME`),
  KEY `idx_grupo` (`GRUPO`),
  KEY `idx_academico_user_group` (`USERNAME`,`SHORTNAME`,`GRUPO`)
) ENGINE=InnoDB AUTO_INCREMENT=1150292 DEFAULT CHARSET=utf8
/*!50500 PARTITION BY LIST  COLUMNS(SIGLA)
(PARTITION DI VALUES IN ('DI') ENGINE = InnoDB,
 PARTITION KLS VALUES IN ('KLS') ENGINE = InnoDB,
 PARTITION AMI VALUES IN ('AMI') ENGINE = InnoDB,
 PARTITION AMP VALUES IN ('AMP') ENGINE = InnoDB,
 PARTITION TUT VALUES IN ('TUT') ENGINE = InnoDB,
 PARTITION DIP VALUES IN ('DIP') ENGINE = InnoDB,
 PARTITION DIBP VALUES IN ('DIBP') ENGINE = InnoDB,
 PARTITION NPJP VALUES IN ('NPJP') ENGINE = InnoDB,
 PARTITION ESTP VALUES IN ('ESTP') ENGINE = InnoDB,
 PARTITION TCCP VALUES IN ('TCCP') ENGINE = InnoDB,
 PARTITION EDP VALUES IN ('EDP') ENGINE = InnoDB,
 PARTITION SCD VALUES IN ('SCD') ENGINE = InnoDB,
 PARTITION SPF VALUES IN ('SPF') ENGINE = InnoDB,
 PARTITION HAMPP VALUES IN ('HAMPP') ENGINE = InnoDB,
 PARTITION HIBV VALUES IN ('HIBV') ENGINE = InnoDB,
 PARTITION HAMIP VALUES IN ('HAMIP') ENGINE = InnoDB) */;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
