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

-- Copiando estrutura para procedure prod_kls.PRC_ENG_ALU_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ENG_ALU_AMI`()
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
		SELECT database(), 'PRC_ENG_ALU_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	


	DROP TABLE IF EXISTS tbl_eng_alu_consolidado_ami1;
	
	CREATE TABLE tbl_eng_alu_consolidado_ami1 AS (
		SELECT 'Kroton' AS descricao,
				 SUM(IF((
				 IF(QUIZ_U1S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U1S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1 > 0,1,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U2S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2 > 0,1,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U3S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3 > 0,1,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U4S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S2_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S3_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S4_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4 > 0,1,0))>0,1,0)) as value
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2  
			AND ind.QuantDiasAcesso > 0);
		 


	



	DROP TABLE IF EXISTS tbl_eng_alu_consolidado_ami2;
	
	
	CREATE TABLE tbl_eng_alu_consolidado_ami2 AS (
		SELECT rg.nm_regional,
				 SUM(IF((
				 IF(QUIZ_U1S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U1S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1 > 0,1,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U2S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2 > 0,1,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U3S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3 > 0,1,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U4S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S2_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S3_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S4_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4 > 0,1,0))>0,1,0)) as value
		  FROM tbl_indicadores_ami ind
		  JOIN kls_lms_instituicao ins ON ins.cd_instituicao = ind.COD_UNIDADE
	     JOIN kls_lms_regional rg ON rg.id_regional = ins.id_regional
		 WHERE ind.ID_CATEGORIA = 2
		   AND ind.QuantDiasAcesso > 0
		 GROUP BY rg.nm_regional);


	CREATE INDEX idx_C2_AMI ON tbl_eng_alu_consolidado_ami2 (nm_regional);
	



	DROP TABLE IF EXISTS tbl_eng_alu_consolidado_ami3;
	
	
	CREATE TABLE tbl_eng_alu_consolidado_ami3 AS (
		SELECT 'Perfil' as descricao,
				 ind.IDNUMBER_GRUPO,
				 SUM(IF((
				 IF(QUIZ_U1S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U1S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U1S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U1 > 0,1,0) +
				 IF(QUIZ_U2S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U2S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U2S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U2 > 0,1,0) +
				 IF(QUIZ_U3S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U3S2_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S2_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S3_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S3_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3S4_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U3S4_APRENDIZAGEM > 0,1,0) +
				 IF(QUIZ_U3 > 0,1,0) +
				 IF(QUIZ_U4S4_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S1_DIAGNOSTICA > 0,1,0)  +
				 IF(QUIZ_U4S1_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S2_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S2_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S3_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4S3_APRENDIZAGEM > 0,1,0)  +
				 IF(QUIZ_U4S4_DIAGNOSTICA > 0,1,0) +
				 IF(QUIZ_U4 > 0,1,0))>0,1,0)) as value
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C3_AMI ON tbl_eng_alu_consolidado_ami3 (IDNUMBER_GRUPO);
	
	
	DROP TABLE IF EXISTS tbl_eng_alu_total_ami3;
	
	
	CREATE TABLE tbl_eng_alu_total_ami3 AS (
		SELECT COUNT(1) AS tot,
				 ind.IDNUMBER_GRUPO
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_T3_AMI ON tbl_eng_alu_total_ami3 (IDNUMBER_GRUPO);
	
	

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