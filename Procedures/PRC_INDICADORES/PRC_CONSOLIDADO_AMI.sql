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

-- Copiando estrutura para procedure prod_kls.PRC_CONSOLIDADO_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CONSOLIDADO_AMI`()
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
		SELECT database(), 'PRC_CONSOLIDADO_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	


	DROP TABLE IF EXISTS tbl_consolidado_ami1;
	
	CREATE TABLE tbl_consolidado_ami1 AS (
		SELECT ind.fullname,
		 		 ind.IDNUMBER_GRUPO, 
				 SUM(ind.QUIZ_U1S1_DIAGNOSTICA) AS '1', 
				 SUM(ind.QUIZ_U1S1_APRENDIZAGEM) AS '2', 
				 SUM(ind.QUIZ_U1S2_DIAGNOSTICA) AS '3', 
				 SUM(ind.QUIZ_U1S2_APRENDIZAGEM) AS '4', 
				 SUM(ind.QUIZ_U1S3_DIAGNOSTICA) AS '5', 
				 SUM(ind.QUIZ_U1S3_APRENDIZAGEM) AS '6', 
				 SUM(ind.QUIZ_U1S4_DIAGNOSTICA) AS '7', 
				 SUM(ind.QUIZ_U1S4_APRENDIZAGEM) AS '8', 
				 SUM(ind.QUIZ_U1) AS '9', 
				 SUM(ind.QUIZ_U2S1_DIAGNOSTICA) AS '10', 
				 SUM(ind.QUIZ_U2S1_APRENDIZAGEM) AS '11', 
				 SUM(ind.QUIZ_U2S2_DIAGNOSTICA) AS '12', 
				 SUM(ind.QUIZ_U2S2_APRENDIZAGEM) AS '13', 
				 SUM(ind.QUIZ_U2S3_DIAGNOSTICA) AS '14', 
				 SUM(ind.QUIZ_U2S3_APRENDIZAGEM) AS '15', 
				 SUM(ind.QUIZ_U2S4_DIAGNOSTICA) AS '16', 
				 SUM(ind.QUIZ_U2S4_APRENDIZAGEM) AS '17', 
				 SUM(ind.QUIZ_U2) AS '18', 
				 SUM(ind.QUIZ_U3S1_DIAGNOSTICA) AS '19', 
				 SUM(ind.QUIZ_U3S1_APRENDIZAGEM) AS '20', 
				 SUM(ind.QUIZ_U3S2_DIAGNOSTICA) AS '21', 
				 SUM(ind.QUIZ_U3S2_APRENDIZAGEM) AS '22', 
				 SUM(ind.QUIZ_U3S3_DIAGNOSTICA) AS '23', 
				 SUM(ind.QUIZ_U3S3_APRENDIZAGEM) AS '24', 
				 SUM(ind.QUIZ_U3S4_DIAGNOSTICA) AS '25', 
				 SUM(ind.QUIZ_U3S4_APRENDIZAGEM) AS '26', 
				 SUM(ind.QUIZ_U3) AS '27', 
				 SUM(ind.QUIZ_U4S4_APRENDIZAGEM) AS '28', 
				 SUM(ind.QUIZ_U4S1_DIAGNOSTICA) AS '29', 
				 SUM(ind.QUIZ_U4S1_APRENDIZAGEM) AS '30', 
				 SUM(ind.QUIZ_U4S2_DIAGNOSTICA) AS '31', 
				 SUM(ind.QUIZ_U4S2_APRENDIZAGEM) AS '32', 
				 SUM(ind.QUIZ_U4S3_DIAGNOSTICA) AS '33', 
				 SUM(ind.QUIZ_U4S3_APRENDIZAGEM) AS '34', 
				 SUM(ind.QUIZ_U4S4_DIAGNOSTICA) AS '35', 
				 SUM(ind.QUIZ_U4) AS '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2  
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.fullname, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C1_AMI ON tbl_consolidado_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_total_ami1;
	
	
	CREATE TABLE tbl_total_ami1 AS (
		SELECT ind.fullname, 
				 ind.IDNUMBER_GRUPO,
				 SUM(IF(ind.QUIZ_U1S1_DIAGNOSTICA	> 0,1,0)) AS '1', 
				 SUM(IF(ind.QUIZ_U1S1_APRENDIZAGEM	> 0,1,0)) AS '2', 
				 SUM(IF(ind.QUIZ_U1S2_DIAGNOSTICA		> 0,1,0)) AS '3', 
				 SUM(IF(ind.QUIZ_U1S2_APRENDIZAGEM	> 0,1,0)) AS '4', 
				 SUM(IF(ind.QUIZ_U1S3_DIAGNOSTICA		> 0,1,0)) AS '5', 
				 SUM(IF(ind.QUIZ_U1S3_APRENDIZAGEM	> 0,1,0)) AS '6', 
				 SUM(IF(ind.QUIZ_U1S4_DIAGNOSTICA		> 0,1,0)) AS '7', 
				 SUM(IF(ind.QUIZ_U1S4_APRENDIZAGEM	> 0,1,0)) AS '8', 
				 SUM(IF(ind.QUIZ_U1						> 0,1,0)) AS '9', 
				 SUM(IF(ind.QUIZ_U2S1_DIAGNOSTICA		> 0,1,0)) AS '10', 
				 SUM(IF(ind.QUIZ_U2S1_APRENDIZAGEM	> 0,1,0)) AS '11', 
				 SUM(IF(ind.QUIZ_U2S2_DIAGNOSTICA		> 0,1,0)) AS '12', 
				 SUM(IF(ind.QUIZ_U2S2_APRENDIZAGEM	> 0,1,0)) AS '13', 
				 SUM(IF(ind.QUIZ_U2S3_DIAGNOSTICA		> 0,1,0)) AS '14', 
				 SUM(IF(ind.QUIZ_U2S3_APRENDIZAGEM	> 0,1,0)) AS '15', 
				 SUM(IF(ind.QUIZ_U2S4_DIAGNOSTICA		> 0,1,0)) AS '16', 
				 SUM(IF(ind.QUIZ_U2S4_APRENDIZAGEM	> 0,1,0)) AS '17', 
				 SUM(IF(ind.QUIZ_U2						> 0,1,0)) AS '18', 
				 SUM(IF(ind.QUIZ_U3S1_DIAGNOSTICA		> 0,1,0)) AS '19', 
				 SUM(IF(ind.QUIZ_U3S1_APRENDIZAGEM	> 0,1,0)) AS '20', 
				 SUM(IF(ind.QUIZ_U3S2_DIAGNOSTICA		> 0,1,0)) AS '21', 
				 SUM(IF(ind.QUIZ_U3S2_APRENDIZAGEM	> 0,1,0)) AS '22', 
				 SUM(IF(ind.QUIZ_U3S3_DIAGNOSTICA		> 0,1,0)) AS '23', 
				 SUM(IF(ind.QUIZ_U3S3_APRENDIZAGEM	> 0,1,0)) AS '24', 
				 SUM(IF(ind.QUIZ_U3S4_DIAGNOSTICA		> 0,1,0)) AS '25', 
				 SUM(IF(ind.QUIZ_U3S4_APRENDIZAGEM	> 0,1,0)) AS '26', 
				 SUM(IF(ind.QUIZ_U3						> 0,1,0)) AS '27', 
				 SUM(IF(ind.QUIZ_U4S4_APRENDIZAGEM	> 0,1,0)) AS '28', 
				 SUM(IF(ind.QUIZ_U4S1_DIAGNOSTICA		> 0,1,0)) AS '29', 
				 SUM(IF(ind.QUIZ_U4S1_APRENDIZAGEM	> 0,1,0)) AS '30', 
				 SUM(IF(ind.QUIZ_U4S2_DIAGNOSTICA		> 0,1,0)) AS '31', 
				 SUM(IF(ind.QUIZ_U4S2_APRENDIZAGEM	> 0,1,0)) AS '32', 
				 SUM(IF(ind.QUIZ_U4S3_DIAGNOSTICA		> 0,1,0)) AS '33', 
				 SUM(IF(ind.QUIZ_U4S3_APRENDIZAGEM	> 0,1,0)) AS '34', 
				 SUM(IF(ind.QUIZ_U4S4_DIAGNOSTICA		> 0,1,0)) AS '35', 
				 SUM(IF(ind.QUIZ_U4						> 0,1,0)) AS '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
		   AND ind.QuantDiasAcesso > 0 
		 GROUP BY ind.fullname, ind.IDNUMBER_GRUPO);


	CREATE INDEX idx_T1_AMI ON tbl_total_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_consolidado_ami2;
	
	
	CREATE TABLE tbl_consolidado_ami2 AS (
		SELECT ind.fullname, 
				 ind.Nome, 
				 ind.IDNUMBER_GRUPO,
				 SUM(ind.QUIZ_U1S1_DIAGNOSTICA) AS '1', 
				 SUM(ind.QUIZ_U1S1_APRENDIZAGEM) AS '2', 
				 SUM(ind.QUIZ_U1S2_DIAGNOSTICA) AS '3', 
				 SUM(ind.QUIZ_U1S2_APRENDIZAGEM) AS '4', 
				 SUM(ind.QUIZ_U1S3_DIAGNOSTICA) AS '5', 
				 SUM(ind.QUIZ_U1S3_APRENDIZAGEM) AS '6', 
				 SUM(ind.QUIZ_U1S4_DIAGNOSTICA) AS '7', 
				 SUM(ind.QUIZ_U1S4_APRENDIZAGEM) AS '8', 
				 SUM(ind.QUIZ_U1) AS '9', 
				 SUM(ind.QUIZ_U2S1_DIAGNOSTICA) AS '10', 
				 SUM(ind.QUIZ_U2S1_APRENDIZAGEM) AS '11', 
				 SUM(ind.QUIZ_U2S2_DIAGNOSTICA) AS '12', 
				 SUM(ind.QUIZ_U2S2_APRENDIZAGEM) AS '13', 
				 SUM(ind.QUIZ_U2S3_DIAGNOSTICA) AS '14', 
				 SUM(ind.QUIZ_U2S3_APRENDIZAGEM) AS '15', 
				 SUM(ind.QUIZ_U2S4_DIAGNOSTICA) AS '16', 
				 SUM(ind.QUIZ_U2S4_APRENDIZAGEM) AS '17', 
				 SUM(ind.QUIZ_U2) AS '18', 
				 SUM(ind.QUIZ_U3S1_DIAGNOSTICA) AS '19', 
				 SUM(ind.QUIZ_U3S1_APRENDIZAGEM) AS '20', 
				 SUM(ind.QUIZ_U3S2_DIAGNOSTICA) AS '21', 
				 SUM(ind.QUIZ_U3S2_APRENDIZAGEM) AS '22', 
				 SUM(ind.QUIZ_U3S3_DIAGNOSTICA) AS '23', 
				 SUM(ind.QUIZ_U3S3_APRENDIZAGEM) AS '24', 
				 SUM(ind.QUIZ_U3S4_DIAGNOSTICA) AS '25', 
				 SUM(ind.QUIZ_U3S4_APRENDIZAGEM) AS '26', 
				 SUM(ind.QUIZ_U3) AS '27', 
				 SUM(ind.QUIZ_U4S4_APRENDIZAGEM) AS '28', 
				 SUM(ind.QUIZ_U4S1_DIAGNOSTICA) AS '29', 
				 SUM(ind.QUIZ_U4S1_APRENDIZAGEM) AS '30', 
				 SUM(ind.QUIZ_U4S2_DIAGNOSTICA) AS '31', 
				 SUM(ind.QUIZ_U4S2_APRENDIZAGEM) AS '32', 
				 SUM(ind.QUIZ_U4S3_DIAGNOSTICA) AS '33', 
				 SUM(ind.QUIZ_U4S3_APRENDIZAGEM) AS '34', 
				 SUM(ind.QUIZ_U4S4_DIAGNOSTICA) AS '35', 
				 SUM(ind.QUIZ_U4) AS '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
			AND ind.QuantDiasAcesso > 0 
		 GROUP BY ind.fullname, ind.nome, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C2_AMI ON tbl_consolidado_ami2 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_total_ami2;
	
	
	CREATE TABLE tbl_total_ami2 AS (
		SELECT ind.fullname, 
				 ind.Nome, 
				 ind.IDNUMBER_GRUPO,
				 SUM(IF(ind.QUIZ_U1S1_DIAGNOSTICA		> 0,1,0)) AS '1', 
				 SUM(IF(ind.QUIZ_U1S1_APRENDIZAGEM	> 0,1,0)) AS '2', 
				 SUM(IF(ind.QUIZ_U1S2_DIAGNOSTICA		> 0,1,0)) AS '3', 
				 SUM(IF(ind.QUIZ_U1S2_APRENDIZAGEM	> 0,1,0)) AS '4', 
				 SUM(IF(ind.QUIZ_U1S3_DIAGNOSTICA		> 0,1,0)) AS '5', 
				 SUM(IF(ind.QUIZ_U1S3_APRENDIZAGEM	> 0,1,0)) AS '6', 
				 SUM(IF(ind.QUIZ_U1S4_DIAGNOSTICA		> 0,1,0)) AS '7', 
				 SUM(IF(ind.QUIZ_U1S4_APRENDIZAGEM	> 0,1,0)) AS '8', 
				 SUM(IF(ind.QUIZ_U1						> 0,1,0)) AS '9', 
				 SUM(IF(ind.QUIZ_U2S1_DIAGNOSTICA		> 0,1,0)) AS '10', 
				 SUM(IF(ind.QUIZ_U2S1_APRENDIZAGEM	> 0,1,0)) AS '11', 
				 SUM(IF(ind.QUIZ_U2S2_DIAGNOSTICA		> 0,1,0)) AS '12', 
				 SUM(IF(ind.QUIZ_U2S2_APRENDIZAGEM	> 0,1,0)) AS '13', 
				 SUM(IF(ind.QUIZ_U2S3_DIAGNOSTICA		> 0,1,0)) AS '14', 
				 SUM(IF(ind.QUIZ_U2S3_APRENDIZAGEM	> 0,1,0)) AS '15', 
				 SUM(IF(ind.QUIZ_U2S4_DIAGNOSTICA		> 0,1,0)) AS '16', 
				 SUM(IF(ind.QUIZ_U2S4_APRENDIZAGEM	> 0,1,0)) AS '17', 
				 SUM(IF(ind.QUIZ_U2						> 0,1,0)) AS '18', 
				 SUM(IF(ind.QUIZ_U3S1_DIAGNOSTICA		> 0,1,0)) AS '19', 
				 SUM(IF(ind.QUIZ_U3S1_APRENDIZAGEM	> 0,1,0)) AS '20', 
				 SUM(IF(ind.QUIZ_U3S2_DIAGNOSTICA		> 0,1,0)) AS '21', 
				 SUM(IF(ind.QUIZ_U3S2_APRENDIZAGEM	> 0,1,0)) AS '22', 
				 SUM(IF(ind.QUIZ_U3S3_DIAGNOSTICA		> 0,1,0)) AS '23', 
				 SUM(IF(ind.QUIZ_U3S3_APRENDIZAGEM	> 0,1,0)) AS '24', 
				 SUM(IF(ind.QUIZ_U3S4_DIAGNOSTICA		> 0,1,0)) AS '25', 
				 SUM(IF(ind.QUIZ_U3S4_APRENDIZAGEM	> 0,1,0)) AS '26', 
				 SUM(IF(ind.QUIZ_U3						> 0,1,0)) AS '27', 
				 SUM(IF(ind.QUIZ_U4S4_APRENDIZAGEM	> 0,1,0)) AS '28', 
				 SUM(IF(ind.QUIZ_U4S1_DIAGNOSTICA		> 0,1,0)) AS '29', 
				 SUM(IF(ind.QUIZ_U4S1_APRENDIZAGEM	> 0,1,0)) AS '30', 
				 SUM(IF(ind.QUIZ_U4S2_DIAGNOSTICA		> 0,1,0)) AS '31', 
				 SUM(IF(ind.QUIZ_U4S2_APRENDIZAGEM	> 0,1,0)) AS '32', 
				 SUM(IF(ind.QUIZ_U4S3_DIAGNOSTICA		> 0,1,0)) AS '33', 
				 SUM(IF(ind.QUIZ_U4S3_APRENDIZAGEM	> 0,1,0)) AS '34', 
				 SUM(IF(ind.QUIZ_U4S4_DIAGNOSTICA		> 0,1,0)) AS '35', 
				 SUM(IF(ind.QUIZ_U4						> 0,1,0)) AS '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2 
		   AND ind.QuantDiasAcesso > 0 
		 GROUP BY ind.fullname, ind.Nome, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_T2_AMI ON tbl_total_ami2 (IDNUMBER_GRUPO);
	

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
