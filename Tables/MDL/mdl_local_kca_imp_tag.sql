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

-- Copiando estrutura para tabela prod_kls.mdl_local_kca_imp_tag
CREATE TABLE IF NOT EXISTS `mdl_local_kca_imp_tag` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `userid` bigint(10) NOT NULL,
  `cd_instituicao` varchar(15) NOT NULL DEFAULT '',
  `cd_disciplina` varchar(30) NOT NULL DEFAULT '',
  `cd_turma` varchar(30) NOT NULL DEFAULT '',
  `messageid` varchar(45) NOT NULL DEFAULT '',
  `input` varchar(10) NOT NULL DEFAULT '',
  `tipo_avaliacao` varchar(2) NOT NULL DEFAULT '',
  `sent_date` varchar(45) DEFAULT NULL,
  `timecreated` bigint(18) NOT NULL,
  `timemodified` bigint(18) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mdl_locakcaimptag_cd__ix` (`cd_instituicao`),
  KEY `mdl_locakcaimptag_cd_2_ix` (`cd_disciplina`),
  KEY `mdl_locakcaimptag_cd_3_ix` (`cd_turma`),
  KEY `mdl_locakcaimptag_mes_ix` (`messageid`),
  KEY `mdl_locakcaimptag_inp_ix` (`input`),
  KEY `mdl_locakcaimptag_tip_ix` (`tipo_avaliacao`),
  KEY `mdl_locakcaimptag_use_ix` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=859711 DEFAULT CHARSET=utf8 COMMENT='Define local/kcontinuousevaluation/subplugin/import/tag tabl';

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
