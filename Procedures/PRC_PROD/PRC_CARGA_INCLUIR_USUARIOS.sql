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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_INCLUIR_USUARIOS
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_CARGA_INCLUIR_USUARIOS`()
BEGIN


delete from anh_import_aluno where status is null;

  
	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		p.senha AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		ucase(i.cidade_ies) AS CITY,
		i.cd_instituicao AS UNIDADE,
		c.nm_curso AS CURSO, 
		i.cd_marca as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pc ON p.id_pessoa = pc.id_pessoa AND pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pc.id_curso_disciplina AND cd.fl_etl_atu<>'E'
	JOIN kls_lms_curso c ON c.id_curso = cd.id_curso AND c.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap ON pap.id_papel=pc.id_papel AND pap.ds_papel='ALUNO'
	JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
	LEFT JOIN mdl_user u ON u.username=p.login AND u.mnethostid=1
	WHERE 
		p.FL_ETL_ATU<>'E' AND
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 AND 
		u.id is null ;  


	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		p.senha AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		'' AS CITY,
		'' AS UNIDADE,
		'' AS CURSO, 
		'' as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pc ON p.id_pessoa = pc.id_pessoa and pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel='PROFESSOR'
	LEFT JOIN mdl_user u on u.username=p.login and u.mnethostid=1
	WHERE 
		u.id is null and 
		p.FL_ETL_ATU<>'E' AND 
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 ;


	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		p.senha AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		'' AS CITY,
		'' AS UNIDADE,
		'' AS CURSO, 
		'' as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa and pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel = 'COORDENADOR DE CURSO'
	LEFT JOIN mdl_user u on u.username=p.login and u.mnethostid=1
	WHERE 
		u.id is null and 
		p.FL_ETL_ATU<>'E' AND 
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 ;


	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		md5('123mudar') AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		'' AS CITY,
		'' AS UNIDADE,
		'' AS CURSO, 
		'' as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa and pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel = 'COORDENADOR ACADEMICO'
	LEFT JOIN mdl_user u on u.username=p.login and u.mnethostid=1
	WHERE 
		u.id is null and 
		p.FL_ETL_ATU<>'E' AND 
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 ;


	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		md5('123mudar') AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		'' AS CITY,
		'' AS UNIDADE,
		'' AS CURSO, 
		'' as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa and pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel = 'DIRETOR'
	LEFT JOIN mdl_user u on u.username=p.login and u.mnethostid=1
	WHERE 
		u.id is null and 
		p.FL_ETL_ATU<>'E' AND 
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 ;


	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		p.login AS USERNAME,
		md5('123mudar') AS PASSWORD,
		trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,
		trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME,
		p.email AS EMAIL,
		'' AS CITY,
		'' AS UNIDADE,
		'' AS CURSO, 
		'' as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'I' AS SITUACAO,		
		NULL AS STATUS
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa and pc.FL_ETL_ATU<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel = 'DIRETOR REGIONAL'
	LEFT JOIN mdl_user u on u.username=p.login and u.mnethostid=1
	WHERE 
		u.id is null and 
		p.FL_ETL_ATU<>'E' AND 
		p.login NOT REGEXP '^[[:space:]]' AND 
		LENGTH(p.login) > 0 ;
update anh_import_aluno set password='@123@' where (password is null or password='') and status is null;
call prc_carga_usuarios;

REPLACE INTO mdl_user_preferences (userid, name, value) 
select id, 'auth_forcepasswordchange', 1 
from mdl_user u 
where password=md5('123mudar');

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
