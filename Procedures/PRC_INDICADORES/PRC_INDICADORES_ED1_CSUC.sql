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

-- Copiando estrutura para procedure prod_kls.PRC_INDICADORES_ED1_CSUC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INDICADORES_ED1_CSUC`()
MAIN: BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;
	
	DECLARE N_ASSIGN_ 		INT DEFAULT 0;

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_INDICADORES_ED1_CSUC', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
   
   SET ID_LOG_=LAST_INSERT_ID();

   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF; 
   
   DROP TABLE IF EXISTS tbl_indicadores_ed1_csuc;

   CREATE TABLE tbl_indicadores_ed1_csuc (  COD_UNIDADE						VARCHAR(100) DEFAULT 'Nenhum Encontrado',
        									UNIDADE							VARCHAR(100) DEFAULT 'Nenhuma Encontrada',
        									ID_CURSO_KLS					BIGINT DEFAULT 0,
		  									COD_CURSO_KLS					VARCHAR(100) DEFAULT NULL,
		  									NOME_CURSO_KLS				 	VARCHAR(200) DEFAULT NULL,
		  									ID_CURSO						BIGINT(10),
			  								NOME_CURSO                 		VARCHAR(100),
			  								FULLNAME						VARCHAR(200),
			  								ID_CATEGORIA					BIGINT,
											NOME_CATEGORIA					VARCHAR(100), 
											ID_GRUPO						BIGINT(10),
		                           GRUPO                      		VARCHAR(100),
		                           USERID                     		BIGINT(10),
		                           LOGIN                      		VARCHAR(100),
		                           NOME                       		VARCHAR(200), 
		                           EMAIL                      		VARCHAR(100), 
		                           DataVinculoDisciplina      		VARCHAR(100),
		                           PrimeiroAcessoDisciplina   		VARCHAR(100) DEFAULT 'Nunca Acessou',
		                           UltimoAcessoDisciplina     		VARCHAR(100) DEFAULT 'Nunca Acessou',
		                           QuantDiasAcesso            		BIGINT DEFAULT 0,										
		                           FEEDBACK_1_ENTREGA          	VARCHAR(100) DEFAULT 'PENDENTE',
		                           CERTIFICADO							VARCHAR(100) DEFAULT 'NÃO POSSUI'
								         );   

    CREATE INDEX idx_CURSO ON tbl_indicadores_ed1_csuc (ID_CURSO, ID_GRUPO);        
     CREATE INDEX idx_USER ON tbl_indicadores_ed1_csuc (ID_CURSO, USERID); 
	     
    INSERT INTO tbl_indicadores_ed1_csuc (COD_UNIDADE, UNIDADE, ID_CURSO, NOME_CURSO, FULLNAME, ID_Categoria, 
				  					 Nome_Categoria, ID_GRUPO, GRUPO, USERID, LOGIN, NOME, EMAIL, 
									 DataVinculoDisciplina)
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
					       WHERE c.fullname like '%carreira de sucesso%' and g.name REGEXP 'TUTOR'
						   GROUP BY u.institution, c.id, cc.id, g.id, u.id;
		  
	     
     
     
     
			UPDATE tbl_indicadores_ed1_csuc t 
			  JOIN kls_lms_pessoa p ON p.login = t.LOGIN
			  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
			  JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina
			  											 AND cd.shortname = t.NOME_CURSO
			  JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			   SET t.ID_CURSO_KLS = c.id_curso,
				    t.COD_CURSO_KLS = c.cd_curso,
				    t.NOME_CURSO_KLS = c.nm_curso
			 WHERE p.fl_etl_atu != 'E'
			   AND pcd.id_papel = 1
				AND pcd.fl_etl_atu != 'E'
				AND cd.fl_etl_atu != 'E'
			   AND c.fl_etl_atu != 'E';
			   
     
     
	  

	  		UPDATE tbl_indicadores_ed1_csuc t
				SET t.PrimeiroAcessoDisciplina =  IFNULL((SELECT 
															  		IFNULL(FROM_UNIXTIME(MIN(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
 
   
	  		UPDATE tbl_indicadores_ed1_csuc t
	  		    SET t.UltimoAcessoDisciplina = IFNULL((SELECT 
															  		IFNULL(FROM_UNIXTIME(MAX(l.DT)-FUSOHORARIO,'%d/%m/%Y %H:%i:%s'),'Nunca Acessou')
														   FROM tbl_login l
														  WHERE l.USERID = t.USERID 
														    AND l.COURSE = t.ID_CURSO), 'Nunca Acessou');
	  
	  
			UPDATE tbl_indicadores_ed1_csuc t
				SET t.QuantDiasAcesso = IFNULL((SELECT COUNT(DISTINCT DATE(FROM_UNIXTIME(l.DT))) 
		 											FROM tbl_login l
												  WHERE l.USERID = t.USERID 
												    AND l.COURSE = t.ID_CURSO), 0);
     
     
	  
	  
	
			
		  SET N_ASSIGN_ = 0;
		  
		  WHILE N_ASSIGN_ < 1 DO
		  
		  		SET N_ASSIGN_ = N_ASSIGN_ + 1;
		  
			  	  
			  	    SET @item = CASE	
								WHEN N_ASSIGN_=1 THEN 'Você sabe qual é o seu nível de determinação?'
							    END;
			         	
		            SET @campo = CONCAT('FEEDBACK_', N_ASSIGN_, '_ENTREGA');
		         	
					SET @query = CONCAT('UPDATE tbl_indicadores_ed1_csuc t
										SET t.', @campo, ' = (
																SELECT CASE
																		WHEN asub.id is not null then 
																			CONCAT(''Postada em '',FROM_UNIXTIME(MAX(asub.timemodified)-',FUSOHORARIO,',''%d/%m/%Y''))
																		ELSE 
																			''Pendente''
																		END
																		FROM mdl_feedback ass	
																		JOIN mdl_feedback_completed asub ON asub.feedback = ass.id
																		WHERE ass.course = t.ID_CURSO
																		AND ass.name = ''', @item, '''
																		AND asub.userid = t.USERID)');
						
					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;


					SET @query=CONCAT('update tbl_indicadores_ed1_csuc set ',@campo,'=''Pendente'' WHERE ',@campo,' IS NULL;');

					PREPARE stmt FROM @query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

			END WHILE;
	
	
	
	update mdl_course c
	join mdl_course_sections cs on cs.course=c.id and cs.section>0
	join mdl_course_modules cm on cm.section=cs.id and cm.course=c.id 
	join mdl_modules m on m.id=cm.module and m.name='customcert'
	join mdl_context co on co.contextlevel=70 and co.instanceid=cm.id
	join mdl_customcert_templates ct on ct.contextid=co.id
	join mdl_customcert cc on cc.templateid=ct.id and cc.course=c.id
	join mdl_customcert_issues ci on ci.customcertid=cc.id 
	join tbl_indicadores_ed1_csuc ind on ind.ID_CURSO=c.id and ind.USERID=ci.userid
	set ind.CERTIFICADO=FROM_UNIXTIME(ci.timecreated, '%d/%m/%Y %H:%i:%s')
	where c.fullname like '%carreira de sucesso%';       

   
	  

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_indicadores_ed1_csuc)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
