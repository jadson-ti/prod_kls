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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG_TUTOR
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG_TUTOR`()
BEGIN
drop table if exists tbl_rel_mensagens;

create table tbl_rel_mensagens (
	userid bigint(10),
	username varchar(100),
	tutor varchar(200),
	curso_id bigint(10),
	curso varchar(255),
	qtd_alunos int(11),
	qtd_dias_acessados int(11),
	mensagens_recebidas int(11),
	mensagens_respondidas int(11),
	taxa_resposta decimal(4,2),
	taxa_nao_resposta decimal(4,2),
	respondida_24_h int(11),
	sla_resposta int(11),
	per_resp_24_h decimal(4,2),
	tempo_medio_resposta time
);	

ALTER TABLE tbl_rel_mensagens ADD PRIMARY KEY (userid, curso_id);		

INSERT INTO tbl_rel_mensagens
SELECT
	distinct 
	u.id as userid,
	u.username,
	concat(u.firstname, ' ', u.lastname) as tutor,
	c.id as curso_id,
	c.fullname as curso,
	0 as qtd_alunos,
	0 as qtd_dias_acessados,
	0 as mensagens_recebidas,
	0 as mensagens_respondidas,
	0 as taxa_resposta,
   0 as taxa_nao_resposta,
   0 as respondida_24_h,
   0 as sla_resposta,
   0 as perc_resp_24_h,
   0 as tempo_medio_resposta
from tbl_mdl_user u
join mdl_role_assignments ra on ra.userid=u.id 
join mdl_role r on r.id=ra.roleid and r.shortname = 'tutor'
join mdl_context co on co.id=ra.contextid
join mdl_course c on c.id=co.instanceid
where c.id>1;


drop table if exists tmp_qtd_alunos;
create table tmp_qtd_alunos as 
select 
	t.userid, t.username, t.curso_id, count(distinct anh.username) as alunos
from tbl_rel_mensagens t
join anh_aluno_matricula anh on anh.TUTOR=t.username 
join mdl_course c on c.shortname=anh.shortname and c.id=t.curso_id
group by t.userid, t.username, t.curso_id;

update tbl_rel_mensagens t 
join tmp_qtd_alunos b on t.userid=b.userid and t.curso_id=b.curso_id
set t.qtd_alunos=b.alunos;

drop table if exists tmp_qtd_alunos;




drop table if exists tmp_dias_acessados;

create table tmp_dias_acessados as 
select 
	t.userid, t.curso_id, count(distinct date_format(from_unixtime(l.DT),'%d/%m/%Y')) as dias_acessados
from tbl_rel_mensagens t
join mdl_role_assignments ra on ra.userid=t.userid 
join mdl_role r on r.id=ra.roleid and r.shortname='tutor'
join mdl_context co on co.id=ra.contextid 
join mdl_course c on c.id=co.instanceid
join tbl_log_usr_cur_mdl l on l.USERID=t.userid and l.COURSE=c.id
group by t.userid, t.curso_id;

update tbl_rel_mensagens t 
join tmp_dias_acessados b on t.userid=b.userid and t.curso_id=b.curso_id
set t.qtd_dias_acessados=b.dias_acessados;

drop table if exists tmp_dias_acessados;



drop table if exists tmp_mensagens_recebidas;

create table tmp_mensagens_recebidas as 
select 
	t.userid, t.curso_id, count(distinct m.messageid) as mensagens
from tbl_rel_mensagens t
join mdl_local_mail_message_users m on t.userid=m.userid and m.role='to' 
join mdl_local_mail_messages lm on lm.id=m.messageid 
join mdl_course c on c.id=lm.courseid
group by t.userid, t.curso_id;

update tbl_rel_mensagens t 
join tmp_mensagens_recebidas b on t.userid=b.userid and t.curso_id=b.curso_id
set t.mensagens_recebidas=b.mensagens;

drop table if exists tmp_mensagens_recebidas;



drop table if exists tmp_mensagens_respondidas;

create table tmp_mensagens_respondidas as 
select 
	t.userid, t.curso_id, count(distinct m2.messageid) as mensagens_respondidas
from tbl_rel_mensagens t
join mdl_local_mail_message_users m on t.userid=m.userid and m.role='to' 
join mdl_local_mail_messages lm on lm.id=m.messageid 
join mdl_course c on c.id=lm.courseid
join mdl_local_mail_message_users m2 on t.userid=m2.id_from
join mdl_local_mail_message_refs ref on ref.messageid=m.messageid and ref.reference=m2.messageid
group by t.userid, t.curso_id;

update tbl_rel_mensagens t 
join tmp_mensagens_respondidas b on t.userid=b.userid and t.curso_id=b.curso_id
set t.mensagens_respondidas=b.mensagens_respondidas;

drop table if exists tmp_mensagens_respondidas;


update tbl_rel_mensagens set taxa_resposta=mensagens_respondidas/mensagens_recebidas;
update tbl_rel_mensagens set taxa_nao_resposta=1-taxa_resposta;



drop table if exists tmp_tempo_24h;

create table tmp_tempo_24h as
select userid, curso_id, count(1) as qtd, sec_to_time(floor(avg(tempo))) as media from (
select distinct
	lm.id, t.userid, t.curso_id, 
	@envio:=lm.time, 
	@resposta:=(
		select time
		from mdl_local_mail_messages a
		where id = (select min(messageid) from mdl_local_mail_message_refs where reference=lm.id)
	) as resposta,
	@resposta-@envio as tempo,
	case when @resposta-@envio<86400 then 'menos' else 'mais' end as '24h'
from tbl_rel_mensagens t
join mdl_local_mail_message_users m on t.userid=m.userid and m.role='to' 
join mdl_local_mail_messages lm on lm.id=m.messageid 
join mdl_course c on c.id=lm.courseid
) a 
where a.resposta is not null and 24h='menos'
group by userid, curso_id;

update tbl_rel_mensagens t 
join tmp_tempo_24h b on t.userid=b.userid and t.curso_id=b.curso_id
set t.respondida_24_h=b.qtd;

update tbl_rel_mensagens t 
join tmp_tempo_24h b on t.userid=b.userid and t.curso_id=b.curso_id
set t.tempo_medio_resposta=b.media;

drop table if exists tmp_tempo_24h;


update tbl_rel_mensagens set per_resp_24_h=respondida_24_h/mensagens_respondidas;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
