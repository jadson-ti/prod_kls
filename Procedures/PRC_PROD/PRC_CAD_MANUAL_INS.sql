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

-- Copiando estrutura para procedure prod_kls.PRC_CAD_MANUAL_INS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CAD_MANUAL_INS`(
	IN `LOGIN_` VARCHAR(255),
	IN `CD_INSTITUICAO_` VARCHAR(255)
,
	IN `PAPEL_` VARCHAR(255)

,
	IN `CD_CURSO_` VARCHAR(255)







)
    COMMENT 'cadastrar diretor academico'
BEGIN

	DECLARE LOGIN_TRUE_ 			 TINYINT(1) DEFAULT 0;
	DECLARE INSTITUICAO_TRUE_ 	 TINYINT(1) DEFAULT 0;
	DECLARE PAPEL_TRUE_ 	 		 TINYINT(1) DEFAULT 0;
	DECLARE CURSO_TRUE_ 	 		 TINYINT(1) DEFAULT 0;
	
	SET LOGIN_TRUE_ = 0;
	SET INSTITUICAO_TRUE_ = 0;
	SET PAPEL_TRUE_ = 0;
	SET CURSO_TRUE_ = 0;

	SELECT 1 INTO LOGIN_TRUE_ 
	  FROM kls_lms_pessoa p
	 WHERE p.login = LOGIN_;
	 
	SELECT 1 INTO INSTITUICAO_TRUE_ 
	  FROM kls_lms_instituicao i
	 WHERE i.cd_instituicao = CD_INSTITUICAO_;

	SELECT 1 INTO PAPEL_TRUE_
	  FROM kls_lms_papel pl
	 WHERE pl.ds_papel = PAPEL_;
	 
	SELECT 1 INTO CURSO_TRUE_
	  FROM kls_lms_curso c
	 WHERE c.cd_curso = CD_CURSO_
	   AND c.id_ies = (SELECT i.id_ies 
								FROM kls_lms_instituicao i 
							  WHERE i.cd_instituicao = CD_INSTITUICAO_);


	IF LOGIN_TRUE_ = 1 AND INSTITUICAO_TRUE_ = 1 AND PAPEL_TRUE_ = 1 AND CURSO_TRUE_ = 0 THEN

		START TRANSACTION;
		
		INSERT INTO kls_lms_pessoa_curso_manual (id_curso, id_pessoa, id_papel, create_dat, fl_etl_atu, `status`)
			SELECT c.id_curso,
			       (SELECT p.id_pessoa FROM kls_lms_pessoa p WHERE p.login = LOGIN_) AS id_pessoa,
					 (SELECT pl.id_papel FROM kls_lms_papel pl WHERE pl.ds_papel = PAPEL_) AS id_papel, 
					 DATE_FORMAT(NOW(), '%Y-%m-%d') AS create_dat, 
					 'N' AS fl_etl_atu,
					 '1' AS `status`
			  FROM kls_lms_curso c 
			 WHERE c.id_ies = (SELECT DISTINCT i.id_ies 
									   FROM kls_lms_instituicao i 
									  WHERE i.cd_instituicao = CD_INSTITUICAO_)
									  
			
				AND NOT EXISTS (SELECT 1 FROM kls_lms_pessoa_curso_manual klpcm
									  WHERE klpcm.id_pessoa = (SELECT p.id_pessoa FROM kls_lms_pessoa p WHERE p.login = LOGIN_)
									    AND klpcm.id_papel = (SELECT pl.id_papel FROM kls_lms_papel pl WHERE pl.ds_papel = PAPEL_)
										 AND klpcm.id_curso = c.id_curso);
									  
	   COMMIT;
	
	ELSEIF LOGIN_TRUE_ = 1 AND INSTITUICAO_TRUE_ = 1 AND PAPEL_TRUE_ = 1 AND CURSO_TRUE_ = 1 THEN
		 
		START TRANSACTION;
		
		INSERT INTO kls_lms_pessoa_curso_manual (id_curso, id_pessoa, id_papel, create_dat, fl_etl_atu, `status`)
			SELECT (SELECT c.id_curso 
			          FROM kls_lms_curso c 
						WHERE c.cd_curso = CD_CURSO_
						  AND c.id_ies = (SELECT i.id_ies 
									           FROM kls_lms_instituicao i 
									          WHERE i.cd_instituicao = CD_INSTITUICAO_)) AS id_curso,
			       (SELECT p.id_pessoa FROM kls_lms_pessoa p WHERE p.login = LOGIN_) AS id_pessoa,
					 (SELECT pl.id_papel FROM kls_lms_papel pl WHERE pl.ds_papel = PAPEL_) AS id_papel, 
					 DATE_FORMAT(NOW(), '%Y-%m-%d') AS create_dat, 
					 'N' AS fl_etl_atu,
					 '1' AS `status`
			  FROM DUAL;
									  
	   COMMIT;
		 
	END IF;
	
	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
