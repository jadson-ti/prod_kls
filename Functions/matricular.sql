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

-- Copiando estrutura para função prod_kls.matricular
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `matricular`(
	`P_IDANH` INT,
	`P_IDPC` INT,
	`P_IDPT` INT,
	`P_USERNAME` VARCHAR(30),
	`P_SHORTNAME` VARCHAR(50),
	`P_UNIDADE` VARCHAR(10),
	`P_CURSO` VARCHAR(10),
	`P_GRUPO` VARCHAR(150),
	`P_TUTOR` VARCHAR(30),
	`P_ROLE` VARCHAR(30),
	`P_SIGLA` VARCHAR(10)


















) RETURNS text CHARSET latin1
BEGIN

	DECLARE P_USERID INT;
	DECLARE P_COURSEID INT;
	DECLARE P_ROLEID INT;
	DECLARE P_GRUPOID INT;
	DECLARE P_GRUPONOME VARCHAR(254);
	DECLARE P_CODIGO_POLO VARCHAR(30);
	DECLARE P_NOME_CURSO VARCHAR(150);
	DECLARE P_CODIGO_DISCIPLINA VARCHAR(50);
	DECLARE P_SERIE VARCHAR(50);
	DECLARE P_TURMA VARCHAR(50);			
	DECLARE P_TUTORID INT;
	DECLARE P_CONTEXTID INT;
	DECLARE P_ENROLID INT;
	DECLARE P_ENROLTUTORID INT;
	DECLARE P_ROLETUTOR INT;
	DECLARE CODE_ VARCHAR(30);
	DECLARE MSG_ VARCHAR(255);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	      SET CODE_ = CONCAT('ERRO - ', CODE_, ' - ',MSG_);
	      RETURN CODE_;
	   END;

	
	SET P_USERID=NULL;
	SET P_COURSEID=NULL;
	SET P_GRUPONOME=NULL;
	SET P_NOME_CURSO=NULL;
	SET P_CODIGO_POLO=NULL;
	SET P_CODIGO_DISCIPLINA=NULL;
	SET P_SERIE=NULL;
	SET P_TURMA=NULL;
	SET P_GRUPOID=NULL;
	SET P_TUTORID=NULL;

	SELECT id INTO P_ROLEID FROM mdl_role WHERE shortname=P_ROLE LIMIT 1;
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

	IF (P_TUTOR IS NOT NULL) THEN 
		SELECT id INTO P_TUTORID FROM mdl_user WHERE username=P_TUTOR AND mnethostid=1 LIMIT 1;
			IF (P_TUTORID IS NULL) THEN 
				RETURN 'ERRO - tutor inválido';
	    	END IF;	
	END IF;

	SELECT id INTO P_CONTEXTID 
	FROM mdl_context WHERE contextlevel=50 and instanceid=P_COURSEID limit 1;
		IF (P_CONTEXTID IS NULL) THEN 
			RETURN 'ERRO - falha no contexto do curso';
	    END IF;			

	SELECT id INTO P_ENROLID 
	FROM mdl_enrol e WHERE enrol='manual' and courseid=P_COURSEID and roleid=P_ROLEID 
	LIMIT 1;
		IF (P_ENROLID IS NULL) THEN 
        	INSERT INTO mdl_enrol(enrol, status, courseid, name, roleid, timecreated, timemodified) 
         VALUES ('manual', 0, P_COURSEID, CONCAT(P_SHORTNAME,'-',P_ROLEID), P_ROLEID, unix_timestamp(), unix_timestamp());
         SELECT id INTO P_ENROLID FROM mdl_enrol 
			WHERE courseid=P_COURSEID AND roleid=P_ROLEID AND enrol='manual' LIMIT 1;
		END IF;

	
	IF (P_SHORTNAME='KLS' AND P_ROLE IN ('regional', 'c_academico', 'diretor')) THEN 
			
			INSERT INTO mdl_user_preferences (userid, name, value) 
			SELECT P_USERID, 'auth_manual_passwordupdatetime', '1'
			FROM DUAL 
			WHERE NOT EXISTS (
				SELECT id FROM mdl_user_preferences 
				WHERE userid=P_USERID AND name='auth_manual_passwordupdatetime'
			);
	END IF;	


	
	IF (P_GRUPO<>'SEM_GRUPO') THEN 
	 SELECT id INTO P_GRUPOID FROM mdl_groups WHERE courseid=P_COURSEID AND description LIKE P_GRUPO LIMIT 1;	
	 
	 IF (P_GRUPOID IS NULL) THEN
		
		
		SET P_GRUPONOME=P_GRUPO;
		IF (P_GRUPO NOT REGEXP 'TUTOR') THEN

			SELECT 
				CODIGO_POLO, NOME_CURSO,CODIGO_DISCIPLINA,SERIE_ALUNO,TURMA_ALUNO
				INTO 
				P_CODIGO_POLO, P_NOME_CURSO,P_CODIGO_DISCIPLINA,P_SERIE,P_TURMA
			FROM anh_import_aluno_curso 
			WHERE SHORTNAME=P_SHORTNAME AND SIGLA=P_SIGLA
			LIMIT 1;
			
			SET P_GRUPONOME=CONCAT('Unidade: ',P_CODIGO_POLO,' Curso: ',P_NOME_CURSO,' Disciplina:',P_CODIGO_DISCIPLINA,' Serie: ',P_SERIE,' Turma: ',P_TURMA);

		END IF;
		
		INSERT INTO mdl_groups (courseid, name, description, timecreated) 
		VALUES 
		(P_COURSEID, P_GRUPONOME, P_GRUPO,unix_timestamp());
		SET P_GRUPOID=LAST_INSERT_ID();
		
		IF (P_TUTORID IS NOT NULL) THEN 

			SELECT id INTO P_ROLETUTOR FROM mdl_role WHERE shortname='tutor';
			
			IF (P_ROLETUTOR IS NULL) THEN 
				RETURN 'ERRO - perfil de tutor não existe';
	      END IF;

			DELETE FROM mdl_role_assignments WHERE userid=P_TUTORID AND contextid=P_CONTEXTID AND roleid=P_ROLETUTOR;
		   INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid) 
		   VALUES (P_ROLETUTOR, P_CONTEXTID, P_TUTORID, unix_timestamp(), 2);
		   INSERT INTO anh_academico_matricula (
						ID_MATRICULA_ATUAL, ID_PES_CUR_DISC, ID_PESSOA_TURMA, UNIDADE, CURSO,
						USERNAME, SHORTNAME, ROLE, GRUPO, DATA_MATRICULA, ORIGEM, SIGLA)
						VALUES (0, 0, 0, 'TUTOR', 'TUTOR', 
						P_TUTOR, P_SHORTNAME, 'tutor', P_GRUPO, date_format(now(),'%Y-%m-%d'), 'CARGA', 'TUT');
			SELECT id INTO P_ENROLTUTORID FROM mdl_enrol e 
			WHERE enrol='manual' and courseid=P_COURSEID 
			and roleid=P_ROLETUTOR  LIMIT 1;
			
			IF (P_ENROLTUTORID IS NULL) THEN 
	        	INSERT INTO mdl_enrol(enrol, status, courseid, name, roleid, timecreated, timemodified) 
	         VALUES ('manual', 0, P_COURSEID, CONCAT(P_SHORTNAME,'-',P_ROLETUTOR), P_ROLETUTOR, unix_timestamp(), unix_timestamp());
	         SELECT id INTO P_ENROLTUTORID FROM mdl_enrol 
				WHERE courseid=P_COURSEID AND roleid=P_ROLETUTOR AND enrol='manual' LIMIT 1;
			END IF;
  
		   DELETE FROM mdl_user_enrolments WHERE userid=P_TUTORID AND enrolid=P_ENROLTUTORID;
			INSERT INTO mdl_user_enrolments(status, enrolid, userid, timestart, timecreated, timemodified, timeend, modifierid) 
		   VALUES ('0', P_ENROLTUTORID, P_TUTORID, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 2);  		

			INSERT INTO mdl_groups_members (groupid, userid, timeadded) VALUES (P_GRUPOID, P_TUTORID, UNIX_TIMESTAMP());
		END IF;
	 END IF;
	END IF; 
	
	
	
	DELETE FROM mdl_role_assignments WHERE userid=P_USERID AND contextid=P_CONTEXTID AND roleid=P_ROLEID;
   INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid) 
   VALUES (P_ROLEID, P_CONTEXTID, P_USERID, unix_timestamp(), 2);
   
   DELETE FROM mdl_user_enrolments WHERE userid=P_USERID AND enrolid=P_ENROLID;
	INSERT INTO mdl_user_enrolments(status, enrolid, userid, timestart, timecreated, timemodified, timeend, modifierid) 
   VALUES ('0', P_ENROLID, P_USERID, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 2);   

	
	IF (P_GRUPO<>'SEM_GRUPO') THEN 	
    DELETE FROM mdl_groups_members WHERE userid=P_USERID AND groupid=P_GRUPOID;
    INSERT INTO mdl_groups_members (userid, groupid, timeadded) VALUES (P_USERID, P_GRUPOID, UNIX_TIMESTAMP());	
   END IF;


	IF (P_ROLE='student' AND P_SIGLA<>'SPF') THEN 

		INSERT INTO anh_aluno_matricula (ID_MATRICULA_ATUAL, ID_PES_CUR_DISC, ID_PESSOA_TURMA, UNIDADE, CURSO,
												USERNAME, SHORTNAME, ROLE, TUTOR, GRUPO, DATA_MATRICULA, ORIGEM, SIGLA)
												VALUES (P_IDANH, P_IDPC, P_IDPT, P_UNIDADE, P_CURSO, 
												P_USERNAME, P_SHORTNAME, P_ROLE, P_TUTOR, P_GRUPO, date_format(now(),'%Y-%m-%d'), 'CARGA', P_SIGLA);
	END IF;												

	IF (
		P_ROLE IN ('editingteacher', 'coordteacher','diretor','c_academico','regional','coordarea','tutor')
		OR
		P_SIGLA='SPF'
	) THEN 

		INSERT INTO anh_academico_matricula (ID_MATRICULA_ATUAL, ID_PES_CUR_DISC, ID_PESSOA_TURMA, UNIDADE, CURSO,
												USERNAME, SHORTNAME, ROLE, GRUPO, DATA_MATRICULA, ORIGEM, SIGLA)
												VALUES (P_IDANH, P_IDPC, P_IDPT, P_UNIDADE, P_CURSO, 
												P_USERNAME, P_SHORTNAME, P_ROLE, P_GRUPO, date_format(now(),'%Y-%m-%d'), 'CARGA', P_SIGLA);
	END IF;


	RETURN 'Matricula Efetuada com sucesso';


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
