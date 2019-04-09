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

-- Copiando estrutura para procedure prod_kls.PRC_SOMBRA
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_SOMBRA`(
	IN `P_USUARIO_ORIGEM` BIGINT,
	IN `P_USUARIO_DESTINO` BIGINT,
	IN `P_CURSO` BIGINT
)
MAIN: BEGIN

DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
DECLARE MSG_ 				VARCHAR(200);
DECLARE V_QTD_QUIZ INT(11) DEFAULT 0;
DECLARE V_QUIZ_COUNTER INT(11) DEFAULT 0;
DECLARE V_THIS_QUIZ BIGINT(10);
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
	GET DIAGNOSTICS CONDITION 1
     CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
     SET CODE_ = CONCAT('ERRO - ', CODE_);
     	SELECT CONCAT('Ocorreu um erro, executando rollback da operação: ',MSG_) FROM DUAL;
	  ROLLBACK;
	END;

START TRANSACTION;

DROP TABLE IF EXISTS tmp_sombra;
CREATE TEMPORARY TABLE tmp_sombra (
	userid BIGINT(10),
	courseid BIGINT(10),
	sectionid BIGINT(10),
	quizid BIGINT(10),
	coursemoduleid BIGINT(10),
	attempt INT(11),
	finalgrade FLOAT,
	slot INT(11),
	questionid BIGINT(10),
	sequencenumber INT(11),
	state VARCHAR(50),
	fraction FLOAT,
	attemptstepname VARCHAR(50),
	attemptstepvalue VARCHAR(100)
);

	
INSERT INTO tmp_sombra 	
SELECT 
	u.id,
	c.id,
	cs.id,
	q.id,
	cm.id,
	qa.attempt,
	gg.finalgrade,
	quea.slot,
	quea.questionid,
	qas.sequencenumber,
	qas.state,
	qas.fraction,
	qasd.name,
	qasd.value
FROM mdl_course c 
JOIN mdl_course_sections cs on cs.course=c.id
JOIN mdl_course_modules cm on find_in_set(cm.id, cs.sequence) 
JOIN mdl_modules m on m.id=cm.module and m.name='quiz'
JOIN mdl_quiz q on q.course=c.id and cm.instance=q.id
JOIN mdl_quiz_attempts qa on qa.quiz=q.id
JOIN mdl_grade_items gi on gi.courseid=c.id and gi.itemmodule='quiz' and gi.iteminstance=q.id
JOIN mdl_grade_grades gg on gg.userid=qa.userid and gg.itemid=gi.id and gg.finalgrade is not null
JOIN mdl_user u on u.id=gg.userid
JOIN mdl_question_attempts quea on quea.questionusageid=qa.uniqueid
JOIN mdl_question_attempt_steps qas on qas.questionattemptid=quea.id and qas.userid=qa.userid
JOIN mdl_question_attempt_step_data qasd on qasd.attemptstepid=qas.id
WHERE c.shortname REGEXP '^AMI' 
		AND u.mnethostid=1
		AND u.id=P_USUARIO_ORIGEM
		AND c.id=P_CURSO
ORDER BY  
	u.id, c.id, cs.section, 
	cm.instance, qa.attempt, 
	quea.slot, qas.sequencenumber,
	qasd.id;

SET V_QUIZ_COUNTER=-1;
SET V_QTD_QUIZ=(SELECT COUNT(DISTINCT quizid) FROM tmp_sombra);

WHILE (V_QUIZ_COUNTER<=V_QTD_QUIZ) DO 

	SET V_QUIZ_COUNTER=V_QUIZ_COUNTER+1;

	SELECT DISTINCT quizid INTO V_THIS_QUIZ FROM tmp_sombra ORDER BY quizid LIMIT V_QUIZ_COUNTER,1;
	IF (V_THIS_QUIZ IS NULL) THEN LEAVE MAIN; END IF;

	ATTEMPTS: BEGIN
	
		DECLARE V_QTD_TENTATIVAS INT(11);
		DECLARE V_TENTATIVAS_COUNTER INT(11);
		DECLARE V_ACTUAL_UNIQUEID BIGINT(10);
		DECLARE V_UNIQUE_ID BIGINT(10);
		DECLARE V_QUIZ_CONTEXT BIGINT(10);
		DECLARE V_CMID BIGINT(10);

		DROP TABLE IF EXISTS tmp_questionusages_depara;
		CREATE TEMPORARY TABLE tmp_questionusages_depara (
			quiz BIGINT(10),
			attempt INT(11),
			uniqueid BIGINT(10),
			new_uniqueid BIGINT(10)
		);
		DELETE FROM mdl_quiz_attempts WHERE userid=P_USUARIO_DESTINO AND quiz=V_THIS_QUIZ;
		
		SET V_TENTATIVAS_COUNTER=1;
		SELECT MAX(attempt) INTO V_QTD_TENTATIVAS FROM tmp_sombra WHERE quizid=V_THIS_QUIZ;
	
		WHILE (V_TENTATIVAS_COUNTER<=V_QTD_TENTATIVAS) DO
			
			SELECT DISTINCT coursemoduleid INTO V_CMID
			FROM tmp_sombra 
			WHERE userid=P_USUARIO_ORIGEM AND quizid=V_THIS_QUIZ AND attempt=V_TENTATIVAS_COUNTER;
			
			SELECT id INTO V_QUIZ_CONTEXT
			FROM mdl_context WHERE contextlevel=70 and instanceid=V_CMID;
			
			INSERT INTO mdl_question_usages (contextid, component, preferredbehaviour)
			VALUES (V_QUIZ_CONTEXT, 'mod_quiz', 'deferredfeedback');
			
			SET V_UNIQUE_ID=LAST_INSERT_ID();
			SET V_ACTUAL_UNIQUEID=(SELECT uniqueid FROM mdl_quiz_attempts WHERE quiz=V_THIS_QUIZ AND userid=P_USUARIO_ORIGEM AND attempt=V_TENTATIVAS_COUNTER);
			
			
			INSERT INTO tmp_questionusages_depara (quiz, attempt, uniqueid, new_uniqueid)
			VALUES (V_THIS_QUIZ, V_TENTATIVAS_COUNTER, V_ACTUAL_UNIQUEID, V_UNIQUE_ID);
			
			INSERT INTO mdl_quiz_attempts (
							quiz,userid,attempt,uniqueid,layout,currentpage,preview,
							state,timestart,timefinish,timemodified,timemodifiedoffline,
							timecheckstate,sumgrades)
			SELECT 
				quiz,P_USUARIO_DESTINO,V_TENTATIVAS_COUNTER,V_UNIQUE_ID,layout,currentpage,preview,
				state,timestart,timefinish,timemodified,timemodifiedoffline,
				timecheckstate,sumgrades
			FROM mdl_quiz_attempts 
			WHERE userid=P_USUARIO_ORIGEM and quiz=V_THIS_QUIZ AND attempt=V_TENTATIVAS_COUNTER;
			
			SET V_TENTATIVAS_COUNTER=V_TENTATIVAS_COUNTER+1;
		
		END WHILE;
	
	END ATTEMPTS;
	
	QUIZ_GRADE: BEGIN 
	
		DECLARE V_NOTA FLOAT;
		DECLARE V_HORA BIGINT(10);
		
		SET V_NOTA=(SELECT MAX(grade) FROM mdl_quiz_grades WHERE quiz=V_THIS_QUIZ AND userid=P_USUARIO_ORIGEM);
		SET V_HORA=(SELECT MAX(timemodified) FROM mdl_quiz_grades WHERE quiz=V_THIS_QUIZ AND userid=P_USUARIO_ORIGEM);
		
		DELETE FROM mdl_quiz_grades WHERE userid=P_USUARIO_DESTINO AND quiz=V_THIS_QUIZ;
		INSERT INTO mdl_quiz_grades (quiz, userid, grade, timemodified)
		VALUES (V_THIS_QUIZ, P_USUARIO_DESTINO, V_NOTA, V_HORA);
		
	END QUIZ_GRADE;
	
	GRADE_GRADES: BEGIN
		
		
		DECLARE V_ITEM_ID BIGINT(10);
		
		SET V_ITEM_ID=(SELECT id FROM mdl_grade_items gi WHERE gi.courseid=P_CURSO AND gi.itemmodule='quiz' and gi.iteminstance=V_THIS_QUIZ);

		DELETE FROM mdl_grade_grades WHERE userid=P_USUARIO_DESTINO AND itemid=V_ITEM_ID;
				
		INSERT INTO mdl_grade_grades (
			itemid, userid, rawgrade, rawgrademax, rawgrademin, rawscaleid,
			usermodified,finalgrade, hidden, locked, locktime, exported,
			overridden, excluded, feedback, feedbackformat, information,
			informationformat, timecreated, timemodified,
			aggregationstatus, aggregationweight
		)
		select 
			itemid, P_USUARIO_DESTINO, rawgrade, rawgrademax, rawgrademin, rawscaleid,
			usermodified,finalgrade, hidden, locked, locktime, exported,
			overridden, excluded, feedback, feedbackformat, information,
			informationformat, timecreated, timemodified,
			aggregationstatus, aggregationweight
		from mdl_grade_grades 
		WHERE userid=P_USUARIO_ORIGEM AND itemid=V_ITEM_ID;	
	
	END GRADE_GRADES;
	
	QUESTION_ATTEMPTS: BEGIN
		
		DECLARE V_OLD_UID BIGINT(10);
		DECLARE V_NEW_UID BIGINT(10);
		DECLARE NODATA INT(11) DEFAULT 0;
		DECLARE C_QUESTIONUSAGE CURSOR FOR SELECT uniqueid, new_uniqueid FROM tmp_questionusages_depara;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=1;
		
		OPEN C_QUESTIONUSAGE;
		
		QU: LOOP
		
		SET NODATA=0;
		
		FETCH C_QUESTIONUSAGE INTO V_OLD_UID, V_NEW_UID;
		
		IF NODATA THEN LEAVE QU; END IF;
		
		INSERT INTO mdl_question_attempts (
			questionusageid, slot, behaviour,questionid,variant,
			maxmark,minfraction,maxfraction,flagged,questionsummary,
			rightanswer,responsesummary,timemodified
		)
		SELECT
			V_NEW_UID, slot, behaviour,questionid,variant,
			maxmark,minfraction,maxfraction,flagged,questionsummary,
			rightanswer,responsesummary,timemodified
		FROM mdl_question_attempts 
		WHERE questionusageid=V_OLD_UID;
	
		QUESTION_ATTEMPT_STEPS: BEGIN
		
			DECLARE V_QAID BIGINT(10);
			DECLARE V_SLOT INT(11);
			DECLARE C_QA CURSOR FOR SELECT id, slot FROM mdl_question_attempts WHERE questionusageid=V_NEW_UID;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=1;
			
			OPEN C_QA;
			
			L_QA: LOOP
		
				SET NODATA=0;
				
				FETCH C_QA INTO V_QAID, V_SLOT;
				
				IF NODATA THEN LEAVE L_QA; END IF;
		
				INSERT INTO mdl_question_attempt_steps (
					questionattemptid, sequencenumber, state, fraction,
					timecreated, userid
				)	
				SELECT 
					V_QAID, sequencenumber, state, fraction, 
					timecreated, P_USUARIO_DESTINO
				FROM mdl_question_attempt_steps a
				WHERE questionattemptid=(
						SELECT id 
						FROM mdl_question_attempts s
						WHERE questionusageid=V_OLD_UID
						AND s.slot=V_SLOT
				);
									
				QUESTION_ATTEMPT_STEPS_DATA: BEGIN
				
					DECLARE V_QAS BIGINT(10);
					DECLARE V_INTERNAL_SLOT BIGINT(10);
					DECLARE V_SEQUENCENUMBER INT(11);
					DECLARE C_QAS CURSOR FOR 
							SELECT a.id, qa.slot, a.sequencenumber 
							FROM mdl_question_attempt_steps a
							JOIN mdl_question_attempts qa on qa.id=a.questionattemptid
							WHERE questionattemptid=V_QAID;	
					DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=1;
					
					OPEN C_QAS;
					
					L_QAS: LOOP

						SET NODATA=0;
						
						FETCH C_QAS INTO V_QAS, V_INTERNAL_SLOT, V_SEQUENCENUMBER;
						
						IF NODATA THEN LEAVE L_QAS; END IF;
						
							insert into mdl_question_attempt_step_data (attemptstepid, name, value)
							select V_QAS, name, value
							from mdl_question_attempt_step_data a
							where a.attemptstepid in (
									select id from mdl_question_attempt_steps b
									where b.questionattemptid in (
											select id from mdl_question_attempts c
											where 
		  									c.slot=V_INTERNAL_SLOT and
		  									c.questionusageid in (
													select uniqueid from mdl_quiz_attempts
													where userid=P_USUARIO_ORIGEM and quiz=V_THIS_QUIZ
											) 
									) and b.sequencenumber=V_SEQUENCENUMBER
							);

					
					END LOOP L_QAS;

					CLOSE C_QAS;
			
				END QUESTION_ATTEMPT_STEPS_DATA;

			END LOOP L_QA;
			
			CLOSE C_QA; 
			
		END QUESTION_ATTEMPT_STEPS;
	
	END LOOP QU;
	
	CLOSE C_QUESTIONUSAGE;
	
	END QUESTION_ATTEMPTS;
	
	
END WHILE;

COMMIT;

FILA_CONTINUADA: BEGIN

	INSERT INTO mdl_local_kca_obs_modquiz (userid, quizid, timecreated)
	SELECT 
		DISTINCT P_USUARIO_DESTINO, quizid, unix_timestamp()
	FROM tmp_sombra;

END FILA_CONTINUADA;


END MAIN//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
