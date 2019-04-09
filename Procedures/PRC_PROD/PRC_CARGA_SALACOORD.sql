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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_SALACOORD
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_SALACOORD`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (SCD) WHERE STATUS IS NULL;

DROP TABLE IF EXISTS alunos_kls_mdl;
CREATE TEMPORARY TABLE alunos_kls_mdl AS 
	SELECT DISTINCT CONCAT(USERNAME, 'SCD') AS CHAVE 
	FROM anh_aluno_matricula PARTITION (SCD);
	
ALTER TABLE alunos_kls_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_kls_kls;
CREATE TEMPORARY TABLE alunos_kls_kls AS 
	SELECT DISTINCT CHAVE FROM (
	SELECT DISTINCT CONCAT(USERNAME, 'SCD') AS CHAVE 
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON pc.ID_PESSOA=p.id_pessoa AND pc.fl_etl_atu REGEXP '[N|A]'
	JOIN kls_lms_papel pap ON pap.id_papel = pc.id_papel 
	JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1
	JOIN mdl_course c on c.shortname='SALA_COORD_DIRETOR'
	where pap.ds_papel IN ('COORDENADOR DE CURSO', 'DIRETOR','DIRETOR REGIONAL','COORDENADOR ACADEMICO')
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
			'SCD' AS SIGLA,
			'KHUB' AS ORIGEM,
			'SALA_COORD_DIRETOR' AS SHORTNAME,
			p.login,
			'' AS CODIGO_POLO,
			'' AS NOME_POLO,
			'' AS CODIGO_CURSO,
			'' AS NOME_CURSO,
			'' AS CODIGO_DISCIPLINA,
			'' AS NOME_DISCIPLINA,
			'SCD' AS GRUPO, 
			'student' as ROLE,
			DATE_FORMAT(NOW(),'%Y-%m-%d') AS DATA_IMPORTACAO,
			'I' AS SITUACAO,
			NULL AS STATUS,
			NULL AS NOVA_TENTATIVA
		FROM kls_lms_pessoa p
		JOIN kls_lms_pessoa_curso pc on p.id_pessoa=pc.id_pessoa and pc.FL_ETL_ATU<>'E' 
		JOIN kls_lms_papel pdp on pdp.id_papel=pc.id_papel
		JOIN mdl_course c on c.shortname='SALA_COORD_DIRETOR'
		JOIN alunos_kls_kls mat on mat.chave=CONCAT(p.login,'SCD')
		WHERE pdp.ds_papel IN ('COORDENADOR DE CURSO','DIRETOR','DIRETOR REGIONAL','COORDENADOR ACADEMICO'); 

call prc_carga_matriculas;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
