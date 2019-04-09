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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_AMP
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_INDICADORES_AMP`()
BEGIN
 
	DECLARE ID_LOG_		INT(10);
	DECLARE CODE_ 			VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			VARCHAR(200);
	DECLARE REGISTROS_	BIGINT DEFAULT NULL;
   DECLARE Vencontro		INT;
   DECLARE Vacesso		INT;
   DECLARE VNomeAcesso	VARCHAR(3);
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;
   DECLARE ENCONTRO INT;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT database(), 'PRC_INDICADORES_AMP', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	
   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;	
	
	DROP TABLE IF EXISTS tmp_curso_aula;

	CREATE TABLE tmp_curso_aula (
		course BIGINT(10),
		section BIGINT(10),
		rotulo TINYINT(1),
		coursemodules BIGINT(10),
		contextid BIGINT(10),
		PRIMARY KEY (rotulo, contextid),
		INDEX idx_course (course),
		INDEX idx_coursemodules (coursemodules),
		INDEX idx_update1 (contextid, rotulo, section)
	)
	PARTITION BY RANGE (rotulo) (
		PARTITION p0 VALUES LESS THAN (1),
		PARTITION p1 VALUES LESS THAN (2),
		PARTITION p2 VALUES LESS THAN (3),
		PARTITION p3 VALUES LESS THAN MAXVALUE
	);
	
	INSERT INTO tmp_curso_aula
		SELECT 
			course, 
			section,
			if(rotulo IS NOT NULL, @aula:=rotulo, @aula) AS rotulo,
			coursemodule,
			contextid
		FROM (
			SELECT 
				c.id course,
				if(c.shortname REGEXP '^H',cs.section-1,cs.section) as section,
				cs.NAME AS secao,
				m.NAME AS modulo,
				case
					when ml.NAME='Pré-Aula' then 0
					when ml.NAME='Aula' 		then 1
					when ml.NAME='Pós-Aula' then 2 
					when ml.name IS NULL then null
					ELSE 4
				end rotulo,
				cm.id AS coursemodule,
				co.id AS contextid
			FROM mdl_course c 
			JOIN mdl_course_sections cs ON cs.course=c.id AND cs.section>0 
													 AND cs.NAME<>'Fórum'
													 AND cs.NAME NOT LIKE 'Apresenta%'
			JOIN mdl_course_modules cm ON FIND_IN_SET(cm.id,cs.sequence) AND cm.visible=1 AND cm.section=cs.id
			JOIN mdl_context co ON co.contextlevel=70 AND co.instanceid=cm.id 
			JOIN mdl_modules m ON m.id=cm.module
			LEFT JOIN mdl_label ml ON ml.id=cm.INSTANCE AND m.NAME='label'
			WHERE c.shortname REGEXP '^AMP|HAMP' 
			ORDER BY c.id, cs.section, FIND_IN_SET(cm.id,cs.sequence)
		) A;	
    DROP TABLE IF EXISTS carga_base_professor_coord;
 
    CREATE TEMPORARY TABLE carga_base_professor_coord (
					PROFESSOR_ID               BIGINT, 
               PROFESSOR_LOGIN            VARCHAR(100), 
               PROFESSOR_EMAIL            VARCHAR(100), 
               COURSE                 		BIGINT,
					GROUP_ID           	  		BIGINT, 
               PROFESSOR_DataVinculo      VARCHAR(100),
               PROFESSOR_NOME             VARCHAR(200),
               PROFESSOR_PrimeiroAcesso   VARCHAR(100),
               PROFESSOR_UltimoAcesso     VARCHAR(100),
					ROLEID			 				int,
					INDEX idx_CUR_BT (COURSE, GROUP_ID)
					);
 
	INSERT INTO carga_base_professor_coord (PROFESSOR_ID ,
														 PROFESSOR_LOGIN,
														 PROFESSOR_EMAIL,
														 COURSE,
														 GROUP_ID,
														 PROFESSOR_DataVinculo,
														 PROFESSOR_NOME ,
														 PROFESSOR_PrimeiroAcesso,
														 PROFESSOR_UltimoAcesso,
														 ROLEID
													)
							                SELECT DISTINCT u.id AS PROFESSOR_ID, u.username AS PROFESSOR_LOGIN, u.email AS PROFESSOR_EMAIL, 
												 					  c.id AS COURSE, g.id AS GROUP_ID, 
							               					  DATE_FORMAT(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO),'%d/%m/%Y %H:%i:%s') AS PROFESSOR_DataVinculo,
							                                UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS PROFESSOR_NOME,
											           			  IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO), 'Nunca Acessou') AS PROFESSOR_PrimeiroAcesso,
																	  IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO), 'Nunca Acessou')	AS PROFESSOR_UltimoAcesso,
                                              		  ra.roleid AS ROLEID
							        FROM mdl_course c
							        JOIN mdl_context ct ON ct.instanceid = c.id AND ct.contextlevel = 50
							        JOIN mdl_course_categories cc ON cc.id = c.category
							        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
							        JOIN mdl_role r on r.id=ra.roleid and r.shortname in ('coordteacher','editingteacher')
							        JOIN mdl_user u ON u.id = ra.userid
							        JOIN mdl_groups g ON g.courseid = c.id
							        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
							        LEFT JOIN tbl_login l ON l.USERID=u.id AND l.COURSE=c.id
									  WHERE c.shortname REGEXP '^AMP' OR c.shortname REGEXP '^HAMP'
									  GROUP BY c.id, g.id, r.id;
	
 
   DROP TABLE IF EXISTS tbl_indicadores_amp;
 
   CREATE TABLE tbl_indicadores_amp ( 
	 									COD_UNIDADE             	 	VARCHAR(100) DEFAULT 'Nenhum Encontrado',
										UNIDADE                 		VARCHAR(100) DEFAULT 'Nenhuma Encontrada',
										ID_CURSO_KLS						BIGINT DEFAULT 0,
										COD_CURSO_KLS						VARCHAR(100) DEFAULT NULL,
										NOME_CURSO_KLS				 		VARCHAR(200) DEFAULT NULL,
										ID_CURSO                		BIGINT(10),
										NOME_CURSO              		VARCHAR(100),
										FULLNAME                		VARCHAR(200),
										SIGLA									VARCHAR(100),
										IDNUMBER_GRUPO						VARCHAR(200), 
										ID_GRUPO                		BIGINT(10),
										GRUPO                   		VARCHAR(200),
										USERID                       	BIGINT(10),
										LOGIN                        	VARCHAR(100),
										NOME                         	VARCHAR(200), 
										EMAIL                        	VARCHAR(100), 
										DataVinculoDisciplina        	VARCHAR(100),
										PrimeiroAcessoDisciplina     	VARCHAR(100) DEFAULT 'Nunca Acessou',
										UltimoAcessoDisciplina       	VARCHAR(100) DEFAULT 'Nunca Acessou',
										QuantDiasAcessoCurso          BIGINT DEFAULT 0,
                              COORDENADOR_ID                BIGINT DEFAULT 0, 
										COORDENADOR_LOGIN             VARCHAR(100) DEFAULT 'Sem Coordenador', 
										COORDENADOR_EMAIL             VARCHAR(100) DEFAULT 'Sem E-mail', 
										COORDENADOR_DataVinculo       VARCHAR(100) DEFAULT 'Sem Vinculo',
										COORDENADOR_NOME              VARCHAR(200) DEFAULT 'Sem Nome',
										COORDENADOR_PrimeiroAcesso    VARCHAR(100) DEFAULT 'Nunca Acessou',
										COORDENADOR_UltimoAcesso      VARCHAR(100) DEFAULT 'Nunca Acessou',
                              COORDENADOR_QuantAcesso       VARCHAR(100) DEFAULT 'Nunca Acessou',
										PROFESSOR_ID                  BIGINT DEFAULT 0, 
										PROFESSOR_LOGIN               VARCHAR(100) DEFAULT 'Sem Professor', 
										PROFESSOR_EMAIL               VARCHAR(100) DEFAULT 'Sem E-mail', 
										PROFESSOR_DataVinculo         VARCHAR(100) DEFAULT 'Sem Vinculo',
										PROFESSOR_NOME                VARCHAR(200) DEFAULT 'Sem Nome',
										PROFESSOR_PrimeiroAcesso      VARCHAR(100) DEFAULT 'Nunca Acessou',
										PROFESSOR_UltimoAcesso        VARCHAR(100) DEFAULT 'Nunca Acessou',
                              PROFESSOR_QuantAcesso         VARCHAR(100) DEFAULT 'Nunca Acessou',
										INDEX `IDX_CUR_IND_AMP` (`ID_CURSO`, `ID_GRUPO`),
										INDEX `IDX_USER` (`ID_CURSO`, `USERID`)
                              );   
    
	-- CREATE INDEX IDX_CUR_IND_AMI ON tbl_indicadores_amp (ID_GRUPO);
	
	SET encontro:=1;
	
	WHILE (encontro<=16) DO
		SET @campo1:=CONCAT('ALTER TABLE tbl_indicadores_amp ADD COLUMN Enc',encontro,'UltAcessoPre VARCHAR(100) DEFAULT ''Nunca Acessou''');
		SET @campo2:=CONCAT('ALTER TABLE tbl_indicadores_amp ADD COLUMN Enc',encontro,'UltAcessoAula VARCHAR(100) DEFAULT ''Nunca Acessou''');
		SET @campo3:=CONCAT('ALTER TABLE tbl_indicadores_amp ADD COLUMN Enc',encontro,'UltAcessoPos VARCHAR(100) DEFAULT ''Nunca Acessou''');
		PREPARE stmt1 FROM @campo1;	
      PREPARE stmt2 FROM @campo2;	
      PREPARE stmt3 FROM @campo3;
		EXECUTE stmt1;	DEALLOCATE PREPARE stmt1;
		EXECUTE stmt2; DEALLOCATE PREPARE stmt2;
		EXECUTE stmt3; DEALLOCATE PREPARE stmt3;
		set encontro=encontro+1;
	END WHILE; 
          
			
           -- AMP 
					       INSERT INTO tbl_indicadores_amp (COD_UNIDADE, 
																		UNIDADE, 
																		ID_CURSO_KLS,
																		COD_CURSO_KLS,
																		NOME_CURSO_KLS,
																		ID_CURSO, 
																		NOME_CURSO, 
																		FULLNAME, 
																		SIGLA,
																		ID_GRUPO, 
																		GRUPO, 
																		USERID, 
																		LOGIN, 
																		NOME, 
																		EMAIL, 
																		DataVinculoDisciplina)
SELECT DISTINCT 
							  			 i2.cd_instituicao AS COD_UNIDADE
			  							,i2.nm_ies AS UNIDADE
			  							,kc.id_curso
										,kc.cd_curso
										,kc.nm_curso
							  			,c.id AS ID_CURSO 
							 			,c.shortname AS NOME_CURSO
		        						,c.fullname AS FULLNAME
		        						,tp.sigla AS SIGLA
		                        ,g.id AS ID_GRUPO
										,g.name AS GRUPO
		                        ,u.id AS USERID 
										,u.username AS LOGIN 
										,UPPER(CONCAT(u.firstname, " ", u.lastname)) AS NOME 
										,u.email AS EMAIL
		                        ,IFNULL(FROM_UNIXTIME(gm.timeadded,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina   
					        FROM mdl_course c
					        JOIN mdl_context ct ON ct.instanceid = c.id AND ct.contextlevel=50
					        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
							  JOIN mdl_role r on r.id=ra.roleid and r.shortname='student'			        
					        JOIN mdl_user u ON u.id = ra.userid AND u.mnethostid=1
					        JOIN mdl_groups g ON g.courseid = c.id
					        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
					        JOIN anh_aluno_matricula anh ON anh.USERNAME=u.username and 
							  																  anh.shortname=c.shortname and
							  																  anh.grupo=g.description and
							  																  anh.sigla='AMP'
					        JOIN kls_lms_pessoa p on p.login=u.username and u.mnethostid=1
					        JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu REGEXP '[NA]'
					        JOIN kls_lms_curso_disciplina cd on pcd.id_curso_disciplina=cd.id_curso_disciplina and cd.shortname = c.shortname AND cd.fl_etl_atu REGEXP '[NA]'
                       JOIN kls_lms_disciplina d on (cd.id_disciplina = d.id_disciplina AND d.fl_etl_atu REGEXP '[NA]')
							  JOIN kls_lms_curso kc on kc.id_curso=cd.id_curso and kc.fl_etl_atu REGEXP '[NA]'
							  JOIN kls_lms_instituicao i2 on i2.id_ies=kc.id_ies
                       JOIN kls_lms_tipo_modelo tp on (d.id_tp_modelo = tp.id_tp_modelo and tp.sigla='AMP')
                       LEFT JOIN anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina) 
					        WHERE temp.id_disciplina is null;					       
					       -- HAMP
					       INSERT INTO tbl_indicadores_amp (COD_UNIDADE, 
																		UNIDADE, 
																		ID_CURSO_KLS,
																		COD_CURSO_KLS,
																		NOME_CURSO_KLS,
																		ID_CURSO, 
																		NOME_CURSO, 
																		FULLNAME, 
																		SIGLA,
																		ID_GRUPO, 
																		GRUPO, 
																		USERID, 
																		LOGIN, 
																		NOME, 
																		EMAIL, 
																		DataVinculoDisciplina)
		  				SELECT DISTINCT 
							  			 i2.cd_instituicao AS COD_UNIDADE
			  							,i2.nm_ies AS UNIDADE
			  							,kc.id_curso
										,kc.cd_curso
										,kc.nm_curso
							  			,c.id AS ID_CURSO 
							 			,c.shortname AS NOME_CURSO
		        						,c.fullname AS FULLNAME
		        						,if(tp.sigla='HIB','HAMP','') AS SIGLA
		                        ,g.id AS ID_GRUPO
										,g.name AS GRUPO
		                        ,u.id AS USERID 
										,u.username AS LOGIN 
										,UPPER(CONCAT(u.firstname, " ", u.lastname)) AS NOME 
										,u.email AS EMAIL
		                        ,IFNULL(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina   
					        FROM mdl_course c
					        JOIN mdl_context ct ON ct.instanceid = c.id
					        JOIN mdl_course_categories cc ON cc.id = c.category
					        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
							  JOIN mdl_role r on r.id=ra.roleid and r.shortname='student'			        
					        JOIN mdl_user u ON u.id = ra.userid
					        JOIN mdl_groups g ON g.courseid = c.id AND g.NAME NOT LIKE 'Grupo%'
					        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
					        JOIN anh_aluno_matricula PARTITION (HAMPP) anh1 ON anh1.USERNAME=u.username and 
							  																	   anh1.shortname=c.shortname AND
							  																	   anh1.sigla='HAMPP'
					        JOIN kls_lms_pessoa p on p.login=u.username and u.mnethostid=1
					        JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu REGEXP '[NA]'
					        JOIN kls_lms_curso_disciplina cd on pcd.id_curso_disciplina=cd.id_curso_disciplina and cd.shortname = c.shortname AND cd.fl_etl_atu REGEXP '[NA]'
                       JOIN kls_lms_disciplina d on (cd.id_disciplina = d.id_disciplina AND d.fl_etl_atu REGEXP '[NA]')
							  JOIN kls_lms_curso kc on kc.id_curso=cd.id_curso and kc.fl_etl_atu REGEXP '[NA]'
							  JOIN kls_lms_instituicao i2 on i2.id_ies=kc.id_ies
                       JOIN kls_lms_tipo_modelo tp on (d.id_tp_modelo = tp.id_tp_modelo and tp.sigla='HIB')
                       LEFT JOIN anh_disciplina_ami_amp temp on (temp.id_disciplina = d.id_disciplina)    
					       WHERE ct.contextlevel = 50  AND temp.id_disciplina is NULL;
     
      
     		UPDATE tbl_indicadores_amp t
	  		SET 
			  	t.PrimeiroAcessoDisciplina = IFNULL((SELECT 
				  										 FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s')
														FROM tbl_login l 
														WHERE l.USERID=t.USERID AND l.COURSE=t.ID_CURSO),'Nunca Acessou'),
  		   	t.UltimoAcessoDisciplina = IFNULL((SELECT 
				  										 FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s')
														FROM tbl_login l 
														WHERE l.USERID=t.USERID AND l.COURSE=t.ID_CURSO),'Nunca Acessou');
	  
			UPDATE tbl_indicadores_amp t 
  	  		SET t.QuantDiasAcessoCurso = IFNULL(
				                              (
				 											SELECT 
				  											COALESCE(COUNT(DISTINCT DATE_FORMAT(FROM_UNIXTIME(l.DT),'%d/%m/%Y')), 0)
															FROM tbl_login l 
															WHERE l.USERID=t.USERID AND l.COURSE=t.ID_CURSO
														)
														,'Nunca Acessou');

				UPDATE tbl_indicadores_amp t
        		JOIN carga_base_professor_coord bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
				JOIN mdl_role r on r.id=bt.ROLEID  and r.shortname='editingteacher'
		      SET t.PROFESSOR_ID = bt.PROFESSOR_ID, 
					 t.PROFESSOR_LOGIN = bt.PROFESSOR_LOGIN, 
					 t.PROFESSOR_EMAIL = bt.PROFESSOR_EMAIL, 
					 t.PROFESSOR_DataVinculo = bt.PROFESSOR_DataVinculo, 
					 t.PROFESSOR_NOME = bt.PROFESSOR_NOME, 
					 t.PROFESSOR_PrimeiroAcesso = bt.PROFESSOR_PrimeiroAcesso, 
					 t.PROFESSOR_UltimoAcesso = bt.PROFESSOR_UltimoAcesso,
                t.PROFESSOR_QuantAcesso = 0;
        
				UPDATE tbl_indicadores_amp t
        		JOIN carga_base_professor_coord bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
				JOIN mdl_role r on r.id=bt.ROLEID  and r.shortname='coordteacher'
		      SET t.COORDENADOR_ID = bt.PROFESSOR_ID, 
					 t.COORDENADOR_LOGIN = bt.PROFESSOR_LOGIN, 
					 t.COORDENADOR_EMAIL = bt.PROFESSOR_EMAIL, 
					 t.COORDENADOR_DataVinculo = bt.PROFESSOR_DataVinculo, 
					 t.COORDENADOR_NOME = bt.PROFESSOR_NOME, 
					 t.COORDENADOR_PrimeiroAcesso = bt.PROFESSOR_PrimeiroAcesso, 
					 t.COORDENADOR_UltimoAcesso = bt.PROFESSOR_UltimoAcesso,
                t.COORDENADOR_QuantAcesso = 0;
      
   
    UPDATE tbl_indicadores_amp
       SET COORDENADOR_QuantAcesso = 	case DATEDIFF(STR_TO_DATE(COORDENADOR_UltimoAcesso, '%Y-%m-%d %H:%i:%s'),STR_TO_DATE(COORDENADOR_PrimeiroAcesso, '%Y-%m-%d %H:%i:%s'))
											when 0 then 1
										else DATEDIFF(STR_TO_DATE(COORDENADOR_UltimoAcesso, '%Y-%m-%d %H:%i:%s'),STR_TO_DATE(COORDENADOR_PrimeiroAcesso, '%Y-%m-%d %H:%i:%s'))
										end
	 WHERE COORDENADOR_PrimeiroAcesso != 'Nunca Acessou';
        
     UPDATE tbl_indicadores_amp
       SET PROFESSOR_QuantAcesso =	case DATEDIFF(STR_TO_DATE(PROFESSOR_UltimoAcesso, '%Y-%m-%d %H:%i:%s'),STR_TO_DATE(PROFESSOR_PrimeiroAcesso, '%Y-%m-%d %H:%i:%s'))
										when 0 then 1
									else DATEDIFF(STR_TO_DATE(PROFESSOR_UltimoAcesso, '%Y-%m-%d %H:%i:%s'),STR_TO_DATE(PROFESSOR_PrimeiroAcesso, '%Y-%m-%d %H:%i:%s'))
                                    end
	 WHERE PROFESSOR_PrimeiroAcesso != 'Nunca Acessou';    
    
	DROP TABLE IF EXISTS carga_base_professor_coord;


	SET encontro=1;

	WHILE (encontro<=16) DO


		SET @query1:=CONCAT('
		UPDATE tbl_indicadores_amp amp
		JOIN tmp_curso_aula ac ON ac.course=amp.ID_CURSO AND ac.rotulo IN (0,4) AND ac.section=',encontro,'
		JOIN mdl_course_modules_completion l ON l.coursemoduleid=ac.coursemodules and amp.userid=l.userid and l.viewed=1
		SET Enc',encontro,'UltAcessoPre=(
			SELECT FROM_UNIXTIME(MAX(l.timemodified),''%d/%m/%Y %H:%i:%s'')
		)');

		SET @query2:=CONCAT('
		UPDATE tbl_indicadores_amp amp
		JOIN tmp_curso_aula ac ON ac.course=amp.ID_CURSO AND ac.rotulo IN (1,4) AND ac.section=',encontro,'
		JOIN mdl_course_modules_completion l ON l.coursemoduleid=ac.coursemodules and amp.userid=l.userid and l.viewed=1
		SET Enc',encontro,'UltAcessoAula=(
			SELECT FROM_UNIXTIME(MAX(l.timemodified),''%d/%m/%Y %H:%i:%s'')
		)');
		
		SET @query3:=CONCAT('
		UPDATE tbl_indicadores_amp amp
		JOIN tmp_curso_aula ac ON ac.course=amp.ID_CURSO AND ac.rotulo IN (2,4)  AND ac.section=',encontro,'
		JOIN mdl_course_modules_completion l ON l.coursemoduleid=ac.coursemodules and amp.userid=l.userid and l.viewed=1
		SET Enc',encontro,'UltAcessoPos=(
			SELECT FROM_UNIXTIME(MAX(l.timemodified),''%d/%m/%Y %H:%i:%s'')
		)');
		PREPARE stmt1 FROM @query1;	
      PREPARE stmt2 FROM @query2;	
      PREPARE stmt3 FROM @query3;
		EXECUTE stmt1;	DEALLOCATE PREPARE stmt1;
		EXECUTE stmt2; DEALLOCATE PREPARE stmt2;
		EXECUTE stmt3; DEALLOCATE PREPARE stmt3;
		SET encontro=encontro+1;
		
	END WHILE;

 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_amp)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
		
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
