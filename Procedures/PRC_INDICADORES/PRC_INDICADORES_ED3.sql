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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_ED3
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INDICADORES_ED3`()
MAIN: BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE v_finished 	   INT DEFAULT 0;
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;	
	DECLARE N_ASSIGN_ 	   INT DEFAULT 0;
   DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;
        
        
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_ED3', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		
	SET ID_LOG_=LAST_INSERT_ID();

   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF; 
	
   DROP TABLE IF EXISTS carga_base_tutor_ed3;

   CREATE TEMPORARY TABLE carga_base_tutor_ed3 ( 
											  		       TUTOR_ID               BIGINT(10), 
                                              TUTOR_LOGIN            VARCHAR(100), 
                                              TUTOR_EMAIL            VARCHAR(100), 
                                              COURSE                 BIGINT(10),
  											             GROUP_ID 			      BIGINT(10), 
                                              TUTOR_DataVinculo      VARCHAR(100),
                                              TUTOR_NOME             VARCHAR(200),
                                              TUTOR_PrimeiroAcesso   VARCHAR(100),
                                              TUTOR_UltimoAcesso     VARCHAR(100) 
											);
                                                                                         
   CREATE INDEX idx_GROUP_ID ON carga_base_tutor_ed3 (COURSE, GROUP_ID);

   DROP TABLE IF EXISTS tbl_indicadores_ed3;

   CREATE TABLE tbl_indicadores_ed3 ( 
										         COD_UNIDADE						     VARCHAR(100) DEFAULT 'Nenhum Encontrado',
     									         UNIDADE							     VARCHAR(100) DEFAULT 'Nenhuma Encontrada',
     									         ID_CURSO_KLS					 	  BIGINT DEFAULT 0,
		  										   COD_CURSO_KLS					     VARCHAR(100) DEFAULT NULL,
		  										   NOME_CURSO_KLS				 	     VARCHAR(200) DEFAULT NULL,
	  									         ID_CURSO						        BIGINT(10),
		  								         NOME_CURSO                 	  VARCHAR(100),
		  								         FULLNAME						        VARCHAR(200),
		  								         ID_Categoria					     BIGINT(10),
										         Nome_Categoria					     VARCHAR(100), 
										         ID_GRUPO						        BIGINT(10),
	                                    GRUPO                      	  VARCHAR(100),
	                                    USERID                     	  BIGINT(10),
	                                    LOGIN                      	  VARCHAR(100),
	                                    NOME                       	  VARCHAR(200), 
	                                    EMAIL                      	  VARCHAR(100), 
	                                    DataVinculoDisciplina      	  VARCHAR(100),
	                                    PrimeiroAcessoDisciplina   	  VARCHAR(100) DEFAULT 'Nunca Acessou',
	                                    UltimoAcessoDisciplina     	  VARCHAR(100) DEFAULT 'Nunca Acessou',
	                                    QuantDiasAcesso            	  BIGINT DEFAULT 0,
	                                    ATIVIDADE_1_ALUNO          	  VARCHAR(100) DEFAULT 'PENDENTE',
	                                    ATIVIDADE_2_ALUNO          	  VARCHAR(100) DEFAULT 'PENDENTE',
	                                    SIMULADO_PARCIAL				     VARCHAR(50) DEFAULT 'PENDENTE',
	                                    SIMULADO_GERAL					     VARCHAR(50) DEFAULT 'PENDENTE',
	                                    AVALIACAO_ONLINE				     VARCHAR(50) DEFAULT 'PENDENTE',
	                                    TUTOR_ID                        BIGINT DEFAULT 0, 
	                                    TUTOR_LOGIN                     VARCHAR(100) DEFAULT 'Sem Tutor', 
	                                    TUTOR_EMAIL                     VARCHAR(100) DEFAULT 'Sem E-mail', 
	                                    TUTOR_DataVinculo               VARCHAR(100) DEFAULT 'Sem Vínculo',
	                                    TUTOR_NOME                      VARCHAR(200) DEFAULT 'Sem Nome',
	                                    TUTOR_PrimeiroAcesso            VARCHAR(100) DEFAULT 'Nunca Acessou',
	                                    TUTOR_UltimoAcesso              VARCHAR(100) DEFAULT 'Nunca Acessou',
	                                    ATIVIDADE_1_AVALIACAO		     VARCHAR(100) DEFAULT 'PENDENTE',
	                                    ATIVIDADE_1_NOTA		           VARCHAR(50) DEFAULT 'PENDENTE',
	                                    ATIVIDADE_2_AVALIACAO		     VARCHAR(100) DEFAULT 'PENDENTE',
	                                    ATIVIDADE_2_NOTA	   	        VARCHAR(50) DEFAULT 'PENDENTE'
								     			);   

   CREATE INDEX idx_CURSO ON tbl_indicadores_ed3 (ID_CURSO, ID_GRUPO);        
	CREATE INDEX idx_USERCURSO ON tbl_indicadores_ed3 (USERID, ID_CURSO); 
	CREATE INDEX idx_USER ON tbl_indicadores_ed3 (USERID);
	  		
    INSERT INTO carga_base_tutor_ed3
        SELECT DISTINCT u.id AS TUTOR_ID, u.username AS TUTOR_LOGIN, u.email AS TUTOR_EMAIL, 
					c.id AS COURSE, g.id AS GROUP_ID, 
               IFNULL((DATE_FORMAT(FROM_UNIXTIME(gm.timeadded),'%d/%m/%Y %H:%i:%s')), 'Nunca Acessou') AS TUTOR_DataVinculo,
               UPPER(CONCAT(u.firstname, ' ', u.lastname)) AS TUTOR_NOME,
           		IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'), 'Nunca Acessou') AS TUTOR_PrimeiroAcesso,
					IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'), 'Nunca Acessou') AS TUTOR_UltimoAcesso
        FROM mdl_context ct 
        JOIN mdl_course c ON c.id = ct.instanceid
        JOIN mdl_course_categories cc ON cc.id = c.category
        JOIN mdl_role_assignments ra ON ra.contextid = ct.id 
        join mdl_role r on r.id=ra.roleid and r.shortname='tutor'
        JOIN mdl_user u ON u.id = ra.userid
        JOIN mdl_groups g ON g.courseid = c.id
        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
        LEFT JOIN tbl_login l ON l.USERID=u.id AND l.COURSE=c.id
        WHERE ct.contextlevel = 50 
		  AND c.summary REGEXP '^ED([5-9]|10)' and c.shortname<>'ED_FOR'
		  GROUP BY c.id, g.id, r.id;	 
	     
		 INSERT INTO tbl_indicadores_ed3 (COD_UNIDADE, UNIDADE, ID_CURSO, NOME_CURSO, FULLNAME, ID_Categoria, Nome_Categoria, 
		 ID_GRUPO, GRUPO,  USERID, LOGIN, NOME, EMAIL, DataVinculoDisciplina)
		  					SELECT   u.institution AS COD_UNIDADE,
			  							(SELECT i.nm_ies FROM kls_lms_instituicao i WHERE i.cd_instituicao = u.institution) AS UNIDADE, 
							  			c.id AS ID_CURSO, 
							 			c.shortname AS NOME_CURSO,
		        						c.fullname AS FULLNAME,
		        						cc.id AS ID_Categoria,
										cc.name AS Nome_Categoria,
		                        g.id AS ID_GRUPO,
										g.name AS GRUPO,
		                        u.id AS USERID, u.username AS LOGIN, 
										UPPER(CONCAT(u.firstname, " ", u.lastname)) AS nome, u.email,
		                        IFNULL(FROM_UNIXTIME(gm.timeadded-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou') AS DataVinculoDisciplina   
 					        FROM mdl_course c 
					        JOIN mdl_course_categories cc ON cc.id = c.category
					        JOIN mdl_enrol e ON e.courseid = c.id AND e.roleid = 5
					        join mdl_user_enrolments ur on ur.enrolid = e.id
					        JOIN mdl_user u ON u.id = ur.userid
					        JOIN mdl_groups g ON g.courseid = c.id
					        JOIN mdl_groups_members gm ON gm.groupid = g.id AND gm.userid = u.id
					       WHERE c.summary REGEXP '^ED([5-9]|10)' and c.shortname<>'ED_FOR'  and g.name REGEXP 'TUTOR'
						   GROUP BY u.institution, c.id, cc.id, g.id, u.id;
	  
	     
     
     
    
			UPDATE tbl_indicadores_ed3 t 
			  JOIN kls_lms_pessoa p ON p.login = t.LOGIN
			  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
			  JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
			  											 AND cd.shortname = t.NOME_CURSO
			  JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			   SET t.ID_CURSO_KLS = c.id_curso,
				    t.COD_CURSO_KLS = c.cd_curso,
				    t.NOME_CURSO_KLS = c.nm_curso
			 WHERE pcd.id_papel = 1
				AND pcd.fl_etl_atu != 'E'
				AND cd.fl_etl_atu REGEXP '[NA]'
			   AND c.fl_etl_atu != 'E';
	  

     
     
	  
		     
	  		UPDATE tbl_indicadores_ed3 t
	  		SET t.PrimeiroAcessoDisciplina =  IFNULL((SELECT 
															  		IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
	  		UPDATE tbl_indicadores_ed3 t
	  		   SET t.UltimoAcessoDisciplina = IFNULL((SELECT 
															  		IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  		
	  UPDATE tbl_indicadores_ed3 t
	  	  SET t.QuantDiasAcesso = IFNULL((SELECT COUNT(DISTINCT DATE(FROM_UNIXTIME(l.DT))) 
		 											FROM tbl_login l
												  WHERE l.USERID = t.USERID 
												    AND l.COURSE = t.ID_CURSO), 0);
     
	  
	  
	  
		  
		  
		SET N_ASSIGN_ = 0;
		  
		WHILE N_ASSIGN_ < 2 DO
		  
		  		SET N_ASSIGN_ = N_ASSIGN_ + 1;
		  
			  	  	SET @item = CONCAT('''[Entrega da Atividade Discursiva]?[[.space.]][', N_ASSIGN_, ']$''');
			         	
					SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_ALUNO');
		         	
		           SET @query = CONCAT('UPDATE tbl_indicadores_ed3 t
					     SET t.', @campo, ' = IFNULL((SELECT CASE
												WHEN asub.status = ''submitted'' then 
													CONCAT(''Postada em '',FROM_UNIXTIME(asub.timemodified-',FUSOHORARIO,',''%d/%m/%Y''))
												WHEN asub.status = ''reopened'' then
													CONCAT(''Ultimo Envio '',(SELECT FROM_UNIXTIME(MAX(asub.timemodified)-',FUSOHORARIO,',''%d/%m/%Y'')
																					  FROM mdl_assign ass	
																					  JOIN mdl_assign_submission asub ON asub.assignment = ass.id
																					  WHERE ass.course = t.ID_CURSO
																						AND ass.name REGEXP ',@item,'
																						AND asub.status = ''submitted'' 
																						AND asub.userid = t.USERID))
												ELSE 
													''Pendente''
												END
												FROM mdl_assign ass	
												JOIN mdl_assign_submission asub ON asub.assignment = ass.id
												WHERE ass.course = t.ID_CURSO
													AND ass.name REGEXP ',@item,'
													AND asub.userid = t.USERID
												ORDER BY asub.attemptnumber DESC
												limit 1),''Pendente'');');

						PREPARE stmt FROM @query;
						EXECUTE stmt;
						DEALLOCATE PREPARE stmt;
		
		END WHILE;
		
	
	
	
			
		SET N_ASSIGN_ = 0;
			
		WHILE N_ASSIGN_ < 2 DO
		  
		  		SET N_ASSIGN_ = N_ASSIGN_ + 1;
  	  
			  	  	SET @item = CONCAT('''[Entrega da Atividade Discursiva]?[[.space.]][', N_ASSIGN_, ']$''');
			         	
					SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_AVALIACAO');

					drop table if exists tmp_avaliacao_ed3;
					create temporary table tmp_avaliacao_ed3 (
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
					
					alter table tmp_avaliacao_ed3 add index idx_uc (userid, course);
					
					set @query=concat('
					insert into tmp_avaliacao_ed3
							select 
								@uid:=asu.userid as userid,
								ma.course,
								@aid:=asu.assignment as assign,
								@lastsub:=MAX(asu.attemptnumber) as lastsub,
								@lastagt:=IFNULL(MAX(agt.attemptnumber),-2) as lastagt,
								@idlastsub:=MAX(asu.id) as idlastsub,
								@idlastgrade:=MAX(agt.id) as idlastgrade,
								'''',
								0,
								'''' as situacao
						FROM mdl_assign ma 
						join mdl_assign_submission asu on asu.assignment = ma.id
						join tbl_indicadores_ed3 tcc on tcc.USERID=asu.userid and tcc.ID_CURSO=ma.course 
						left join mdl_assign_grades agt ON agt.assignment = ma.id and asu.userid = agt.userid and asu.attemptnumber=agt.attemptnumber and (agt.grade>=0 or agt.grade is null)
						WHERE  ma.name REGEXP ',@item,'
								AND asu.status <> ''new''
						GROUP BY asu.userid,asu.assignment;');

						PREPARE stmt FROM @query;
						EXECUTE stmt;
						DEALLOCATE PREPARE stmt;

						update tmp_avaliacao_ed3 a
						join mdl_assign_submission b on a.idlastsub=b.id
						left join mdl_assign_grades c on a.idlastgrade=c.id
						set a.statuslastsub=b.status, a.horacorrecao=c.timemodified;

					update tmp_avaliacao_ed3 a
					join mdl_assign_submission b on a.idlastsub=b.id
					set situacao=CASE
					WHEN idlastgrade is null then  'Pendente'
					WHEN statuslastsub = 'submitted' and lastsub=lastgrade then 	
						CONCAT('Corrigida em ', FROM_UNIXTIME(horacorrecao-FUSOHORARIO,'%d/%m/%Y'))
					WHEN statuslastsub = 'submitted' and lastsub>lastgrade then
						CONCAT('Última Correção em ', FROM_UNIXTIME(horacorrecao-FUSOHORARIO,'%d/%m/%Y'))
					WHEN statuslastsub = 'reopened' then 
						CONCAT('Reaberta em ', FROM_UNIXTIME(b.timecreated-FUSOHORARIO,'%d/%m/%Y'))
				 	END;

					SET @query=CONCAT('
					update tbl_indicadores_ed3 t 
					join tmp_avaliacao_ed3 b on t.USERID=b.userid and t.ID_CURSO=b.course
					set ',@campo,'=b.situacao;
					');
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;		         			
		END WHILE;
			
			
		SET N_ASSIGN_ = 0;
			
		WHILE N_ASSIGN_ < 2 DO
		  
		  		SET N_ASSIGN_ = N_ASSIGN_ + 1;
		  
			  	  	SET @item = CONCAT('''[Entrega da Atividade Discursiva]?[[.space.]][', N_ASSIGN_, ']$''');
			         	
					SET @campo = CONCAT('ATIVIDADE_', N_ASSIGN_, '_NOTA');
		         	
		           SET @query = CONCAT('UPDATE tbl_indicadores_ed3 t
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
																			AND ma.name REGEXP ',@item,' 
																			AND agt.userid = t.USERID
																order by agt.attemptnumber desc
																limit 1
															), ''Pendente'')
													);');
						
						PREPARE stmt FROM @query;
						EXECUTE stmt;
						DEALLOCATE PREPARE stmt;

		
		END WHILE;
	       
	
	
	
	      	  

         	UPDATE tbl_indicadores_ed3 t 
			   SET t.SIMULADO_PARCIAL = IFNULL((SELECT CONCAT('Nota: ', CAST(MAX(gg.FINALGRADE) AS decimal(4, 2)))
												  FROM mdl_grade_grades gg
												  JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
												 WHERE gg.USERID = t.USERID
													AND gi.courseid = t.ID_CURSO
												   AND gi.itemname = 'Simulado Parcial'), 'PENDENTE');										    
		         	
			         	
         	UPDATE tbl_indicadores_ed3 t 
			   SET t.SIMULADO_GERAL = IFNULL((SELECT CONCAT('Nota: ', CAST(MAX(gg.FINALGRADE) AS decimal(4, 2)))
												  FROM mdl_grade_grades gg
												  JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
												 WHERE gg.USERID = t.USERID
													AND gi.courseid = t.ID_CURSO
												   AND gi.itemname = 'Simulado Geral'), 'PENDENTE');										    
		         	
		         	
         	UPDATE tbl_indicadores_ed3 t 
			   SET t.AVALIACAO_ONLINE = IFNULL((SELECT CONCAT('Nota: ', CAST(MAX(gg.FINALGRADE) AS decimal(4, 2)))
												  FROM mdl_grade_grades gg
												  JOIN mdl_grade_items gi ON gi.id = gg.ITEMID 
												 WHERE gg.USERID = t.USERID
													AND gi.courseid = t.ID_CURSO
												   AND gi.itemname = 'Avaliação'), 'PENDENTE');										    
		         	

	
			  
	

			UPDATE tbl_indicadores_ed3 t
           	  JOIN carga_base_tutor_ed3 bt ON bt.GROUP_ID = t.ID_GRUPO AND bt.COURSE = t.ID_CURSO
		       SET t.TUTOR_ID = bt.TUTOR_ID, 
				   t.TUTOR_LOGIN = bt.TUTOR_LOGIN, 
				   t.TUTOR_EMAIL = bt.TUTOR_EMAIL, 
				   t.TUTOR_DataVinculo = bt.TUTOR_DataVinculo, 
				   t.TUTOR_NOME = bt.TUTOR_NOME, 
				   t.TUTOR_PrimeiroAcesso = bt.TUTOR_PrimeiroAcesso, 
				   t.TUTOR_UltimoAcesso = bt.TUTOR_UltimoAcesso;
        
		      
   

	DROP TABLE IF EXISTS carga_base_tutor_ed3;     

update  tbl_indicadores_ed3 a set ATIVIDADE_1_ALUNO='Pendente' WHERE atividade_1_aluno IS NULL;
update  tbl_indicadores_ed3 a set ATIVIDADE_2_ALUNO='Pendente' WHERE atividade_2_aluno IS NULL;

update tbl_indicadores_ed3 a 
set a.PrimeiroAcessoDisciplina=(
			select from_unixtime(min(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.PrimeiroAcessoDisciplina='Nunca Acessou' and
		concat(a.ATIVIDADE_1_ALUNO,a.ATIVIDADE_2_ALUNO) REGEXP '(Post)|(Ult)';
		
update tbl_indicadores_ed3 a 
set a.UltimoAcessoDisciplina=(
			select from_unixtime(max(l.timecreated))
			from mdl_logstore_standard_log l
			where l.userid=a.USERID and l.courseid=a.ID_CURSO and l.action='viewed'
)
where a.UltimoAcessoDisciplina='Nunca Acessou' and
		concat(a.ATIVIDADE_1_ALUNO,a.ATIVIDADE_2_ALUNO) REGEXP '(Post)|(Ult)';
		
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_ed3)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
