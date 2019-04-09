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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT_AMI2
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT_AMI2`()
BEGIN

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;
	
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_RETORNO_NT_AMI2', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		



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

	
	
	DROP TABLE IF EXISTS tbl_retorno_nt_ami2_siae;

	CREATE TABLE tbl_retorno_nt_ami2_siae (
													UNIDADE					VARCHAR(100),
													ALUNO						VARCHAR(100),
													ANO						INT DEFAULT 2017,
													PERIODO					INT DEFAULT 1,
													REFERENCIA 				INT DEFAULT 1,
													DISCIPLINA				VARCHAR(100),
													NOTA						DECIMAL(2,1),
													AUSENCIA					INT DEFAULT 0,
													OPERACAO					VARCHAR(1) DEFAULT 'I',
													USUARIO					VARCHAR(50) DEFAULT 'tiweb',
													DATA						VARCHAR(50),
													TIPO						INT DEFAULT 1,
													SHORTNAME				VARCHAR(100),
													AMBIENTE					VARCHAR(3) DEFAULT 'KLS',
													STATUS					INT DEFAULT 0,
													LOG						VARCHAR(50) DEFAULT ' ',
													NOTA_MOODLE 			DECIMAL(2,1),
													PERIODO_MOODLE			INT DEFAULT 0,
													REFERENCIA_MOODLE		INT DEFAULT 0
											 );


	DROP TABLE IF EXISTS tbl_retorno_nt_ami2_olim;

	CREATE TABLE tbl_retorno_nt_ami2_olim (
													UNIDADE							VARCHAR(100),
													CODIGO_MATRICULA				BIGINT,
													
													COD_CURSO						BIGINT,
													
													COD_DISCIPLINA					BIGINT,
													
													TURMA								VARCHAR(100),
													DISTIPO							VARCHAR(1) DEFAULT 'N',
													TITULO_AVALIACAO				VARCHAR(100) DEFAULT ' E1 AMI 20171',
													NOTA								DECIMAL(3,1),
													PEL_COD							SMALLINT	DEFAULT 20171,
													TPRCOD							VARCHAR(2) DEFAULT 'E1',
													TITULO_APLICACAO				VARCHAR(1) DEFAULT ''											
											 );
											 

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
					  FROM tbl_mdl_course c
					  JOIN mdl_context ct ON ct.contextlevel = 50
					 						   AND ct.instanceid = c.id
					  JOIN mdl_role_assignments ra ON ra.contextid = ct.id
					 									   AND ra.roleid = 5
					  JOIN tbl_mdl_user u ON u.id = ra.userid
					  LEFT JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
														   AND gi.courseid = c.id
														   AND (UPPER(gi.itemname) REGEXP '^U1'
															 OR  UPPER(gi.itemname) REGEXP '^U2')
														   
					  LEFT JOIN tbl_notas gg ON gg.USERID = u.id
					  										 AND gi.id = gg.ITEMID
					 WHERE c.id = 697
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
								WHERE rb1.COURSEID = 697
								GROUP BY rb1.COURSEID, rb1.SHORTNAME, rb1.USERID, rb1.USERNAME, rb1.ITEMNAME) a
					GROUP BY a.shortname, a.bimestre, a.username;

	COMMIT;

	
	START TRANSACTION;
	
		UPDATE tbl_retorno_base2 rb2
		  JOIN tbl_mdl_course c ON c.shortname = rb2.SHORTNAME
		  JOIN tbl_mdl_user u ON u.username = rb2.USERNAME AND u.mnethostid = 1
		  LEFT JOIN tbl_mdl_grade_items gi ON gi.itemtype = 'mod'
											   AND gi.courseid = c.id
											   AND UPPER(gi.itemname) = 'LISTA ESPECIAL'
		  LEFT JOIN tbl_notas gg ON gg.USERID = u.id
												 AND gi.id = gg.ITEMID 
			SET rb2.BONUS = (rb2.BONUS + (CASE
													 	WHEN (gg.finalgrade >= (gi.grademax * 0.6)) THEN
															1
													 	ELSE
															0
													 END));
	
	COMMIT;
	


   START TRANSACTION;

		INSERT INTO tbl_retorno_nt_ami2_siae (UNIDADE, ALUNO, DISCIPLINA, NOTA, DATA, SHORTNAME, NOTA_MOODLE)
					SELECT DISTINCT i.cd_instituicao AS UNIDADE,
							 rb2.USERNAME AS ALUNO,
							 d.cd_disciplina AS DISCIPLINA,
							 
							 rb2.BONUS AS NOTA,
							 DATE_FORMAT(NOW(),'%d/%m/%Y') AS DATA,
							 rb2.SHORTNAME,
							 rb2.BONUS AS NOTA_MOODLE
					  FROM tbl_retorno_base2 rb2
					  LEFT JOIN tbl_valeu_conteudo vc ON vc.SHORTNAME = rb2.SHORTNAME 
										 						AND vc.username = rb2.USERNAME
					  JOIN kls_lms_pessoa p ON p.login = rb2.USERNAME
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA 
					  											 AND cd.shortname = rb2.SHORTNAME
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina  
					  JOIN kls_lms_pessoa_turma pt ON pt.ID_PES_CUR_DISC = pcd.ID_PES_CUR_DISC
					  JOIN kls_lms_turmas t ON t.ID_TURMA = pt.ID_TURMA 
					  							  AND t.id_curso_disciplina = cd.id_curso_disciplina 
					  JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
					 WHERE CONCAT(vc.SHORTNAME, vc.username) IS NULL
					   AND p.id_pessoa > 100000000
					   AND tm.sigla REGEXP '^AMI';

	COMMIT;
	
	
	START TRANSACTION;
	
		INSERT INTO tbl_retorno_nt_ami2_olim (UNIDADE, CODIGO_MATRICULA, COD_CURSO, COD_DISCIPLINA,
														  TURMA, NOTA)
			SELECT DISTINCT i.cd_instituicao AS UNIDADE, 
							 p.cd_pessoa AS CODIGO_MATRICULA,
							 
							 c.cd_curso AS COD_CURSO,
							 
							 d.cd_disciplina AS COD_DISCIPLINA,
							 
							 t.cd_turma AS TURMA,
							 (rb2.BONUS * 5) AS NOTA
					  FROM tbl_retorno_base2 rb2
					  LEFT JOIN tbl_valeu_conteudo vc ON vc.SHORTNAME = rb2.SHORTNAME 
										 						AND vc.username = rb2.USERNAME
					  JOIN kls_lms_pessoa p ON p.login = rb2.USERNAME
					  JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
					  JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA 
					  											 AND cd.shortname = rb2.SHORTNAME
					  JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
					  JOIN kls_lms_disciplina d ON d.id_ies = c.id_ies 
					  									AND cd.ID_DISCIPLINA = d.id_disciplina
					  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
					  JOIN kls_lms_pessoa_turma pt ON pt.ID_PES_CUR_DISC = pcd.ID_PES_CUR_DISC
					  JOIN kls_lms_turmas t ON t.ID_TURMA = pt.ID_TURMA 
					  							  AND t.id_curso_disciplina = cd.id_curso_disciplina 
					  JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel 
					  JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo 
					 WHERE CONCAT(vc.SHORTNAME, vc.username) IS NULL
					   AND p.id_pessoa <= 100000000
					   AND i.cd_instituicao NOT IN ('OLIM-531','OLIM-522','OLIM-555','OLIM-1','OLIM-535','OLIM-697')
					   AND tm.sigla REGEXP '^AMI';
	
	COMMIT;


	DROP TABLE IF EXISTS tbl_retorno_base1;

	DROP TABLE IF EXISTS tbl_retorno_base2;


	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_retorno_base2)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
