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

-- Copiando estrutura para procedure prod_kls.PRC_ALOCAR_TUTORES_DI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ALOCAR_TUTORES_DI`()
BEGIN


UPDATE anh_import_aluno_curso PARTITION (DI) iac
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
DECLARE V_CONTEXT_ID INT;
DECLARE V_ROLE_ID INT;
DECLARE V_COUNT INT;
DECLARE V_NOVO_TUTOR INT;
DECLARE V_USERNAME  VARCHAR(50);
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
DECLARE V_PM INT;
DECLARE ALUNOS CURSOR FOR
		SELECT 
		anh.ID as id1, 
		anh.ID_PES_CUR_DISC, 
		anh.ID_PESSOA_TURMA,
		anh.username, 
		c.id, c.shortname, 
		anh.CODIGO_POLO as UNIDADE,  
		anh.CODIGO_CURSO as CURSO,
		(select count(1) from anh_aluno_matricula where username=anh.username and tutor LIKE 'tutor_di\_%')
		+
		(select count(1) from anh_import_aluno_curso partition (di) where status is null and username=anh.username) as qtd
	FROM anh_import_aluno_curso PARTITION (DI) anh
	JOIN mdl_user u on u.username=anh.username 
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



SELECT id INTO V_MODELO FROM mdl_sgt_modelo WHERE sigla='DI';

DROP TABLE IF EXISTS controle_tutores_di;
CREATE TABLE controle_tutores_di (
	username VARCHAR(30),
	qtd_alunos INT
);
ALTER TABLE controle_tutores_di ADD PRIMARY KEY (username);

INSERT INTO controle_tutores_di 
SELECT TUTOR, count(distinct USERNAME) AS ALUNOS
FROM anh_aluno_matricula anh
JOIN mdl_course c on c.shortname=anh.shortname
WHERE SIGLA='DI' AND TUTOR LIKE 'tutor_di\_%'
GROUP BY TUTOR
ORDER BY TUTOR;



INSERT INTO controle_tutores_di
SELECT DISTINCT 
mdl.username AS TUTOR, 0
FROM mdl_sgt_usuario U
JOIN mdl_sgt_usuario_moodle UMO ON U.id=UMO.id_usuario_id
JOIN mdl_user mdl ON mdl.id=UMO.mdl_user_id
JOIN mdl_sgt_usuario_modelo UM ON UM.id_usuario=U.ID AND UM.id_modelo=V_MODELO
LEFT JOIN (
	SELECT TUTOR, count(distinct USERNAME) 
	FROM anh_aluno_matricula PARTITION (DI)
	GROUP BY TUTOR
) a on a.tutor=mdl.username
where a.tutor is null AND U.status='A';

DROP TABLE IF EXISTS controle_tutores_di_uc;
CREATE TABLE controle_tutores_di_uc (
	username VARCHAR(30),
	unidade varchar(20),
	curso varchar(20),
	qtd_alunos INT
);
ALTER TABLE controle_tutores_di_uc ADD PRIMARY KEY (username,unidade,curso);

INSERT INTO controle_tutores_di_uc 
SELECT * FROM (
SELECT 
	t.username,
	anh.unidade,
	anh.curso,
	COUNT(DISTINCT anh.username)
FROM controle_tutores_di t
JOIN anh_aluno_matricula anh on anh.tutor=t.username 
GROUP BY t.username,anh.unidade,anh.curso 
) A; 

DROP TABLE IF EXISTS controle_di_disciplinas;

CREATE TABLE controle_di_disciplinas AS
	SELECT TUTOR, SHORTNAME
	FROM anh_aluno_matricula PARTITION (DI)
	GROUP BY TUTOR, SHORTNAME;
ALTER TABLE `controle_di_disciplinas`
	ALTER `TUTOR` DROP DEFAULT;
ALTER TABLE `controle_di_disciplinas`
	CHANGE COLUMN `TUTOR` `TUTOR` VARCHAR(30) NOT NULL COLLATE 'latin1_swedish_ci' FIRST,
	ADD PRIMARY KEY (`SHORTNAME`, `TUTOR`);

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
	
	FETCH ALUNOS INTO V_ANH_ID, V_IDPC, V_IDPT, V_USERNAME, V_COURSE_ID, V_SHORTNAME, V_UNIDADE, V_CURSO, V_PM;
	
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

				TUTORDOALUNO: BEGIN 

					
					
				
					IF (V_PM>1) THEN 
	
						SELECT 
							TUTOR INTO V_TUTOR
						FROM anh_aluno_matricula PARTITION (DI) mat 
						JOIN mdl_user mdl on mdl.username=mat.TUTOR and mdl.mnethostid=1
						JOIN mdl_sgt_usuario_moodle umo ON umo.mdl_user_id=mdl.id
						JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=umo.id_usuario_id 
						JOIN mdl_sgt_formacao_disciplina fd on fd.shortname=mat.shortname 
						JOIN mdl_sgt_usuario_formacao uf on uf.id_area_formacao=fd.id_area_formacao and uf.id_usuario=umo.id_usuario_id
						WHERE mat.USERNAME=V_USERNAME AND uf.id_area_formacao=V_AF_ID 
						GROUP BY TUTOR
						ORDER BY mdl.id
						LIMIT 1;	
	
					END IF;
					
					
					
					IF (V_TUTOR IS NOT NULL) THEN 

							SELECT COUNT(1) INTO V_QTD_DISCIPLINAS 
							FROM controle_di_disciplinas WHERE TUTOR=V_TUTOR AND SHORTNAME<>V_SHORTNAME;
				
						IF (V_QTD_DISCIPLINAS>=15) THEN 
						
						
							SET V_TUTOR=NULL;
						END IF;
					END IF;
					
					IF (V_TUTOR IS NOT NULL) THEN 
						
						SET V_QTD_ALUNOS_UNIDADE_CURSO=0;
						SELECT COUNT(1) INTO V_QTD_ALUNOS_UNIDADE_CURSO
						FROM anh_aluno_matricula PARTITION (DI)
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
						FROM controle_tutores_di mat
						JOIN (
							SELECT DISTINCT 
								mdl.username AS TUTOR, uf.id_area_formacao, 
								uc.qtd_alunos AS LIMITE
							FROM mdl_sgt_usuario u
							JOIN mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=V_AF_ID
							JOIN mdl_sgt_usuario_moodle umo ON u.id=umo.id_usuario_id
							JOIN mdl_user mdl ON mdl.id=umo.mdl_user_id
							JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=u.id and um.id_modelo=V_MODELO
							JOIN mdl_sgt_usuario_capacidade uc on uc.id_usuario=u.id and uc.id_modelo=um.id_modelo
							WHERE u.status='A' and uc.qtd_alunos>0 
						) A ON mat.username=A.TUTOR AND mat.qtd_alunos<A.LIMITE
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
								FROM controle_tutores_di_uc 
								WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
								
								
								IF (V_QTD_ALUNOS_UNIDADE_CURSO>=50) THEN
									SET V_TUTOR=NULL;
								END IF;
						END IF;
	
						
						IF (V_TUTOR IS NOT NULL) THEN 
							
							SELECT COUNT(1) INTO V_QTD_DISCIPLINAS 
							FROM controle_di_disciplinas WHERE TUTOR=V_TUTOR AND SHORTNAME<>V_SHORTNAME;
							
							IF (V_QTD_DISCIPLINAS>=15) THEN 
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
				DECLARE T_USUARIOID INT;
				DECLARE SEQ_NOVO_TUTOR INT;
				DECLARE NOVO_MDL_USER INT;
		
				SET T_USUARIOID=NULL;
					
				SELECT
					u.id INTO T_USUARIOID
				FROM mdl_sgt_usuario u
				JOIN mdl_sgt_usuario_formacao uf ON uf.id_usuario=u.id
				JOIN mdl_sgt_usuario_capacidade uc on uc.id_usuario=u.id and uc.id_modelo=V_MODELO AND uc.qtd_alunos>0
				LEFT JOIN mdl_sgt_usuario_modelo um ON um.id_usuario=u.id
				LEFT JOIN mdl_sgt_usuario_moodle umo ON umo.id_usuario_id=u.id
				WHERE um.id IS NULL and umo.id_usuario_id is null and uf.id_area_formacao IN (
							SELECT id_area_formacao 
							FROM mdl_sgt_formacao_disciplina 
							WHERE SHORTNAME=V_SHORTNAME
				)
				AND u.status='A' 
				ORDER BY nivel
				LIMIT 1;

				IF (T_USUARIOID IS NOT NULL) THEN
				
					SET V_TUTOR=CONCAT('tutor_di_',T_USUARIOID);

					INSERT INTO mdl_sgt_usuario_modelo (id_usuario, id_modelo) VALUES (T_USUARIOID, V_MODELO);
					
					INSERT INTO mdl_user (username, password, firstname, lastname, email, city, country, lang, timezone, confirmed, mnethostid, 
									institution, department,emailstop, timecreated)
								VALUES(V_TUTOR,md5('tutor@kroton'),'TUTOR',' DI' ,'sucess@simulator.amazones.com','','BR','pt_br_utf8','-3.0',1,1, 
								'', '',0, unix_timestamp(now()));
					SET NOVO_MDL_USER=LAST_INSERT_ID();
					INSERT INTO mdl_sgt_usuario_moodle (id_usuario_id, mdl_user_id, mdl_username) VALUES (T_USUARIOID, NOVO_MDL_USER, V_TUTOR);

					INSERT INTO controle_tutores_di (username, qtd_alunos) VALUES (V_TUTOR,0);
				

				END IF;
			
			END NOVOUSUARIO;
			
		END IF;
	
	END ALOCACAO;

	IF (V_TUTOR IS NOT NULL) THEN 	
		SET V_GRUPO=CONCAT('GRUPO_',V_TUTOR);
		SET V_LOG=matricular(V_ANH_ID, V_IDPC, V_IDPT, V_USERNAME, V_SHORTNAME, V_UNIDADE, V_CURSO, V_GRUPO, V_TUTOR, 'student', 'DI');
		IF (V_LOG LIKE 'Erro%') THEN 
			SET V_STATUS='ERRO';
		ELSE 
			UPDATE controle_tutores_di SET qtd_alunos=qtd_alunos+ADDALUNO WHERE username=V_TUTOR;
			SET V_COUNT=0;
			SELECT COUNT(1) INTO V_COUNT
			FROM controle_tutores_di_uc 
			WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
			IF V_COUNT=0 THEN 
				INSERT INTO controle_tutores_di_uc (USERNAME, CURSO, UNIDADE, QTD_ALUNOS)			
				VALUES (V_TUTOR, V_CURSO, V_UNIDADE, 1);				
			ELSE 
				UPDATE controle_tutores_di_uc SET qtd_alunos=qtd_alunos+ADDALUNO_UC WHERE username=V_TUTOR AND unidade=V_UNIDADE AND curso=V_CURSO;
			END IF;
			REPLACE INTO controle_di_disciplinas (TUTOR, SHORTNAME) 
			VALUES (V_TUTOR,V_SHORTNAME);			
			SET V_STATUS='OK';
		END IF;
		UPDATE anh_import_aluno_curso SET TUTOR=V_TUTOR, GRUPO=V_GRUPO, STATUS=V_STATUS, LOG=V_LOG WHERE ID=V_ANH_ID;
	ELSE 
		UPDATE anh_import_aluno_curso SET LOG='Não foi possível alocar um tutor, aguardando cadastro' WHERE ID=V_ANH_ID;
   END IF;
	
	
	
END LOOP ALUNO;

DROP TABLE IF EXISTS controle_tutores_di;
DROP TABLE IF EXISTS controle_tutores_di_uc;
DROP TABLE IF EXISTS controle_di_disciplinas;



INSERT INTO mdl_groups (courseid, name, description, timecreated)
SELECT DISTINCT 
	COURSE_ID,
	GRUPO_DI,
	GRUPO_DI,
	UNIX_TIMESTAMP(NOW())
FROM (
	SELECT DISTINCT
		u.id AS USER_ID,
		ed.USERNAME,
		c.id as COURSE_ID,
		ed.shortname, 
		ed.TUTOR AS TUTOR_ATUAL, 
		g.id AS GRUPO_ORIGEM_ID,
		ed.GRUPO AS GRUPO_ATUAL,
		di.TUTOR AS TUTOR_DI,
		g2.id AS GRUPO_ID_DESTINO,
		di.GRUPO AS GRUPO_DI	
	FROM anh_aluno_matricula PARTITION (EDV) ed
	JOIN mdl_user u on u.username=ed.username and u.mnethostid=1
	JOIN mdl_course c on c.shortname=ed.shortname and c.summary REGEXP 'ED[567]'
	JOIN mdl_groups g on g.courseid=c.id and g.description=ed.grupo
	JOIN anh_aluno_matricula PARTITION (DI) di ON ed.username=di.username
	
	
   JOIN (SELECT username, MAX(ID) AS idmax
           FROM anh_aluno_matricula PARTITION (DI)
           GROUP BY username
        ) dimax on (di.id = dimax.idmax and di.username = dimax.username)

	LEFT JOIN mdl_groups g2 on g2.courseid=c.id and g2.description=di.GRUPO
	WHERE ed.TUTOR REGEXP 'tutor_ed_[0-9].*'
) A WHERE GRUPO_ID_DESTINO IS NULL;


DELETE gm 
FROM mdl_groups_members  gm
JOIN (
	SELECT DISTINCT
		u.id AS USER_ID,
		ed.USERNAME,
		c.id as COURSE_ID,
		ed.shortname, 
		ed.TUTOR AS TUTOR_ATUAL, 
		g.id AS GRUPO_ORIGEM_ID,
		ed.GRUPO AS GRUPO_ATUAL,
		di.TUTOR AS TUTOR_DI,
		g2.id AS GRUPO_ID_DESTINO,
		di.GRUPO AS GRUPO_DI	
	FROM anh_aluno_matricula PARTITION (EDV) ed
	JOIN mdl_user u on u.username=ed.username and u.mnethostid=1
	JOIN mdl_course c on c.shortname=ed.shortname and c.summary REGEXP 'ED[567]'
	JOIN mdl_groups g on g.courseid=c.id and g.description=ed.grupo
	JOIN anh_aluno_matricula PARTITION (DI) di ON ed.username=di.username
	JOIN mdl_groups g2 on g2.courseid=c.id and g2.description=di.GRUPO
	WHERE ed.TUTOR REGEXP 'tutor_ed_[0-9].*'
) A ON gm.userid=A.USER_ID AND gm.groupid=A.GRUPO_ORIGEM_ID;


INSERT INTO mdl_groups_members (userid, groupid, timeadded)
SELECT DISTINCT
	USER_ID,
	GRUPO_ID_DESTINO,
	UNIX_TIMESTAMP(NOW())
	FROM (
	SELECT DISTINCT
		u.id AS USER_ID,
		ed.USERNAME,
		c.id as COURSE_ID,
		ed.shortname, 
		ed.TUTOR AS TUTOR_ATUAL, 
		g.id AS GRUPO_ORIGEM_ID,
		ed.GRUPO AS GRUPO_ATUAL,
		di.TUTOR AS TUTOR_DI,
		g2.id AS GRUPO_ID_DESTINO,
		di.GRUPO AS GRUPO_DI	
	FROM anh_aluno_matricula PARTITION (EDV) ed
	JOIN mdl_user u on u.username=ed.username and u.mnethostid=1
	JOIN mdl_course c on c.shortname=ed.shortname and c.summary REGEXP 'ED[567]'
	JOIN mdl_groups g on g.courseid=c.id and g.description=ed.grupo
	JOIN anh_aluno_matricula PARTITION (DI) di ON ed.username=di.username
	
	
   JOIN (SELECT username, MAX(ID) AS idmax
           FROM anh_aluno_matricula PARTITION (DI)
           GROUP BY username
        ) dimax on (di.id = dimax.idmax and di.username = dimax.username)

	JOIN mdl_groups g2 on g2.courseid=c.id and g2.description=di.GRUPO
	WHERE ed.TUTOR REGEXP 'tutor_ed_[0-9].*'
	) A;
	

DROP TABLE IF EXISTS tmp_trocar_grupos;
CREATE TABLE tmp_trocar_grupos AS 
	SELECT DISTINCT
		ed.id AS ID_ANH,
		u.id AS USER_ID,
		ed.USERNAME,
		c.id as COURSE_ID,
		ed.shortname, 
		ed.TUTOR AS TUTOR_ATUAL, 
		g.id AS GRUPO_ORIGEM_ID,
		ed.GRUPO AS GRUPO_ATUAL,
		di.TUTOR AS TUTOR_DI,
		g2.id AS GRUPO_ID_DESTINO,
		di.GRUPO AS GRUPO_DI	
	FROM anh_aluno_matricula PARTITION (EDV) ed
	JOIN mdl_user u on u.username=ed.username and u.mnethostid=1
	JOIN mdl_course c on c.shortname=ed.shortname and c.summary REGEXP 'ED[567]'
	JOIN mdl_groups g on g.courseid=c.id and g.description=ed.grupo
	JOIN anh_aluno_matricula PARTITION (DI) di ON ed.username=di.username
	
	
   JOIN (SELECT username, MAX(ID) AS idmax
           FROM anh_aluno_matricula PARTITION (DI)
           GROUP BY username
        ) dimax on (di.id = dimax.idmax and di.username = dimax.username)
	
	JOIN mdl_groups g2 on g2.courseid=c.id and g2.description=di.GRUPO
	WHERE ed.TUTOR REGEXP 'tutor_ed_[0-9].*';


UPDATE anh_aluno_matricula anh
JOIN tmp_trocar_grupos tmp ON anh.id=tmp.ID_ANH
SET anh.GRUPO=tmp.GRUPO_DI, anh.TUTOR=tmp.TUTOR_DI;

DROP TABLE IF EXISTS tmp_trocar_grupos;



END PROCESSO;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
