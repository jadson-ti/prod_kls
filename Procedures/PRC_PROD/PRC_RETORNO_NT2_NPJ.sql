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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_NPJ
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_NPJ`()
BEGIN


	DECLARE v_finished 	   INT DEFAULT 0;
	DECLARE SHORTNAME_		VARCHAR(100);
	DECLARE QTD_ALU_			BIGINT;


	DECLARE c_cursos CURSOR FOR

             SELECT DISTINCT ed1.SHORTNAME
					FROM tbl_retorno_nt2_npj ed1;


   DECLARE CONTINUE HANDLER

     FOR NOT FOUND SET v_finished = 1;
	
	
	
	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
												UNIDADE			VARCHAR(100),
												SHORTNAME		VARCHAR(100),
												USERNAME			VARCHAR(100),
												ITEM				VARCHAR(200),
												AUSENCIA			DECIMAL(4,1),
												NOTA				DECIMAL(4,3)
						 				    );

	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME);
	
	
	
	DROP TABLE IF EXISTS tbl_retorno_nt2_npj;

	CREATE TABLE tbl_retorno_nt2_npj (
													CD_INSTITUICAO			VARCHAR(20),
												   NM_IES					VARCHAR(200),
													CD_PESSOA				VARCHAR(100),
													USERNAME					VARCHAR(200),
													NOME_USUARIO			VARCHAR(200),
													COURSE_ID				BIGINT,
													SHORTNAME				VARCHAR(200),
													FULLNAME					VARCHAR(200),
													CD_CURSO					VARCHAR(100),
													CURSO						VARCHAR(200),
													CD_DISCIPLINA			VARCHAR(100),
													DISCIPLINA				VARCHAR(200),
													TURMA						VARCHAR(100),
												 	ORIGEM					VARCHAR(100),
													AUSENCIA 			BIGINT(10) DEFAULT 0,
													NOTA						DECIMAL(3,1) DEFAULT 0
											   );

   CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_npj (SHORTNAME);



	 
	
		INSERT INTO tbl_retorno_nt2_npj (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, AUSENCIA)
					SELECT i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							 p.nm_pessoa AS NOME_USUARIO,
							 tc.id AS COURSE_ID,
							 tc.shortname,
							 tc.fullname,
							 c.cd_curso AS COD_CURSO,
							 c.nm_curso AS CURSO,
							 d.cd_disciplina AS CD_DISCIPLINA,
							 d.ds_disciplina AS DISCIPLINA,
							 IFNULL(t.cd_turma, '') AS TURMA,
							 'OLIMPO' AS ORIGEM,
							 0 AS AUSENCIA
					  FROM kls_lms_pessoa p
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
					  LEFT JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
					  							       AND t.fl_etl_atu != 'E'
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
					  JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
					  JOIN mdl_course tc ON tc.shortname = cd.shortname AND tc.visible=1
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname REGEXP '^NPJ'
			  			AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd1.id_cd_remarc 
						  												 FROM kls_lms_curso_disciplina cd1 
																		WHERE cd1.id_cd_remarc > 0
																		AND cd1.fl_etl_atu != 'E')
					   AND d.id_tp_modelo = 8
  					   AND d.id_disciplina NOT IN (SELECT d1.id_disciplina_remarc 
						  									   FROM kls_lms_disciplina d1 
															  WHERE d1.id_disciplina_remarc > 0
															    AND d1.fl_etl_atu != 'E')
						AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd2.id_curso_disciplina
																	  FROM kls_lms_curso_disciplina cd2 
																	 WHERE cd2.id_curso_disciplina = cd.ID_CURSO_DISCIPLINA
																	   AND cd2.id_cd_remarc > 0 
																	   AND cd2.fl_etl_atu = 'E'
																	   AND EXISTS (SELECT 1 
																						  FROM kls_lms_curso_disciplina cd3
																						 WHERE cd3.id_curso_disciplina = cd2.id_cd_remarc
																						   AND cd3.fl_etl_atu != 'E'))
					 GROUP BY i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							 
							 tc.id,
							 tc.shortname,
							 tc.fullname,
							 c.cd_curso,
							 c.nm_curso,
							 d.cd_disciplina,
							 d.ds_disciplina,
							 cd.carga_horaria;


	 

	OPEN c_cursos;


	  get_CURSOS: LOOP


	  FETCH c_cursos INTO SHORTNAME_;


	  IF v_finished = 1 THEN

	  		LEAVE get_CURSOS;

	  END IF;
	  
	  
	   

				INSERT INTO tbl_retorno_base2
	
						SELECT ed1.CD_INSTITUICAO AS UNIDADE,
								 UPPER(c.shortname) AS SHORTNAME,
								 u.username AS USERNAME,
								 gi.itemname AS ITEM,
								 0 AS AUSENCIA,
								 (CAST(gg.finalgrade AS DECIMAL(4,2)) * 0.3) AS NOTA
						  FROM tbl_retorno_nt2_npj ed1
						  JOIN mdl_user u ON u.username = ed1.USERNAME
						  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
						  JOIN mdl_grade_items gi ON gi.courseid = c.id
															  AND gi.itemtype = 'mod'
															  AND gi.itemmodule = 'assign'
															  AND gi.itemname REGEXP 'Prova$'
						  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
						  								      AND gg.userid = u.id
						 WHERE ed1.SHORTNAME = SHORTNAME_
						   AND gg.finalgrade IS NOT NULL
						   AND gg.finalgrade > 0
						 GROUP BY ed1.CD_INSTITUICAO, c.shortname, u.username, gi.itemname;

		 
		
		
		 

				INSERT INTO tbl_retorno_base2
	
					SELECT ed1.CD_INSTITUICAO AS UNIDADE,
							 UPPER(c.shortname) AS SHORTNAME,
							 u.username AS USERNAME,
							 gi.itemname AS ITEM,
							 CASE
							 	WHEN gi.itemname REGEXP '1$' THEN
							 		2.5
							 	WHEN ((gi.itemname REGEXP '2$') OR (gi.itemname REGEXP '3$')) THEN
							 		5
							 	ELSE
							 		12.5
							 END AS AUSENCIA,
							
							(CAST(gg.finalgrade AS DECIMAL(4,2)) * 0.7) AS NOTA
					  FROM tbl_retorno_nt2_npj ed1
					  JOIN mdl_user u ON u.username = ed1.USERNAME
					  JOIN mdl_course c ON c.shortname = ed1.SHORTNAME
					  JOIN mdl_grade_items gi ON gi.courseid = c.id
														  AND gi.itemtype = 'mod'
														  AND gi.itemmodule = 'assign'
														  AND gi.itemname REGEXP '^Envio'
					  JOIN mdl_course_modules cm ON cm.course = c.id
					  									 AND cm.instance = gi.iteminstance
					  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
					  								      AND gg.userid = u.id
					 WHERE ed1.SHORTNAME = SHORTNAME_
					   AND gg.finalgrade IS NOT NULL
					   AND gg.finalgrade >= 0
					   AND cm.visible = 1
					 GROUP BY ed1.CD_INSTITUICAO, c.shortname, u.username, gi.itemname;

		 
		
		
		 

				INSERT INTO tbl_retorno_base2
	
						SELECT rb2.UNIDADE,
								 rb2.SHORTNAME,
								 rb2.USERNAME,
								 'Nota' AS ITEM,
								 SUM(rb2.AUSENCIA) AS AUSENCIA,
								 SUM(rb2.NOTA) AS NOTA
						  FROM tbl_retorno_base2 rb2
						 WHERE rb2.SHORTNAME = SHORTNAME_
						 GROUP BY rb2.UNIDADE, rb2.SHORTNAME, rb2.USERNAME;

		 
	  	  
	  
	END LOOP get_CURSOS;
	
	CLOSE c_cursos;
	
	
	
	 

		UPDATE tbl_retorno_nt2_npj ed1
		 LEFT JOIN (SELECT rb.*
			       FROM tbl_retorno_base2 rb
			      WHERE rb.ITEM = 'Nota'
					LIMIT 0, 100000
				 ) AS nt ON nt.USERNAME = ed1.USERNAME
						  AND nt.SHORTNAME = ed1.SHORTNAME
			SET ed1.NOTA = ROUND(coalesce(nt.NOTA,0), 1),
				 ed1.AUSENCIA = (100 - COALESCE(nt.AUSENCIA,0));

	 
	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
