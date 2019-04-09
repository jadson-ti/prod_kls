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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_BLOQUEAR_USUARIOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_BLOQUEAR_USUARIOS`()
BEGIN

	
	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		u.username AS USERNAME,
		u.password AS PASSWORD,
		u.firstname AS FIRSTNAME,
		u.lastname AS LASTNAME,
		u.email AS EMAIL,
		u.city AS CITY,
		u.institution AS UNIDADE,
		u.department AS CURSO, 
		u.theme as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'B' AS SITUACAO,		
		NULL AS STATUS
	FROM mdl_user u
   JOIN kls_lms_pessoa p on p.login=u.username and p.FL_ETL_ATU='E'
	WHERE 
		u.deleted=0 
		AND NOT EXISTS (SELECT * FROM kls_lms_pessoa WHERE login=p.login AND FL_ETL_ATU<>'E');
		
	
	INSERT INTO anh_import_aluno (ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, EMAIL, CITY,
	UNIDADE, CURSO, MARCA, DATA_IMPORTACAO, SITUACAO, STATUS) 
	   SELECT 
	   DISTINCT 
		'KHUB' AS ORIGEM,
		u.username AS USERNAME,
		u.password AS PASSWORD,
		u.firstname AS FIRSTNAME,
		u.lastname AS LASTNAME,
		u.email AS EMAIL,
		u.city AS CITY,
		u.institution AS UNIDADE,
		u.department AS CURSO, 
		u.theme as MARCA,
		date_format(now(),'%Y-%m-%d') as DATA_IMPORTACAO,
		'E' AS SITUACAO,		
		NULL AS STATUS
	FROM mdl_user u
	JOIN kls_lms_pessoa p on p.login=u.username and p.FL_ETL_ATU<>'E'
	WHERE u.deleted=1 ;  

call prc_carga_usuarios;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
