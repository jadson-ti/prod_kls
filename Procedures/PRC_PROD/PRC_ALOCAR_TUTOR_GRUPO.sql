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

-- Copiando estrutura para procedure prod_kls.PRC_ALOCAR_TUTOR_GRUPO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ALOCAR_TUTOR_GRUPO`()
BEGIN



drop table if exists tmp_tutores_grupos;

create table tmp_tutores_grupos as
select distinct tutor, shortname, grupo
from anh_aluno_matricula partition (ed)
where tutor is not null
union
select distinct tutor, shortname, grupo
from anh_aluno_matricula partition (di)
where tutor is not null;

alter table tmp_tutores_grupos add index idx_tutor (tutor);

INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid)
select distinct r.id, co.id, u.id, unix_timestamp(now()), 1
from tmp_tutores_grupos t
join tbl_mdl_user u on u.username=t.tutor
join mdl_course c on c.shortname=t.shortname
join mdl_context co on co.instanceid=c.id and co.contextlevel=50
join mdl_groups g on g.courseid=c.id and g.name=t.grupo
join mdl_role r on r.shortname='tutor'
left join mdl_role_assignments ra on ra.userid=u.id and ra.contextid=co.id and ra.roleid=r.id
where ra.id is null;


INSERT INTO mdl_user_enrolments(status, enrolid, userid, timestart, timecreated, timemodified, timeend, modifierid)
SELECT distinct '0', e.id, u.id, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 1
from tmp_tutores_grupos t
join tbl_mdl_user u on u.username=t.tutor
join mdl_course c on c.shortname=t.shortname
join mdl_role r on r.shortname='tutor'
join mdl_enrol e on e.enrol='manual' and e.courseid=c.id and e.roleid=r.id
join mdl_groups g on g.courseid=c.id and g.name=t.grupo
left join mdl_user_enrolments ue on ue.userid=u.id and ue.enrolid=e.id
where ue.id is null;

INSERT INTO mdl_groups_members (userid, groupid, timeadded)
select distinct u.id, g.id, unix_timestamp()
from tmp_tutores_grupos t
join tbl_mdl_user u on u.username=t.tutor
join mdl_course c on c.shortname=t.shortname
join mdl_groups g on g.courseid=c.id and g.name=t.grupo
left join mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
where gm.id is null;

drop table if exists tmp_tutores_grupos;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
