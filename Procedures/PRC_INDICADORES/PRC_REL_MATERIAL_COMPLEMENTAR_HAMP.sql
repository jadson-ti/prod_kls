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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MATERIAL_COMPLEMENTAR_HAMP
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_REL_MATERIAL_COMPLEMENTAR_HAMP`()
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

DROP TABLE IF EXISTS tbl_rel_material_comp_hamp;
CREATE TABLE tbl_rel_material_comp_hamp (
	REGIONAL VARCHAR(50),
	CODIGO_UNIDADE VARCHAR(15),
	INSTITUICAO VARCHAR(255),
	PROFESSOR VARCHAR(255),
	COORDENADOR VARCHAR(255),
	CODIGO_CURSO VARCHAR(20),
	NOME_CURSO VARCHAR(255),
	CODIGO_TURMA VARCHAR(100),
	SERIE_TURMA VARCHAR(15),
	CODIGO_DISCIPLINA VARCHAR(30),
	NOME_DISCIPLINA VARCHAR(255),
	SHORTNAME VARCHAR(50),
	GRUPO VARCHAR(255),
	ENCONTRO INT(11),
	QTD_PRE INT(11),
	TEMPO_PRE INT(11),
	QTD_AULA INT(11),
	TEMPO_AULA INT(11),
	QTD_POS INT(11),
	TEMPO_POS INT(11),
	CARGA_HORARIA INT(11)
);	

alter table tbl_rel_material_comp_hamp add primary key (SHORTNAME, CODIGO_TURMA, GRUPO, ENCONTRO);


INSERT INTO tbl_rel_material_comp_hamp 
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
			0 AS QTD_PRE, 
			0 AS TEMPO_PRE,
			0 AS QTD_AULA,
			0 AS TEMPO_AULA,
			0 AS QTD_POS,
			0 AS TEMPO_POS,
			cd.carga_horaria AS CARGA_HORARIA
from mdl_course mc 
join mdl_groups g on g.courseid=mc.id 
join mdl_course_sections cs on cs.course=mc.id and cs.section>1 and cs.section<=17
join kls_lms_turmas t on t.fl_etl_atu REGEXP '[NA]' and t.shortname=g.description
join kls_lms_curso_disciplina cd on t.id_curso_disciplina=cd.id_curso_disciplina and cd.shortname=mc.shortname and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
join kls_lms_instituicao i on i.id_ies=c.id_ies  and i.fl_etl_atu REGEXP '[NA]'
join kls_lms_regional r on r.id_regional=i.id_regional

where 
	cd.shortname REGEXP '^HAMP'
group by mc.shortname, g.name, cs.section;

DROP TABLE IF EXISTS tmp_matcomp;

CREATE TABLE tmp_matcomp (
	SHORTNAME VARCHAR(50),
	GRUPO VARCHAR(255),
	ENCONTRO INT(11),
	QTD_PRE INT(11),
	TEMPO_PRE INT(11),
	QTD_AULA INT(11),
	TEMPO_AULA INT(11),
	QTD_POS INT(11),
	TEMPO_POS INT(11),
	PRIMARY KEY (SHORTNAME, GRUPO, ENCONTRO)
);


INSERT INTO tmp_matcomp
SELECT
	A.SHORTNAME,
	A.GRUPO, 
	A.ENCONTRO,
	SUM(IF(l.name='Pré-Aula',1,0)) AS QTD_PRE, 
	sum(IF(l.name='Pré-Aula', tc.workload, 0)) AS TEMPO_PRE,
	SUM(IF(l.name='Aula',1,0)) AS QTD_AULA,
	SUM(IF(l.name='Aula', tc.workload, 0)) AS TEMPO_AULA,
	SUM(IF(l.name='Pós-Aula',1,0)) AS QTD_POS,
	SUM(IF(l.name='Pós-Aula', tc.workload, 0)) AS TEMPO_POS
from tbl_rel_material_comp_hamp A
join mdl_course c on c.shortname=A.shortname
join mdl_groups g on g.courseid=c.id and g.name=A.GRUPO
join mdl_course_sections cs on cs.course=g.courseid and cs.section=A.ENCONTRO
join mdl_teacher_class tc on tc.courseid=c.id and tc.sectionid=cs.id
JOIN mdl_course_modules cm on cm.id=tc.cmid
JOIN mdl_course_modules cm1 on cm1.id=tc.labelid
JOIN mdl_label l on l.id=cm1.instance and l.name IN ('Pré-Aula','Aula','Pós-Aula')
JOIN mdl_teacher_class_group tcg on tcg.cmid=tc.cmid  and tcg.groupid=g.id
group by A.SHORTNAME, A.GRUPO, A.ENCONTRO;


UPDATE tmp_matcomp A
JOIN tbl_rel_material_comp_hamp B ON A.SHORTNAME=B.SHORTNAME AND A.GRUPO=B.GRUPO AND A.ENCONTRO=B.ENCONTRO
SET B.QTD_PRE=A.QTD_PRE,
	 B.QTD_POS=A.QTD_POS,
	 B.QTD_AULA=A.QTD_AULA,
	 B.TEMPO_PRE=A.TEMPO_PRE,
	 B.TEMPO_POS=A.TEMPO_POS,
	 B.TEMPO_AULA=A.TEMPO_AULA;
	 

UPDATE tbl_rel_material_comp_hamp SET ENCONTRO=ENCONTRO-1;
		
		UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
		pl.`STATUS` = CODE_,
		pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_rel_material_comp_hamp)),
		pl.INFO = MSG_
		WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
