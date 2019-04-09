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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_TCC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INDICADORES_TCC`()
MAIN : BEGIN
	
	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    	INT DEFAULT 0;
	DECLARE FUSOHORARIO	 	INT DEFAULT 10800;	
	DECLARE N_ASSIGN_ 		INT DEFAULT 0;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_TCC', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();

   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;
	
	DROP TABLE IF EXISTS carga_base_tutor_tcc;

    CREATE TEMPORARY TABLE carga_base_tutor_tcc ( TUTOR_ID               BIGINT, 
                                                  TUTOR_LOGIN            VARCHAR(100), 
                                                  TUTOR_EMAIL            VARCHAR(100), 
                                                  COURSE                 BIGINT,
																  GROUP_ID					 BIGINT, 
                                                  TUTOR_DataVinculo      VARCHAR(100),
                                                  TUTOR_NOME             VARCHAR(200),
                                                  TUTOR_PrimeiroAcesso   VARCHAR(100),
                                                  TUTOR_UltimoAcesso     VARCHAR(100) );
                                                                                         
    CREATE INDEX idx_GROUP_ID ON carga_base_tutor_tcc (GROUP_ID);
        
        
    DROP TABLE IF EXISTS tbl_indicadores_tcc;

    CREATE TABLE tbl_indicadores_tcc ( COD_UNIDADE					 VARCHAR(100),
        												 UNIDADE							 VARCHAR(100),
        												 ID_CURSO_KLS					 BIGINT DEFAULT 0,
		  												 COD_CURSO_KLS					 VARCHAR(100) DEFAULT NULL,
		  												 NOME_CURSO_KLS				 VARCHAR(200) DEFAULT NULL,
		  												 ID_CURSO						 BIGINT,
			  											 NOME_CURSO                 VARCHAR(100),
			  											 FULLNAME						 VARCHAR(200),
			  											 ID_Categoria					 BIGINT,
														 Nome_Categoria				 VARCHAR(100), 
														 ID_GRUPO						 BIGINT,
		                                     GRUPO                      VARCHAR(100),
		                                     USERID                     BIGINT,
		                                     LOGIN                      VARCHAR(100),
		                                     NOME                       VARCHAR(200), 
		                                     EMAIL                      VARCHAR(100), 
		                                     DataVinculoDisciplina      VARCHAR(100),
		                                     PrimeiroAcessoDisciplina   VARCHAR(100) DEFAULT 'Nunca Acessou',
		                                     UltimoAcessoDisciplina     VARCHAR(100) DEFAULT 'Nunca Acessou',
		                                     QuantDiasAcesso            BIGINT DEFAULT 0,
		                                     ATIVIDADE_1_ALUNO		    VARCHAR(100) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_2_ALUNO		    VARCHAR(100) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_3_ALUNO		    VARCHAR(100) DEFAULT 'PENDENTE',
		                                     TUTOR_ID                   BIGINT DEFAULT 0, 
		                                     TUTOR_LOGIN                VARCHAR(100) DEFAULT 'Sem Tutor', 
		                                     TUTOR_EMAIL                VARCHAR(100) DEFAULT 'Sem E-mail', 
		                                     TUTOR_DataVinculo          VARCHAR(100) DEFAULT 'Sem VÃ­nculo',
		                                     TUTOR_NOME                 VARCHAR(200) DEFAULT 'Sem Nome',
		                                     TUTOR_PrimeiroAcesso       VARCHAR(100) DEFAULT 'Nunca Acessou',
		                                     TUTOR_UltimoAcesso         VARCHAR(100) DEFAULT 'Nunca Acessou',
		                                     ATIVIDADE_1_AVALIACAO		 VARCHAR(100) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_1_NOTA			    VARCHAR(50) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_2_AVALIACAO		 VARCHAR(100) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_2_NOTA			    VARCHAR(50) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_3_AVALIACAO		 VARCHAR(100) DEFAULT 'PENDENTE',
			                                 ATIVIDADE_3_NOTA			    VARCHAR(50) DEFAULT 'PENDENTE'
									         );   

    CREATE INDEX idx_USERID ON tbl_indicadores_tcc (USERID);
		
					INSERT INTO carga_base_tutor_tcc
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
								        				FROM mdl_course c 
											         JOIN mdl_context ct ON ct.instanceid = c.id
											         JOIN mdl_course_categories cc ON cc.id = c.category
											         JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
											         JOIN mdl_role r on r.id=ra.roleid and r.shortname='tutor'
											         JOIN mdl_user u ON u.id = ra.userid
											         JOIN mdl_groups g ON g.courseid = c.id
											         JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
											         WHERE c.shortname LIKE 'TCC%' AND  ct.contextlevel = 50;

        
			  		INSERT INTO tbl_indicadores_tcc (ID_CURSO, NOME_CURSO, FULLNAME, ID_Categoria, 
					  																		Nome_Categoria, ID_GRUPO, GRUPO, USERID, LOGIN, NOME, EMAIL, 
																							DataVinculoDisciplina)
			  					SELECT DISTINCT 
								  			c.id AS ID_CURSO, 
								 			c.shortname AS NOME_CURSO,
			        						c.fullname AS FULLNAME,
			        						cc.id AS ID_Categoria,
											cc.name AS Nome_Categoria,
			                        g.id AS ID_GRUPO,
											g.name AS GRUPO,
			                        u.id AS USERID, u.username AS LOGIN, 
											UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS nome, u.email,
			                        IFNULL(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina   
						        FROM mdl_course c 
						        JOIN mdl_enrol e ON e.courseid=c.id and e.enrol='manual'
						        JOIN mdl_role r on r.id=e.roleid and r.shortname='student'
						        JOIN mdl_user_enrolments ue ON ue.enrolid=e.id and ue.`status`= 0
						        JOIN mdl_user u ON u.id = ue.userid
						        JOIN mdl_course_categories cc ON cc.id = c.category
						        JOIN mdl_groups g ON g.courseid = c.id
						        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
						       WHERE c.shortname LIKE 'TCC%' AND g.name REGEXP 'TUTOR';
			  
		  
     
          
			UPDATE tbl_indicadores_tcc t 
			  JOIN kls_lms_pessoa p ON p.login = t.LOGIN
			  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa 
			  JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
			  											 AND cd.shortname = t.NOME_CURSO
			  JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			  join kls_lms_instituicao i on i.id_ies = c.id_ies
			   SET t.ID_CURSO_KLS = c.id_curso,
				    t.COD_CURSO_KLS = c.cd_curso,
				    t.NOME_CURSO_KLS = c.nm_curso,
				    t.COD_UNIDADE = i.cd_instituicao,
				    t.UNIDADE = i.nm_ies
			 WHERE pcd.id_papel = 1
				AND pcd.fl_etl_atu != 'E'
			   AND cd.fl_etl_atu REGEXP '[NA]'
				AND c.fl_etl_atu != 'E';
	  
    
     
     
     
     
     UPDATE tbl_indicadores_tcc t
	  		SET t.PrimeiroAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
	  		UPDATE tbl_indicadores_tcc t
												 
				SET t.UltimoAcessoDisciplina = IFNULL((SELECT IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
													   FROM tbl_login l
													   WHERE l.USERID = t.USERID 
															AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');											 
	  
	  
	  UPDATE tbl_indicadores_tcc t
	  	  SET t.QuantDiasAcesso = IFNULL((SELECT COUNT(DISTINCT DATE_FORMAT(FROM_UNIXTIME(l.DT),'%d/%m/%Y')) 
		 											FROM tbl_login l
												  WHERE l.USERID = t.USERID 
												    AND l.COURSE = t.ID_CURSO), 0);
     

	  
     
	  

		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 3 DO

					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT(N_ASSIGN_, '$');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_ALUNO'); 



	         	
	         	SET @query = CONCAT('UPDATE tbl_indicadores_tcc t
												   SET t.', @campo, ' = (SELECT CASE
																								WHEN asub.status = ''submitted'' then 
																									CONCAT(''Postada em '',FROM_UNIXTIME(asub.timemodified-',FUSOHORARIO,',''%d/%m/%Y''))
																								WHEN asub.status = ''reopened'' then
																									CONCAT(''Ultimo Envio '',(SELECT max(FROM_UNIXTIME(asub.timemodified-',FUSOHORARIO,',''%d/%m/%Y''))
																																	  FROM mdl_assign ass	
																																	  JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																																	  WHERE ass.course = t.ID_CURSO
																																			 	AND ass.name REGEXP ''', @item, '''
																																				AND asub.status = ''submitted'' 
																																				AND asub.userid = t.USERID))
																								ELSE 
																									''Pendente''
																							END
																		       FROM mdl_assign ass	
																				 JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																		       WHERE ass.course = t.ID_CURSO
																		       	AND ass.name REGEXP ''', @item, '''
																		       	AND asub.userid = t.USERID
																				 ORDER BY asub.attemptnumber DESC
																				 limit 1)');
				    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
							
			     
	     END WHILE;
	     
		
		    	
		
       
		  SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 3 DO
					
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT(N_ASSIGN_, '$');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_AVALIACAO'); 
	         	
					drop table if exists tmp_avaliacao_tcc;
					create temporary table tmp_avaliacao_tcc (
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

					insert into tmp_avaliacao_tcc
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
						join tbl_indicadores_tcc tcc on tcc.USERID=asu.userid and tcc.ID_CURSO=ma.course 
						left join mdl_assign_grades agt ON agt.assignment = ma.id and asu.userid = agt.userid and asu.attemptnumber=agt.attemptnumber and (agt.grade>=0 or agt.grade is null)
						WHERE  ma.name REGEXP CONCAT(N_ASSIGN_,'$')	
								AND asu.status <> 'new'
						GROUP BY asu.userid,asu.assignment;

						update tmp_avaliacao_tcc a
						join mdl_assign_submission b on a.idlastsub=b.id
						left join mdl_assign_grades c on a.idlastgrade=c.id
						set a.statuslastsub=b.status, a.horacorrecao=c.timemodified;

					update tmp_avaliacao_tcc a
					join mdl_assign_submission b on a.idlastsub=b.id
					set situacao=CASE
					WHEN idlastgrade is null then  'Pendente'
					WHEN statuslastsub = 'submitted' and lastsub=lastgrade then 	
						CONCAT('Corrigida em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'submitted' and lastsub>lastgrade then
						CONCAT('Ãšltima CorreÃ§Ã£o em ', FROM_UNIXTIME(horacorrecao-10800,'%d/%m/%Y'))
					WHEN statuslastsub = 'reopened' then 
						CONCAT('Reaberta em ', FROM_UNIXTIME(b.timecreated-10800,'%d/%m/%Y'))
				 	END;

					set @query=concat('update tbl_indicadores_tcc t join tmp_avaliacao_tcc b on t.USERID=b.userid and t.ID_CURSO=b.course
						 set ATIVIDADE_',N_ASSIGN_,'_AVALIACAO=b.situacao');
	         	
	  															    
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

			     
	     END WHILE;
		  drop table if exists tmp_avaliacao_tcc;	
	     
	     											

	     SET N_ASSIGN_ = 0;
		     
		  WHILE N_ASSIGN_ < 3 DO
        		
        		
					SET N_ASSIGN_ = N_ASSIGN_ + 1;
	        		
	         	SET @item = CONCAT(N_ASSIGN_, '$');
	         	
	         	SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_NOTA'); 
					
	         	SET @query = CONCAT('UPDATE tbl_indicadores_tcc t 
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
																						AND ma.name REGEXP ''', @item, '''
																						AND agt.userid = t.USERID
																						order by agt.attemptnumber desc
																						limit 1
																					), ''Pendente'')
																					)');
	         
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
															    
			     
	     END WHILE;
	  
	     	 		 		     
	  
        	
		UPDATE tbl_indicadores_tcc t
      JOIN carga_base_tutor_tcc bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
		SET  t.TUTOR_ID = bt.TUTOR_ID, 
			  t.TUTOR_LOGIN = bt.TUTOR_LOGIN, 
			  t.TUTOR_EMAIL = bt.TUTOR_EMAIL, 
			  t.TUTOR_DataVinculo = bt.TUTOR_DataVinculo, 
			  t.TUTOR_NOME = bt.TUTOR_NOME, 
			  t.TUTOR_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
			  t.TUTOR_UltimoAcesso = bt.TUTOR_UltimoAcesso;
   
     
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_1_ALUNO = 'Pendente'
	  WHERE ATIVIDADE_1_ALUNO is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_2_ALUNO = 'Pendente'
	  WHERE ATIVIDADE_2_ALUNO is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_3_ALUNO = 'Pendente'
	  WHERE ATIVIDADE_3_ALUNO is null;
	  
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_1_AVALIACAO = 'Pendente'
	  WHERE ATIVIDADE_1_AVALIACAO is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_2_AVALIACAO = 'Pendente'
	  WHERE ATIVIDADE_2_AVALIACAO is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_3_AVALIACAO = 'Pendente'
	  WHERE ATIVIDADE_3_AVALIACAO is null;
	  
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_1_NOTA = 'Pendente'
	  WHERE ATIVIDADE_1_NOTA is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_2_NOTA = 'Pendente'
	  WHERE ATIVIDADE_2_NOTA is null;
	  
	  UPDATE tbl_indicadores_tcc
	  SET ATIVIDADE_2_NOTA = 'Pendente'
	  WHERE ATIVIDADE_2_NOTA is null;
	  
	  DROP TABLE IF EXISTS carga_base_tutor_tcc;
	
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_tcc)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
