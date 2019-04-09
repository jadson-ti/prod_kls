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

-- Copiando estrutura para tabela prod_kls.mdl_facetoface
CREATE TABLE IF NOT EXISTS `mdl_facetoface` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `course` bigint(10) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `intro` longtext,
  `introformat` tinyint(2) NOT NULL DEFAULT '0',
  `thirdparty` varchar(255) DEFAULT NULL,
  `thirdpartywaitlist` tinyint(1) NOT NULL DEFAULT '0',
  `display` bigint(10) NOT NULL DEFAULT '0',
  `confirmationsubject` longtext,
  `confirmationinstrmngr` longtext,
  `confirmationmessage` longtext,
  `waitlistedsubject` longtext,
  `waitlistedmessage` longtext,
  `cancellationsubject` longtext,
  `cancellationinstrmngr` longtext,
  `cancellationmessage` longtext,
  `remindersubject` longtext,
  `reminderinstrmngr` longtext,
  `remindermessage` longtext,
  `reminderperiod` bigint(10) NOT NULL DEFAULT '0',
  `requestsubject` longtext,
  `requestinstrmngr` longtext,
  `requestmessage` longtext,
  `timecreated` bigint(20) NOT NULL DEFAULT '0',
  `timemodified` bigint(20) NOT NULL DEFAULT '0',
  `shortname` varchar(32) DEFAULT NULL,
  `showoncalendar` tinyint(1) NOT NULL DEFAULT '1',
  `approvalreqd` tinyint(1) NOT NULL DEFAULT '0',
  `usercalentry` tinyint(1) NOT NULL DEFAULT '1',
  `allowcancellationsdefault` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `mdl_face_cou_ix` (`course`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Each facetoface activity has an entry here';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
