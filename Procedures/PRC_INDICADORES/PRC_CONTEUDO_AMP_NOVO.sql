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

-- Copiando estrutura para procedure prod_kls.PRC_CONTEUDO_AMP_NOVO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CONTEUDO_AMP_NOVO`()
BEGIN

	DECLARE ID_LOG_       INT(10);
	DECLARE CODE_         VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_          VARCHAR(200);
	DECLARE REGISTROS_    BIGINT DEFAULT NULL;
	

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN

		GET DIAGNOSTICS CONDITION 1
		CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;

		SET CODE_ = CONCAT('ERRO - ', CODE_);

	END;


	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_MATERIAL_COMP_AMP', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

	SET ID_LOG_=LAST_INSERT_ID();	

DROP TABLE IF EXISTS tbl_conteudo_amp_novo;
CREATE TABLE tbl_conteudo_amp_novo (
	REGIONAL VARCHAR(50),
	CODIGO_UNIDADE VARCHAR(15),
	INSTITUICAO VARCHAR(255),
	PROFESSOR VARCHAR(1000),
	COORDENADOR VARCHAR(1000),
	CODIGO_CURSO VARCHAR(20),
	NOME_CURSO VARCHAR(255),
	CODIGO_TURMA VARCHAR(100),
	SERIE_TURMA VARCHAR(15),
	CODIGO_DISCIPLINA VARCHAR(30),
	NOME_DISCIPLINA VARCHAR(255),
	SHORTNAME VARCHAR(50),
	GRUPO VARCHAR(255),
	ENCONTRO INT(11),
	QTD_CONTEUDO INT(11),
	CARGA_HORARIA INT(11),
	PRI_ACESSO_PR VARCHAR(30),
	ULT_ACESSO_PR VARCHAR(30),
	PRI_ACESSO_CD VARCHAR(30),
	ULT_ACESSO_CD VARCHAR(30)
);	

INSERT INTO tbl_conteudo_amp_novo 
select distinct
			r.nm_regional AS REGIONAL,
			i.cd_instituicao AS COD_INST,
			i.nm_ies AS NOME_INST,
			(
				SELECT DISTINCT GROUP_CONCAT(DISTINCT nm_pessoa)
				FROM kls_lms_pessoa p1 
				JOIN kls_lms_pessoa_curso_disc pcd1 on pcd1.id_pessoa=p1.id_pessoa and pcd1.fl_etl_atu REGEXP '[NA]'
				JOIN kls_lms_pessoa_turma pt1 on pt1.id_pes_cur_disc=pcd1.id_pes_cur_disc and pt1.fl_etl_atu REGEXP '[NA]'
				JOIN kls_lms_turmas t1 on t1.id_turma=pt1.id_turma 
				JOIN kls_lms_papel pap on pap.id_papel=pcd1.id_papel and pap.ds_papel='PROFESSOR'
				WHERE t1.id_turma=t.id_turma
			) AS PROFESSOR,
			(
				SELECT DISTINCT GROUP_CONCAT(DISTINCT nm_pessoa)
				FROM kls_lms_pessoa p1 
				JOIN kls_lms_pessoa_curso pc1 on pc1.id_pessoa=p1.id_pessoa and pc1.fl_etl_atu REGEXP '[NA]'
				JOIN kls_lms_papel pap on pap.id_papel=pc1.id_papel and pap.ds_papel='COORDENADOR DE CURSO'
				WHERE pc1.id_curso=c.id_curso 
			) AS COORDENADOR,
			c.cd_curso AS COD_CURSO,
			c.nm_curso AS CURSO,
			t.cd_turma AS COD_TURMA,
			t.termo_turma AS SERIE, 
			d.cd_disciplina AS CODIGO_DISCIPLINA,
			mc.fullname as DISCIPLINA,
			mc.shortname,
			g.name,
			cs.section Encontro,
			0 AS QTD_CONTEUDO, 
			cd.carga_horaria AS CARGA_HORARIA,
			NULL,
			NULL,
			NULL,
			NULL
from mdl_course mc 
join mdl_groups g on g.courseid=mc.id 
join mdl_course_sections cs on cs.course=mc.id and cs.section>0
join kls_lms_turmas t on t.fl_etl_atu REGEXP '[NA]' and t.shortname=g.description
join kls_lms_curso_disciplina cd on t.id_curso_disciplina=cd.id_curso_disciplina and cd.shortname=mc.shortname and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
join kls_lms_instituicao i on i.id_ies=c.id_ies  and i.fl_etl_atu REGEXP '[NA]'
join kls_lms_regional r on r.id_regional=i.id_regional
left join anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina)

where cd.shortname REGEXP '^AMP'
and temp.id_disciplina is null 
group by mc.shortname, g.name, cs.section;

alter table tbl_conteudo_amp_novo add primary key (SHORTNAME, CODIGO_TURMA, GRUPO, ENCONTRO);


update tbl_conteudo_amp_novo a
set QTD_CONTEUDO=(
	SELECT COUNT(DISTINCT tc.contentid)
	FROM mdl_course c 
	join mdl_groups g on g.courseid=c.id 
	join mdl_groups_members gm on gm.groupid=g.id
	join mdl_course_sections cs on cs.course=c.id
	join mdl_teacher_class_content tc on tc.courseid=c.id and tc.sectionid=cs.id and tc.groupid=g.id
	WHERE c.shortname=a.shortname and
		   g.name=a.GRUPO and
		   cs.section=a.encontro
);


DROP TABLE IF EXISTS tbl_prof_amp;
	
CREATE TABLE tbl_prof_amp (
professor VARCHAR(500),
shortname VARCHAR(50),
first_access VARCHAR(50),
last_access VARCHAR(50)
);
	
INSERT INTO tbl_prof_amp 
SELECT
p.nm_pessoa,
cd.shortname,
FROM_UNIXTIME(MIN(l.timecreated), '%Y-%m-%d') AS first_access,
FROM_UNIXTIME(MAX(ul.timeaccess), '%Y-%m-%d') AS last_access
FROM kls_lms_pessoa p
INNER JOIN kls_lms_pessoa_curso_disc pcd ON (pcd.id_pessoa = p.id_pessoa)
INNER JOIN kls_lms_curso_disciplina cd ON (cd.id_curso_disciplina = pcd.id_curso_disciplina)
INNER JOIN tbl_mdl_user u ON (u.username = p.login)
INNER JOIN tbl_mdl_course c ON (c.SHORTNAME = cd.shortname)
left join mdl_user_lastaccess ul on (ul.userid = u.id and ul.courseid = c.id)
JOIN mdl_logstore_standard_log l ON (l.USERID = u.id AND l.COURSEid = c.id)
WHERE p.fl_etl_atu != 'E'
AND pcd.id_papel = 3
AND pcd.fl_etl_atu != 'E'
AND cd.fl_etl_atu != 'E'
AND u.mnethostid = 1
GROUP BY cd.shortname, p.nm_pessoa;

CREATE INDEX idx_prof_amp ON tbl_prof_amp (shortname, professor);
	

DROP TABLE IF EXISTS tbl_coord_amp;

CREATE TABLE tbl_coord_amp (
coordenador VARCHAR(500),
shortname VARCHAR(50),
first_access VARCHAR(50),
last_access VARCHAR(50)
);
		
INSERT INTO tbl_coord_amp 
SELECT 
p.nm_pessoa,
cd.shortname,
FROM_UNIXTIME(MIN(l.timecreated), '%Y-%m-%d') AS first_access, 
FROM_UNIXTIME(MAX(ul.timeaccess), '%Y-%m-%d') AS last_access
FROM kls_lms_pessoa p
INNER JOIN kls_lms_pessoa_curso pc ON (pc.id_pessoa = p.id_pessoa)
INNER JOIN kls_lms_curso_disciplina cd ON (cd.id_curso = pc.id_curso)
INNER JOIN tbl_mdl_user u ON (u.username = p.login)
INNER JOIN tbl_mdl_course c ON (c.SHORTNAME = cd.shortname)
left join mdl_user_lastaccess ul on (ul.userid = u.id and ul.courseid = c.id)
INNER JOIN mdl_logstore_standard_log l ON (l.USERID = u.id AND l.COURSEid = c.id)
WHERE p.fl_etl_atu != 'E'
AND pc.id_papel = 4
AND pc.fl_etl_atu != 'E'
AND cd.fl_etl_atu != 'E' 
AND u.mnethostid = 1
GROUP BY cd.shortname, p.nm_pessoa;

CREATE INDEX idx_coord_amp ON tbl_coord_amp (shortname, coordenador);


UPDATE tbl_conteudo_amp_novo a 
SET PRI_ACESSO_PR = (
  	SELECT min(first_access)
  	  FROM tbl_prof_amp 
    WHERE shortname = a.shortname and FIND_IN_SET(professor, a.professor)
);

UPDATE tbl_conteudo_amp_novo
SET PRI_ACESSO_PR='Nunca Acessou'
WHERE PRI_ACESSO_PR IS NULL;


UPDATE tbl_conteudo_amp_novo a 
  SET ULT_ACESSO_PR = (
  	SELECT max(last_access) 
  	  FROM tbl_prof_amp 
	 WHERE shortname = a.shortname and FIND_IN_SET(professor, a.professor)
);

UPDATE tbl_conteudo_amp_novo
SET ULT_ACESSO_PR='Nunca Acessou'
WHERE ULT_ACESSO_PR IS NULL;
 

UPDATE tbl_conteudo_amp_novo a 
  SET PRI_ACESSO_CD = (
  	SELECT min(first_access)
  	  FROM tbl_coord_amp 
	 WHERE shortname = a.shortname and FIND_IN_SET(coordenador, a.coordenador)
);

UPDATE tbl_conteudo_amp_novo
SET PRI_ACESSO_CD='Nunca Acessou'
WHERE PRI_ACESSO_CD IS NULL;


UPDATE tbl_conteudo_amp_novo a 
  SET ULT_ACESSO_CD = (
  	SELECT max(last_access)
  	  FROM tbl_coord_amp 
	 WHERE shortname = a.shortname and FIND_IN_SET(coordenador, a.coordenador)
);

UPDATE tbl_conteudo_amp_novo
SET ULT_ACESSO_CD='Nunca Acessou'
WHERE ULT_ACESSO_CD IS NULL;

		UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
		pl.`STATUS` = CODE_,
		pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_rel_material_comp_novo)),
		pl.INFO = MSG_
		WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
