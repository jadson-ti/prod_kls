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

-- Copiando estrutura para procedure prod_kls.PRC_ALOCAR_TUTORES_NPJ
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ALOCAR_TUTORES_NPJ`()
BEGIN


UPDATE anh_import_aluno_curso PARTITION (NPJV) iac
JOIN mdl_course c on c.shortname=iac.shortname
LEFT JOIN mdl_sgt_formacao_disciplina SGT ON SGT.shortname=c.shortname
SET LOG='Disciplina não possui área de formação'
WHERE STATUS IS NULL AND SITUACAO='I' AND SGT.id IS NULL;

PROCESSO: BEGIN

DECLARE V_ANH_ID INT;
DECLARE V_IDPC INT;
DECLARE V_IDPT INT;
DECLARE V_COURSE_ID INT;
DECLARE ADDALUNO INT;
DECLARE ADDALUNO_UC INT;
DECLARE V_PERIODO INT;
DECLARE V_CONTEXT_ID INT;
DECLARE V_ROLE_ID INT;
DECLARE V_COUNT INT;
DECLARE V_NOVO_TUTOR INT;
DECLARE V_USERNAME  VARCHAR(30);
DECLARE V_SHORTNAME VARCHAR(50);
DECLARE V_AF_ID INT;
DECLARE V_AF_SIGLA VARCHAR(10);
DECLARE V_UNIDADE VARCHAR(10);
DECLARE V_CURSO VARCHAR(20);
DECLARE V_TUTOR_ID INT;
DECLARE V_SENHA VARCHAR(5);
DECLARE V_AREA_CON VARCHAR(50);
DECLARE V_GRUPO VARCHAR(50);
DECLARE V_GRUPO_ID INT;
DECLARE V_LOG VARCHAR(150);
DECLARE V_MODELO INT;
DECLARE V_STATUS VARCHAR(20);
DECLARE NODATA INT DEFAULT FALSE;
DECLARE V_TUTOR VARCHAR(30);
DECLARE V_QTD_ALUNOS_TOTAL INT DEFAULT 0;
DECLARE V_QTD_ALUNOS_UND INT DEFAULT 0;
DECLARE V_QTD_DISCIPLINAS INT DEFAULT 0;
DECLARE V_QTD_DISC_ALUNO INT DEFAULT 0;
DECLARE V_QTD_ALUNOS_UNIDADE_CURSO INT DEFAULT 0;
DECLARE T_USUARIOID INT;
DECLARE SEQ_NOVO_TUTOR INT;
DECLARE NOVO_MDL_USER INT;
DECLARE ALUNOS CURSOR FOR
		SELECT 
		anh.ID as id1, 
		anh.ID_PES_CUR_DISC, 
		anh.ID_PESSOA_TURMA,
		anh.username, 
		c.id, c.shortname, 
		anh.CODIGO_POLO as UNIDADE,  
		anh.CODIGO_CURSO as CURSO
	FROM anh_import_aluno_curso PARTITION (NPJV) anh
	JOIN mdl_user u on u.username=anh.username AND u.mnethostid=1
	JOIN mdl_course c on c.shortname=anh.shortname
	WHERE 
		GRUPO='GRUPO_' AND 
		STATUS IS NULL AND 
		LOG IS NULL AND 
		anh.ROLE='student' AND EXISTS (
			SELECT sgt.id
			FROM mdl_sgt_formacao_disciplina sgt
			WHERE sgt.shortname=c.shortname
		);
	
DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;



SELECT id INTO V_MODELO FROM mdl_sgt_modelo WHERE sigla='NPJ';

DROP TABLE IF EXISTS controle_tutores_npj;
CREATE TABLE controle_tutores_npj (
	username VARCHAR(30),
	qtd_alunos INT
);
ALTER TABLE controle_tutores_npj ADD PRIMARY KEY (username);

INSERT INTO controle_tutores_npj 
SELECT TUTOR, count(distinct USERNAME) 
FROM anh_aluno_matricula PARTITION (NPJV)
GROUP BY TUTOR

ORDER BY TUTOR;


INSERT INTO controle_tutores_npj
SELECT DISTINCT 
mdl.username AS TUTOR, 0
FROM mdl_sgt_usuario U
JOIN mdl_sgt_usuario_moodle UMO ON U.id=UMO.id_usuario_id
JOIN mdl_user mdl ON mdl.id=UMO.mdl_user_id
JOIN mdl_sgt_usuario_modelo UM ON UM.id_usuario=U.ID AND UM.id_modelo=V_MODELO
LEFT JOIN (
	SELECT TUTOR, count(distinct USERNAME) 
	FROM anh_aluno_matricula PARTITION (NPJV)
	GROUP BY TUTOR
	ORDER BY TUTOR
) a on a.tutor=mdl.username
where a.tutor is null  AND U.status='A';	

DROP TABLE IF EXISTS controle_tutores_npj_uc;
CREATE TABLE controle_tutores_npj_uc (
	username VARCHAR(30),
	unidade varchar(20),
	curso varchar(20),
	qtd_alunos INT
);
ALTER TABLE controle_tutores_npj_uc ADD PRIMARY KEY (username,unidade,curso);

INSERT INTO controle_tutores_npj_uc 
SELECT * FROM (
SELECT 
	t.username,
	anh.unidade,
	anh.curso,
	COUNT(DISTINCT anh.username)
FROM controle_tutores_npj t
JOIN anh_aluno_matricula PARTITION (NPJV) anh on anh.tutor=t.username 
GROUP BY t.username,anh.unidade,anh.curso 
) A; 


OPEN ALUNOS;

ALUNO: LOOP

	
	SET ADDALUNO=1;
	SET ADDALUNO_UC=1;
	SET NODATA=FALSE;
	SET V_GRUPO=NULL;
	SET V_GRUPO_ID=NULL;
	SET V_TUTOR_ID=NULL;
	SET V_TUTOR=NULL;
	SET V_QTD_DISC_ALUNO=0;
	SET V_QTD_DISCIPLINAS=0;	
	
	FETCH ALUNOS INTO V_ANH_ID, V_IDPC, V_IDPT, V_USERNAME, V_COURSE_ID, V_SHORTNAME, V_UNIDADE, V_CURSO;
	
	IF NODATA THEN LEAVE ALUNO; END IF;
	

	ALOCACAO: BEGIN 	
	
		
		TUTORESATIVOS: BEGIN 
		
			DECLARE AREASNODATA INT DEFAULT FALSE;
			DECLARE AREAS CURSOR FOR
			SELECT 
				sgt_fd.id_area_formacao, sgt_af.dsc_area_formacao, sgt_af.sigla AS SIGLA_AF			
			FROM mdl_course c
			JOIN mdl_sgt_formacao_disciplina sgt_fd ON sgt_fd.shortname=c.shortname
			JOIN mdl_sgt_area_formacao sgt_af ON sgt_af.id=sgt_fd.id_area_formacao		
			WHERE c.shortname=V_SHORTNAME
			ORDER BY sgt_fd.nivel;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET AREASNODATA=TRUE;
	
			OPEN AREAS;
			
			AREALOOP: LOOP

				SET AREASNODATA = FALSE;
				
				FETCH AREAS INTO V_AF_ID, V_AREA_CON, V_AF_SIGLA;
			
				IF AREASNODATA THEN LEAVE AREALOOP; END IF;
			
				
				SET V_GRUPO=NULL;
				SET V_GRUPO_ID=NULL;
				SET V_TUTOR_ID=NULL;
				SET V_TUTOR=NULL;
				SET V_QTD_DISC_ALUNO=0;
				SET V_QTD_DISCIPLINAS=0;
				SET V_PERIODO=1;

				TUTORDOALUNO: BEGIN 

					
					
					
					SELECT
						TUTOR INTO V_TUTOR
					FROM (	
						SELECT 
							TUTOR 
						FROM anh_aluno_matricula PARTITION (NPJV) mat 
						JOIN mdl_user mdl on mdl.username=mat.TUTOR and mdl.mnethostid=1
						JOIN mdl_sgt_usuario_moodle umo ON umo.mdl_user_id=mdl.id
						JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=umo.id_usuario_id 
						JOIN mdl_sgt_formacao_disciplina fd on fd.shortname=mat.shortname 
						JOIN mdl_sgt_usuario_formacao uf on uf.id_area_formacao=fd.id_area_formacao
						WHERE mat.USERNAME=V_USERNAME  AND 
						uf.id_area_formacao=V_AF_ID AND
						V_AF_ID IN (SELECT id_area_formacao FROM mdl_sgt_formacao_disciplina WHERE SHORTNAME=V_SHORTNAME)
						GROUP BY TUTOR
				) A
				ORDER BY TUTOR
				LIMIT 1;		
	
					
					
					IF (V_TUTOR IS NOT NULL) THEN
							
						SET V_QTD_ALUNOS_UNIDADE_CURSO=0;
						SET V_COUNT=0;
						
						SELECT qtd_alunos 
						INTO V_QTD_ALUNOS_UNIDADE_CURSO 
						FROM controle_tutores_npj_uc 
						WHERE username=V_TUTOR AND 
						unidade=V_UNIDADE AND 
						curso=V_CURSO;

						SELECT 
							COUNT(1) INTO V_COUNT 
						FROM anh_aluno_matricula PARTITION (NPJV)
						WHERE USERNAME=V_USERNAME AND TUTOR=V_TUTOR;
						
						SET V_QTD_ALUNOS_UNIDADE_CURSO=V_QTD_ALUNOS_UNIDADE_CURSO-V_COUNT;
						SET V_COUNT=0;

						IF (V_QTD_ALUNOS_UNIDADE_CURSO>=50) THEN
							SET V_TUTOR=NULL;
						END IF;

					END IF;
					
					IF (V_TUTOR IS NOT NULL) THEN 
						
						SET V_QTD_ALUNOS_UNIDADE_CURSO=0;
						SELECT COUNT(1) INTO V_QTD_ALUNOS_UNIDADE_CURSO
						FROM anh_aluno_matricula PARTITION (NPJV)
						WHERE 
							TUTOR=V_TUTOR AND 
							UNIDADE=V_UNIDADE AND 
							CURSO=V_CURSO AND 
							USERNAME=V_USERNAME;

						
						
						SET ADDALUNO=0;
						
						IF (V_QTD_ALUNOS_UNIDADE_CURSO>0) THEN
							SET ADDALUNO_UC=0;
						END IF;

						LEAVE AREALOOP;
					END IF;
				
				
				END TUTORDOALUNO;
					
				
				
				
				
				SELECIONATUTOR: BEGIN 
			
					DECLARE FIMLISTA INT DEFAULT FALSE;
					DECLARE TUTORUSER VARCHAR(30);
					DECLARE TUTORES CURSOR FOR

						SELECT TUTOR FROM (
						SELECT 
							username AS TUTOR,
							qtd_alunos AS QTD_ALUNOS_TUTOR
						FROM controle_tutores_npj mat
						JOIN (
							SELECT  
								u.id as sgt_uid,
								mdl.username AS TUTOR, uf.id_area_formacao, 
								uc.qtd_alunos AS LIMITE
							FROM mdl_sgt_usuario u
							JOIN mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=V_AF_ID
							JOIN mdl_sgt_usuario_moodle umo ON u.id=umo.id_usuario_id
							JOIN mdl_user mdl ON mdl.id=umo.mdl_user_id
							JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=u.id and um.id_modelo=V_MODELO
							JOIN mdl_sgt_usuario_capacidade uc on uc.id_usuario=u.id and uc.id_modelo=um.id_modelo
							WHERE u.status='A' and uc.qtd_alunos>0
							GROUP BY u.id, mdl.username, uc.qtd_alunos
						) A ON mat.username=A.TUTOR AND mat.qtd_alunos<A.LIMITE AND A.LIMITE>0
						GROUP BY TUTOR
						) B 
					ORDER BY TUTOR;
					
					DECLARE CONTINUE HANDLER FOR NOT FOUND SET FIMLISTA=TRUE;
			
					OPEN TUTORES;
						
					TUTOR: LOOP
						
						SET FIMLISTA=FALSE;
						
						FETCH TUTORES INTO TUTORUSER;
					
						IF FIMLISTA THEN LEAVE TUTOR; END IF;
						
						SET V_TUTOR=TUTORUSER;
						
						
						IF (V_TUTOR IS NOT NULL) THEN
							
								SET V_QTD_ALUNOS_UNIDADE_CURSO=0;
								SELECT qtd_alunos 
								INTO V_QTD_ALUNOS_UNIDADE_CURSO 
								FROM controle_tutores_npj_uc 
								WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
								
								IF (V_QTD_ALUNOS_UNIDADE_CURSO>=50) THEN
									SET V_TUTOR=NULL;
								END IF;
						END IF;
						
						IF (V_TUTOR IS NOT NULL) 
							THEN LEAVE AREALOOP; 
						END IF;
					
					END LOOP TUTOR;
				
				END SELECIONATUTOR;				
	
			END LOOP AREALOOP;
		
		END TUTORESATIVOS;
			
		IF (V_TUTOR IS NULL) THEN
		
			NOVOUSUARIO: BEGIN
		
				SET T_USUARIOID=NULL;
					
				SELECT
					u.id INTO T_USUARIOID
				FROM mdl_sgt_usuario u
				JOIN mdl_sgt_usuario_formacao uf ON uf.id_usuario=u.id
				JOIN mdl_sgt_usuario_capacidade uc on uc.id_usuario=u.id and uc.id_modelo=V_MODELO AND uc.qtd_alunos>0				
				LEFT JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=u.id
				LEFT JOIN mdl_sgt_usuario_moodle umo ON umo.id_usuario_id=u.id
				WHERE u.status='A' AND um.id IS NULL and umo.id_usuario_id is null and uf.id_area_formacao=V_AF_ID
				ORDER BY nivel
				LIMIT 1;
					
				IF (T_USUARIOID IS NOT NULL) THEN
				
					INSERT INTO mdl_sgt_usuario_modelo (id_usuario, id_modelo) VALUES (T_USUARIOID, V_MODELO);
					INSERT INTO mdl_user (username, password, firstname, lastname, email, city, country, lang, timezone, confirmed, mnethostid, 
									institution, department,emailstop,timecreated)
								VALUES(CONCAT('tutor_npj_',T_USUARIOID),md5('tutor@kroton'),'TUTOR',' NPJ' ,'sucess@simulator.amazones.com','','BR','pt_br_utf8','-3.0',1,1, 
								'', '',0, unix_timestamp(now()));
					SET NOVO_MDL_USER=LAST_INSERT_ID();
					SET V_TUTOR=CONCAT('tutor_npj_',T_USUARIOID);
					
					INSERT INTO mdl_sgt_usuario_moodle (id_usuario_id,mdl_user_id,mdl_username) 
					VALUES (T_USUARIOID,NOVO_MDL_USER,V_TUTOR);	
					
					INSERT INTO controle_tutores_npj (username, qtd_alunos) VALUES (V_TUTOR,0);
				

				END IF;
			
			END NOVOUSUARIO;
			
		END IF;
	
	END ALOCACAO;

	IF (V_TUTOR IS NOT NULL) THEN 	
		SET V_GRUPO=CONCAT('GRUPO_',V_TUTOR);
		SET V_LOG=matricular(V_ANH_ID, V_IDPC, V_IDPT, V_USERNAME, V_SHORTNAME, V_UNIDADE, V_CURSO, V_GRUPO, V_TUTOR, 'student', 'NPJV');
		IF (V_LOG LIKE 'Erro%') THEN 
			SET V_STATUS='ERRO';
		ELSE 
			UPDATE controle_tutores_npj SET qtd_alunos=qtd_alunos+ADDALUNO WHERE username=V_TUTOR;
			SET V_COUNT=0;
			SELECT COUNT(1) INTO V_COUNT
			FROM controle_tutores_npj_uc 
			WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
			
			IF V_COUNT=0 THEN 
				INSERT INTO controle_tutores_npj_uc (USERNAME, CURSO, UNIDADE, QTD_ALUNOS)			
				VALUES (V_TUTOR, V_CURSO, V_UNIDADE, 1);				
			ELSE 
				UPDATE controle_tutores_npj_uc SET qtd_alunos=qtd_alunos+ADDALUNO_UC 
				WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
			END IF;
			
			SET V_STATUS='OK';
		END IF;
		UPDATE anh_import_aluno_curso PARTITION (NPJV) SET TUTOR=V_TUTOR, GRUPO=V_GRUPO, STATUS=V_STATUS, LOG=V_LOG WHERE ID=V_ANH_ID;
	ELSE 
		UPDATE anh_import_aluno_curso PARTITION (NPJV) SET LOG='Não foi possível alocar um tutor, aguardando cadastro' WHERE ID=V_ANH_ID;
   END IF;
	
	
	
END LOOP ALUNO;

DROP TABLE IF EXISTS controle_tutores_npj;
DROP TABLE IF EXISTS controle_tutores_npj_uc;



END PROCESSO;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
