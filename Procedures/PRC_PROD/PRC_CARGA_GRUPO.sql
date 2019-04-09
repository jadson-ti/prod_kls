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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_GRUPO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_GRUPO`()
BEGIN

DECLARE V_GRUPO            VARCHAR(150);
DECLARE V_SIGLA		VARCHAR(5);
DECLARE V_SHORTNAME  VARCHAR(150);
DECLARE V_COURSE_ID			INT;


DECLARE V_IDC INT;
DECLARE V_IDD INT;
DECLARE V_IDT INT;
DECLARE V_NOME_CURSO VARCHAR(150);
DECLARE V_CODIGO_POLO VARCHAR(30);
DECLARE V_CODIGO_DISCIPLINA VARCHAR(30);
DECLARE V_NOME_POLO VARCHAR(150);
DECLARE V_SERIE VARCHAR(30);
DECLARE V_TURMA VARCHAR(30);
DECLARE V_TURNO VARCHAR(30);
DECLARE V_NOME_GRUPO VARCHAR(255);
DECLARE NODATA 			INT DEFAULT FALSE;

DECLARE GRUPOS CURSOR FOR
SELECT DISTINCT 
	   SIGLA, GRUPO, c.SHORTNAME, c.id courseid, 
		iac.NOME_CURSO, iac.CODIGO_POLO, 
		iac.NOME_POLO, iac.SERIE_ALUNO, 
		iac.TURMA_ALUNO, 
		iac.CODIGO_DISCIPLINA, 
		iac.TURNO_CURSO
		
		FROM anh_import_aluno_curso iac 		
		INNER JOIN mdl_course c ON iac.SHORTNAME = c.shortname
		LEFT JOIN mdl_groups g ON g.courseid=c.id and (g.name=iac.GRUPO or g.description=iac.GRUPO)
		WHERE g.id is null and iac.status is null and iac.DATA_IMPORTACAO=date(now())
		and iac.situacao<>'B' and iac.GRUPO not in ('GRUPO_','SEM_GRUPO') ;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;

OPEN GRUPOS;

GRUPO: LOOP

	FETCH GRUPOS INTO V_SIGLA, V_GRUPO, V_SHORTNAME, V_COURSE_ID, 
	V_NOME_CURSO, V_CODIGO_POLO, V_NOME_POLO, V_SERIE, 
	V_TURMA, V_CODIGO_DISCIPLINA, V_TURNO; 
	
	IF NODATA THEN LEAVE GRUPO; END IF;
	
	IF (V_GRUPO NOT LIKE '%TUTOR%' AND V_SIGLA NOT IN ('KLS','EDCL','SCD')) THEN 

		SET V_NOME_GRUPO=CONCAT('Unidade: ',V_CODIGO_POLO,' Curso: ',V_NOME_CURSO,' Disciplina:',V_CODIGO_DISCIPLINA,' Serie: ',V_SERIE,' Turma: ',V_TURMA);
		INSERT INTO mdl_groups (courseid, name, description, timecreated) VALUES (V_COURSE_ID,V_NOME_GRUPO, V_GRUPO,	unix_timestamp());

	ELSE 

		INSERT INTO mdl_groups (courseid, name, description, timecreated) VALUES (V_COURSE_ID,V_GRUPO, V_GRUPO, unix_timestamp());
				
	END IF;
	
	SET NODATA=FALSE;
		
END LOOP GRUPO;	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
