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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_HOME
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_HOME`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (KLS) WHERE STATUS IS NULL;

DROP TABLE IF EXISTS alunos_kls_mdl;
CREATE TEMPORARY TABLE alunos_kls_mdl AS 
	SELECT DISTINCT MD5(CONCAT(USERNAME, ROLE, 'KLS')) AS CHAVE 
	FROM anh_aluno_matricula PARTITION (KLS)
	UNION
	SELECT DISTINCT MD5(CONCAT(USERNAME, ROLE, 'KLS')) AS CHAVE 
	FROM anh_academico_matricula PARTITION (KLS);
	
ALTER TABLE alunos_kls_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_kls_kls;
CREATE TEMPORARY TABLE alunos_kls_kls AS 
	SELECT DISTINCT CHAVE FROM (
	SELECT DISTINCT MD5(CONCAT(USERNAME, r.shortname, 'KLS')) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
	JOIN mdl_role r on r.id=pap.id_role
	JOIN tbl_mdl_user u ON u.username=p.login 
	WHERE p.fl_etl_atu REGEXP '[NA]'
	UNION
	SELECT DISTINCT MD5(CONCAT(USERNAME, r.shortname, 'KLS')) AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_role r on r.id=pap.id_role
	JOIN tbl_mdl_user u ON u.username=p.login 
	WHERE p.fl_etl_atu REGEXP '[NA]'	
	) A;
ALTER TABLE alunos_kls_kls ADD PRIMARY KEY pk_shortname (chave);	

DELETE t1
FROM alunos_kls_kls t1
JOIN alunos_kls_mdl t2 on t1.chave=t2.chave;




		INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC,ID_PESSOA_TURMA,SIGLA,ORIGEM,SHORTNAME,USERNAME,
		CODIGO_POLO,NOME_POLO,CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,
		GRUPO,ROLE, DATA_IMPORTACAO,	SITUACAO, STATUS, NOVA_TENTATIVA) 
		SELECT 
		DISTINCT
			0,0,0,
			'KLS' AS SIGLA,
			'KHUB' AS ORIGEM,
			'KLS' AS SHORTNAME,
			p.login,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'KLS' AS GRUPO, 
			r.shortname as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'I' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM kls_lms_pessoa p
		JOIN kls_lms_pessoa_curso_disc pc on p.id_pessoa=pc.id_pessoa and pc.FL_ETL_ATU<>'E' 
		JOIN kls_lms_papel pdp on pdp.id_papel=pc.id_papel
		JOIN mdl_role r on r.id=pdp.id_role
		JOIN alunos_kls_kls mat on mat.chave=md5(CONCAT(p.login,r.shortname, 'KLS'))
		WHERE r.shortname IN ('student','editingteacher');


		INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC,ID_PESSOA_TURMA,SIGLA,ORIGEM,SHORTNAME,USERNAME,
		CODIGO_POLO,NOME_POLO,CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,
		GRUPO,ROLE, DATA_IMPORTACAO,	SITUACAO, STATUS, NOVA_TENTATIVA) 
		SELECT 
		DISTINCT
			0,0,0,
			'KLS' AS SIGLA,
			'KHUB' AS ORIGEM,
			'KLS' AS SHORTNAME,
			p.login,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'KLS' AS GRUPO, 
			r.shortname as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'I' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM kls_lms_pessoa p
		JOIN kls_lms_pessoa_curso pc on p.id_pessoa=pc.id_pessoa and pc.FL_ETL_ATU REGEXP '[NA]'
		JOIN kls_lms_papel pdp on pdp.id_papel=pc.id_papel
		JOIN mdl_role r on r.id=pdp.id_role
		JOIN alunos_kls_kls mat on mat.chave=md5(CONCAT(p.login,r.shortname,'KLS'))
		WHERE r.shortname  NOT IN ('student','editingteacher');

call prc_carga_matriculas;


		INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC,ID_PESSOA_TURMA,SIGLA,ORIGEM,SHORTNAME,USERNAME,
		CODIGO_POLO,NOME_POLO,CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,
		GRUPO,ROLE, DATA_IMPORTACAO,	SITUACAO, STATUS, NOVA_TENTATIVA) 
		SELECT 
		DISTINCT
			0,0,0,
			'KLS' AS SIGLA,
			'KHUB' AS ORIGEM,
			'KLS' AS SHORTNAME,
			mat.tutor,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'KLS' AS GRUPO, 
			'tutor' as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'I' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM anh_aluno_matricula mat
		LEFT JOIN anh_academico_matricula PARTITION (KLS) tut ON mat.TUTOR=tut.USERNAME 
		WHERE tut.id is null;

call prc_carga_matriculas;

		INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC,ID_PESSOA_TURMA,SIGLA,ORIGEM,SHORTNAME,USERNAME,
		CODIGO_POLO,NOME_POLO,CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,
		GRUPO,ROLE, DATA_IMPORTACAO,	SITUACAO, STATUS, NOVA_TENTATIVA) 
		SELECT 
		DISTINCT
			0,0,0,
			'KLS' AS SIGLA,
			'KHUB' AS ORIGEM,
			'KLS' AS SHORTNAME,
			us.username,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'KLS' AS GRUPO, 
			'coordarea' as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'I' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM mdl_sgt_usuario u
		JOIN mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id
		JOIN tbl_mdl_user us on us.id=um.mdl_user_id
		LEFT JOIN anh_academico_matricula PARTITION (KLS) home ON home.username=us.username and us.mnethostid=1
		WHERE u.id_perfil=2 and home.ID is null;


CALL PRC_CARGA_MATRICULAS;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
