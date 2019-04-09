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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_USUARIOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_USUARIOS`()
BEGIN

DECLARE V_ID            INT;
DECLARE V_ORIGEM 		VARCHAR(10);
DECLARE V_USERNAME 		VARCHAR(30);
DECLARE V_PASSWORD 		VARCHAR(100);
DECLARE V_FIRSTNAME 	VARCHAR(50);
DECLARE V_LASTNAME 		VARCHAR(100);
DECLARE V_EMAIL 		VARCHAR(50);
DECLARE V_CITY 			VARCHAR(100);
DECLARE V_UNIDADE 	VARCHAR(150);
DECLARE V_CURSO	VARCHAR(150);
DECLARE V_MARCA 		VARCHAR(50);
DECLARE V_SITUACAO 		VARCHAR(10);
DECLARE V_EMAILSTOP    INT;
DECLARE NODATA 			INT DEFAULT 0;
DECLARE LINHAS			INT;

DECLARE USUARIOS CURSOR FOR
	SELECT ID, ORIGEM, USERNAME, PASSWORD, FIRSTNAME, LASTNAME,
		   EMAIL, CITY, UNIDADE, CURSO, MARCA, SITUACAO
	FROM anh_import_aluno 
	WHERE 
	(
		DATA_IMPORTACAO = date_format(now(),'%Y-%m-%d')
		OR
		NOVA_TENTATIVA = date_format(now(),'%Y-%m-%d')
	)
	AND STATUS IS NULL
	ORDER BY SITUACAO ASC;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=1;


UPDATE anh_import_aluno SET NOVA_TENTATIVA=date_format(now(),'%Y-%m-%d') WHERE STATUS IS NULL;

OPEN USUARIOS;

USUARIO: LOOP

	SET NODATA=0;
	
	FETCH USUARIOS INTO V_ID, V_ORIGEM, V_USERNAME, V_PASSWORD, V_FIRSTNAME, V_LASTNAME,
						V_EMAIL, V_CITY, V_UNIDADE, V_CURSO, V_MARCA, V_SITUACAO;
	
	IF NODATA=1 THEN LEAVE USUARIO; END IF;
	
	SELECT COUNT(1) INTO LINHAS FROM mdl_user WHERE USERNAME=V_USERNAME and mnethostid=1;
	
		CASE V_SITUACAO
	
			WHEN 'B' THEN 
				IF LINHAS=0 THEN 
					UPDATE anh_import_aluno SET STATUS='ERRO' WHERE ID=V_ID;
				ELSE 
					UPDATE mdl_user SET deleted=1 WHERE USERNAME=V_USERNAME AND mnethostid=1;
					UPDATE anh_import_aluno SET STATUS='OK' WHERE ID=V_ID;
				END IF;
			
			WHEN 'I' THEN 
				IF LINHAS=0 THEN 
					
					SET V_EMAILSTOP=0;
					
					IF V_EMAIL like '%professor.moodle%' 
					  	or V_EMAIL like '%coordenador.moodle%' 
						or V_EMAIL like '%test%'
						or V_EMAIL like '%nd.com%'
						or V_EMAIL like '%naote%'
						or V_EMAIL like '%sem@%'
						or V_EMAIL like '%mail@%'
						or V_EMAIL like '%xxx%'
						or length(V_EMAIL)<10
						or V_EMAIL = 'ND' 
						or V_EMAIL not REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
						or instr(V_EMAIL,'@')<=3 
					THEN 
						SET V_EMAILSTOP=1; 
					END IF;

					INSERT INTO mdl_user (username, password, firstname, lastname, email, city, country, lang, timezone, confirmed, mnethostid, 
										  institution, department, emailstop, theme)
									   VALUES(V_USERNAME,V_PASSWORD,trim(V_FIRSTNAME),trim(V_LASTNAME) ,V_EMAIL,V_CITY,'BR','pt_br_utf8','-3.0',1,1, 
									   V_UNIDADE, V_CURSO,V_EMAILSTOP, V_MARCA);

					UPDATE anh_import_aluno SET STATUS='OK' WHERE ID=V_ID;
					

				ELSE
					UPDATE anh_import_aluno SET STATUS='ERRO' WHERE ID=V_ID;
				END IF;
			WHEN 'E' THEN 
				IF LINHAS=0 THEN 
				
					SET V_EMAILSTOP=0;
					
					IF V_EMAIL like '%professor.moodle%' 
					  	or V_EMAIL like '%coordenador.moodle%' 
						or V_EMAIL like '%test%'
						or V_EMAIL like '%nd.com%'
						or V_EMAIL like '%naote%'
						or V_EMAIL like '%sem@%'
						or V_EMAIL like '%mail@%'
						or V_EMAIL like '%xxx%'
						or length(V_EMAIL)<10
						or V_EMAIL = 'ND' 
						or V_EMAIL not REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
						or instr(V_EMAIL,'@')<=3 
					THEN 
						SET V_EMAILSTOP=1; 
					END IF;
									
					INSERT INTO mdl_user (username, password, firstname, lastname, email, city, country, lang, timezone, confirmed, mnethostid, 
										  institution, department,emailstop,theme)
									   VALUES(V_USERNAME,V_PASSWORD,trim(V_FIRSTNAME),trim(V_LASTNAME) ,V_EMAIL,V_CITY,'BR','pt_br_utf8','-3.0',1,1, 
									   V_UNIDADE, V_CURSO,V_EMAILSTOP,V_MARCA);
					UPDATE anh_import_aluno SET STATUS='OK' WHERE ID=V_ID;
				ELSE
					UPDATE mdl_user 
						SET 
							deleted 	= 0,
							password	= V_PASSWORD,
							firstname	= trim(V_FIRSTNAME),
							lastname	= trim(V_LASTNAME),
							email		= V_EMAIL,
							institution	= V_UNIDADE,
							department	= V_CURSO,
							city		= V_CITY,
							theme = V_MARCA
						WHERE 
							username = V_USERNAME and mnethostid=1;
					UPDATE anh_import_aluno SET STATUS='OK' WHERE ID=V_ID;
				END IF;

		END CASE;
		
END LOOP USUARIO;	


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
