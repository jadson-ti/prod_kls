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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_DI1
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_DI1`()
BEGIN


	DROP TABLE IF EXISTS tbl_retorno_base;

	CREATE TABLE tbl_retorno_base (
															SHORTNAME			VARCHAR(100),
															FULLNAME				VARCHAR(200),
															USERID				BIGINT,
															USERNAME				VARCHAR(100),
															ITEMNAME				VARCHAR(100),
															NOTA					DECIMAL(4,1)
									 				    );

	CREATE INDEX idx_BASE ON tbl_retorno_base (SHORTNAME);


	DROP TABLE IF EXISTS tbl_retorno_base1;

	CREATE TABLE tbl_retorno_base1 (
															SHORTNAME		VARCHAR(100),
															USERNAME			VARCHAR(100),
															ITEMNAME			VARCHAR(100),
															NOTA				DECIMAL(4,1)
									 				   );

	CREATE INDEX idx_BASE1 ON tbl_retorno_base1 (SHORTNAME);



	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
															SHORTNAME		VARCHAR(100),
															USERNAME			VARCHAR(100),
															NOTA				DECIMAL(4,1)
									 				   );

	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (USERNAME, SHORTNAME);

	
	DROP TABLE IF EXISTS tbl_retorno_nt2_di1;


	CREATE TABLE tbl_retorno_nt2_di1 (
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
													NOTA						DECIMAL(3,1) DEFAULT 0
											 );


   CREATE INDEX idx_NT_DI1 ON tbl_retorno_nt2_di1 (USERNAME, SHORTNAME);


		INSERT INTO tbl_retorno_nt2_di1 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA)
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
							 cd.carga_horaria
					  FROM kls_lms_pessoa p
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
					  JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
					  JOIN mdl_course tc ON tc.shortname = cd.shortname
					  JOIN mdl_course_categories cc on cc.id=tc.category
					  LEFT JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc 
					  LEFT JOIN kls_lms_turmas t ON pt.id_turma=t.id_turma  AND t.id_curso_disciplina = cd.id_curso_disciplina 
					 WHERE pcd.id_papel = 1
			  			AND cd.shortname != ''
			  			AND cd.shortname != 'A DEFINIR'
					   AND d.id_tp_modelo = 3
					   
			
						
					   
	
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
							 p.nm_pessoa,
							 tc.id,
							 tc.shortname,
							 tc.fullname,
							 c.cd_curso,
							 c.nm_curso,
							 d.cd_disciplina,
							 d.ds_disciplina,
							 cd.carga_horaria;


			INSERT INTO tbl_retorno_base

					SELECT  UPPER(c.shortname) AS SHORTNAME,
					       UPPER(c.fullname) AS FULLNAME,
							 u.id AS USERID,
							 u.username AS USERNAME,
							 UPPER(gi.itemname) AS ITEMNAME,
							 CASE 
							 	WHEN MAX(gg.finalgrade) = 1 THEN 0
							 	WHEN MAX(gg.finalgrade) = 2 THEN 5
							 	WHEN MAX(gg.finalgrade) = 3 THEN 10
							 	WHEN MAX(gg.finalgrade) = 4 THEN 15
							 	WHEN MAX(gg.finalgrade) = 5 THEN 20
							 	WHEN MAX(gg.finalgrade) = 6 THEN 25
							 	WHEN MAX(gg.finalgrade) = 7 THEN 30
							 END AS NOTA
					  FROM tbl_retorno_nt2_di1 di1
					  JOIN mdl_user u ON u.username = di1.USERNAME
					  JOIN mdl_course c ON c.shortname = di1.SHORTNAME
					  JOIN mdl_grade_items gi ON gi.courseid = c.id
													 	  AND gi.itemtype = 'mod'
													 	  AND gi.itemmodule = 'assign'
					  JOIN mdl_course_modules cm ON cm.course = c.id
					  									 AND cm.instance = gi.iteminstance
					  JOIN mdl_grade_grades gg ON gi.id = gg.itemid
					  								  AND gg.userid = u.id
					 WHERE gg.finalgrade IS NOT NULL
					   AND gg.finalgrade > 0
					   AND cm.visible = 1
					 GROUP BY c.fullname, u.id, gi.itemname, di1.CD_INSTITUICAO;

			INSERT INTO tbl_retorno_base1(SHORTNAME, USERNAME, ITEMNAME, NOTA)
						SELECT  tb.SHORTNAME,
								 tb.USERNAME,
								 tb.ITEMNAME,
								 MAX(tb.NOTA) AS NOTA
						  FROM tbl_retorno_base tb
						 GROUP BY tb.SHORTNAME, tb.USERNAME, tb.ITEMNAME;


			INSERT INTO tbl_retorno_base2(SHORTNAME, USERNAME, NOTA)

						SELECT tb.SHORTNAME,
								 tb.USERNAME,
								 ROUND((tb.NOTA / 3), 1) AS NOTA
						  FROM tbl_retorno_base1 tb
						 GROUP BY tb.SHORTNAME, tb.USERNAME;


					UPDATE tbl_retorno_nt2_di1 di1
					  JOIN tbl_retorno_base2 rb ON rb.USERNAME = di1.USERNAME
													   AND rb.SHORTNAME = di1.SHORTNAME
					   SET di1.NOTA = rb.NOTA;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
