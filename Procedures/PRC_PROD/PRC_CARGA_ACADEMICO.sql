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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_ACADEMICO
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_CARGA_ACADEMICO`()
BEGIN

DROP TABLE IF EXISTS tmp_anh_academico;
CREATE TEMPORARY TABLE tmp_anh_academico (
	username VARCHAR(100),
	shortname VARCHAR(50),
	grupo VARCHAR(255),
	role VARCHAR(100)
);
ALTER TABLE tmp_anh_academico ADD INDEX idx_1 (username, shortname, grupo);
ALTER TABLE tmp_anh_academico ADD INDEX idx_2 (username);
ALTER TABLE tmp_anh_academico ADD INDEX idx_3 (shortname, grupo);


INSERT INTO tmp_anh_academico 
SELECT DISTINCT USERNAME, SHORTNAME, GRUPO, ROLE
FROM anh_academico_matricula 
WHERE ROLE<>'tutor' AND shortname<>'KLS'; 


DROP TABLE IF EXISTS tmp_kls_academico;
CREATE TEMPORARY TABLE tmp_kls_academico (
	username VARCHAR(100),
	shortname VARCHAR(50),
	grupo VARCHAR(255),
	role VARCHAR(100)
);

ALTER TABLE tmp_kls_academico ADD INDEX idx_1 (username, shortname, grupo);
ALTER TABLE tmp_kls_academico ADD INDEX idx_2 (username);
ALTER TABLE tmp_kls_academico ADD INDEX idx_3 (shortname);

INSERT INTO tmp_kls_academico 
	SELECT DISTINCT p.login as username, cd.shortname, t.shortname as grupo, r.shortname as role
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.id_pessoa=p.id_pessoa  and pc.fl_etl_atu REGEXP '[NA]' 
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel 
	JOIN mdl_role r on r.id=pap.id_role
	JOIN kls_lms_curso c ON c.id_curso = pc.id_curso AND c.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_curso_disciplina cd on cd.id_curso=c.id_curso AND cd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]'  
	JOIN kls_lms_turmas t on t.id_curso_disciplina=cd.id_curso_disciplina and t.FL_ETL_ATU REGEXP '[NA]'  
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname
	WHERE 	
		p.FL_ETL_ATU REGEXP '[NA]' AND 
		pap.ds_papel not in ('ALUNO', 'PROFESSOR');
		
INSERT INTO tmp_kls_academico 
	SELECT DISTINCT p.login, cd.shortname,t.shortname, r.shortname as role
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc and pt.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_turmas t on t.id_turma=pt.id_turma and t.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_agrupamento ag on ag.cd_agrupamento=c.cd_agrupamento
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel and pap.ds_papel='PROFESSOR'
	JOIN mdl_role r on r.id=pap.id_role
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1
	JOIN mdl_course mc on mc.shortname=cd.shortname
	WHERE p.fl_etl_atu REGEXP '[NA]' 
			AND  LENGTH(c.cd_agrupamento)>0 
		   AND cd.shortname NOT REGEXP 'DIPP_(METOD_CIENT_PILOT|PROBI_ESTAT_PILOT)_[23]';



DELETE gm 
FROM tmp_anh_academico a
JOIN tbl_mdl_user u on u.username=a.username
JOIN tbl_mdl_course c on c.shortname=a.shortname
JOIN mdl_groups g on g.courseid=c.id and g.description=a.grupo
JOIN mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
LEFT JOIN tmp_kls_academico b on a.username=b.username and
											a.shortname=b.shortname and
											a.grupo=b.grupo
WHERE b.username IS NULL;




DELETE ra 
FROM tmp_anh_academico a
JOIN tbl_mdl_user u on u.username=a.username
JOIN tbl_mdl_course c on c.shortname=a.shortname
JOIN mdl_role r on r.shortname=a.role
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_role_assignments ra on ra.userid=u.id and ra.contextid=co.id and ra.roleid=r.id
LEFT JOIN tmp_kls_academico b on a.username=b.username and
											a.shortname=b.shortname and
											a.role=b.role
WHERE b.username IS NULL;

DELETE ue 
FROM tmp_anh_academico a
JOIN tbl_mdl_user u on u.username=a.username
JOIN tbl_mdl_course c on c.shortname=a.shortname
JOIN mdl_role r on r.shortname=a.role
JOIN mdl_enrol e on e.enrol='manual' and e.courseid=c.id and e.roleid=r.id
JOIN mdl_user_enrolments ue on ue.userid=u.id and ue.enrolid=e.id
LEFT JOIN tmp_kls_academico b on a.username=b.username and
											a.shortname=b.shortname and
											a.role=b.role
WHERE b.username IS NULL;


DELETE a FROM tmp_anh_academico a
JOIN tmp_kls_academico b on a.username=b.username and
									 a.shortname=b.shortname and
									 a.grupo=b.grupo and
									 a.role=b.role;


INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
												CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
												GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 

SELECT 
	DISTINCT 
	anh.ID_PESSOA_CURSO,
	0 AS ID_PES_CUR_DISC,
	0 AS ID_PESSOA_TURMA,
	anh.SIGLA AS SIGLA,
	'KHUB' AS ORIGEM,
	anh.USERNAME AS USERNAME,
	anh.SHORTNAME AS SHORTNAME,
	anh.UNIDADE AS CODIGO_POLO,
	iac.NOME_POLO AS NOME_POLO,
	anh.CURSO AS CODIGO_CURSO,
	iac.NOME_CURSO AS NOME_CURSO,
	iac.CODIGO_DISCIPLINA AS CODIGO_DISCIPLINA,
	iac.NOME_DISCIPLINA AS NOME_DISCIPLINA, 
	iac.SERIE_ALUNO AS SERIE, 
	iac.TURNO_CURSO AS TURNO,
	iac.TURMA_ALUNO AS TURMA,
	anh.GRUPO AS GRUPO,
	anh.role AS ROLE, 
	date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
   'B' AS SITUACAO,
	'OK' AS STATUS,
	NULL AS NOVA_TENTATIVA
FROM anh_academico_matricula anh 
JOIN anh_import_aluno_curso iac on iac.id=anh.id_matricula_atual
JOIN tmp_anh_academico tmp ON tmp.username=anh.username and
										tmp.shortname=anh.shortname and
										tmp.grupo=anh.grupo and
										tmp.role=anh.role;


										
DELETE anh
FROM anh_academico_matricula anh 
JOIN tmp_anh_academico tmp ON tmp.username=anh.username and
										tmp.shortname=anh.shortname and
										tmp.grupo=anh.grupo and
										tmp.role=anh.role;



TRUNCATE TABLE tmp_anh_academico;



INSERT INTO tmp_anh_academico 
SELECT DISTINCT USERNAME, SHORTNAME, GRUPO, ROLE
FROM anh_academico_matricula 
WHERE ROLE<>'tutor' AND shortname<>'KLS';




DELETE b 
FROM tmp_anh_academico a
JOIN tmp_kls_academico b on a.username=b.username and
									 a.shortname=b.shortname and
									 a.grupo=b.grupo and
									 a.role=b.role;



	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		pc.id_pessoa_curso AS ID_PESSOA_CURSO,
		0 AS ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		CASE 
			WHEN cd.shortname LIKE 'DI\_%' THEN 'DIP'
			WHEN cd.shortname LIKE 'DIB%' THEN 'DIBP' 
			WHEN cd.shortname LIKE 'TCC%' THEN 'TCCP'
			WHEN cd.shortname LIKE 'ED%' THEN 'EDP' 
			WHEN cd.shortname LIKE 'EST%' THEN 'ESTP'
			WHEN cd.shortname LIKE 'NPJ%' THEN 'NPJP'
			WHEN cd.shortname LIKE 'HAMP%' THEN 'HAMPP'
			WHEN cd.shortname LIKE 'HAMI%' THEN 'HAMIP'
			ELSE SUBSTR(cd.shortname,1,3) 
		END AS SIGLA,
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		cd.SHORTNAME AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		d.cd_disciplina AS CODIGO_DISCIPLINA,
		d.ds_disciplina AS NOME_DISCIPLINA, 
		t.termo_turma AS SERIE, 
		c.turno AS TURNO,
		t.cd_turma AS TURMA,
		t.SHORTNAME AS GRUPO,
		r.shortname AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.id_pessoa=p.id_pessoa  and pc.fl_etl_atu REGEXP '[NA]' 
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel 
	join mdl_role r on r.id=pap.id_role
	JOIN kls_lms_curso c ON c.id_curso = pc.id_curso AND c.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_curso_disciplina cd on cd.id_curso=c.id_curso AND cd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]'  
	JOIN kls_lms_turmas t on t.id_curso_disciplina=cd.id_curso_disciplina and t.FL_ETL_ATU REGEXP '[NA]'  
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
	JOIN tbl_mdl_user u ON u.username=p.login 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname 
	JOIN tmp_kls_academico anh ON anh.username=u.username and
											anh.shortname=mdlc.shortname and
											anh.grupo=t.shortname and
											anh.role=r.shortname								
	WHERE pap.ds_papel not in ('ALUNO', 'PROFESSOR')
	GROUP BY p.login,cd.shortname,i.cd_instituicao,i.nm_ies,c.cd_agrupamento,c.nm_curso,d.cd_disciplina,t.SHORTNAME,d.ds_disciplina;
	

	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		pcd.ID_PES_CUR_DISC,
		pt.id_pes_turma_disciplina AS ID_PESSOA_TURMA,
		CASE 
			WHEN cd.shortname LIKE 'DI\_%' THEN 'DIP'
			WHEN cd.shortname LIKE 'DIB%' THEN 'DIBP' 
			WHEN cd.shortname LIKE 'TCC%' THEN 'TCCP'
			WHEN cd.shortname LIKE 'ED%' THEN 'EDP' 
			WHEN cd.shortname LIKE 'EST%' THEN 'ESTP'
			WHEN cd.shortname LIKE 'NPJ%' THEN 'NPJP'
			WHEN cd.shortname LIKE 'HAMP%' THEN 'HAMPP'
			WHEN cd.shortname LIKE 'HAMI%' THEN 'HAMIP'
			ELSE SUBSTR(cd.shortname,1,3) 
		END AS SIGLA,
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		cd.SHORTNAME AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		d.cd_disciplina AS CODIGO_DISCIPLINA,
		d.ds_disciplina AS NOME_DISCIPLINA, 
		t.termo_turma AS SERIE, 
		c.turno AS TURNO,
		t.cd_turma AS TURMA,
		t.SHORTNAME AS GRUPO,
		'editingteacher' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA and cd.fl_etl_atu regexp '[NA]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU regexp '[NA]'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU regexp '[NA]'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_pessoa_turma pt on pt.ID_PES_CUR_DISC=pcd.ID_PES_CUR_DISC and pt.FL_ETL_ATU regexp '[NA]'
	JOIN kls_lms_turmas t on t.ID_TURMA=pt.ID_TURMA and t.FL_ETL_ATU REGEXP '[NA]' 
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel AND pap.ds_papel='PROFESSOR'
	JOIN mdl_role r on r.id=pap.id_role
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN tbl_mdl_course mdlc on mdlc.shortname=cd.shortname 
	JOIN tmp_kls_academico anh ON anh.username=u.username and
											anh.shortname=mdlc.shortname and
											anh.grupo=t.shortname and
											anh.role=r.shortname
	WHERE
		p.fl_etl_atu REGEXP '[NA]' 
		AND  LENGTH(c.cd_agrupamento)>0  
		AND cd.shortname NOT REGEXP 'DIPP_(METOD_CIENT_PILOT|PROBI_ESTAT_PILOT)_[23]'						
	GROUP BY p.login,cd.shortname,i.cd_instituicao,i.nm_ies,c.cd_agrupamento,c.nm_curso,d.cd_disciplina,d.ds_disciplina;

	CALL PRC_CARGA_GRUPO;
	CALL PRC_CARGA_MATRICULAS;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
