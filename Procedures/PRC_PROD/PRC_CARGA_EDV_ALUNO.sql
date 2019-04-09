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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_EDV_ALUNO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_EDV_ALUNO`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (EDV) WHERE STATUS IS NULL;

DROP TABLE IF EXISTS alunos_ed_mdl;
CREATE TEMPORARY TABLE alunos_ed_mdl AS SELECT DISTINCT MD5(CONCAT(USERNAME, SHORTNAME)) AS CHAVE 
FROM anh_aluno_matricula PARTITION (EDV);
ALTER TABLE alunos_ed_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_ed_kls;
CREATE TEMPORARY TABLE alunos_ed_kls AS 
	SELECT DISTINCT MD5(CONCAT(USERNAME, SHORTNAME)) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA AND cd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='ED'
	JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1
	WHERE LENGTH(c.cd_agrupamento)>0;
	
ALTER TABLE alunos_ed_kls ADD PRIMARY KEY pk_shortname (chave);	

DELETE t1
FROM alunos_ed_mdl t1
JOIN alunos_ed_kls t2 on t1.chave=t2.chave;




	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0,
		anh.ID_PES_CUR_DISC,
		anh.ID_PESSOA_TURMA,
		'EDV' AS SIGLA,
		'KHUB' AS ORIGEM,
		anh.USERNAME AS USERNAME,
		anh.SHORTNAME AS SHORTNAME,
		iac.CODIGO_POLO,
		iac.NOME_POLO,
		anh.CURSO,
		iac.NOME_CURSO,
		iac.CODIGO_DISCIPLINA,
		iac.NOME_DISCIPLINA, 
		iac.SERIE_ALUNO, 
		iac.TURNO_CURSO,
		iac.TURMA_ALUNO,
		anh.GRUPO,
		iac.ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'B' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM anh_aluno_matricula PARTITION (EDV) anh
	JOIN anh_import_aluno_curso PARTITION (EDV)  iac ON anh.id_matricula_atual=iac.id
	JOIN alunos_ed_mdl b ON b.chave=MD5(CONCAT(anh.username, anh.shortname))
	GROUP BY anh.username,anh.shortname;


	CALL PRC_CARGA_MATRICULAS;   	

	DELETE anh 
	FROM anh_aluno_matricula PARTITION (EDV) anh
	JOIN alunos_ed_mdl b ON b.chave=MD5(CONCAT(anh.USERNAME,anh.SHORTNAME));



DROP TABLE IF EXISTS alunos_ed_mdl;
CREATE TEMPORARY TABLE alunos_ed_mdl AS SELECT DISTINCT MD5(CONCAT(USERNAME, SHORTNAME)) AS CHAVE 
FROM anh_aluno_matricula PARTITION (EDV);
ALTER TABLE alunos_ed_mdl ADD PRIMARY KEY pk_shortname (chave);

DELETE t1
FROM alunos_ed_kls t1
JOIN alunos_ed_mdl t2 on t1.chave=t2.chave;




	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		pcd.ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		'EDV' AS SIGLA,
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
		c.turno AS TURNO,
		NULL AS TURMA,
		'GRUPO_' AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[NA]'
	JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
	JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]'
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='ED'
	JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1 
	JOIN mdl_course mdlc on mdlc.shortname=cd.shortname 
	JOIN alunos_ed_kls anh ON anh.chave=MD5(CONCAT(p.login,cd.shortname))
	WHERE 
   	p.FL_ETL_ATU<>'E' AND 
		pap.ds_papel IN ('ALUNO') AND
		LENGTH(c.cd_agrupamento)>0 
	GROUP BY p.login,cd.shortname;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
