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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_AUTOLOGIN_PVD
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_AUTOLOGIN_PVD`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (AUTOLOGIN) WHERE STATUS IS NULL;

DROP TABLE IF EXISTS alunos_kls_mdl;
CREATE TEMPORARY TABLE alunos_kls_mdl AS 
	SELECT DISTINCT md5(CONCAT(USERNAME, 'PVD')) AS CHAVE 
	FROM anh_aluno_matricula PARTITION (AUTOLOGIN)
	WHERE SIGLA='PVD';
	
ALTER TABLE alunos_kls_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_kls_kls;
CREATE TEMPORARY TABLE alunos_kls_kls AS 
	SELECT DISTINCT CHAVE FROM (
	SELECT DISTINCT md5(CONCAT(p.login, 'PVD')) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.termo_turma like '2%' AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'	
	JOIN kls_lms_instituicao i ON i.id_ies=c.id_ies AND i.fl_etl_atu<>'E'	
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1
	UNION
	SELECT DISTINCT md5(CONCAT(p2.login, 'PVD')) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.termo_turma like '2%' AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'	
	JOIN kls_lms_instituicao i ON i.id_ies=c.id_ies AND i.fl_etl_atu<>'E'	
	JOIN kls_lms_pessoa_curso pc2 ON pc2.id_curso=c.id_curso and pc.fl_etl_atu<>'E' and pc2.id_papel not in (1,3)
	JOIN kls_lms_pessoa p2 on p2.id_pessoa=pc2.id_pessoa and p2.fl_etl_atu<>'E'	
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_user u ON u.username=p2.login AND u.mnethostid=1
	) A;
ALTER TABLE alunos_kls_kls ADD PRIMARY KEY pk_shortname (chave);	

DELETE t1
FROM alunos_kls_mdl t1
JOIN alunos_kls_kls t2 on t1.chave=t2.chave;




		INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC,ID_PESSOA_TURMA,SIGLA,ORIGEM,SHORTNAME,USERNAME,
		CODIGO_POLO,NOME_POLO,CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,
		GRUPO,ROLE, DATA_IMPORTACAO,	SITUACAO, STATUS, NOVA_TENTATIVA) 
		SELECT 
		DISTINCT
			0,0,0,
			'PVD' AS SIGLA,
			'KHUB' AS ORIGEM,
			anh.shortname AS SHORTNAME,
			anh.username,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'PVD' AS GRUPO, 
			anh.role as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'B' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM anh_aluno_matricula PARTITION (AUTOLOGIN) anh
		JOIN alunos_kls_mdl mat on mat.chave=md5(CONCAT(anh.username,'PVD'))
		WHERE anh.SIGLA='PVD';

call prc_carga_matriculas;

DELETE anh 
FROM anh_aluno_matricula PARTITION (AUTOLOGIN) anh
JOIN anh_import_aluno_curso PARTITION (AUTOLOGIN) iac on anh.id_matricula_atual=iac.id
JOIN alunos_kls_mdl b on b.chave=md5(concat(anh.username, 'PVD'))
WHERE anh.SIGLA='PVD';



DROP TABLE IF EXISTS alunos_kls_mdl;
CREATE TEMPORARY TABLE alunos_kls_mdl AS 
	SELECT DISTINCT md5(CONCAT(USERNAME, 'PVD')) AS CHAVE 
	FROM anh_aluno_matricula PARTITION (AUTOLOGIN)
	WHERE SIGLA='PVD';

DELETE t1
FROM alunos_kls_kls t1
JOIN alunos_kls_mdl t2 on t1.chave=t2.chave;
	
	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		pc.id_pessoa_curso AS ID_PESSOA_CURSO,
		0,
		0 AS ID_PESSOA_TURMA,
		'PVD' AS SIGLA,
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		'projeto_vida' AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		'AUTOLOGINPVD' AS CODIGO_DISCIPLINA,
		'AUTOLOGINPVD' AS NOME_DISCIPLINA, 
		'2' AS SERIE, 
		c.turno AS TURNO,
		NULL AS TURMA,
		'PVDAUTOLOGIN' AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.termo_turma like '2%'  AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'	
	JOIN kls_lms_instituicao i ON i.id_ies=c.id_ies AND i.fl_etl_atu<>'E'
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1
	JOIN alunos_kls_kls anh ON anh.chave=md5(CONCAT(p.login,'PVD'))
  WHERE 
  		p.FL_ETL_ATU != 'E' AND 
		pap.ds_papel = 'ALUNO';

	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		pc2.id_pessoa_curso AS ID_PESSOA_CURSO,
		0,
		0 AS ID_PESSOA_TURMA,
		'PVD' AS SIGLA,
		'KHUB' AS ORIGEM,
		p2.login AS USERNAME,
		'projeto_vida' AS SHORTNAME,
		i.cd_instituicao AS CODIGO_POLO,
		i.nm_ies AS NOME_POLO,
		c.cd_agrupamento AS CODIGO_CURSO,
		c.nm_curso AS NOME_CURSO,
		'AUTOLOGINPVD' AS CODIGO_DISCIPLINA,
		'AUTOLOGINPVD' AS NOME_DISCIPLINA, 
		'2' AS SERIE, 
		c.turno AS TURNO,
		NULL AS TURMA,
		'PVDAUTOLOGIN' AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.termo_turma like '2%' AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'	
	JOIN kls_lms_instituicao i ON i.id_ies=c.id_ies AND i.fl_etl_atu<>'E'	
	JOIN kls_lms_pessoa_curso pc2 ON pc2.id_curso=c.id_curso and pc.fl_etl_atu<>'E' and pc2.id_papel not in (1,3)
	JOIN kls_lms_pessoa p2 on p2.id_pessoa=pc2.id_pessoa and p2.fl_etl_atu<>'E'	
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_user u ON u.username=p2.login AND u.mnethostid=1
	JOIN alunos_kls_kls anh ON anh.chave=md5(CONCAT(p2.login,'PVD'))
  WHERE 
  		p.FL_ETL_ATU != 'E' AND 
		pap.ds_papel = 'ALUNO';

CALL PRC_CARGA_GRUPO;
CALL PRC_CARGA_MATRICULAS;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
