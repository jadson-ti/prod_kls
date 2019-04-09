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

-- Copiando estrutura para procedure prod_kls.PRC_AJUSTE_SUBMISSAO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AJUSTE_SUBMISSAO`()
BEGIN

Drop table if exists tmp_asuupd;
create temporary table tmp_asuupd (id bigint(10));
alter table tmp_asuupd add primary key (id);

insert into tmp_asuupd
select distinct asu.id
from mdl_course co
join mdl_assign a on a.course = co.id
join mdl_assign_submission asu on asu.assignment = a.id
join mdl_user u on u.id = asu.userid
left join mdl_assign_grades ag on ag.assignment = a.id and ag.userid = u.id
where asu.latest = 0
and not exists (select distinct asu1.userid
                    from  mdl_assign a1
                    join mdl_assign_submission asu1 on asu1.assignment = a1.id 
                    where a1.id = a.id
                    and asu1.userid = asu.userid
                    and asu1.attemptnumber > asu.attemptnumber);

update mdl_assign_submission a
join tmp_asuupd b on a.id=b.id
set a.latest=1;

drop table if exists tmp_maxatp;
create temporary table tmp_maxatp (
	userid bigint(10),
	assignment bigint(10),
	attemptnumber bigint(10)
);
alter table tmp_maxatp add index idx_ua (userid, assignment);
insert into tmp_maxatp
select userid, assignment, max(attemptnumber)
from mdl_assign_submission 
group by userid, assignment
having sum(latest)>1;
update mdl_assign_submission a
join tmp_maxatp b on a.userid=b.userid and a.assignment=b.assignment and a.attemptnumber<b.attemptnumber
set a.latest=0;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
