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

-- Copiando estrutura para função prod_kls.bloquear
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `bloquear`(
	`P_IDANH` INT,
	`P_USERNAME` VARCHAR(30),
	`P_SHORTNAME` VARCHAR(50),
	`P_GRUPO` VARCHAR(100),
	`P_ROLE` VARCHAR(30),
	`P_SIGLA` VARCHAR(10)
) RETURNS text CHARSET latin1
    READS SQL DATA
    DETERMINISTIC
BEGIN

	DECLARE P_USERID INT;
	DECLARE P_COURSEID INT;
	DECLARE P_ROLEID INT;
	DECLARE P_GRUPOID INT;
	DECLARE P_CONTEXTID INT;
	DECLARE P_ENROLID INT;
	DECLARE P_ENROLTUTORID INT;
	DECLARE P_ROLETUTOR INT;
	DECLARE P_QTDGRUPOS INT;
	DECLARE V_RASS INT;
	DECLARE V_GRUPO_REMOVIDO INT;
	
	SET P_USERID=NULL;
	SET P_COURSEID=NULL;
	SET P_GRUPOID=NULL;

	SELECT id INTO P_ROLEID FROM mdl_role WHERE shortname=P_ROLE;
		IF (P_ROLEID IS NULL) THEN 
			RETURN 'ERRO - perfil inválido';
	    END IF;
	
	SELECT id INTO P_USERID FROM mdl_user WHERE username=P_USERNAME AND mnethostid=1 LIMIT 1;
		IF (P_USERID IS NULL) THEN 
			RETURN 'ERRO - usuário inválido';
	    END IF;

	SELECT id INTO P_COURSEID FROM mdl_course WHERE shortname=P_SHORTNAME LIMIT 1;
		IF (P_COURSEID IS NULL) THEN 
			RETURN 'ERRO - curso inválido';
	    END IF;	

	SELECT id INTO P_CONTEXTID 
	FROM mdl_context WHERE contextlevel=50 and instanceid=P_COURSEID LIMIT 1;
		IF (P_CONTEXTID IS NULL) THEN 
			RETURN 'ERRO - falha no contexto do curso';
	    END IF;	

	SELECT id INTO P_ENROLID 
	FROM mdl_enrol e WHERE enrol='manual' and courseid=P_COURSEID and roleid=P_ROLEID 
	LIMIT 1;
		IF (P_ENROLID IS NULL) THEN 
			RETURN 'ERRO - enrol inválido';
		END IF;


	SELECT id INTO P_GRUPOID FROM mdl_groups WHERE description=P_GRUPO AND courseid=P_COURSEID LIMIT 1;
	
	SET V_GRUPO_REMOVIDO=0;
	
	IF (P_GRUPOID IS NOT NULL) THEN 

			SET V_RASS=0;	

			IF (P_ROLE IN ('coordteacher', 'editingteacher')) THEN
			
				SELECT COUNT(1) INTO V_RASS 
				FROM mdl_role_assignments 
				WHERE contextid=P_CONTEXTID AND userid=P_USERID AND roleid<>P_ROLEID;
				
			END IF;

			IF (V_RASS=0) THEN 
				DELETE FROM mdl_groups_members WHERE userid=P_USERID AND groupid=P_GRUPOID;	
				SET V_GRUPO_REMOVIDO=1;
			END IF;
			
	END IF;
	
	
	SELECT COUNT(DISTINCT g.id) INTO P_QTDGRUPOS
	FROM mdl_groups_members gm 
	JOIN mdl_groups g on g.id=gm.groupid and g.courseid=P_COURSEID
	WHERE gm.userid=P_USERID;
	
	IF P_QTDGRUPOS=0 THEN 
		DELETE FROM mdl_role_assignments WHERE userid=P_USERID AND contextid=P_CONTEXTID AND roleid=P_ROLEID ;
		DELETE FROM mdl_user_enrolments WHERE userid=P_USERID AND enrolid=P_ENROLID;
	ELSE
		IF (V_GRUPO_REMOVIDO=1) THEN 
			RETURN 'Foi realizado apenas o bloqueio no grupo pois o usuário está em outros grupos desta disciplina';
		ELSE 
			RETURN 'O usuário não foi desassociado da disciplina por que possui outros grupos';
		END IF;
	END IF;
	

	RETURN 'Bloqueio realizado com sucesso';


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
