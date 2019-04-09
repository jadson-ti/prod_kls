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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_NPJ
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_INDICADORES_NPJ`()
MAIN: BEGIN
		  
 	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;	
	DECLARE N_ASSIGN_ 	INT DEFAULT 0 ;
		  
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_NPJ', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
   SET ID_LOG_=LAST_INSERT_ID();
        
   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;		  
    DROP TABLE IF EXISTS carga_base_tutor_npj;

    CREATE TEMPORARY TABLE carga_base_tutor_npj ( TUTOR_ID               BIGINT, 
                                                  TUTOR_LOGIN            VARCHAR(100), 
                                                  TUTOR_EMAIL            VARCHAR(100), 
                                                  COURSE                 BIGINT,
																  GROUP_ID					 BIGINT, 
                                                  TUTOR_DataVinculo      VARCHAR(100),
                                                  TUTOR_NOME             VARCHAR(200),
                                                  TUTOR_PrimeiroAcesso   VARCHAR(100),
                                                  TUTOR_UltimoAcesso     VARCHAR(100) );
                                                                                         
    CREATE INDEX idx_GROUP_ID ON carga_base_tutor_npj (GROUP_ID);
	
	
	INSERT INTO carga_base_tutor_npj
                SELECT DISTINCT u.id AS TUTOR_ID, u.username AS TUTOR_LOGIN, u.email AS TUTOR_EMAIL, 
					 					  c.id AS COURSE, g.id AS GROUP_ID, 
               					  (DATE_FORMAT(FROM_UNIXTIME(gm.timeadded),'%d/%m/%Y %H:%i:%s')) AS TUTOR_DataVinculo,
                                UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS TUTOR_NOME,
           							  IFNULL((SELECT IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') 
												  	  FROM tbl_login l 
													 WHERE l.userid = u.id 
													   AND l.course = c.id), 'Nunca Acessou') AS TUTOR_PrimeiroAcesso,
           (SELECT COALESCE(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS TUTOR_UltimoAcesso 
				  FROM tbl_login l WHERE l.userid = u.id AND l.course = c.id) AS TUTOR_UltimoAcesso
        FROM mdl_context ct 
        JOIN mdl_course c ON c.id = ct.instanceid
        JOIN mdl_course_categories cc ON cc.id = c.category
        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
        JOIN mdl_role r on r.id=ra.roleid and r.shortname='tutor'
        JOIN mdl_user u ON u.id = ra.userid
        JOIN mdl_groups g ON g.courseid = c.id
        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
        WHERE ct.contextlevel = 50
        AND c.fullname = 'Estágio Supervisionado II' and c.shortname LIKE 'NPJ%';

        DROP TABLE IF EXISTS tbl_indicadores_npj;

        CREATE TABLE tbl_indicadores_npj ( COD_UNIDADE									VARCHAR(100),
        												 UNIDADE											VARCHAR(100),
		  												 ID_CURSO_KLS									BIGINT,
		  												 COD_CURSO_KLS									VARCHAR(100),
		  												 NOME_CURSO_KLS								VARCHAR(200),
														 ID_CURSO							   		BIGINT,
			  											 NOME_CURSO                 				VARCHAR(100),
			  											 FULLNAME										VARCHAR(200),
			  											 ID_Categoria									BIGINT,
														 Nome_Categoria								VARCHAR(100), 
														 ID_GRUPO										BIGINT,
		                                     GRUPO                      				VARCHAR(100),
		                                     USERID                     				BIGINT,
		                                     LOGIN                      				VARCHAR(100),
		                                     NOME                       				VARCHAR(200), 
		                                     EMAIL                      				VARCHAR(100), 
		                                     DataVinculoDisciplina      				VARCHAR(100),
		                                     PrimeiroAcessoDisciplina   				VARCHAR(100),
		                                     UltimoAcessoDisciplina     				VARCHAR(100),
		                                     QuantDiasAcesso            				BIGINT,
		                                     ATIVIDADE_1_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_2_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_3_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_4_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_5_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_6_ALUNO_PENAL         		VARCHAR(100),
			                                  ATIVIDADE_1_ALUNO_TRABALHISTA   		VARCHAR(100),
			                                  ATIVIDADE_2_ALUNO_TRABALHISTA   		VARCHAR(100), 
			                                  ATIVIDADE_3_ALUNO_TRABALHISTA   		VARCHAR(100), 
			                                  ATIVIDADE_4_ALUNO_TRABALHISTA   		VARCHAR(100), 
			                                  ATIVIDADE_5_ALUNO_TRABALHISTA   		VARCHAR(100), 
			                                  ATIVIDADE_6_ALUNO_TRABALHISTA   		VARCHAR(100),
		                                     TUTOR_ID                        		BIGINT, 
		                                     TUTOR_LOGIN                     		VARCHAR(100), 
		                                     TUTOR_EMAIL                     		VARCHAR(100), 
		                                     TUTOR_DataVinculo               		VARCHAR(100),
		                                     TUTOR_NOME                      		VARCHAR(200),
		                                     TUTOR_PrimeiroAcesso            		VARCHAR(100),
		                                     TUTOR_UltimoAcesso              		VARCHAR(100),
		                                     ATIVIDADE_1_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_1_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_2_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_2_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_3_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_3_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_4_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_4_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_5_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_5_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_6_AVALIACAO_PENAL     		VARCHAR(100),
			                                  ATIVIDADE_6_NOTA_PENAL          		VARCHAR(50),
			                                  ATIVIDADE_1_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_1_NOTA_TRABALHISTA          VARCHAR(50),
			                                  ATIVIDADE_2_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_2_NOTA_TRABALHISTA          VARCHAR(50),
			                                  ATIVIDADE_3_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_3_NOTA_TRABALHISTA          VARCHAR(50),
			                                  ATIVIDADE_4_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_4_NOTA_TRABALHISTA          VARCHAR(50),
			                                  ATIVIDADE_5_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_5_NOTA_TRABALHISTA          VARCHAR(50),
			                                  ATIVIDADE_6_AVALIACAO_TRABALHISTA     VARCHAR(100),
			                                  ATIVIDADE_6_NOTA_TRABALHISTA          VARCHAR(50),
			                                  INDEX idx_userid (USERID)
									             );   

        INSERT INTO tbl_indicadores_npj
                SELECT DISTINCT i.cd_instituicao AS COD_UNIDADE,
					 			i.nm_ies  AS UNIDADE,
								kc.id_curso,
			   				kc.cd_curso,
			   				kc.nm_curso,
					 			c.id AS ID_CURSO, 
					 			c.shortname AS NOME_CURSO,
        						c.fullname AS FULLNAME,
        						cc.id AS ID_Categoria,
								cc.name AS Nome_Categoria,
								g.id AS ID_GRUPO,
								g.name AS GRUPO,
                        u.id AS USERID, u.username AS LOGIN, 
								UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS nome, u.email,
                        IFNULL(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina,
						      
				'Nunca Acessou' AS PrimeiroAcessoDisciplina,
				'Nunca Acessou' AS UltimoAcessoDisciplina,
			    0 AS QuantDiasAcesso,
            
				'PENDENTE' AS ATIVIDADE_1_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_2_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_3_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_4_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_5_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_6_ALUNO_PENAL,
				'PENDENTE' AS ATIVIDADE_1_ALUNO_TRABALHISTA,
				'PENDENTE' AS ATIVIDADE_2_ALUNO_TRABALHISTA,
				'PENDENTE' AS ATIVIDADE_3_ALUNO_TRABALHISTA,
				'PENDENTE' AS ATIVIDADE_4_ALUNO_TRABALHISTA,
				'PENDENTE' AS ATIVIDADE_5_ALUNO_TRABALHISTA,   
				'PENDENTE' AS ATIVIDADE_6_ALUNO_TRABALHISTA,

             0 AS TUTOR_ID, 
				'Sem Tutor' AS TUTOR_LOGIN, 
				'Sem E-mail' AS TUTOR_EMAIL, 
				'Sem Vínculo' AS TUTOR_DataVinculo, 
				'Sem Nome' AS TUTOR_NOME, 
				'Nunca Acessou' AS TUTOR_PrimeiroAcesso, 
				'Nunca Acessou' AS TUTOR_UltimoAcesso,
            'PENDENTE' AS ATIVIDADE_1_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_1_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_2_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_2_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_3_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_3_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_4_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_4_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_5_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_5_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_6_AVALIACAO_PENAL,
	         'PENDENTE' AS ATIVIDADE_6_NOTA_PENAL,
	         'PENDENTE' AS ATIVIDADE_1_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_1_NOTA_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_2_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_2_NOTA_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_3_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_3_NOTA_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_4_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_4_NOTA_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_5_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_5_NOTA_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_6_AVALIACAO_TRABALHISTA,
	         'PENDENTE' AS ATIVIDADE_6_NOTA_TRABALHISTA

        FROM mdl_course c 
        JOIN mdl_course_categories cc on cc.id=c.category
        JOIN mdl_context co ON co.contextlevel=50 and co.instanceid=c.id
        JOIN mdl_role_assignments ra ON ra.contextid = co.id 
        JOIN mdl_role r on r.id=ra.roleid and r.shortname='student'
        JOIN mdl_user u ON u.id = ra.userid
        JOIN mdl_groups_members gm ON gm.userid = u.id
        JOIN mdl_groups g ON g.courseid = c.id AND g.id=gm.groupid
        JOIN kls_lms_pessoa p ON u.username=p.login AND p.fl_etl_atu <>'E'
		  JOIN kls_lms_pessoa_curso_disc pcd on p.id_pessoa = pcd.id_pessoa  and pcd.fl_etl_atu <> 'E'
		  JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina = pcd.id_curso_disciplina   and 
		  												  cd.shortname=c.shortname and cd.fl_etl_atu REGEXP '[NA]'
		  JOIN kls_lms_curso kc ON kc.id_curso = cd.id_curso AND kc.fl_etl_atu<>'E'
		  JOIN kls_lms_instituicao i on i.id_ies = kc.id_ies
        WHERE c.fullname = 'Estágio Supervisionado II' AND c.shortname LIKE 'NPJ%'
		  AND g.name REGEXP 'TUTOR' ;
		      
	  
	  		UPDATE tbl_indicadores_npj t
	  		SET t.PrimeiroAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MIN(l.timecreated)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM mdl_logstore_standard_log l
														  WHERE l.USERID = t.USERID 
														    AND l.courseid = t.ID_CURSO), 'Nunca Acessou');
	  
     
	  		UPDATE tbl_indicadores_npj t
	  		   SET t.UltimoAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MAX(l.timecreated)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														    FROM mdl_logstore_standard_log l
														   WHERE l.USERID = t.USERID 
														     AND l.courseid = t.ID_CURSO), 'Nunca Acessou');


	  UPDATE tbl_indicadores_npj t
	  	  SET t.QuantDiasAcesso = IFNULL((SELECT COUNT(DISTINCT DATE(FROM_UNIXTIME(l.timecreated))) 
		 											FROM mdl_logstore_standard_log l
												  WHERE l.USERID = t.USERID 
												    AND l.courseid = t.ID_CURSO), 0);
     
		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
      		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Temática 1%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_ALUNO_PENAL'); 
	         	
	           	SET @query = CONCAT('UPDATE tbl_indicadores_npj t
												   SET t.', @campo, ' = (SELECT CASE
																								WHEN asub.status = ''submitted'' then 
																									CONCAT(''Postada em '',FROM_UNIXTIME(asub.timemodified-',FUSOHORARIO,',''%d/%m/%Y''))
																								WHEN asub.status = ''reopened'' then
																									CONCAT(''Ultimo Envio '',(SELECT FROM_UNIXTIME(MAX(asub.timemodified)-',FUSOHORARIO,',''%d/%m/%Y'')
																																	  FROM mdl_assign ass	
																																	  JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																																	  WHERE ass.course = t.ID_CURSO
																																			 	AND ass.name LIKE ''', @item, '''
																																				AND asub.status = ''submitted'' 
																																				AND asub.userid = t.USERID))
																								ELSE 
																									''Pendente''
																							END
																		       FROM mdl_assign ass	
																				 JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																		       WHERE ass.course = t.ID_CURSO
																		       	AND ass.name like ''', @item, '''
																		       	AND asub.userid = t.USERID
																				 ORDER BY asub.attemptnumber DESC
																				 limit 1)');
																    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    
			     
	     END WHILE;
	     
														    	
	        
	     SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Temática 2%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_ALUNO_TRABALHISTA'); 
	         	
	           	SET @query = CONCAT('UPDATE tbl_indicadores_npj t
												   SET t.', @campo, ' = (SELECT CASE
																								WHEN asub.status = ''submitted'' then 
																									CONCAT(''Postada em '',FROM_UNIXTIME(MAX(asub.timemodified)-',FUSOHORARIO,',''%d/%m/%Y''))
																								WHEN asub.status = ''reopened'' then
																									CONCAT(''Ultimo Envio '',(SELECT FROM_UNIXTIME(MAX(asub.timemodified)-',FUSOHORARIO,',''%d/%m/%Y'')
																																	  FROM mdl_assign ass	
																																	  JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																																	  WHERE ass.course = t.ID_CURSO
																																			 	AND ass.name LIKE ''', @item, '''
																																				AND asub.status = ''submitted'' 
																																				AND asub.userid = t.USERID))
																								ELSE 
																									''Pendente''
																							END
																		       FROM mdl_assign ass	
																				 JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																		       WHERE ass.course = t.ID_CURSO
																		       	AND ass.name LIKE ''', @item, '''
																		       	AND asub.userid = t.USERID
																				 ORDER BY asub.attemptnumber DESC
																				 limit 1)');
																    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    
			     
	     END WHILE;
		
		    	
		
		  
		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Temática 1%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_AVALIACAO_PENAL');

					drop table if exists tmp_avaliacao_npj;
					create temporary table tmp_avaliacao_npj (
						userid bigint(10),
						course bigint(10),
						assign bigint(10),
						lastsub bigint(20),
						lastgrade bigint(20),
						idlastsub bigint(20),
						idlastgrade bigint(20),
						statuslastsub varchar(50),
						horacorrecao bigint(20),
						situacao varchar(50),
						primary key (userid, course, assign)
					);

					insert into tmp_avaliacao_npj
							select 
								@uid:=asu.userid as userid,
								ma.course,
								@aid:=asu.assignment as assign,
								@lastsub:=MAX(asu.attemptnumber) as lastsub,
								@lastagt:=IFNULL(MAX(agt.attemptnumber),-2) as lastagt,
								@idlastsub:=MAX(asu.id) as idlastsub,
								@idlastgrade:=MAX(agt.id) as idlastgrade,
								'',
								0,
								'' as situacao
						FROM mdl_assign ma 
						join mdl_assign_submission asu on asu.assignment = ma.id
						join tbl_indicadores_npj tcc on tcc.USERID=asu.userid and tcc.ID_CURSO=ma.course 
						left join mdl_assign_grades agt ON agt.assignment = ma.id and asu.userid = agt.userid and asu.attemptnumber=agt.attemptnumber and (agt.grade>=0 or agt.grade is null)
						WHERE  ma.name LIKE @item
								AND asu.status <> 'new'
						GROUP BY asu.userid,asu.assignment;

						update tmp_avaliacao_npj a
						join mdl_assign_submission b on a.idlastsub=b.id
						left join mdl_assign_grades c on a.idlastgrade=c.id
						set a.statuslastsub=b.status, a.horacorrecao=c.timemodified;

					update tmp_avaliacao_npj a
					join mdl_assign_submission b on a.idlastsub=b.id
					set situacao=CASE
					WHEN idlastgrade is null then  'Pendente'
					WHEN statuslastsub = 'submitted' and lastsub=lastgrade then 	
						CONCAT('Corrigida em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'submitted' and lastsub>lastgrade then
						CONCAT('Última Correção em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'reopened' then 
						CONCAT('Reaberta em ', FROM_UNIXTIME(b.timecreated-10800,'%d/%m/%Y'))
				 	END;

					set @query=concat('update tbl_indicadores_npj t join tmp_avaliacao_npj b on t.USERID=b.userid and t.ID_CURSO=b.course
						 set ',@campo,'=b.situacao');
	         		         	
	         	
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    
			     
	     END WHILE;														
																  
		  
		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Temática 2%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_AVALIACAO_TRABALHISTA'); 

					drop table if exists tmp_avaliacao_npj;
					create temporary table tmp_avaliacao_npj (
						userid bigint(10),
						course bigint(10),
						assign bigint(10),
						lastsub bigint(20),
						lastgrade bigint(20),
						idlastsub bigint(20),
						idlastgrade bigint(20),
						statuslastsub varchar(50),
						horacorrecao bigint(20),
						situacao varchar(50),
						primary key (userid, course, assign)
					);

					insert into tmp_avaliacao_npj
							select 
								@uid:=asu.userid as userid,
								ma.course,
								@aid:=asu.assignment as assign,
								@lastsub:=MAX(asu.attemptnumber) as lastsub,
								@lastagt:=IFNULL(MAX(agt.attemptnumber),-2) as lastagt,
								@idlastsub:=MAX(asu.id) as idlastsub,
								@idlastgrade:=MAX(agt.id) as idlastgrade,
								'',
								0,
								'' as situacao
						FROM mdl_assign ma 
						join mdl_assign_submission asu on asu.assignment = ma.id
						join tbl_indicadores_npj tcc on tcc.USERID=asu.userid and tcc.ID_CURSO=ma.course 
						left join mdl_assign_grades agt ON agt.assignment = ma.id and asu.userid = agt.userid and asu.attemptnumber=agt.attemptnumber and (agt.grade>=0 or agt.grade is null)
						WHERE  ma.name LIKE @item
								AND asu.status <> 'new'
						GROUP BY asu.userid,asu.assignment;

						update tmp_avaliacao_npj a
						join mdl_assign_submission b on a.idlastsub=b.id
						left join mdl_assign_grades c on a.idlastgrade=c.id
						set a.statuslastsub=b.status, a.horacorrecao=c.timemodified;

					update tmp_avaliacao_npj a
					join mdl_assign_submission b on a.idlastsub=b.id
					set situacao=CASE
					WHEN idlastgrade is null then  'Pendente'
					WHEN statuslastsub = 'submitted' and lastsub=lastgrade then 	
						CONCAT('Corrigida em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'submitted' and lastsub>lastgrade then
						CONCAT('Última Correção em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'reopened' then 
						CONCAT('Reaberta em ', FROM_UNIXTIME(b.timecreated-10800,'%d/%m/%Y'))
				 	END;

					set @query=concat('update tbl_indicadores_npj t join tmp_avaliacao_npj b on t.USERID=b.userid and t.ID_CURSO=b.course
						 set ',@campo,'=b.situacao');
	         		         	
	  				PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    			     
	     END WHILE; 	
	     
	     											
	     											
	     SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Direito Penal%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_NOTA_PENAL'); 

	         	SET @query = CONCAT('UPDATE tbl_indicadores_npj t 
												   SET t.', @campo, ' = (
																				select coalesce(
																					(
																						select 
																							case
																								when agt.grade is not null and agt.grade >= 0 then 
																									CONCAT(''Nota: '', CAST(agt.grade AS decimal(4, 2)))
																								else ''Pendente''
																							end datas
																						FROM mdl_assign ma
																						join mdl_assign_grades agt ON agt.assignment = ma.id
																															  AND agt.grade is not null
																															  AND agt.grade>=0
																						WHERE ma.course = t.ID_CURSO
																						AND ma.name LIKE ''', @item, '''
																						AND agt.userid = t.USERID
																						order by agt.attemptnumber desc
																						limit 1
																					), ''Pendente'')
																					)');
	         	
																    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    			     
	     END WHILE;
		  									
		  									
		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 6 DO
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT('%Temática 2%', N_ASSIGN_, '%');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_NOTA_TRABALHISTA'); 
	         	
	         	SET @query = CONCAT('UPDATE tbl_indicadores_npj t 
												   SET t.', @campo, ' = (
																				select coalesce(
																					(
																						select 
																							case
																								when agt.grade is not null and agt.grade >= 0 then 
																									CONCAT(''Nota: '', CAST(agt.grade AS decimal(4, 2)))
																								else ''Pendente''
																							end datas
																						FROM mdl_assign ma
																						join mdl_assign_grades agt ON agt.assignment = ma.id
																															  AND agt.grade is not null
																															  AND agt.grade>=0
																						WHERE ma.course = t.ID_CURSO
																						AND ma.name LIKE ''', @item, '''
																						AND agt.userid = t.USERID
																						order by agt.attemptnumber desc
																						limit 1
																					), ''Pendente'')
																					)');
																		         
																    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    
			     
	     END WHILE; 
        		
				UPDATE tbl_indicadores_npj t
        		JOIN carga_base_tutor_npj bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
		      SET t.TUTOR_ID = bt.TUTOR_ID, 
					 t.TUTOR_LOGIN = bt.TUTOR_LOGIN, 
					 t.TUTOR_EMAIL = bt.TUTOR_EMAIL, 
					 t.TUTOR_DataVinculo = bt.TUTOR_DataVinculo, 
					 t.TUTOR_NOME = bt.TUTOR_NOME, 
					 t.TUTOR_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
					 t.TUTOR_UltimoAcesso = bt.TUTOR_UltimoAcesso;
            
        DROP TABLE IF EXISTS carga_base_tutor_npj;  


	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_1_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_1_ALUNO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_2_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_2_ALUNO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_3_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_3_ALUNO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_4_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_4_ALUNO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_5_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_5_ALUNO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_ALUNO_PENAL = 'Pendente' WHERE ATIVIDADE_6_ALUNO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_ALUNO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_6_ALUNO_TRABALHISTA is null;

	  
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_1_AVALIACAO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_2_AVALIACAO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_3_AVALIACAO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_4_AVALIACAO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_5_AVALIACAO_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_AVALIACAO_PENAL = 'Pendente' WHERE ATIVIDADE_5_AVALIACAO_PENAL is null;

	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_1_AVALIACAO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_2_AVALIACAO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_3_AVALIACAO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_4_AVALIACAO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_5_AVALIACAO_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_AVALIACAO_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_5_AVALIACAO_TRABALHISTA is null;

	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_1_NOTA_PENAL is null;
  	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_2_NOTA_PENAL is null;
 	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_3_NOTA_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_4_NOTA_PENAL is null;
 	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_5_NOTA_PENAL is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_NOTA_PENAL = 'Pendente' WHERE ATIVIDADE_5_NOTA_PENAL is null;

	  UPDATE tbl_indicadores_npj SET ATIVIDADE_1_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_1_NOTA_TRABALHISTA is null;
  	  UPDATE tbl_indicadores_npj SET ATIVIDADE_2_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_2_NOTA_TRABALHISTA is null;
 	  UPDATE tbl_indicadores_npj SET ATIVIDADE_3_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_3_NOTA_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_4_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_4_NOTA_TRABALHISTA is null;
 	  UPDATE tbl_indicadores_npj SET ATIVIDADE_5_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_5_NOTA_TRABALHISTA is null;
	  UPDATE tbl_indicadores_npj SET ATIVIDADE_6_NOTA_TRABALHISTA = 'Pendente' WHERE ATIVIDADE_5_NOTA_TRABALHISTA is null;
   

update tbl_indicadores_npj a 
set a.PrimeiroAcessoDisciplina=(
			select from_unixtime(min(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.PrimeiroAcessoDisciplina='Nunca Acessou' and
		a.ATIVIDADE_1_ALUNO_PENAL>=0;
		
update tbl_indicadores_npj a 
set a.UltimoAcessoDisciplina=(
			select from_unixtime(max(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.UltimoAcessoDisciplina='Nunca Acessou' and
		a.ATIVIDADE_1_ALUNO_PENAL>=0;

update tbl_indicadores_npj set PrimeiroAcessoDisciplina='Nunca Acessou' where PrimeiroAcessoDisciplina is null;
update tbl_indicadores_npj set UltimoAcessoDisciplina='Nunca Acessou' where UltimoAcessoDisciplina is null;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_npj)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
