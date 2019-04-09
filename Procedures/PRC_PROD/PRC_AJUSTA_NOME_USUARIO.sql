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

-- Copiando estrutura para procedure prod_kls.PRC_AJUSTA_NOME_USUARIO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AJUSTA_NOME_USUARIO`()
BEGIN

CALL PRC_USER_MDL;

DROP TABLE IF EXISTS tmp_nome_social;

CREATE TEMPORARY TABLE tmp_nome_social
SELECT 
	u.id, 
	CONCAT(u.firstname, ' ',u.lastname) nome_ava, 
	UPPER(p.nm_pessoa) nome_atual,
	trim(ucase(substring_index(p.nm_pessoa,' ',1))) AS FIRSTNAME,		
	trim(ucase(substr(p.nm_pessoa,(char_length(substring_index(p.nm_pessoa,' ',1)) + 2)))) AS LASTNAME
FROM kls_lms_pessoa p
JOIN tbl_mdl_user u on u.username=p.login and u.mnethostid=1
WHERE 
	CONCAT(u.firstname, ' ',u.lastname)<>p.nm_pessoa and
	(p.nm_social IS NULL OR char_length(p.nm_social)<3) AND
	p.fl_etl_atu REGEXP '[NA]' 
GROUP BY u.id
UNION
SELECT 
	u.id, 
	CONCAT(u.firstname, ' ',u.lastname), 
	UPPER(p.nm_social),
	trim(ucase(substring_index(p.nm_social,' ',1))) AS FIRSTNAME,		
	trim(ucase(substr(p.nm_social,(char_length(substring_index(p.nm_social,' ',1)) + 2)))) AS LASTNAME

FROM kls_lms_pessoa p
JOIN tbl_mdl_user u on u.username=p.login and u.mnethostid=1
WHERE 
	CONCAT(u.firstname, ' ',u.lastname)<>p.nm_social and
	p.nm_social IS NOT NULL AND
	char_length(p.nm_social)>=3 AND
	p.fl_etl_atu REGEXP '[NA]'
GROUP BY u.id;

ALTER TABLE tmp_nome_social ADD PRIMARY KEY (id);

UPDATE mdl_user u
JOIN tmp_nome_social b on u.id=b.id
SET u.firstname=b.firstname,
	 u.lastname=b.lastname;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
