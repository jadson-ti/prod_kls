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

-- Copiando estrutura para função prod_kls.suspender
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `suspender`(
	`P_IDANH` INT,
	`P_USERNAME` VARCHAR(30),
	`P_SHORTNAME` VARCHAR(30),
	`P_GRUPO` VARCHAR(30),
	`P_ROLE` VARCHAR(30),
	`P_SIGLA` VARCHAR(10)

) RETURNS text CHARSET latin1
BEGIN

	DECLARE P_USERID INT;
	DECLARE P_COURSEID INT;
	DECLARE P_ROLEID INT;
	DECLARE P_GRUPOID INT;
	DECLARE P_ENROLID INT;
	DECLARE P_ENROLTUTORID INT;
	DECLARE P_ROLETUTOR INT;
	
	SET P_USERID=NULL;
	SET P_COURSEID=NULL;
	SET P_GRUPOID=NULL;

	SELECT id INTO P_ROLEID FROM mdl_role WHERE shortname=P_ROLE;
		IF (P_ROLEID IS NULL) THEN 
			RETURN 'ERRO - perfil inválido';
	    END IF;
	
	SELECT id INTO P_USERID FROM mdl_user WHERE username=P_USERNAME AND mnethostid=1;
		IF (P_USERID IS NULL) THEN 
			RETURN 'ERRO - usuário inválido';
	    END IF;

	SELECT id INTO P_COURSEID FROM mdl_course WHERE shortname=P_SHORTNAME;
		IF (P_COURSEID IS NULL) THEN 
			RETURN 'ERRO - curso inválido';
	    END IF;	

	SELECT id INTO P_ENROLID 
	FROM mdl_enrol e WHERE enrol='manual' and courseid=P_COURSEID and roleid=P_ROLEID 
	LIMIT 1;
		IF (P_ENROLID IS NULL) THEN 
			RETURN 'ERRO - enrol inválido';
		END IF;

	IF (P_ROLE='student') THEN 
		UPDATE mdl_user_enrolments SET STATUS=1 WHERE userid=P_USERID AND enrolid=P_ENROLID;
		
	END IF;												

	RETURN 'Matricula Suspensa com sucesso';


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
