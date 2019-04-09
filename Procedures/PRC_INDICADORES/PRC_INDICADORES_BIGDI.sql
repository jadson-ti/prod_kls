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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_BIGDI
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_INDICADORES_BIGDI`()
BEGIN
 
	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;
   DECLARE U_QUIZ_       INT DEFAULT 0 ;
   DECLARE S_QUIZ_       INT DEFAULT 0 ;
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT database(), 'PRC_INDICADORES_BIGDI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	
    DROP TABLE IF EXISTS carga_base_prof_bigdi;
 
    CREATE TABLE carga_base_prof_bigdi (
                                             COURSE                 BIGINT(10),
                            				 		GROUP_ID           	BIGINT(10), 
			  											   TUTOR_ID               BIGINT(10), 
                                             TUTOR_LOGIN            VARCHAR(100), 
                                             TUTOR_EMAIL            VARCHAR(100), 
                                             TUTOR_DataVinculo      VARCHAR(100),
                                             TUTOR_NOME             VARCHAR(200),
                                             TUTOR_PrimeiroAcesso   VARCHAR(100),
                                             TUTOR_UltimoAcesso     VARCHAR(100)
														 );
 
	ALTER TABLE carga_base_prof_bigdi ADD PRIMARY KEY (COURSE, GROUP_ID);

    CREATE TABLE carga_base_coord_bigdi (
                                             COURSE                 BIGINT(10),
                            				 		GROUP_ID           	BIGINT(10), 
			  											   COORD_ID               BIGINT(10), 
                                             COORD_LOGIN            VARCHAR(100), 
                                             COORD_EMAIL            VARCHAR(100), 
                                             COORD_DataVinculo      VARCHAR(100),
                                             COORD_NOME             VARCHAR(200),
                                             COORD_PrimeiroAcesso   VARCHAR(100),
                                             COORD_UltimoAcesso     VARCHAR(100)
														 );
 
	ALTER TABLE carga_base_coord_bigdi ADD PRIMARY KEY (COURSE, GROUP_ID);
	

    DROP TABLE IF EXISTS tbl_indicadores_bigdi;
 
    CREATE TABLE tbl_indicadores_bigdi ( 
	 											  COD_UNIDADE             	    VARCHAR(100) DEFAULT 'Nenhum Encontrado',
                           			  UNIDADE                 		 VARCHAR(100) DEFAULT 'Nenhuma Encontrada',
                           			  ID_CURSO_KLS					 	 BIGINT(20) DEFAULT 0,
		  						      		  COD_CURSO_KLS					 VARCHAR(100) DEFAULT NULL,
									  			  NOME_CURSO_KLS				 	 VARCHAR(255) DEFAULT NULL,
			                             ID_CURSO                		 BIGINT(10),
			                             NOME_CURSO              		 VARCHAR(100),
			                             FULLNAME                		 VARCHAR(200),
			                             ID_CATEGORIA            		 BIGINT(10),
									  			  NOME_CATEGORIA          		 VARCHAR(100),
									  			  IDNUMBER_GRUPO				 	 VARCHAR(200), 
                       				     ID_GRUPO_PRESENCIAL     		 BIGINT(10),
                       				     ID_GRUPO_VIRTUAL     		 	 BIGINT(10),
                                   	  GRUPO_PRESENCIAL        		 VARCHAR(200),
                                   	  GRUPO_TUTOR						 VARCHAR(100),
                                      USERID                       BIGINT(10),
                                      LOGIN                        VARCHAR(100),
                                      NOME                         VARCHAR(200), 
                                      EMAIL                        VARCHAR(100), 
                                      DataVinculoDisciplina        VARCHAR(100),
                                      PrimeiroAcessoDisciplina     VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      UltimoAcessoDisciplina       VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      QuantDiasAcesso              BIGINT DEFAULT 0,
                                      QUIZ_U1S1_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0, 
                                      QUIZ_U1S1_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U1S2_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U1S2_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U1S3_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U1S3_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U1                      DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S1_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S1_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S2_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S2_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S3_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2S3_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U2                      DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S1_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S1_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S2_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S2_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S3_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3S3_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U3                      DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S1_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S1_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S2_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S2_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S3_DIAGNOSTICA        DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4S3_APRENDIZAGEM       DECIMAL(3,1) DEFAULT 0,
                                      QUIZ_U4                  	 DECIMAL(3,1) DEFAULT 0,
                                      PROF_ID                     BIGINT(10) DEFAULT 0, 
                                      PROF_LOGIN                  VARCHAR(100) DEFAULT 'Sem Professor', 
                                      PROF_EMAIL                  VARCHAR(100) DEFAULT 'Sem E-mail', 
                                      PROF_DataVinculo            VARCHAR(100) DEFAULT 'Sem Vínculo',
                                      PROF_NOME                   VARCHAR(200) DEFAULT 'Sem Nome',
                                      PROF_PrimeiroAcesso         VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      PROF_UltimoAcesso           VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      TUTOR_ID                     BIGINT(10) DEFAULT 0, 
                                      TUTOR_LOGIN                  VARCHAR(100) DEFAULT 'Sem Tutor', 
                                      TUTOR_EMAIL                  VARCHAR(100) DEFAULT 'Sem E-mail', 
                                      TUTOR_DataVinculo            VARCHAR(100) DEFAULT 'Sem Vínculo',
                                      TUTOR_NOME                   VARCHAR(200) DEFAULT 'Sem Nome',
                                      TUTOR_PrimeiroAcesso         VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      TUTOR_UltimoAcesso 			VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      COORD_ID                     BIGINT(10) DEFAULT 0, 
                                      COORD_LOGIN                  VARCHAR(100) DEFAULT 'Sem Tutor', 
                                      COORD_EMAIL                  VARCHAR(100) DEFAULT 'Sem E-mail', 
                                      COORD_DataVinculo            VARCHAR(100) DEFAULT 'Sem Vínculo',
                                      COORD_NOME                   VARCHAR(200) DEFAULT 'Sem Nome',
                                      COORD_PrimeiroAcesso         VARCHAR(100) DEFAULT 'Nunca Acessou',
                                      COORD_UltimoAcesso 			VARCHAR(100) DEFAULT 'Nunca Acessou'
                               );   
    
	CREATE INDEX idx_CURGRP_BIGDI ON tbl_indicadores_bigdi (ID_CURSO, ID_GRUPO_PRESENCIAL);
	CREATE INDEX idx_CURGRP_BIGDI_VIR ON tbl_indicadores_bigdi (ID_CURSO,ID_GRUPO_VIRTUAL);
	CREATE INDEX idx_CUR_BIGDI ON tbl_indicadores_bigdi (ID_CURSO);
	CREATE INDEX idx_GRP_BIGDI_P ON tbl_indicadores_bigdi (ID_GRUPO_PRESENCIAL);
	CREATE INDEX idx_GRP_BIGDI_V ON tbl_indicadores_bigdi (ID_GRUPO_VIRTUAL);
	CREATE INDEX idx_GRP_LOGIN ON tbl_indicadores_bigdi (LOGIN);
	CREATE INDEX idx_GRP_UC ON tbl_indicadores_bigdi (USERID, ID_CURSO);

				
					INSERT INTO carga_base_prof_bigdi
							        SELECT DISTINCT 
												c.id AS COURSE, 
												g.id AS GROUP_ID, 
												GROUP_CONCAT(DISTINCT u.id ORDER BY u.id ASC) AS TUTOR_ID, 
												GROUP_CONCAT(DISTINCT u.username ORDER BY u.id ASC) AS TUTOR_LOGIN, 
												GROUP_CONCAT(DISTINCT u.email ORDER BY u.id ASC) AS TUTOR_EMAIL, 
					               		DATE_FORMAT(FROM_UNIXTIME(MIN(gm.timeadded)),'%d/%m/%Y %H:%i:%s') AS TUTOR_DataVinculo,
					                     UPPER(GROUP_CONCAT(DISTINCT CONCAT(u.firstname, ' ',u.lastname) ORDER BY u.id ASC)) AS TUTOR_NOME,
												COALESCE(FROM_UNIXTIME(MIN(l.DT)-10800,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_PrimeiroAcesso,
												COALESCE(FROM_UNIXTIME(MAX(l.DT)-10800,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_UltimoAcesso
							      FROM anh_academico_matricula anh
							      JOIN mdl_user u on u.username=anh.username and u.mnethostid=1
							      JOIN mdl_course c on c.shortname=anh.shortname
									JOIN mdl_groups g on g.description=anh.grupo and g.courseid=c.id
									JOIN mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
									LEFT JOIN tbl_login l on l.userid=u.id and l.course=c.id
							        WHERE 
									   anh.shortname='DI_SOCIE_BRASIL_CIDAD' AND anh.role='editingteacher'  
									GROUP BY c.id, g.id;

					INSERT INTO carga_base_coord_bigdi
							        SELECT DISTINCT 
												c.id AS COURSE, 
												g.id AS GROUP_ID, 
												GROUP_CONCAT(DISTINCT u.id ORDER BY u.id ASC) AS TUTOR_ID, 
												GROUP_CONCAT(DISTINCT u.username ORDER BY u.id ASC) AS TUTOR_LOGIN, 
												GROUP_CONCAT(DISTINCT u.email ORDER BY u.id ASC) AS TUTOR_EMAIL, 
					               		DATE_FORMAT(FROM_UNIXTIME(MIN(gm.timeadded)),'%d/%m/%Y %H:%i:%s') AS TUTOR_DataVinculo,
					                     UPPER(GROUP_CONCAT(DISTINCT CONCAT(u.firstname, ' ',u.lastname) ORDER BY u.id ASC)) AS TUTOR_NOME,
												COALESCE(FROM_UNIXTIME(MIN(l.DT)-10800,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_PrimeiroAcesso,
												COALESCE(FROM_UNIXTIME(MAX(l.DT)-10800,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_UltimoAcesso
							      FROM anh_academico_matricula anh
							      JOIN mdl_user u on u.username=anh.username and u.mnethostid=1
							      JOIN mdl_course c on c.shortname=anh.shortname
									JOIN mdl_groups g on g.description=anh.grupo and g.courseid=c.id
									JOIN mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
									LEFT JOIN tbl_login l on l.userid=u.id and l.course=c.id
							        WHERE 
									   anh.shortname='DI_SOCIE_BRASIL_CIDAD' AND anh.role='coordteacher'  
									GROUP BY c.id, g.id;

		  
    DROP TABLE IF EXISTS carga_base_tutor_bigdi;

    CREATE TEMPORARY TABLE carga_base_tutor_bigdi ( TUTOR_ID               BIGINT, 
                                                  TUTOR_LOGIN            VARCHAR(100), 
                                                  TUTOR_EMAIL            VARCHAR(100), 
                                                  COURSE                 BIGINT,
																  GROUP_ID					 BIGINT, 
                                                  TUTOR_DataVinculo      VARCHAR(100),
                                                  TUTOR_NOME             VARCHAR(200),
                                                  TUTOR_PrimeiroAcesso   VARCHAR(100),
                                                  TUTOR_UltimoAcesso     VARCHAR(100) );
                                                                                         
    CREATE INDEX idx_GROUP_ID ON carga_base_tutor_bigdi (COURSE, GROUP_ID);
	
    
    INSERT INTO carga_base_tutor_bigdi
                SELECT DISTINCT u.id AS TUTOR_ID, u.username AS TUTOR_LOGIN, u.email AS TUTOR_EMAIL, 
					 					  c.id AS COURSE, g.id AS GROUP_ID, 
               					  IFNULL((DATE_FORMAT(FROM_UNIXTIME(gm.timeadded),'%d/%m/%Y %H:%i:%s')), 'Nunca Acessou') AS TUTOR_DataVinculo,
                                UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS TUTOR_NOME,
							           IFNULL((SELECT IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
												  	  FROM tbl_login l 
													 WHERE l.userid = u.id 
													   AND l.course = c.id), 'Nunca Acessou') AS TUTOR_PrimeiroAcesso,
           IFNULL((
			  		SELECT COALESCE(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_UltimoAcesso 
				   FROM tbl_login l WHERE l.userid = u.id AND l.course = c.id), 'Nunca Acessou') AS TUTOR_UltimoAcesso
        FROM mdl_context ct 
        JOIN mdl_course c ON c.id = ct.instanceid
        JOIN mdl_course_categories cc ON cc.id = c.category
        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
        JOIN mdl_role r on r.id=ra.roleid and r.shortname='tutor'
        JOIN mdl_user u ON u.id = ra.userid
        JOIN mdl_groups g ON g.courseid = c.id
        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
        WHERE ct.contextlevel = 50
		  AND c.shortname='DI_SOCIE_BRASIL_CIDAD';


		  		INSERT INTO tbl_indicadores_bigdi 
				(
				 COD_UNIDADE, UNIDADE, ID_CURSO, NOME_CURSO, FULLNAME, ID_CATEGORIA,
				 ID_CURSO_KLS, COD_CURSO_KLS, NOME_CURSO_KLS,
 				 NOME_CATEGORIA, IDNUMBER_GRUPO, ID_GRUPO_PRESENCIAL, GRUPO_PRESENCIAL, USERID, LOGIN, NOME, 
				 EMAIL, DataVinculoDisciplina
				)
		  		SELECT DISTINCT 
					i.cd_instituicao AS COD_UNIDADE
					,i.nm_ies AS UNIDADE
					,c.id AS ID_CURSO 
					,c.shortname AS NOME_CURSO
		        	,c.fullname AS FULLNAME
    				,cc.id AS ID_CATEGORIA
					,kc.id_curso
					,kc.cd_curso
					,kc.nm_curso
					,cc.name AS NOME_CATEGORIA
					,g.description AS IDNUMBER_GRUPO
					,g.id AS ID_GRUPO
					,g.name AS GRUPO
					,u.id AS USERID 
					,u.username AS LOGIN 
					,UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS NOME 
					,u.email AS EMAIL
					,IFNULL(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina   
            	FROM mdl_context ct 
					JOIN mdl_course c ON c.id = ct.instanceid
					JOIN mdl_course_categories cc ON cc.id = c.category
					JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
					JOIN mdl_role r on r.id=ra.roleid AND r.shortname='student'
					JOIN mdl_user u ON u.id = ra.userid and u.deleted=0
					JOIN mdl_groups g ON g.courseid = c.id
					JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
					JOIN kls_lms_turmas t on t.shortname=g.description and t.fl_etl_atu REGEXP '[NA]'
					JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
					JOIN kls_lms_curso kc on kc.id_curso=cd.id_curso and kc.fl_etl_atu REGEXP '[NA]'
					JOIN kls_lms_instituicao i on i.id_ies=kc.id_ies
					JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
					WHERE ct.contextlevel = 50 AND c.shortname='DI_SOCIE_BRASIL_CIDAD';

			UPDATE tbl_indicadores_bigdi t 
			  JOIN kls_lms_pessoa p ON p.login = t.LOGIN
			  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa 
			  JOIN kls_lms_papel pa on pa.id_papel=pcd.id_papel and pa.ds_papel='ALUNO'
			  JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina AND cd.shortname = t.NOME_CURSO
			  JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			   SET t.ID_CURSO_KLS = c.id_curso, t.COD_CURSO_KLS = c.cd_curso, t.NOME_CURSO_KLS = c.nm_curso
				WHERE pcd.fl_etl_atu REGEXP '[NA]'
			   AND cd.fl_etl_atu REGEXP '[NA]'
				AND c.fl_etl_atu REGEXP '[NA]';

		  UPDATE tbl_indicadores_bigdi bigdi
		  JOIN anh_aluno_matricula anh ON bigdi.LOGIN=anh.USERNAME AND anh.SHORTNAME=bigdi.NOME_CURSO AND anh.SIGLA='DI'
		  JOIN mdl_course c on c.shortname=anh.shortname
		  JOIN mdl_groups g on g.name=anh.grupo
		  JOIN mdl_groups_members gm on gm.userid=bigdi.USERID and gm.groupid=g.id
		  SET ID_GRUPO_VIRTUAL=g.id, GRUPO_TUTOR=g.name;
		  
	     UPDATE tbl_indicadores_bigdi t
	     SET t.PrimeiroAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');


		
     		UPDATE tbl_indicadores_bigdi t
     		SET t.UltimoAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
													   FROM tbl_login l
													   WHERE l.USERID = t.USERID 
															AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');

  
	  		UPDATE tbl_indicadores_bigdi t
	  		SET t.QuantDiasAcesso = IFNULL((SELECT COUNT(DISTINCT DATE_FORMAT(FROM_UNIXTIME(l.DT),'%d/%m/%Y')) 
		 											FROM tbl_login l
												  WHERE l.USERID = t.USERID 
												    AND l.COURSE = t.ID_CURSO), 0);
 

				UPDATE tbl_indicadores_bigdi t
        		JOIN carga_base_prof_bigdi bt ON bt.GROUP_ID = t.ID_GRUPO_PRESENCIAL AND bt.COURSE = t.ID_CURSO
		      SET t.PROF_ID = bt.TUTOR_ID, 
					 t.PROF_LOGIN = bt.TUTOR_LOGIN, 
					 t.PROF_EMAIL = bt.TUTOR_EMAIL, 
					 t.PROF_DataVinculo = bt.TUTOR_DataVinculo, 
					 t.PROF_NOME = bt.TUTOR_NOME, 
					 t.PROF_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
					 t.PROF_UltimoAcesso = bt.TUTOR_UltimoAcesso;

				UPDATE tbl_indicadores_bigdi t
        		JOIN carga_base_tutor_bigdi bt ON bt.GROUP_ID = t.ID_GRUPO_VIRTUAL AND bt.COURSE = t.ID_CURSO
		      SET t.TUTOR_ID = bt.TUTOR_ID, 
					 t.TUTOR_LOGIN = bt.TUTOR_LOGIN, 
					 t.TUTOR_EMAIL = bt.TUTOR_EMAIL, 
					 t.TUTOR_DataVinculo = bt.TUTOR_DataVinculo, 
					 t.TUTOR_NOME = bt.TUTOR_NOME, 
					 t.TUTOR_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
					 t.TUTOR_UltimoAcesso = bt.TUTOR_UltimoAcesso;

  				UPDATE tbl_indicadores_bigdi t
        		JOIN carga_base_coord_bigdi bt ON bt.GROUP_ID = t.ID_GRUPO_PRESENCIAL AND bt.COURSE = t.ID_CURSO
		      SET t.COORD_ID = bt.COORD_ID, 
					 t.COORD_LOGIN = bt.COORD_LOGIN, 
					 t.COORD_EMAIL = bt.COORD_EMAIL, 
					 t.COORD_DataVinculo = bt.COORD_DataVinculo, 
					 t.COORD_NOME = bt.COORD_NOME, 
					 t.COORD_PrimeiroAcesso = bt.COORD_PrimeiroAcesso, 
					 t.COORD_UltimoAcesso = bt.COORD_UltimoAcesso;
         
         SET U_QUIZ_ = 0;
         
         WHILE U_QUIZ_ < 4 DO
            
          SET U_QUIZ_ = U_QUIZ_ + 1;
          
          SET S_QUIZ_ = 0;
            
            WHILE S_QUIZ_ < 3 DO
            
                SET S_QUIZ_ = S_QUIZ_ + 1;
                  
                SET @item = CONCAT('''^(U', U_QUIZ_, 'S', S_QUIZ_, ').*DIAG''');
                
                SET @campo = CONCAT('QUIZ_U', U_QUIZ_, 'S', S_QUIZ_, '_DIAGNOSTICA');


					 SET @query = CONCAT('
						UPDATE tbl_indicadores_bigdi t 
						SET t.QUIZ_U',U_QUIZ_,'S',S_QUIZ_,'_DIAGNOSTICA = IFNULL(
								(
									SELECT CAST(MAX(gg.FINALGRADE) AS decimal(3, 1))
									FROM mdl_grade_grades gg
									JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
									WHERE gg.USERID = t.USERID
											AND gi.courseid = t.ID_CURSO
											AND gi.itemname REGEXP ''^(U',U_QUIZ_,'S',S_QUIZ_,').*DIAG'' 
											AND gi.itemname REGEXP ''(tica)$''
								 ), -1);
					');
	                                        
              PREPARE stmt FROM @query;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;                          
 
 		        SET @query=CONCAT('
			     UPDATE tbl_indicadores_bigdi A
				  SET ',@campo,'=-2 
				  WHERE NOME_CURSO IN (
				    SELECT DISTINCT c.shortname
				    FROM mdl_course c 
				    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
				    WHERE q.id IS NULL AND c.shortname=''DI_SOCIE_BRASIL_CIDAD''
				  );
				  '
				  );
							PREPARE stmt FROM @query;
							EXECUTE stmt;
							DEALLOCATE PREPARE stmt;	
           			     
           END WHILE;
           
       END WHILE;
        
    
    
  
         SET U_QUIZ_ = 0;
         
      WHILE U_QUIZ_ < 4 DO
            
          SET U_QUIZ_ = U_QUIZ_ + 1;
          
          SET S_QUIZ_ = 0;
            
            WHILE S_QUIZ_ < 3 DO
            
           
                  SET S_QUIZ_ = S_QUIZ_ + 1;
                  
                SET @item = CONCAT('''^(U', U_QUIZ_, 'S', S_QUIZ_, ').*APREN''');
                
                SET @campo = CONCAT('QUIZ_U', U_QUIZ_, 'S', S_QUIZ_, '_APRENDIZAGEM');
                
                SET @query = CONCAT('UPDATE tbl_indicadores_bigdi t 
                                        SET t.', @campo, ' = IFNULL((SELECT CAST(MAX(gg.FINALGRADE) AS decimal(3, 1))
																	    FROM mdl_grade_grades gg
																	    JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
																	   WHERE gg.USERID = t.USERID
																	     AND gi.courseid = t.ID_CURSO
																	     AND gi.itemname REGEXP ', @item,' AND gi.itemname REGEXP "(agem)$"), -1)');
                                        
              PREPARE stmt FROM @query;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;                          
  
 		        SET @query=CONCAT('
			     UPDATE tbl_indicadores_bigdi A
				  SET ',@campo,'=-2 
				  WHERE NOME_CURSO IN (
				    SELECT DISTINCT c.shortname
				    FROM mdl_course c 
				    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
				    WHERE q.id IS NULL AND c.shortname=''DI_SOCIE_BRASIL_CIDAD''
				  )
				  '
				  );
							PREPARE stmt FROM @query;
							EXECUTE stmt;
							DEALLOCATE PREPARE stmt;                        
              
           END WHILE;
           
       END WHILE;
    
        
    
         SET U_QUIZ_ = 0;
         
      WHILE U_QUIZ_ < 4 DO

          SET U_QUIZ_ = U_QUIZ_ + 1;
              
            SET @item = CONCAT('"^(U', U_QUIZ_, ')"');
            
            SET @campo = CONCAT('QUIZ_U', U_QUIZ_);
            
            SET @query = CONCAT('UPDATE tbl_indicadores_bigdi t 
									SET t.', @campo, ' = IFNULL((SELECT CAST(MAX(gg.FINALGRADE) AS decimal(3, 1))
																   FROM mdl_grade_grades gg
																   JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
																  WHERE gg.USERID = t.USERID
																    AND gi.courseid = t.ID_CURSO
																    AND gi.itemname REGEXP ', @item, 
																  ' AND gi.itemname REGEXP "(dade)$"), -1)');
                                    
          PREPARE stmt FROM @query;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

  
 		        SET @query=CONCAT('
			     UPDATE tbl_indicadores_bigdi A
				  SET ',@campo,'=-2 
				  WHERE NOME_CURSO IN (
				    SELECT DISTINCT c.shortname
				    FROM mdl_course c 
				    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
				    WHERE q.id IS NULL AND c.shortname=''DI_SOCIE_BRASIL_CIDAD''
				  )
				  '
				  );
							PREPARE stmt FROM @query;
							EXECUTE stmt;
							DEALLOCATE PREPARE stmt;  
           
       END WHILE;
  
      	
 		DROP TABLE IF EXISTS carga_base_prof_bigdi;
 		DROP TABLE IF EXISTS carga_base_coord_bigdi;
	
update tbl_indicadores_bigdi a 
set a.PrimeiroAcessoDisciplina=(
			select from_unixtime(min(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.PrimeiroAcessoDisciplina='Nunca Acessou' and
		a.QUIZ_U1S1_DIAGNOSTICA>=0;
		
update tbl_indicadores_bigdi a 
set a.UltimoAcessoDisciplina=(
			select from_unixtime(max(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.UltimoAcessoDisciplina='Nunca Acessou' and
		a.QUIZ_U1S1_DIAGNOSTICA>=0;
				
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_bigdi)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
