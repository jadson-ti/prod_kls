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

-- Copiando estrutura para procedure prod_kls.PRC_RECOVER_KLS_BKP
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RECOVER_KLS_BKP`()
BEGIN

set foreign_key_checks=0;

truncate table kls_lms_instituicao;
truncate table kls_lms_curso;
truncate table kls_lms_disciplina;
truncate table kls_lms_curso_disciplina;
truncate table kls_lms_turmas;
truncate table kls_lms_pessoa;
truncate table kls_lms_pessoa_curso;
truncate table kls_lms_pessoa_curso_disc;
truncate table kls_lms_pessoa_turma;



insert into kls_lms_instituicao select * from bkp_lms_instituicao;
insert into kls_lms_curso select * from bkp_lms_curso;
insert into kls_lms_disciplina select * from bkp_lms_disciplina;
insert into kls_lms_curso_disciplina select * from bkp_lms_curso_disciplina;
insert into kls_lms_turmas select * from bkp_lms_turmas;
insert into kls_lms_pessoa select * from bkp_lms_pessoa;
insert into kls_lms_pessoa_curso select * from bkp_lms_pessoa_curso;
insert into kls_lms_pessoa_curso_disc select * from bkp_lms_pessoa_curso_disc;
insert into kls_lms_pessoa_turma select * from bkp_lms_pessoa_turma;

set foreign_key_checks=1;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
