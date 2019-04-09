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

-- Copiando estrutura para procedure prod_kls.PRC_DMC_PERC_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_DMC_PERC_AMI`()
BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_DMC_PERC_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	


	DROP TABLE IF EXISTS tbl_dmc_perc_consolidado_ami1;
	
	CREATE TABLE tbl_dmc_perc_consolidado_ami1 AS (
		SELECT ind.NOME_CURSO_KLS AS curso,
		 		 ind.IDNUMBER_GRUPO, 
				 sum((IF(QUIZ_U1S1_DIAGNOSTICA >= 6, 1	,0) +
				 IF(QUIZ_U1S1_APRENDIZAGEM >= 6, 1	,0) +
				 IF(QUIZ_U1S2_DIAGNOSTICA	>= 6, 1	,0) +
				 IF(QUIZ_U1S2_APRENDIZAGEM >= 6, 1	,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA	>= 6, 1	,0) +
				 IF(QUIZ_U1S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U1S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U1						>= 6,	1	,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2 					>= 6,	1	,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3						>= 6,	1	,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4						>= 6,	1						,0))) as total_maior_6
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2  
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.NOME_CURSO_KLS, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C1_AMI ON tbl_dmc_perc_consolidado_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_dmc_perc_total_ami1;
	
	
	CREATE TABLE tbl_dmc_perc_total_ami1 AS (
		SELECT ind.NOME_CURSO_KLS AS curso,
				 ind.IDNUMBER_GRUPO,
				 sum((IF(QUIZ_U1S1_DIAGNOSTICA > 0, 1	,0) +
				 IF(QUIZ_U1S1_APRENDIZAGEM > 0, 1	,0) +
				 IF(QUIZ_U1S2_DIAGNOSTICA	> 0, 1	,0) +
				 IF(QUIZ_U1S2_APRENDIZAGEM > 0, 1	,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA	> 0, 1	,0) +
				 IF(QUIZ_U1S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U1S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U1						> 0,	1	,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2 					> 0,	1	,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3						> 0,	1	,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4						> 0,	1	,0))) as quantidade
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
		   AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.NOME_CURSO_KLS, ind.IDNUMBER_GRUPO);


	CREATE INDEX idx_T1_AMI ON tbl_dmc_perc_total_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_dmc_perc_consolidado_ami2;
	
	
	CREATE TABLE tbl_dmc_perc_consolidado_ami2 AS (
		SELECT ind.FULLNAME AS disciplina, 
				 ind.IDNUMBER_GRUPO,
				 sum((IF(QUIZ_U1S1_DIAGNOSTICA >= 6, 1	,0) +
				 IF(QUIZ_U1S1_APRENDIZAGEM >= 6, 1	,0) +
				 IF(QUIZ_U1S2_DIAGNOSTICA	>= 6, 1	,0) +
				 IF(QUIZ_U1S2_APRENDIZAGEM >= 6, 1	,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA	>= 6, 1	,0) +
				 IF(QUIZ_U1S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U1S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U1						>= 6,	1	,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U2S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U2 					>= 6,	1	,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U3S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U3						>= 6,	1	,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S1_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S1_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S2_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S3_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM >= 6,	1	,0) +
				 IF(QUIZ_U4S4_DIAGNOSTICA	>= 6,	1	,0) +
				 IF(QUIZ_U4						>= 6,	1						,0))) as total_maior_6
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.FULLNAME, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C2_AMI ON tbl_dmc_perc_consolidado_ami2 (IDNUMBER_GRUPO);




	DROP TABLE IF EXISTS tbl_dmc_perc_total_ami2;
	
	
	CREATE TABLE tbl_dmc_perc_total_ami2 AS (
		SELECT ind.FULLNAME AS disciplina,
				 ind.IDNUMBER_GRUPO,
				 sum((IF(QUIZ_U1S1_DIAGNOSTICA > 0, 1	,0) +
				 IF(QUIZ_U1S1_APRENDIZAGEM > 0, 1	,0) +
				 IF(QUIZ_U1S2_DIAGNOSTICA	> 0, 1	,0) +
				 IF(QUIZ_U1S2_APRENDIZAGEM > 0, 1	,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA	> 0, 1	,0) +
				 IF(QUIZ_U1S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U1S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U1						> 0,	1	,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U2S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U2 					> 0,	1	,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U3S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U3						> 0,	1	,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S1_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S1_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S2_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S3_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM > 0,	1	,0) +
				 IF(QUIZ_U4S4_DIAGNOSTICA	> 0,	1	,0) +
				 IF(QUIZ_U4						> 0,	1	,0))) as quantidade
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2 
		   AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.FULLNAME, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_T2_AMI ON tbl_dmc_perc_total_ami2 (IDNUMBER_GRUPO);
	

	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, 0),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
