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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG_TUTOR_CONS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG_TUTOR_CONS`()
BEGIN

drop table if exists tbl_rel_mensagens_tutor;

create table tbl_rel_mensagens_tutor (
	userid bigint(10),
	username varchar(100),
	tutor varchar(200),
	mensagens_recebidas int(11),
	mensagens_respondidas int(11),
	mensagens_enviadas int(11)
	
);	

ALTER TABLE tbl_rel_mensagens_tutor ADD PRIMARY KEY (userid);		

INSERT INTO tbl_rel_mensagens_tutor
SELECT
	distinct 
	u.id as userid,
	u.username,
	concat(u.firstname, ' ', u.lastname) as tutor,
	0 as mensagens_recebidas,
	0 as mensagens_respondidas,
	0 as mensagens_enviadas
from tbl_mdl_user u
join mdl_role_assignments ra on ra.userid=u.id 
join mdl_role r on r.id=ra.roleid and r.shortname = 'tutor'
join mdl_context co on co.id=ra.contextid
join mdl_course c on c.id=co.instanceid
where c.id>1;



drop table if exists tmp_mensagens_recebidas;

create table tmp_mensagens_recebidas as 
select 
	t.userid,  count(distinct me.id) as mensagens
from tbl_rel_mensagens_tutor t
join mdl_local_mail_message_users m on t.userid=m.userid and m.role='to' 
join mdl_local_mail_messages me on m.messageid = me.id
join tbl_mdl_user u on u.id = m.id_from
where u.username not like 'p%'
and me.`status` = 1
group by t.userid;

update tbl_rel_mensagens_tutor t 
join tmp_mensagens_recebidas b on t.userid=b.userid 
set t.mensagens_recebidas=b.mensagens;

drop table if exists tmp_mensagens_recebidas;



drop table if exists tmp_mensagens_respondidas;

create table tmp_mensagens_respondidas as 
select 
	t.userid, count(distinct m.messageid) as mensagens_respondidas
from tbl_rel_mensagens_tutor t
join mdl_local_mail_message_users m on t.userid = m.id_from
join mdl_local_mail_messages me on me.id= m.messageid
join mdl_local_mail_message_refs mr on  mr.messageid = m.messageid
join tbl_mdl_user u on u.id = m.userid
where m.role='to'
and u.username not like 'p%'
and me.draft = 0
group by t.userid;


update tbl_rel_mensagens_tutor t 
join tmp_mensagens_respondidas b on t.userid=b.userid 
set t.mensagens_respondidas=b.mensagens_respondidas;

drop table if exists tmp_mensagens_respondidas;



drop table if exists tmp_mensagens_enviadas;

create table tmp_mensagens_enviadas as 
select 
	t.userid,  count(distinct me.id) as mensagens_enviadas
from tbl_rel_mensagens_tutor t
join mdl_local_mail_message_users m on t.userid=m.userid and m.role='from' 
join mdl_local_mail_messages me on me.id= m.messageid
left join mdl_local_mail_message_refs mr on mr.messageid = m.messageid
join tbl_mdl_user u on u.id = m.userid
where u.username not like 'p%'
and mr.id is null
and me.draft = 0
group by t.userid;

update tbl_rel_mensagens_tutor t 
join tmp_mensagens_enviadas b on t.userid=b.userid 
set t.mensagens_enviadas=b.mensagens_enviadas;

drop table if exists tmp_mensagens_enviadas;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
