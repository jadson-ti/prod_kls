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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_AMI2
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_AMI2`()
BEGIN




	DROP TABLE IF EXISTS tbl_retorno_base1;

	CREATE TABLE tbl_retorno_base1 (
													COURSEID			BIGINT,
													SHORTNAME		VARCHAR(100),
													BIMESTRE			INT,
													ITEMNAMEID		BIGINT,
													ITEMNAME			VARCHAR(200),
													USERID			BIGINT,
													USERNAME			VARCHAR(100),
													BONUS				DECIMAL(2,1)
							 				  );

	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
												SHORTNAME		VARCHAR(100),
												BIMESTRE			INT,
												USERNAME			VARCHAR(100),
												BONUS				DECIMAL(2,1)
										 );

	
	
	DROP TABLE IF EXISTS tbl_retorno_nt2_ami2;

	CREATE TABLE tbl_retorno_nt2_ami2 (
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
													AUSENCIA					BIGINT,
													NOTA						DECIMAL(3,1) DEFAULT 0
											 	 );

	
	CREATE INDEX idx_NT_AMI2 ON tbl_retorno_nt2_ami2 (SHORTNAME);
											 

	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt2_ami2 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												   FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA,
												   AUSENCIA)
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
							 cd.id_curso_disciplina AS AUSENCIA
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
					  JOIN tbl_mdl_course tc ON tc.shortname = cd.shortname
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname = 'AMI_RACIO'
					   AND d.id_tp_modelo = 2
					   AND i.cd_instituicao NOT IN ('OLIM-531','OLIM-522','OLIM-555','OLIM-1','OLIM-535','OLIM-697')
					   	   
				
					   
					   
	
					   AND cd.ID_CURSO_DISCIPLINA NOT IN (SELECT cd1.id_cd_remarc 
						  												 FROM kls_lms_curso_disciplina cd1 
																		WHERE cd1.id_cd_remarc > 0
																		AND cd1.fl_etl_atu != 'E')
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

		DELETE ami2 FROM tbl_retorno_nt2_ami2 ami2
		JOIN mdl_course mc ON mc.shortname = ami2.SHORTNAME
		WHERE mc.visible = 0;

	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_ami2 ami2
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = ami2.AUSENCIA
		   SET ami2.TURMA = t.cd_turma
		 WHERE ami2.TURMA = '';
	
	COMMIT;


	START TRANSACTION;
	
		UPDATE tbl_retorno_nt2_ami2 ami2
		  SET ami2.AUSENCIA = 0;
	
	COMMIT;
	
	
	START TRANSACTION;

		INSERT INTO tbl_retorno_base1
					SELECT c.id AS COURSEID,
							 c.shortname,
							 CASE
							   WHEN IFNULL(SUBSTR(gi.itemname,2,1), 1) IN (1,2) THEN
							   	1
							   ELSE
							  		2
							 END AS BIMESTRE,
							 gi.id,
							 gi.itemname,
							 u.id,
							 u.username,
							 CASE
							 	WHEN (gg.finalgrade IS NOT NULL  ) THEN
									1
							 	
									
							 	ELSE
									0
							 END AS BONUS
					  FROM tbl_retorno_nt2_ami2 di1
					  
					  JOIN tbl_mdl_course c ON c.shortname = di1.SHORTNAME
					  JOIN tbl_mdl_user u ON u.username = di1.USERNAME
					  LEFT JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
														   AND gi.courseid = c.id
														   AND (UPPER(gi.itemname) REGEXP '^U3'
															 OR  UPPER(gi.itemname) REGEXP '^U4')
					  LEFT JOIN tbl_notas gg ON gg.userid = u.id
					  										 AND gi.id = gg.itemid
					 WHERE c.id = 425
					 GROUP BY c.id, c.shortname, u.id, u.username, gi.itemname;

	COMMIT;
	

	START TRANSACTION;

		INSERT INTO tbl_retorno_base2
					SELECT a.shortname,
							 a.bimestre,
							 a.username,
							 IFNULL(ROUND((SUM(a.nota) / 18), 1), 0) AS BONUS
					  FROM (SELECT rb1.COURSEID AS course_id,
										rb1.SHORTNAME,
										rb1.ITEMNAME,
										rb1.USERID,
										rb1.USERNAME,
										rb1.BIMESTRE,
										rb1.BONUS AS nota
								 FROM tbl_retorno_base1 rb1
								WHERE rb1.COURSEID = 425
								GROUP BY rb1.COURSEID, rb1.SHORTNAME, rb1.USERID, rb1.USERNAME, rb1.ITEMNAME) a
					GROUP BY a.shortname, a.bimestre, a.username;

	COMMIT;

	
	START TRANSACTION;
	
		UPDATE tbl_retorno_base2 rb2
		  JOIN mdl_course c ON c.shortname = rb2.SHORTNAME
		  JOIN tbl_mdl_user u ON u.username = rb2.USERNAME AND u.mnethostid = 1
		  LEFT JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
											   AND gi.courseid = c.id
											   AND UPPER(gi.itemname) = 'SIMULADO FINAL'
		  LEFT JOIN tbl_notas gg ON gg.userid = u.id
												 AND gi.id = gg.itemid 
			SET rb2.BONUS = (rb2.BONUS + (CASE
													 	WHEN (gg.finalgrade >= (gi.grademax * 0.6)) THEN
															1
													 	ELSE
															0
													 END));
	
	COMMIT;
	

	START TRANSACTION;

		UPDATE tbl_retorno_nt2_ami2 ami2
		  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami2.USERNAME
		   SET ami2.NOTA = rb.BONUS
		 WHERE ami2.ORIGEM = 'SIAE';

	COMMIT;
	
	
	START TRANSACTION;

			UPDATE tbl_retorno_nt2_ami2 ami2
			  JOIN tbl_retorno_base2 rb ON rb.USERNAME = ami2.USERNAME
			   SET ami2.NOTA = (rb.BONUS * 5)
			 WHERE ami2.ORIGEM = 'OLIMPO';

	COMMIT;
	







END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
