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

-- Copiando estrutura para tabela prod_kls.mdl_attendancelist_report
CREATE TABLE IF NOT EXISTS `mdl_attendancelist_report` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `userid` bigint(11) NOT NULL,
  `courseid` bigint(11) NOT NULL,
  `categoryid` bigint(11) NOT NULL,
  `attendancelistid` bigint(11) NOT NULL,
  `groupid` bigint(11) NOT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `lastname` varchar(255) NOT NULL DEFAULT '',
  `name_tutor` varchar(255) NOT NULL DEFAULT '',
  `name_course` varchar(255) NOT NULL DEFAULT '',
  `name_category` varchar(255) NOT NULL DEFAULT '',
  `name_group` varchar(255) DEFAULT NULL,
  `name_attendancelist` varchar(255) NOT NULL DEFAULT '',
  `period1` tinyint(1) DEFAULT NULL,
  `period2` tinyint(1) DEFAULT NULL,
  `period3` tinyint(1) DEFAULT NULL,
  `period4` tinyint(1) DEFAULT NULL,
  `timemodified` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_atterepo_att_ix` (`attendancelistid`),
  KEY `mdl_atterepo_use_ix` (`userid`),
  KEY `mdl_atterepo_cou_ix` (`courseid`),
  KEY `mdl_atterepo_cat_ix` (`categoryid`),
  KEY `mdl_atterepo_usecou_ix` (`userid`,`courseid`),
  KEY `mdl_atterepo_usecoucat_ix` (`userid`,`courseid`,`categoryid`),
  KEY `mdl_atterepo_use2_ix` (`username`),
  KEY `mdl_atterepo_ins_ix` (`institution`),
  KEY `mdl_atterepo_gro_ix` (`groupid`),
  KEY `mdl_atterepo_inscou_ix` (`institution`,`courseid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='attendancelist_report table retrofitted from MySQL';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
