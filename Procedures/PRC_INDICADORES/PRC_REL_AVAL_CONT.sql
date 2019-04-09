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

-- Copiando estrutura para procedure prod_kls.PRC_REL_AVAL_CONT
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_AVAL_CONT`()
BEGIN

drop table if exists rel_avaliacao_continuada;

create table rel_avaliacao_continuada (
	username varchar(50),
	nome varchar(255),
	shortname varchar(50),
	disciplina varchar(150),
	secao varchar(50),
	tipo_avaliacao varchar(10),
	qtd int(11)
);

insert into rel_avaliacao_continuada
select
	u.username,
	concat(u.firstname,' ',u.lastname) as nome,
	c.shortname,
	c.fullname as disciplina,
	cs.name as secao,
	t.tipo_avaliacao,
	count(distinct q.id)
from anh_aluno_matricula partition (ami) ami
join tbl_mdl_user u on u.username=ami.username
join tbl_mdl_course c on c.shortname=ami.shortname
join mdl_course_sections cs on cs.course=c.id and cs.section>0 
join mdl_course_modules cm on cm.section=cs.id 
join mdl_modules m on m.id=cm.module and m.name='quiz'
join mdl_quiz q on q.id=cm.instance
join tbl_quiz_grades qg on qg.userid=u.id and qg.quiz=q.id
join kls_lms_pessoa_turma pt on pt.id_pes_turma_disciplina=ami.ID_PESSOA_TURMA
join kls_lms_turmas t on t.id_turma=pt.id_turma and t.shortname=ami.grupo
group by u.id, cs.id;


insert into rel_avaliacao_continuada
select
	u.username,
	concat(u.firstname,' ',u.lastname) as nome,
	c.shortname,
	c.fullname as disciplina,
	cs.name as secao,
	t.tipo_avaliacao,
	count(distinct q.id)
from anh_aluno_matricula partition (amp) ami
join tbl_mdl_user u on u.username=ami.username
join tbl_mdl_course c on c.shortname=ami.shortname
join mdl_course_sections cs on cs.course=c.id and cs.section>0 
join mdl_course_modules cm on cm.section=cs.id 
join mdl_modules m on m.id=cm.module and m.name='quiz'
join mdl_quiz q on q.id=cm.instance
join tbl_quiz_grades qg on qg.userid=u.id and qg.quiz=q.id
join kls_lms_pessoa_turma pt on pt.id_pes_turma_disciplina=ami.ID_PESSOA_TURMA
join kls_lms_turmas t on t.id_turma=pt.id_turma and t.shortname=ami.grupo
group by u.id, cs.id;


drop table if exists rel_avaliacao_cont_181;

create table rel_avaliacao_cont_181 (
	username varchar(50),
	nome varchar(255),
	shortname varchar(50),
	disciplina varchar(150),
	secao varchar(50),
	tipo_avaliacao varchar(10),
	qtd int(11)
);

insert into rel_avaliacao_cont_181
select
	u.username,
	concat(u.firstname,' ',u.lastname) as nome,
	c.shortname,
	c.fullname as disciplina,
	cs.name as secao,
	t.tipo_avaliacao,
	count(distinct q.id)
from anh_aluno_matricula partition (ami) ami
join tbl_mdl_user u on u.username=ami.username
join tbl_mdl_course c on c.shortname=ami.shortname
join mdl_course_sections cs on cs.course=c.id and cs.section>0 
join mdl_course_modules cm on cm.section=cs.id 
join mdl_modules m on m.id=cm.module and m.name='quiz'
join mdl_quiz q on q.id=cm.instance
join tbl_quiz_grades qg on qg.userid=u.id and qg.quiz=q.id
join kls_lms_pessoa_turma pt on pt.id_pes_turma_disciplina=ami.ID_PESSOA_TURMA
join kls_lms_turmas t on t.id_turma=pt.id_turma and t.shortname=ami.grupo 
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina 
where 
	cd.cd_curriculo='20181' and
	t.termo_turma='1º semestre' and
	qg.timemodified<from_unixtime('2018-02-24')
group by u.id, cs.id;


insert into rel_avaliacao_cont_181
select
	u.username,
	concat(u.firstname,' ',u.lastname) as nome,
	c.shortname,
	c.fullname as disciplina,
	cs.name as secao,
	t.tipo_avaliacao,
	count(distinct q.id)
from anh_aluno_matricula partition (amp) ami
join tbl_mdl_user u on u.username=ami.username
join tbl_mdl_course c on c.shortname=ami.shortname
join mdl_course_sections cs on cs.course=c.id and cs.section>0 
join mdl_course_modules cm on cm.section=cs.id 
join mdl_modules m on m.id=cm.module and m.name='quiz'
join mdl_quiz q on q.id=cm.instance
join tbl_quiz_grades qg on qg.userid=u.id and qg.quiz=q.id
join kls_lms_pessoa_turma pt on pt.id_pes_turma_disciplina=ami.ID_PESSOA_TURMA
join kls_lms_turmas t on t.id_turma=pt.id_turma and t.shortname=ami.grupo
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina 
where 
	cd.cd_curriculo='20181' and
	t.termo_turma='1º semestre' and
	qg.timemodified<from_unixtime('2018-02-24')
group by u.id, cs.id;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
