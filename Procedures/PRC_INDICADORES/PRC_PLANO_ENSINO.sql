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

-- Copiando estrutura para procedure prod_kls.PRC_PLANO_ENSINO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_PLANO_ENSINO`()
BEGIN

DECLARE ID_LOG_               INT(10);
DECLARE CODE_                      VARCHAR(50) DEFAULT 'SUCESSO';
DECLARE MSG_                       VARCHAR(200);
DECLARE REGISTROS_            BIGINT DEFAULT NULL;

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	SET CODE_ = CONCAT('ERRO - ', CODE_);
	ROLLBACK;
END;
 
INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
SELECT database(), 'PRC_PLANO_ENSINO', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
SET group_concat_max_len = 15000;
SET ID_LOG_=LAST_INSERT_ID();





drop table if exists tmp_pde_turmas_prof;

create table tmp_pde_turmas_prof (
	id_turma int,
	teacher_login varchar(200),
	teacher_name varchar(255)
);

 
alter table tmp_pde_turmas_prof add primary key (id_turma);

insert into tmp_pde_turmas_prof (id_turma,teacher_login)
SELECT
t.id_turma as id_turma,
GROUP_CONCAT(DISTINCT p.login ORDER BY p.login ASC SEPARATOR ', ') as teacher
FROM kls_lms_turmas t
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina
JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_curso_disciplina=cd.id_curso_disciplina
JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc AND pt.id_turma=t.id_turma
JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
JOIN kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa
Where
	p.FL_ETL_ATU  REGEXP '[NA]'  and
	t.FL_ETL_ATU  REGEXP '[NA]'  and
	pcd.FL_ETL_ATU   REGEXP '[NA]'  and
	cd.FL_ETL_ATU  REGEXP '[NA]'  and
	d.FL_ETL_ATU  REGEXP '[NA]'  and
	pt.fl_etl_atu  REGEXP '[NA]'  and
	cd.shortname NOT LIKE 'ED%'
GROUP BY t.id_turma ;

 

update tmp_pde_turmas_prof a
join tbl_mdl_user b on a.teacher_login=b.username
set a.teacher_name=concat(b.firstname, ' ',b.lastname);


DROP TABLE IF EXISTS tmp_pde_multiplo_login;

CREATE TABLE tmp_pde_multiplo_login (
	teacher_login VARCHAR(200)
);

ALTER TABLE tmp_pde_multiplo_login ADD PRIMARY KEY (teacher_login);

INSERT INTO tmp_pde_multiplo_login (teacher_login)
SELECT DISTINCT a.teacher_login
FROM tmp_pde_turmas_prof a
where a.teacher_name is null;
 
drop table if exists tmp_pde_multiplo_login_2;
create table tmp_pde_multiplo_login_2 as
select
a.teacher_login,
GROUP_CONCAT(CONCAT(b.firstname, ' ',b.lastname) ORDER BY b.username ASC) AS teacher_name
from tmp_pde_multiplo_login a
join tbl_mdl_user b on find_in_set(b.username,replace(a.teacher_login,' ',''))
GROUP BY a.teacher_login;
 
ALTER TABLE tmp_pde_multiplo_login_2 ADD PRIMARY KEY (teacher_login);
 
update tmp_pde_turmas_prof a
join tmp_pde_multiplo_login_2 b on a.teacher_login=b.teacher_login
set a.teacher_name=b.teacher_name;
 
drop table if exists tmp_pde_multiplo_login;
drop table if exists tmp_pde_multiplo_login_2;
 
 

 
drop table if exists tmp_pde_turmas_coord;
 
create table tmp_pde_turmas_coord (
id_turma int,
coord_login varchar(200),
coord_name varchar(255)
);
 
alter table tmp_pde_turmas_coord add primary key (id_turma);
 
insert into tmp_pde_turmas_coord (id_turma,coord_login)

SELECT
t.id_turma,
GROUP_CONCAT(DISTINCT p.login ORDER BY p.login ASC SEPARATOR ', ') as coord
FROM kls_lms_pessoa p
JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa
JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel='COORDENADOR DE CURSO'
JOIN kls_lms_curso_disciplina cd on cd.id_curso=pc.id_curso
JOIN kls_lms_turmas t on t.id_curso_disciplina=cd.id_curso_disciplina
WHERE p.FL_ETL_ATU  REGEXP '[NA]'  AND pc.FL_ETL_ATU  REGEXP '[NA]'  and t.FL_ETL_ATU  REGEXP '[NA]'  and cd.FL_ETL_ATU  REGEXP '[NA]' 
group by t.id_turma;

 
update tmp_pde_turmas_coord a
join tbl_mdl_user b on a.coord_login=b.username
set a.coord_name=concat(b.firstname, ' ',b.lastname);
 

DROP TABLE IF EXISTS tmp_pde_multiplo_login;

CREATE TABLE tmp_pde_multiplo_login (
	coord_login VARCHAR(200)
);
ALTER TABLE tmp_pde_multiplo_login ADD PRIMARY KEY (coord_login);

 
INSERT INTO tmp_pde_multiplo_login (coord_login)
	SELECT DISTINCT a.coord_login
	FROM tmp_pde_turmas_coord a
	where a.coord_name is null;

drop table if exists tmp_pde_multiplo_login_2;
create table tmp_pde_multiplo_login_2 as
select
a.coord_login,
GROUP_CONCAT(CONCAT(b.firstname, ' ',b.lastname) ORDER BY b.username ASC) AS coord_name
from tmp_pde_multiplo_login a
join tbl_mdl_user b on find_in_set(b.username,replace(a.coord_login,' ',''))
GROUP BY a.coord_login;
 
ALTER TABLE tmp_pde_multiplo_login_2 ADD PRIMARY KEY (coord_login);
 
update tmp_pde_turmas_coord a
join tmp_pde_multiplo_login_2 b on a.coord_login=b.coord_login
set a.coord_name=b.coord_name;
 
drop table if exists tmp_pde_multiplo_login;
drop table if exists tmp_pde_multiplo_login_2;
 

 

drop table if exists tmp_pde_turmas_curso;

 
create table tmp_pde_turmas_curso (
	id_turma int,
	marca varchar(50),
	nome_regional varchar(255),
	codigo_unidade varchar(20),
	nome_unidade varchar(255),
	codigo_curso varchar(255),
	nome_curso varchar(255),
	nome_disciplina varchar(255),
	modelo varchar(150),
	turma varchar(150)
);

 

alter table tmp_pde_turmas_curso add primary key (id_turma);

insert into tmp_pde_turmas_curso (id_turma,marca, nome_regional,codigo_unidade, nome_unidade,codigo_curso, nome_curso,
nome_disciplina, modelo,turma)
SELECT
t.id_turma,
GROUP_CONCAT(DISTINCT i.ds_marca ORDER BY c.nm_curso ASC ) as cd_marca,
GROUP_CONCAT(DISTINCT r.nm_regional ORDER BY c.nm_curso ASC ) as regional,
GROUP_CONCAT(DISTINCT i.cd_instituicao ORDER BY c.nm_curso ASC ) as cd_instituicao,
GROUP_CONCAT(DISTINCT i.nm_ies ORDER BY c.nm_curso ASC ) as nm_ies,
GROUP_CONCAT(DISTINCT c.cd_curso ORDER BY c.nm_curso ASC ) as codigo_curso,
GROUP_CONCAT(DISTINCT c.nm_curso ORDER BY c.nm_curso ASC ) as curso,
GROUP_CONCAT(DISTINCT d.ds_disciplina ORDER BY c.nm_curso ASC ) as disciplina,
GROUP_CONCAT(DISTINCT tm.ds_tipo_disciplina ORDER BY c.nm_curso ASC ) as modelo,
GROUP_CONCAT(DISTINCT CONCAT(t.termo_turma,'-',t.cd_turma) ORDER BY c.nm_curso ASC ) as turma
FROM kls_lms_turmas t
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina
JOIN mdl_course mdlc on mdlc.shortname=cd.shortname
JOIN kls_lms_curso c on c.id_curso=cd.id_curso
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina
JOIN kls_lms_tipo_modelo tm on tm.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies
JOIN kls_lms_regional r on r.id_regional=i.id_regional
WHERE t.FL_ETL_ATU  REGEXP '[NA]'  and cd.FL_ETL_ATU  REGEXP '[NA]'  and d.FL_ETL_ATU  REGEXP '[NA]' 
AND mdlc.shortname NOT LIKE 'ED%'
group by t.id_turma;
 


DROP TABLE IF EXISTS tbl_plano_ensino;

CREATE TABLE tbl_plano_ensino (
Id                              INT,
Regional                      VARCHAR(200),
Marca                         VARCHAR(200),
Instituicao                    VARCHAR(200),
Nome_Instituicao              VARCHAR(200),
Codigo_Curso                        VARCHAR(200),
Nome_Curso                    TEXT,
Disciplina                    VARCHAR(200),
Modelo                        VARCHAR(100),
Professor                     TEXT,
Login_Professor               TEXT,
Coordenador                   TEXT,
Login_Coordenador             TEXT,
Turmas                        TEXT,
Status                                  VARCHAR(100),
CriadoPor                            VARCHAR(100),
CriadoPor_Nome                         VARCHAR(100),
AprovadoPor                         VARCHAR(100),
AprovadoPor_Nome                     VARCHAR(100),
AtualizadoPor                        VARCHAR(100),
AtualizadoPor_Nome                VARCHAR(100)
);


INSERT INTO tbl_plano_ensino
SELECT DISTINCT
todos.id,
todos.nm_regional AS 'Regional',
todos.brandName AS 'Marca',
todos.unit AS 'Instituicao',
todos.businessUnit AS 'Nome_Instituicao',
todos.erpCourseCode AS 'Codigo Curso',
todos.erpCourseName AS 'Nome Curso',
todos.erpDisciplineName AS 'Disciplina',
todos.teachingModel AS 'Modelo',
todos.teacherName AS 'Professor',
todos.teacherLogin AS 'Login_Professor',
todos.CoordName AS 'Coordenador',
todos.CoordLogin AS 'Login_Coordenador',
todos.period AS 'Turmas',
CASE
WHEN todos.status = 'approved' THEN 'Aprovado'
WHEN todos.status = 'in_elaboration' THEN 'Em_Elaboracao'
WHEN todos.status = 'not_created' THEN 'Nao_Iniciado'
WHEN todos.status = 'waiting_for_approval' THEN 'Aguardando_Aprovacao'
WHEN todos.status = 'reproved' THEN 'Reprovado'
WHEN todos.status = 'waiting_for_elaboration' THEN 'Aguardando por Elaboração'
WHEN todos.status = 'not_created' THEN 'Nao_cadastrado'
END AS 'Status',
who_created,
concat(ua.firstname,' ',ua.lastname),
who_approved,
concat(ub.firstname,' ',ub.lastname),
who_updated,
concat(uc.firstname,' ',uc.lastname)
FROM (


 
	SELECT
	tp.id AS id,
	tmpt.nome_regional as nm_regional,
	tmpt.marca as brandName,
	tmpt.codigo_unidade as unit,
	tmpt.nome_unidade as businessUnit,
	GROUP_CONCAT(DISTINCT tmpt.codigo_curso ORDER BY t.id_turma SEPARATOR ', ') as erpCourseCode,
	GROUP_CONCAT(DISTINCT tmpt.nome_curso ORDER BY t.id_turma) as erpCourseName,
	GROUP_CONCAT(DISTINCT tmpt.nome_disciplina ORDER BY t.id_turma) as erpDisciplineName,
	GROUP_CONCAT(DISTINCT tmpt.modelo ORDER BY t.id_turma) as teachingModel,
	GROUP_CONCAT(DISTINCT tmp.teacher_name ORDER BY t.id_turma) as teacherName,
	GROUP_CONCAT(DISTINCT tmp.teacher_login ORDER BY t.id_turma) as teacherLogin,
	GROUP_CONCAT(DISTINCT tmpc.coord_name ORDER BY t.id_turma) as CoordName,
	GROUP_CONCAT(DISTINCT tmpc.coord_login ORDER BY t.id_turma) as CoordLogin,
	GROUP_CONCAT(DISTINCT tmpt.turma ORDER BY t.id_turma) as period,
	tp.status,
	tp.who_created,
	tp.who_approved,
	tp.who_updated
	FROM mdl_teaching_plan tp
	JOIN mdl_teaching_plan_class tpcl ON tpcl.tp_id = tp.id
	JOIN kls_lms_turmas t ON t.id_turma = tpcl.erp_class_id
	JOIN tmp_pde_turmas_curso tmpt on tmpt.id_turma=t.id_turma
	LEFT JOIN tmp_pde_turmas_prof tmp on tmp.id_turma=t.id_turma
	LEFT JOIN tmp_pde_turmas_coord tmpc on tmpc.id_turma=t.id_turma
	WHERE
	tp.active = 'yes' AND t.FL_ETL_ATU  REGEXP '[NA]' 
	GROUP BY tp.id

) todos
LEFT JOIN tbl_mdl_user ua on ua.username=todos.who_created
LEFT JOIN tbl_mdl_user ub on ub.username=todos.who_approved
LEFT JOIN tbl_mdl_user uc on uc.username=todos.who_updated;

 
UPDATE tbl_prc_log pl
SET pl.FIM = sysdate(),
pl.`STATUS` = CODE_,
pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_plano_ensino)),
pl.INFO = MSG_
WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
