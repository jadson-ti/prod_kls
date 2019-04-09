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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_MATRICULAS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_MATRICULAS`()
BEGIN

DECLARE V_ID INT;
DECLARE V_IDPC INT;
DECLARE V_IDPCD INT;
DECLARE V_IDPT INT;
DECLARE V_SIGLA VARCHAR(20);
DECLARE V_ORIGEM VARCHAR(20);
DECLARE V_CODIGO_POLO VARCHAR(10);
DECLARE V_NOME_POLO VARCHAR(255);
DECLARE V_CODIGO_CURSO VARCHAR(20);
DECLARE V_NOME_CURSO VARCHAR(200);
DECLARE V_CODIGO_DISCIPLINA VARCHAR(50);
DECLARE V_NOME_DISCIPLINA VARCHAR(150);
DECLARE V_SERIE_ALUNO VARCHAR(10);
DECLARE V_TURNO_CURSO VARCHAR(30);
DECLARE V_TURMA_ALUNO VARCHAR(20);
DECLARE V_USERNAME VARCHAR(50);
DECLARE V_SHORTNAME VARCHAR(100);
DECLARE V_GRUPO VARCHAR(100);
DECLARE V_ROLE VARCHAR(50);
DECLARE V_SITUACAO VARCHAR(5);
DECLARE V_STATUS VARCHAR(10);
DECLARE V_ID_SHORTNAME INT;
DECLARE V_ID_ROLE INT;
DECLARE V_ID_PESSOA_DISCIPLINA INT;
DECLARE V_ID_ENROL INT;
DECLARE V_ID_CONTEXT INT;
DECLARE V_USER_ID INT;
DECLARE V_GRUPO_ID INT;
DECLARE V_CHECK INT;
DECLARE V_UNIDADE VARCHAR(10);
DECLARE V_CURSO VARCHAR(20);
DECLARE V_TUTOR VARCHAR(30);
DECLARE V_LOG VARCHAR(255);
DECLARE NODATA	INT DEFAULT FALSE;
DECLARE V_BOOL INT;
DECLARE LINHAS			INT;

DECLARE MATRICULAS CURSOR FOR 
	SELECT 
				iac.ID
				, iac.SIGLA
				, iac.ID_PESSOA_CURSO
				, iac.ID_PES_CUR_DISC
				, iac.ID_PESSOA_TURMA
				, iac.ORIGEM 
				, iac.USERNAME
				, iac.SHORTNAME
				, iac.GRUPO
				, iac.ROLE
				, iac.SITUACAO
				, c.id CODIGO_CURSO
				, r.id CODIGO_REGRA
    			, e.id CODIGO_ENROL 
				, co.id CODIGO_CONTEXTO		
				, u.id as USERID
				, g.id as GROUPID
				, iac.CODIGO_POLO
				, iac.CODIGO_CURSO
				, iac.TUTOR
			 FROM anh_import_aluno_curso iac 			
				  INNER JOIN mdl_course c ON c.shortname = iac.SHORTNAME  
				  INNER JOIN mdl_role r ON r.shortname = iac.ROLE 
				  INNER JOIN mdl_context co ON co.instanceid = c.id AND contextlevel = 50
				  INNER JOIN mdl_user u ON u.username=iac.USERNAME and u.mnethostid=1
				  LEFT JOIN mdl_enrol e ON e.courseid=c.id and e.roleid=r.id and e.enrol='manual'
				  LEFT JOIN mdl_groups g on g.courseid=c.id and g.description LIKE iac.GRUPO
	WHERE 
	DATA_IMPORTACAO = date_format(now(),'%Y-%m-%d')
	AND iac.STATUS IS NULL and iac.LOG IS NULL 
	AND iac.GRUPO<>'GRUPO_'
	
	ORDER BY SITUACAO ASC;
	
DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;
DECLARE CONTINUE HANDLER FOR 1062 SET V_BOOL=1;


UPDATE anh_import_aluno_curso SET NOVA_TENTATIVA=date_format(now(),'%Y-%m-%d') 
WHERE STATUS IS NULL AND DATA_IMPORTACAO<>date_format(now(),'%Y-%m-%d');


OPEN MATRICULAS;

MATRICULA: LOOP

	SET NODATA=FALSE;

	FETCH MATRICULAS INTO V_ID, V_SIGLA, V_IDPC, V_IDPCD, V_IDPT, V_ORIGEM, V_USERNAME, V_SHORTNAME, V_GRUPO, V_ROLE, V_SITUACAO, V_ID_SHORTNAME, 
								 V_ID_ROLE, V_ID_ENROL, V_ID_CONTEXT, V_USER_ID, V_GRUPO_ID, V_UNIDADE, V_CURSO, V_TUTOR;
	IF NODATA THEN 
		LEAVE MATRICULA; 
	END IF;

	SELECT COUNT(1) INTO LINHAS FROM mdl_role_assignments WHERE userid=V_USER_ID AND contextid=V_ID_CONTEXT and roleid=V_ID_ROLE;
	

	IF (V_SITUACAO='B') THEN
							
					SELECT 
					bloquear(V_ID, V_USERNAME, V_SHORTNAME, V_GRUPO, V_ROLE, V_SIGLA)  
					INTO V_LOG
					FROM DUAL;

					IF (V_LOG='Bloqueio realizado com sucesso' OR V_LOG LIKE 'Foi realizado%') THEN 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='OK'
						WHERE ID=V_ID;
					ELSE 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='ERRO'
						WHERE ID=V_ID;
					END IF;
				
		
		END IF;

		IF (V_SITUACAO='S') THEN  
		
					SELECT 
					suspender(V_ID, V_USERNAME, V_SHORTNAME, V_GRUPO, V_ROLE, V_SIGLA)  
					INTO V_LOG
					FROM DUAL;

					IF (V_LOG='Matricula Suspensa com sucesso') THEN 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='OK'
						WHERE ID=V_ID;
					ELSE 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='ERRO'
						WHERE ID=V_ID;
					END IF;
		 
		END IF;

		IF (V_SITUACAO='D') THEN  
		
					SELECT 
					desbloquear(V_ID, V_USERNAME, V_SHORTNAME, V_GRUPO, V_ROLE, V_SIGLA)  
					INTO V_LOG
					FROM DUAL;

					IF (V_LOG='Matricula Desbloqueada com sucesso') THEN 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='OK'
						WHERE ID=V_ID;
					ELSE 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='ERRO'
						WHERE ID=V_ID;
					END IF;
		 
		END IF;
		
		IF (V_SITUACAO='I') THEN  

			
			IF (V_ROLE='student') THEN 

					SELECT 
					matricular(V_ID, V_IDPCD, V_IDPT, V_USERNAME, V_SHORTNAME, V_UNIDADE, V_CURSO, V_GRUPO, V_TUTOR, V_ROLE, V_SIGLA)  
					INTO V_LOG
					FROM DUAL;
					
					IF (V_LOG='Matricula Efetuada com sucesso') THEN 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='OK'
						WHERE ID=V_ID;
					ELSE 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='ERRO'
						WHERE ID=V_ID;
					END IF;

			END IF;
			
			
			IF (V_ROLE<>'student') THEN
					SELECT 
					matricular(V_ID, V_IDPCD, V_IDPT, V_USERNAME, V_SHORTNAME, V_UNIDADE, V_CURSO, V_GRUPO, NULL, V_ROLE, V_SIGLA)  
					INTO V_LOG
					FROM DUAL;
					
					IF (V_LOG='Matricula Efetuada com sucesso') THEN 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='OK'
						WHERE ID=V_ID;
					ELSE 
						UPDATE anh_import_aluno_curso 
							SET LOG=V_LOG, STATUS='ERRO'
						WHERE ID=V_ID;
					END IF;
			END IF;
			
			
		END IF;
	
END LOOP MATRICULA;

COMMIT;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
