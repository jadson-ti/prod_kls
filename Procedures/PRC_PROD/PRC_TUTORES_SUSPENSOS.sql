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

-- Copiando estrutura para procedure prod_kls.PRC_TUTORES_SUSPENSOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_TUTORES_SUSPENSOS`()
MAIN: BEGIN


REALOCACAO: BEGIN


	DECLARE V_TUTOR_ID INT;
	DECLARE V_TUTOR_USERNAME VARCHAR(50);
	DECLARE V_SHORTNAME VARCHAR(50);
	DECLARE V_SHORTNAME_ID INT;
	DECLARE V_GRUPO VARCHAR(100);
	DECLARE V_GRUPO_ID INT;
	DECLARE NODATA INT DEFAULT FALSE;
	DECLARE TUTORES CURSOR FOR
			SELECT DISTINCT 
			u.id, um.mdl_username, anh.SHORTNAME, c.id, anh.grupo, COALESCE(g.id,0)
			FROM anh_aluno_matricula anh
			JOIN mdl_sgt_usuario_moodle um on um.mdl_username=anh.TUTOR
			JOIN mdl_sgt_usuario u on u.id=um.id_usuario_id and u.status='S'
			JOIN mdl_course c on c.shortname=anh.shortname
			LEFT JOIN mdl_groups g on g.description=anh.GRUPO and g.courseid=c.id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;	
	
	DROP TABLE IF EXISTS tmp_bloqueios;
	CREATE TABLE tmp_bloqueios (username varchar(50), shortname varchar(50), tutor varchar(50));
	alter table tmp_bloqueios ADD INDEX idx_shortname (shortname);
	alter table tmp_bloqueios ADD INDEX idx_username (username);

	
	OPEN TUTORES;
	
	TUTOR: LOOP 
	
		SET NODATA=FALSE;
		FETCH TUTORES INTO V_TUTOR_ID, V_TUTOR_USERNAME, V_SHORTNAME, 
								 V_SHORTNAME_ID, V_GRUPO, V_GRUPO_ID;

		IF NODATA THEN LEAVE TUTOR; END IF;

		ALUNOS: BEGIN
		
			DECLARE V_ANH_ID INT;
			DECLARE V_IAC_ID INT;
			DECLARE V_USERNAME VARCHAR(50);
			DECLARE V_MODELO INT;
			DECLARE V_MODELO_SIGLA VARCHAR(10);
			DECLARE ALUNOS CURSOR FOR
				SELECT anh.ID, anh.USERNAME, anh.ID_MATRICULA_ATUAL,m.id, m.sigla
				FROM anh_aluno_matricula anh				
				JOIN mdl_sgt_modelo m on m.sigla=case
																when anh.sigla='TCCV' then 'TCC'
																when anh.sigla='ESTV' then 'EST'
																when anh.sigla='NPJV' then 'NPJ'
																when anh.sigla='DIBV' then 'DIB'
																when anh.sigla='DI' then 'DI'
																when anh.sigla='EDV' then 'ED'
															end
				WHERE SHORTNAME=V_SHORTNAME AND
						TUTOR=V_TUTOR_USERNAME AND
						GRUPO=V_GRUPO;				
		   
		   OPEN ALUNOS;
		   
		   ALUNO: LOOP
			
				SET NODATA=FALSE;
				FETCH ALUNOS INTO V_ANH_ID, V_USERNAME, V_IAC_ID, V_MODELO, V_MODELO_SIGLA;
				IF NODATA THEN LEAVE ALUNO; END IF;
			
				NOVOTUTOR: BEGIN
				
					DECLARE V_TUTOR_DESTINO_ID INT;
					DECLARE V_TUTOR_DESTINO_MDLID INT;
					DECLARE V_TUTOR_DESTINO_USER VARCHAR(50);
					DECLARE V_TUTOR_DESTINO_MODELO INT;
					DECLARE V_GRUPO_DESTINO_ID INT;
					DECLARE V_QTD_ALUNOS INT;
					DECLARE V_USER_ID INT;
					
					SET V_QTD_ALUNOS=0;
					SET V_TUTOR_DESTINO_ID=NULL;
					SET V_TUTOR_DESTINO_MODELO=NULL;

					SELECT id_usuario_destino, um.id_modelo, 
					@qtd_alunos:=COALESCE(COUNT(DISTINCT anh.USERNAME),0) AS QTD
					INTO V_TUTOR_DESTINO_ID, V_TUTOR_DESTINO_MODELO, V_QTD_ALUNOS 
					FROM mdl_sgt_transferencia_alunos t
					JOIN mdl_sgt_transf_alunos_dest td on t.id=td.id_transferencia_aluno
					JOIN mdl_sgt_usuario_formacao uf on uf.id_usuario=td.id_usuario_destino
					JOIN mdl_sgt_formacao_disciplina fd on fd.id_area_formacao=uf.id_area_formacao
					JOIN mdl_sgt_usuario u ON u.id=td.id_usuario_destino
					JOIN mdl_sgt_usuario_capacidade uc on uc.id_usuario=u.id and uc.id_modelo=V_MODELO
					LEFT JOIN mdl_sgt_usuario_moodle umod ON umod.id_usuario_id=td.id_usuario_destino
					LEFT JOIN mdl_sgt_usuario_modelo um on um.id_usuario=td.id_usuario_destino 
					LEFT JOIN anh_aluno_matricula anh ON anh.TUTOR=umod.mdl_username
					WHERE 
						t.id_usuario_origem=V_TUTOR_ID and 
						fd.shortname=V_SHORTNAME and
						(um.id_modelo is null or um.id_modelo=V_MODELO) AND 
						@qtd_alunos<uc.qtd_alunos and
						uc.qtd_alunos > 0
					GROUP BY id_usuario_destino, um.id_modelo
					LIMIT 1;
										
					IF V_TUTOR_DESTINO_ID IS NULL THEN 

							
							
							

							INSERT INTO tmp_bloqueios (username, shortname, tutor) VALUES (V_USERNAME, V_SHORTNAME, V_TUTOR_USERNAME);
							
					ELSE
							
							SET V_TUTOR_DESTINO_MDLID=NULL;
							
							
							SELECT mdl_user_id INTO V_TUTOR_DESTINO_MDLID
							FROM mdl_sgt_usuario_moodle umdl 
							WHERE umdl.id_usuario_id=V_TUTOR_DESTINO_ID;
							
							
							IF V_TUTOR_DESTINO_MDLID IS NULL THEN 
									INSERT INTO mdl_user (username, password, firstname, lastname, email, city, country, lang, timezone, confirmed, mnethostid, 
									institution, department,emailstop,timecreated)
									VALUES(CONCAT('TUTOR_',V_MODELO_SIGLA,'_',V_TUTOR_DESTINO_ID),md5('tutor@kroton'),'TUTOR ',V_MODELO_SIGLA ,'','','BR','pt_br_utf8','-3.0',1,1, 
									'', '',0, unix_timestamp(now()));
									SET V_TUTOR_DESTINO_MDLID=LAST_INSERT_ID();
									INSERT INTO mdl_sgt_usuario_moodle (id_usuario_id, mdl_user_id, mdl_username)
									VALUES (V_TUTOR_DESTINO_ID,V_TUTOR_DESTINO_MDLID,CONCAT('TUTOR_',V_MODELO_SIGLA,'_',V_TUTOR_DESTINO_ID));				
							END IF;							

							
							IF V_TUTOR_DESTINO_MODELO IS NULL THEN
								INSERT INTO mdl_sgt_usuario_modelo (id_modelo, id_usuario)
								VALUES (V_MODELO, V_TUTOR_DESTINO_ID);
							END IF;
					
							
							SELECT username 
							INTO V_TUTOR_DESTINO_USER 
							FROM mdl_user 
							WHERE id=V_TUTOR_DESTINO_MDLID;

							
							IF V_TUTOR_DESTINO_USER IS NULL THEN
								
								
								LEAVE REALOCACAO;
							END IF;
							
							
							SET V_GRUPO_DESTINO_ID=NULL;
							SELECT id INTO V_GRUPO_DESTINO_ID FROM mdl_groups
							WHERE courseid=V_SHORTNAME_ID AND description=CONCAT('GRUPO_',V_TUTOR_DESTINO_USER);
							
							
							IF V_GRUPO_DESTINO_ID IS NULL THEN 
								INSERT INTO mdl_groups (courseid, name,  description, timecreated)
								VALUES (V_SHORTNAME_ID,CONCAT('GRUPO_',V_TUTOR_DESTINO_USER),
											CONCAT('GRUPO_',V_TUTOR_DESTINO_USER), UNIX_TIMESTAMP(NOW()));
								SET V_GRUPO_DESTINO_ID=LAST_INSERT_ID();
							END IF;
							
							
							SELECT id INTO V_USER_ID FROM mdl_user WHERE username=V_USERNAME AND mnethostid=1;
							
							IF V_USER_ID IS NULL THEN
								LEAVE REALOCACAO;
							END IF;
							
							DELETE FROM mdl_groups_members WHERE userid=V_USER_ID AND groupid=V_GRUPO_ID;
							INSERT INTO mdl_groups_members (userid, groupid, timeadded) VALUES (V_USER_ID, V_GRUPO_DESTINO_ID, UNIX_TIMESTAMP(NOW()));
							UPDATE anh_aluno_matricula SET GRUPO=CONCAT('GRUPO_',V_TUTOR_DESTINO_USER) WHERE ID=V_ANH_ID;
						   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
						   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
							GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
							SELECT DISTINCT 0,anh.ID_PES_CUR_DISC,	anh.ID_PESSOA_TURMA,V_MODELO_SIGLA AS SIGLA,'KHUB' AS ORIGEM,
							anh.USERNAME AS USERNAME,	anh.SHORTNAME AS SHORTNAME,iac.CODIGO_POLO,iac.NOME_POLO,anh.CURSO,
							iac.NOME_CURSO,iac.CODIGO_DISCIPLINA,iac.NOME_DISCIPLINA, iac.SERIE_ALUNO, iac.TURNO_CURSO,
							iac.TURMA_ALUNO,anh.GRUPO,iac.ROLE, date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
						   'R' AS SITUACAO,'OK' AS STATUS,NULL AS NOVA_TENTATIVA
							FROM anh_aluno_matricula anh
							JOIN anh_import_aluno_curso iac ON anh.id_matricula_atual=iac.id
							WHERE anh.ID=V_ANH_ID;
					
					END IF;								

				END NOVOTUTOR;

			END LOOP ALUNO;    

		END ALUNOS;
		

	END LOOP TUTOR;		

INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
SELECT DISTINCT 0,anh.ID_PES_CUR_DISC,	anh.ID_PESSOA_TURMA,anh.SIGLA,'SUSP' AS ORIGEM,
anh.USERNAME AS USERNAME,	anh.SHORTNAME AS SHORTNAME,iac.CODIGO_POLO,iac.NOME_POLO,anh.CURSO,
iac.NOME_CURSO,iac.CODIGO_DISCIPLINA,iac.NOME_DISCIPLINA, iac.SERIE_ALUNO, iac.TURNO_CURSO,
iac.TURMA_ALUNO,anh.GRUPO,iac.ROLE, date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
'B' AS SITUACAO,NULL AS STATUS,NULL AS NOVA_TENTATIVA
FROM anh_aluno_matricula anh
JOIN anh_import_aluno_curso iac ON anh.id_matricula_atual=iac.id
JOIN tmp_bloqueios tmp on tmp.username=anh.username AND tmp.tutor=anh.tutor 

GROUP BY anh.username,anh.shortname, anh.grupo;


CALL PRC_CARGA_MATRICULAS;
DELETE a FROM anh_aluno_matricula a 
JOIN tmp_bloqueios b ON a.username=b.username and a.tutor=b.tutor AND a.GRUPO REGEXP 'TUTOR';
DROP TABLE IF EXISTS tmp_bloqueios;


delete g
from mdl_sgt_usuario u
JOIN mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id
JOIN mdl_groups g on g.description=CONCAT('GRUPO_',um.mdl_username)
where status='S';

END REALOCACAO;



delete ra 
from mdl_sgt_usuario u
join mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id 
join mdl_role_assignments ra on ra.userid=um.mdl_user_id 
where u.status='S' AND u.id_perfil=1;

delete ue
from mdl_sgt_usuario u
join mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id 
join mdl_user_enrolments ue on ue.userid=um.mdl_user_id
where u.status='S' AND u.id_perfil=1;

delete gm
from mdl_sgt_usuario u
join mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id 
join mdl_groups_members gm on gm.userid=um.mdl_user_id
where u.status='S' AND u.id_perfil=1;

update mdl_sgt_usuario u
join mdl_sgt_usuario_moodle umo on u.id = umo.id_usuario_id
set u.qtde_alunos = (select count(distinct a.USERNAME)
from anh_aluno_matricula a
where a.tutor = umo.mdl_username);

END MAIN//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
