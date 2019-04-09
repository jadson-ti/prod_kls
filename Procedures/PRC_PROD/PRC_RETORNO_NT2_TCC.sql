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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_TCC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_TCC`()
BEGIN


	DECLARE v_finished 	   INT DEFAULT 0;
	DECLARE SHORTNAME_		VARCHAR(100);


	DECLARE c_cursos CURSOR FOR

             SELECT DISTINCT ed1.SHORTNAME
					FROM tbl_retorno_nt2_tcc ed1;


   DECLARE CONTINUE HANDLER

     FOR NOT FOUND SET v_finished = 1;	
	
	
	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
												UNIDADE			VARCHAR(100),
												CD_CURSO			VARCHAR(100),
												CD_DISCIPLINA	VARCHAR(100),
												SHORTNAME		VARCHAR(100),
												USERNAME			VARCHAR(100),
												NOTA				DECIMAL(4,1)
						 				    );

	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME);
	
	

	DROP TABLE IF EXISTS tbl_retorno_nt2_tcc;


	CREATE TABLE tbl_retorno_nt2_tcc (
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
													CARGA_HORARIA			SMALLINT(10),
													AUSENCIA_SIAE			SMALLINT(2) DEFAULT 0,
													AUSENCIA_OLIMPO		DECIMAL(4,1) DEFAULT 0,
													NOTA						DECIMAL(3,1) DEFAULT 0
											   );


   CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_tcc (SHORTNAME);



	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt2_tcc (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA,
												  AUSENCIA_SIAE)
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
							 CASE 
							 	WHEN (p.id_pessoa > 100000000) AND (p.id_pessoa < 800000000) THEN
							 		'SIAE'
							 	ELSE
							 		'OLIMPO'
							 END AS ORIGEM,
							 cd.carga_horaria,
							 cd.id_curso_disciplina AS AUSENCIA_SIAE
					  FROM kls_lms_pessoa p
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
					  LEFT JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina
					  							       AND t.fl_etl_atu != 'E'
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
					  JOIN tbl_mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
					  JOIN mdl_course tc ON tc.shortname = cd.shortname
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname REGEXP '^TCCV'
			  			AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd1.id_cd_remarc 
						  												 FROM kls_lms_curso_disciplina cd1 
																		WHERE cd1.id_cd_remarc > 0
																		AND cd1.fl_etl_atu != 'E')
					   AND d.id_tp_modelo = 6
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


	COMMIT;



	START TRANSACTION;

		DELETE ed1 FROM tbl_retorno_nt2_tcc ed1
		  JOIN mdl_course mc ON mc.shortname = ed1.SHORTNAME
		 WHERE mc.visible = 0;

	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_tcc ed1
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ed1.AUSENCIA_SIAE
		   SET ed1.TURMA = t.cd_turma
		 WHERE ed1.TURMA = '';
	
	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_tcc ed1
		   SET ed1.AUSENCIA_SIAE = 0;
	
	COMMIT;
 	
 	
 	OPEN c_cursos;


	  get_CURSOS: LOOP


	  FETCH c_cursos INTO SHORTNAME_;


	  IF v_finished = 1 THEN

	  		LEAVE get_CURSOS;

	  END IF;
	
	
		START TRANSACTION;

				INSERT INTO tbl_retorno_base2
	
						SELECT ed1.CD_INSTITUICAO AS UNIDADE
								 ,ed1.CD_CURSO
								 ,ed1.CD_DISCIPLINA
								 ,UPPER(c.shortname) AS SHORTNAME
								 ,u.username AS USERNAME
								 ,SUM(gg.finalgrade) AS NOTA
						  FROM tbl_retorno_nt2_tcc ed1
						  JOIN tbl_mdl_user u ON u.username = ed1.USERNAME
						  JOIN tbl_mdl_course c ON c.shortname = ed1.SHORTNAME
						  JOIN tbl_mdl_grade_items gi ON gi.courseid = c.id
															  AND gi.itemtype = 'mod'
															  AND gi.itemmodule = 'assign'
															  
															  AND gi.hidden != 1
						  JOIN mdl_course_modules cm ON cm.course = c.id
						  									 AND cm.instance = gi.iteminstance
						  JOIN tbl_notas gg ON gi.id = gg.itemid
						  								  AND gg.userid = u.id
						 WHERE ed1.SHORTNAME = SHORTNAME_
						   AND cm.visible = 1
						   AND gg.finalgrade IS NOT NULL
						   AND gg.finalgrade > 0
						 GROUP BY ed1.CD_INSTITUICAO, ed1.CD_CURSO, ed1.CD_DISCIPLINA, c.shortname, u.username;

		COMMIT;


		START TRANSACTION;

			UPDATE tbl_retorno_nt2_tcc ed1
				JOIN (SELECT rb.*
				       FROM tbl_retorno_base2 rb
				      WHERE rb.SHORTNAME = SHORTNAME_
						LIMIT 0, 100000
					 ) AS nt ON nt.USERNAME = ed1.USERNAME
					 		  AND nt.CD_CURSO = ed1.CD_CURSO
							  AND nt.SHORTNAME = SHORTNAME_
				SET ed1.NOTA = (nt.NOTA /10)
				WHERE ed1.SHORTNAME = SHORTNAME_;

		COMMIT;
	

	END LOOP get_CURSOS;
	
	CLOSE c_cursos;
	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
