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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_DI2
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INDICADORES_DI2`()
BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	
	DECLARE U_QUIZ_ 		INT DEFAULT 0 ;
	DECLARE S_QUIZ_ 		INT DEFAULT 0 ;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;		
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_DI2', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

	SET ID_LOG_=LAST_INSERT_ID();		  
	
   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;	
		  
		  
    DROP TABLE IF EXISTS carga_base_tutor_di2;

    CREATE TEMPORARY TABLE carga_base_tutor_di2 ( TUTOR_ID               BIGINT, 
                                                  TUTOR_LOGIN            VARCHAR(100), 
                                                  TUTOR_EMAIL            VARCHAR(100), 
                                                  COURSE                 BIGINT,
																  GROUP_ID					 BIGINT, 
                                                  TUTOR_DataVinculo      VARCHAR(100),
                                                  TUTOR_NOME             VARCHAR(200),
                                                  TUTOR_PrimeiroAcesso   VARCHAR(100),
                                                  TUTOR_UltimoAcesso     VARCHAR(100) );
                                                                                         
    CREATE INDEX idx_GROUP_ID ON carga_base_tutor_di2 (COURSE, GROUP_ID);
	
    
    INSERT INTO carga_base_tutor_di2
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
		  AND (cc.name='Disciplinas Interativas KLS 2.0' or cc.name='Disciplinas Interativas KLS 2.0 – Blended');

        DROP TABLE IF EXISTS tbl_indicadores_di2;

        CREATE TABLE tbl_indicadores_di2 ( COD_UNIDADE							VARCHAR(100),
        												 UNIDADE									VARCHAR(100),
        												 ID_CURSO_KLS					 		BIGINT DEFAULT 0,
  														 COD_CURSO_KLS					 		VARCHAR(100) DEFAULT NULL,
  												 		 NOME_CURSO_KLS				 		VARCHAR(200) DEFAULT NULL,
		  												 ID_CURSO							   BIGINT,
			  											 NOME_CURSO                 		VARCHAR(100),
			  											 FULLNAME								VARCHAR(200),
			  											 ID_Categoria							BIGINT,
														 Nome_Categoria						VARCHAR(100), 
														 ID_GRUPO								BIGINT,
		                                     GRUPO                      		VARCHAR(100),
		                                     USERID                     		BIGINT,
		                                     LOGIN                      		VARCHAR(100),
		                                     NOME                       		VARCHAR(200), 
		                                     EMAIL                      		VARCHAR(100), 
		                                     DataVinculoDisciplina      		VARCHAR(100),
		                                     PrimeiroAcessoDisciplina   		VARCHAR(100),
		                                     UltimoAcessoDisciplina     		VARCHAR(100),
		                                     QuantDiasAcesso            		int(11),
		                                     ATIVIDADE_1_ALUNO					VARCHAR(100),
		                                     QUIZ_U1S1_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U1S1_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U1S2_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U1S2_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U1S3_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U1S3_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U1S4_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U1S4_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U1									VARCHAR(50),
		                                     QUIZ_U2S1_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U2S1_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U2S2_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U2S2_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U2S3_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U2S3_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U2S4_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U2S4_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U2									VARCHAR(50),
		                                     QUIZ_U3S1_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U3S1_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U3S2_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U3S2_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U3S3_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U3S3_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U3S4_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U3S4_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U3									VARCHAR(50),
		                                     QUIZ_U4S1_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U4S1_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U4S2_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U4S2_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U4S3_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U4S3_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U4S4_DIAGNOSTICA				VARCHAR(50),
		                                     QUIZ_U4S4_APRENDIZAGEM				VARCHAR(50),
		                                     QUIZ_U4									VARCHAR(50),
		                                     TUTOR_ID                        BIGINT, 
		                                     TUTOR_LOGIN                     VARCHAR(100), 
		                                     TUTOR_EMAIL                     VARCHAR(100), 
		                                     TUTOR_DataVinculo               VARCHAR(100),
		                                     TUTOR_NOME                      VARCHAR(200),
		                                     TUTOR_PrimeiroAcesso            VARCHAR(100),
		                                     TUTOR_UltimoAcesso              VARCHAR(100),
		                                     ATIVIDADE_1_AVALIACAO		      VARCHAR(100),
		                                     ATIVIDADE_1_NOTA		            VARCHAR(50)
									             );   

        CREATE INDEX idx_cursogrupo ON tbl_indicadores_di2 (ID_CURSO, ID_GRUPO);
        CREATE INDEX idx_usercurso ON tbl_indicadores_di2 (ID_CURSO, USERID);
		   
        INSERT INTO tbl_indicadores_di2
                SELECT DISTINCT u.institution AS COD_UNIDADE,
			  					(SELECT i.nm_ies FROM kls_lms_instituicao i WHERE i.cd_instituicao = u.institution) AS UNIDADE,
			  					0 AS ID_CURSO_KLS,
								NULL AS COD_CURSO_KLS,
								NULL AS NOME_CURSO_KLS,
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
			    'PENDENTE' AS ATIVIDADE_1_ALUNO,
				'PENDENTE' AS QUIZ_U1S1_DIAGNOSTICA,				
		      'PENDENTE' AS QUIZ_U1S1_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U1S2_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U1S2_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U1S3_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U1S3_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U1S4_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U1S4_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U1,
		      'PENDENTE' AS QUIZ_U2S1_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U2S1_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U2S2_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U2S2_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U2S3_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U2S3_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U2S4_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U2S4_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U2,
		      'PENDENTE' AS QUIZ_U3S1_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U3S1_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U3S2_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U3S2_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U3S3_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U3S3_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U3S4_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U3S4_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U3,
		      'PENDENTE' AS QUIZ_U4S1_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U4S1_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U4S2_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U4S2_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U4S3_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U4S3_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U4S4_DIAGNOSTICA,
		      'PENDENTE' AS QUIZ_U4S4_APRENDIZAGEM,
		      'PENDENTE' AS QUIZ_U4,   
				   
   
            
             0 AS TUTOR_ID, 
				'Sem Tutor' AS TUTOR_LOGIN, 
				'Sem E-mail' AS TUTOR_EMAIL, 
				'Sem Vínculo' AS TUTOR_DataVinculo, 
				'Sem Nome' AS TUTOR_NOME, 
				'Nunca Acessou' AS TUTOR_PrimeiroAcesso, 
				'Nunca Acessou' AS TUTOR_UltimoAcesso,
            'PENDENTE' AS ATIVIDADE_1_AVALIACAO,
	         'PENDENTE' AS ATIVIDADE_1_NOTA
              
   
              
        FROM mdl_context ct 
        JOIN mdl_course c ON c.id = ct.instanceid
        JOIN mdl_course_categories cc ON cc.id = c.category
        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
        JOIN mdl_role r on r.id=ra.roleid and r.shortname='student' 
        JOIN mdl_user u ON u.id = ra.userid
        JOIN mdl_groups g ON g.courseid = c.id
        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
        WHERE ct.contextlevel = 50
			AND (cc.name='Disciplinas Interativas KLS 2.0' or cc.name='Disciplinas Interativas KLS 2.0 – Blended')
			 AND g.name REGEXP 'TUTOR';
    
     
     
			UPDATE tbl_indicadores_di2 t 
			  JOIN kls_lms_pessoa p ON p.login = t.LOGIN
			  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
			  JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
			  											 AND cd.shortname = t.NOME_CURSO
			  JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			   SET t.ID_CURSO_KLS = c.id_curso,
				    t.COD_CURSO_KLS = c.cd_curso,
				    t.NOME_CURSO_KLS = c.nm_curso
			 WHERE 
			       pcd.id_papel = 1
				AND pcd.fl_etl_atu REGEXP '[NA]'
				AND cd.fl_etl_atu REGEXP '[NA]'
			   AND c.fl_etl_atu REGEXP '[NA]';
	  
     
     
     
     
	  		UPDATE tbl_indicadores_di2 t
	  		SET t.PrimeiroAcessoDisciplina = IFNULL((SELECT 
															  		IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
     
	  		UPDATE tbl_indicadores_di2 t
	  		   SET t.UltimoAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														    FROM tbl_login l
														   WHERE l.USERID = t.USERID 
														     AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
	  
		  UPDATE tbl_indicadores_di2 t
		  	  SET t.QuantDiasAcesso = IFNULL(( SELECT COUNT(DISTINCT DATE_FORMAT(FROM_UNIXTIME(l.DT),'%d/%m/%Y')) 
		 											FROM tbl_login l
												  WHERE l.USERID = t.USERID 
												    AND l.COURSE = t.ID_CURSO), 0);
     

	  
    
	  

       	UPDATE tbl_indicadores_di2 t
				SET t.ATIVIDADE_1_ALUNO = (SELECT CASE
												WHEN asub.status = 'submitted' then 
													CONCAT('Postada em ',FROM_UNIXTIME(asub.timemodified-FUSOHORARIO,'%d/%m/%Y'))
												WHEN asub.status = 'reopened' then
													CONCAT('Ultimo Envio ',(SELECT FROM_UNIXTIME(MAX(asub.timemodified)-FUSOHORARIO,'%d/%m/%Y')
																					  FROM mdl_assign ass	
																					  JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																					  WHERE ass.course = t.ID_CURSO
																						AND ass.name='Atividade Discursiva'
																						AND asub.status = 'submitted' 
																						AND asub.userid = t.USERID))
												ELSE 
													'Pendente'
												END
												FROM mdl_assign ass	
												JOIN mdl_assign_submission asub ON asub.assignment = ass.id
												WHERE ass.course = t.ID_CURSO
													AND ass.name='Atividade Discursiva'
													AND asub.userid = t.USERID
												ORDER BY asub.attemptnumber DESC
												limit 1);

				


					drop table if exists tmp_avaliacao_di2;
					create temporary table tmp_avaliacao_di2 (
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

					alter table tmp_avaliacao_di2 add index idx_uc (userid, course);
					
					insert into tmp_avaliacao_di2
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
						join tbl_indicadores_di2 tcc on tcc.USERID=asu.userid and tcc.ID_CURSO=ma.course 
						left join mdl_assign_grades agt ON agt.assignment = ma.id and asu.userid = agt.userid and asu.attemptnumber=agt.attemptnumber and (agt.grade>=0 or agt.grade is null)
						WHERE  ma.name='Atividade Discursiva'
								AND asu.status <> 'new'
						GROUP BY asu.userid,asu.assignment;

						update tmp_avaliacao_di2 a
						join mdl_assign_submission b on a.idlastsub=b.id
						left join mdl_assign_grades c on a.idlastgrade=c.id
						set a.statuslastsub=b.status, a.horacorrecao=c.timemodified;

					update tmp_avaliacao_di2 a
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

					update tbl_indicadores_di2 t 
					join tmp_avaliacao_di2 b on t.USERID=b.userid and t.ID_CURSO=b.course
					set ATIVIDADE_1_AVALIACAO=b.situacao;


	         	UPDATE tbl_indicadores_di2 t 
					SET t.ATIVIDADE_1_NOTA = (
														select coalesce(
														(
															select 
																case
																	when agt.grade is not null and agt.grade >= 0 then 
																		CONCAT('Nota: ', CAST(agt.grade AS decimal(4, 2)))
																	else 'Pendente'
																end datas
																FROM mdl_assign ma
																join mdl_assign_grades agt ON agt.assignment = ma.id
																 	 								   AND agt.grade is not null
																									   AND agt.grade>=0
																WHERE ma.course = t.ID_CURSO
																			AND ma.name='Atividade Discursiva'
																			AND agt.userid = t.USERID
																order by agt.attemptnumber desc
																limit 1
															), 'Pendente')
													);
							              
	  
     
    
        
        SET U_QUIZ_ = 0;
        
        WHILE U_QUIZ_ < 4 DO
        		
				  SET U_QUIZ_ = U_QUIZ_ + 1;
				  
				  SET S_QUIZ_ = 0;
        		
		        WHILE S_QUIZ_ < 4 DO
		        

			        	SET S_QUIZ_ = S_QUIZ_ + 1;
                SET @item = CONCAT('''^(U', U_QUIZ_, 'S', S_QUIZ_, ').*DIAG''');
                
                SET @campo = CONCAT('QUIZ_U', U_QUIZ_, 'S', S_QUIZ_, '_DIAGNOSTICA');			        		
						 SET @query = CONCAT('
							UPDATE tbl_indicadores_di2 t 
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
						     UPDATE tbl_indicadores_di2 A
				  					SET ',@campo,'=-2 
				  			  WHERE NOME_CURSO IN (
							    SELECT DISTINCT c.shortname
								    FROM mdl_course c 
							    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
								    WHERE q.id IS NULL AND c.shortname REGEXP ''^DI''
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
        		
		        WHILE S_QUIZ_ < 4 DO
		        
		        
			        		SET S_QUIZ_ = S_QUIZ_ + 1;
			        		
                SET @item = CONCAT('''^(U', U_QUIZ_, 'S', S_QUIZ_, ').*APREN''');
                
                SET @campo = CONCAT('QUIZ_U', U_QUIZ_, 'S', S_QUIZ_, '_APRENDIZAGEM');
					 			         	
			         	SET @query = CONCAT('UPDATE tbl_indicadores_di2 t 
										  SET t.', @campo, ' = IFNULL((SELECT CONCAT("Nota: ", CAST(MAX(gg.FINALGRADE) AS decimal(4, 2)))
																		 FROM mdl_grade_grades gg
																		 JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
																		WHERE gg.USERID = t.USERID
																		  AND gi.courseid = t.ID_CURSO
																		  AND gg.FINALGRADE>=0 
																		  AND gi.itemname REGEXP ', @item,
																		  ' AND gi.itemname REGEXP "(agem)$"), "PENDENTE")');
																		    
							PREPARE stmt FROM @query;
							EXECUTE stmt;
							DEALLOCATE PREPARE stmt;											    

		 		        SET @query=CONCAT('
						     UPDATE tbl_indicadores_di2 A
				  					SET ',@campo,'=-2 
				  			  WHERE NOME_CURSO IN (
							    SELECT DISTINCT c.shortname
								    FROM mdl_course c 
							    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
								    WHERE q.id IS NULL AND c.shortname REGEXP ''^DI''
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
	        		
	         	SET @item = CONCAT('"^(U', U_QUIZ_, ')"');
	         	
	         	SET @campo = CONCAT('QUIZ_U', U_QUIZ_);
	         	
	         	SET @query = CONCAT('UPDATE tbl_indicadores_di2 t 
								  SET t.', @campo, ' = IFNULL((SELECT CONCAT("Nota: ", CAST(MAX(gg.FINALGRADE) AS decimal(4, 2))) 
																 FROM mdl_grade_grades gg
																 JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
																WHERE gg.USERID = t.USERID
																  AND gi.courseid = t.ID_CURSO
																  AND gg.FINALGRADE>=0 
																  AND gi.itemname REGEXP ', @item, 
																' AND gi.itemname REGEXP "(dade)$"), "PENDENTE")');
																    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

		 		        SET @query=CONCAT('
						     UPDATE tbl_indicadores_di2 A
				  					SET ',@campo,'=-2 
				  			  WHERE NOME_CURSO IN (
							    SELECT DISTINCT c.shortname
								    FROM mdl_course c 
							    LEFT JOIN mdl_quiz q ON q.course=c.id AND q.name REGEXP ',@item,'
								    WHERE q.id IS NULL AND c.shortname REGEXP ''^DI''
				  				);
				  			'
				  			);
							PREPARE stmt FROM @query;
							EXECUTE stmt;
							DEALLOCATE PREPARE stmt;															    
		     
	     END WHILE;
	
			
	
        
       		
				UPDATE tbl_indicadores_di2 t
        		JOIN carga_base_tutor_di2 bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
		      SET t.TUTOR_ID = bt.TUTOR_ID, 
					 t.TUTOR_LOGIN = bt.TUTOR_LOGIN, 
					 t.TUTOR_EMAIL = bt.TUTOR_EMAIL, 
					 t.TUTOR_DataVinculo = bt.TUTOR_DataVinculo, 
					 t.TUTOR_NOME = bt.TUTOR_NOME, 
					 t.TUTOR_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
					 t.TUTOR_UltimoAcesso = bt.TUTOR_UltimoAcesso;
            
        
		        
        DROP TABLE IF EXISTS carga_base_tutor_di2;  
		      
   


update tbl_indicadores_di2 a 
set a.PrimeiroAcessoDisciplina=(
			select from_unixtime(min(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.PrimeiroAcessoDisciplina='Nunca Acessou' and
		a.QUIZ_U1S1_DIAGNOSTICA>=0;
		
update tbl_indicadores_di2 a 
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
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_di2)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_DI_DGA', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

	SET ID_LOG_=LAST_INSERT_ID();		  




drop table if exists tbl_indicadores_di2_dga;
drop table if exists tbl_indicadores_di1_dga;

create table tbl_indicadores_di2_dga like tbl_indicadores_di2;
insert into tbl_indicadores_di2_dga select * from tbl_indicadores_di2;

create table tbl_indicadores_di1_dga like tbl_indicadores_di1;
insert into tbl_indicadores_di1_dga select * from tbl_indicadores_di1;

alter table tbl_indicadores_di2_dga add column codigo_disciplina varchar(20) after fullname;
alter table tbl_indicadores_di1_dga add column codigo_disciplina varchar(20) after fullname;

alter table tbl_indicadores_di2_dga add column nome_disciplina_erp varchar(150) after codigo_disciplina;
alter table tbl_indicadores_di1_dga add column nome_disciplina_erp varchar(150) after codigo_disciplina;

alter table tbl_indicadores_di2_dga add column ra_aluno varchar(30) after login;
alter table tbl_indicadores_di1_dga add column ra_aluno varchar(30) after login;

alter table tbl_indicadores_di2_dga add column cod_turma varchar(30) after nome_disciplina_erp;
alter table tbl_indicadores_di1_dga add column cod_turma varchar(30) after nome_disciplina_erp;

alter table tbl_indicadores_di2_dga add column carga_horaria varchar(30) default 0 ;
alter table tbl_indicadores_di1_dga add column carga_horaria varchar(30) default 0;


update tbl_indicadores_di1_dga a
join kls_lms_pessoa b on a.LOGIN=b.login
set a.ra_aluno=b.cd_pessoa;

update tbl_indicadores_di2_dga a
join kls_lms_pessoa b on a.LOGIN=b.login
set a.ra_aluno=b.cd_pessoa;

update tbl_indicadores_di1_dga a
join kls_lms_pessoa p on p.login=a.LOGIN
join kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.shortname=a.NOME_CURSO
join kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc
join kls_lms_turmas t on t.id_turma=pt.id_turma
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina
set a.codigo_disciplina=d.cd_disciplina, a.nome_disciplina_erp=d.ds_disciplina, a.cod_turma=t.cd_turma, a.carga_horaria=cd.carga_horaria;

update tbl_indicadores_di2_dga a
join kls_lms_pessoa p on p.login=a.LOGIN
join kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.shortname=a.NOME_CURSO
join kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc
join kls_lms_turmas t on t.id_turma=pt.id_turma
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina
set a.codigo_disciplina=d.cd_disciplina, a.nome_disciplina_erp=d.ds_disciplina, a.cod_turma=t.cd_turma, a.carga_horaria=cd.carga_horaria;



update tbl_indicadores_di2 set ATIVIDADE_1_AVALIACAO='N/A',ATIVIDADE_1_NOTA='N/A' 
WHERE NOME_CATEGORIA REGEXP 'Blended';

update tbl_indicadores_di2
set ATIVIDADE_1_NOTA=case
when (ATIVIDADE_1_NOTA='Nota: 1.00') then '0.00'
when (ATIVIDADE_1_NOTA='Nota: 2.00') then '5.00'
when (ATIVIDADE_1_NOTA='Nota: 3.00') then '10.00'
when (ATIVIDADE_1_NOTA='Nota: 4.00') then '15.00'
when (ATIVIDADE_1_NOTA='Nota: 5.00') then '20.00'
when (ATIVIDADE_1_NOTA='Nota: 6.00') then '25.00'
when (ATIVIDADE_1_NOTA='Nota: 7.00') then '30.00'
else 'Pendente'
end;


update tbl_indicadores_di2 set atividade_1_aluno='Pendente' where atividade_1_aluno is null;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_di2)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
