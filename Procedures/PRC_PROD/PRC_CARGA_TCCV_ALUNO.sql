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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_TCCV_ALUNO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_TCCV_ALUNO`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (TCCV) WHERE STATUS IS NULL AND SHORTNAME LIKE 'TCCV%';

DROP TABLE IF EXISTS alunos_tcc_mdl;
CREATE TEMPORARY TABLE alunos_tcc_mdl AS SELECT DISTINCT md5(CONCAT(USERNAME, SHORTNAME)) AS CHAVE 
FROM anh_aluno_matricula PARTITION (TCCV) WHERE SHORTNAME LIKE 'TCCV%';
ALTER TABLE alunos_tcc_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_tcc_kls;
CREATE TEMPORARY TABLE alunos_tcc_kls AS 
	SELECT DISTINCT md5(CONCAT(p.login, cd.shortname)) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU<>'E' 
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='TCC'
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname 
	WHERE 
		c.cd_agrupamento is not null and 
		cd.SHORTNAME LIKE 'TCCV%' AND 
   	p.FL_ETL_ATU<>'E' AND 
		pap.ds_papel IN ('ALUNO');
	
ALTER TABLE alunos_tcc_kls ADD INDEX idx_chave (chave);	

DELETE t1
FROM alunos_tcc_mdl t1
JOIN alunos_tcc_kls t2 on t1.chave=t2.chave;



  INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
    								  CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
									  GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		anh.ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		'TCCV' AS SIGLA,
		'KHUB' AS ORIGEM,
		anh.username AS USERNAME,
		anh.shortname AS SHORTNAME,
		iac.CODIGO_POLO,
		iac.NOME_POLO,
		iac.CODIGO_CURSO,
		iac.NOME_CURSO,
		iac.CODIGO_DISCIPLINA,
		iac.NOME_DISCIPLINA, 
		NULL AS SERIE, 
		NULL AS TURNO,
		NULL AS TURMA,
		anh.GRUPO,
		iac.ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'S' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM anh_aluno_matricula PARTITION (TCCV) anh
	JOIN anh_import_aluno_curso iac on iac.ID=anh.id_matricula_atual 
	JOIN tbl_mdl_user u on u.username=anh.username and u.mnethostid=1 
	JOIN mdl_course c on c.shortname=anh.shortname
	JOIN mdl_enrol e on e.enrol='manual' and e.courseid=c.id and e.roleid=5
	JOIN mdl_user_enrolments ue on ue.enrolid=e.id and ue.userid=u.id and ue.status=0
	JOIN alunos_tcc_mdl b on b.chave=md5(CONCAT(anh.username, anh.shortname));

CALL PRC_CARGA_MATRICULAS;



DROP TABLE IF EXISTS alunos_tcc_mdl;
CREATE TEMPORARY TABLE alunos_tcc_mdl AS SELECT DISTINCT md5(CONCAT(USERNAME, SHORTNAME)) AS CHAVE 
FROM anh_aluno_matricula PARTITION (TCCV) WHERE SHORTNAME LIKE 'TCCV%';
ALTER TABLE alunos_tcc_mdl ADD PRIMARY KEY pk_shortname (chave);



	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		pcd.ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		'TCCV' AS SIGLA,
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		cd.shortname AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		d.cd_disciplina AS CODIGO_DISCIPLINA,
		d.ds_disciplina AS NOME_DISCIPLINA, 
		NULL AS SERIE, 
		NULL AS TURNO,
		NULL AS TURMA,
		mat.GRUPO AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'D' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU<>'E' 
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='TCC'
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname 
	JOIN mdl_enrol e on e.enrol='manual' and e.courseid=mdlc.id and e.roleid=5
	JOIN mdl_user_enrolments ue on ue.enrolid=e.id and ue.userid=u.id and ue.status=1
	JOIN anh_aluno_matricula PARTITION (TCCV) mat ON mat.username=p.login and mat.shortname=cd.shortname
	JOIN alunos_tcc_kls anh ON anh.chave=md5(CONCAT(p.login,cd.shortname))
	WHERE 
		cd.SHORTNAME LIKE 'TCCV%' AND 
   	p.FL_ETL_ATU<>'E' AND 
		pap.ds_papel IN ('ALUNO') 
	GROUP BY p.login,cd.shortname;

CALL PRC_CARGA_MATRICULAS;

DELETE t1
FROM alunos_tcc_kls t1
JOIN alunos_tcc_mdl t2 on t1.chave=t2.chave;




	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		pcd.ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		'TCCV' AS SIGLA,
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		cd.shortname AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		d.cd_disciplina AS CODIGO_DISCIPLINA,
		d.ds_disciplina AS NOME_DISCIPLINA, 
		NULL AS SERIE, 
		NULL AS TURNO,
		NULL AS TURMA,
		'GRUPO_' AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU<>'E' 
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='TCC'
	JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname 
	JOIN alunos_tcc_kls anh ON anh.chave=md5(CONCAT(p.login,cd.shortname))
	WHERE 
		cd.SHORTNAME LIKE 'TCCV%' AND 
   	p.FL_ETL_ATU<>'E' AND 
		pap.ds_papel IN ('ALUNO') 
	GROUP BY p.login,cd.shortname;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
