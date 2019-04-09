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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MYRATING
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MYRATING`()
BEGIN
drop table if exists rel_myrating;
create table rel_myrating as
SELECT DISTINCT
i.cd_instituicao as cod_unidade,
i.nm_ies AS nome_unidade,
cc.name as nome_categoria,
c.shortname as cod_disciplina,
c.fullname as nome_disciplina,
u.username as login_aluno,
concat(u.firstname, ' ', u.lastname) as nome_aluno,
u.email as email_aluno,
case
when r.shortname  = 'student' then 'Aluno'
when r.shortname  = 'editingteacher' then 'Professor'
else r.shortname
end as perfil_pessoa,
COALESCE(r1.name,r2.name, r3.name,r4.name, r5.name) as nome_conteudo,
m.name as tipo_material,
ms.subject as assunto,
ml.comment as descricao,
CASE
WHEN ml.rating=1 THEN 'Totalmente Insatisfeito'
WHEN ml.rating=2 THEN 'Insatisfeito'
WHEN ml.rating=3 THEN 'Parcialmente Satisfeito'
WHEN ml.rating=4 THEN 'Satisfeito'
WHEN ml.rating=5 THEN 'Totalmente Satisfeito'
end as nota,
from_unixtime(ml.timecreated -10800) as data_avaliacao
FROM mdl_myrating_log ml
LEFT JOIN mdl_myrating_subjects ms on ms.id=ml.subject
JOIN mdl_course_modules cm on cm.id=ml.coursemodule
JOIN mdl_modules m on m.id=cm.module and m.name in ('quiz','assign','url', 'activityvideo', 'unitygame')
JOIN mdl_course c on c.id=cm.course
JOIN mdl_course_categories cc on cc.id=c.category
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_role_assignments ra on ra.userid=ml.userid and ra.contextid=co.id
JOIN mdl_role r on r.id=ra.roleid
JOIN tbl_mdl_user u on u.id=ml.userid
JOIN kls_lms_pessoa p on p.login=u.username and p.fl_etl_atu<>'E'
JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa AND pcd.fl_etl_atu<>'E'
JOIN kls_lms_curso_disciplina cd on cd.shortname=c.shortname and cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.fl_etl_atu<>'E'
JOIN kls_lms_curso klsc on klsc.id_curso=cd.id_curso and klsc.fl_etl_atu<>'E'
JOIN kls_lms_instituicao i on i.id_ies=klsc.id_ies and i.fl_etl_atu<>'E'
LEFT JOIN mdl_assign r1 on r1.id=cm.instance and m.name='assign'
LEFT JOIN mdl_quiz r2 on r2.id=cm.instance and m.name='quiz'
LEFT JOIN mdl_url r3 on r3.id=cm.instance and m.name='url'
LEFT JOIN mdl_activityvideo r4 on r4.id = cm.instance and  m.name ='activityvideo'
LEFT JOIN mdl_unitygame r5 on r5.id = cm.instance and m.name = 'unitygame';
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
