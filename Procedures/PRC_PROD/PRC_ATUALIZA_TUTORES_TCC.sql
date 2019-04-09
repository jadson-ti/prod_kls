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

-- Copiando estrutura para procedure prod_kls.PRC_ATUALIZA_TUTORES_TCC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ATUALIZA_TUTORES_TCC`()
BEGIN
 
TRUNCATE TABLE anh_tutores_tcc_201602;

 
INSERT INTO anh_tutores_tcc_201602 (
unidade, aluno, nome_aluno, id_tutor, nome_tutor, email_tutor, alocado
)
SELECT
unidade,
username as aluno,
nome_aluno,
ID_USUARIO_ID as id_tutor,
tutor as nome_tutor,
EMAIL AS email_tutor,
0 as alocado
FROM (
SELECT distinct
CU.shortname,
U.username,
sgtum.ID_USUARIO_ID,
sgtu.NOME as tutor,
sgtu.EMAIL,
UPPER(concat(U.firstname, ' ' , U.lastname)) as nome_aluno,
U.institution as unidade,
t.NOTA,
case
when (CU.shortname like 'tccv1/2%' or CU.shortname like 'tccv2/3%' or CU.shortname like 'tccv1/3%') then 'reservar'
when ((t.CD_INSTITUICAO like 'olim%' or t.CD_INSTITUICAO like 'fama%')
and ((CU.shortname like 'tccv2/2%' or CU.shortname like 'tccv3/3%' or CU.shortname like 'tccvu%'))
and t.NOTA < 7) then 'Reservar'
when (t.CD_INSTITUICAO not like 'olim%'
and t.CD_INSTITUICAO not like 'fama%'
and ((CU.shortname like 'tccv2/2%' or CU.shortname like 'tccv3/3%' or CU.shortname like 'tccvu%'))
and t.NOTA < 6) then 'Reservar'
else 'Não reservar'
end Reservar
FROM mdl_context CO
JOIN mdl_course CU ON CO.instanceid = CU.id AND CO.contextlevel = 50
JOIN mdl_role_assignments RA ON CO.id = RA.contextid and RA.roleid = 5
JOIN mdl_user U ON RA.userid = U.id and U.mnethostid = 1
join tbl_retorno_nt2_tcc t on t.USERNAME = U.username and t.SHORTNAME = CU.shortname
JOIN anh_aluno_matricula PARTITION (TCC) anh ON U.username=anh.username and U.mnethostid=1 and CU.shortname=anh.shortname
join mdl_user ut on ut.username=anh.tutor and ut.mnethostid=1
JOIN SGT_USUARIO_MOODLE sgtum on sgtum.MDL_USER_ID=ut.id
JOIN SGT_USUARIO sgtu ON sgtu.ID=sgtum.ID_USUARIO_ID
where CU.shortname like 'tccv%'
) A
WHERE A.Reservar='Reservar';
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
