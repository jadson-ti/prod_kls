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

-- Copiando estrutura para procedure prod_kls.PRC_LISTA_DISC_AMI
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_LISTA_DISC_AMI`()
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
		SELECT database(), 'PRC_LISTA_DISC_AMI', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	


	DROP TABLE IF EXISTS tbl_lista_consolidado_ami1;
	
	CREATE TABLE tbl_lista_consolidado_ami1 AS (
		SELECT ind.fullname,
		 		 ind.IDNUMBER_GRUPO, 
				 SUM(IF(ind.QUIZ_U1S1_DIAGNOSTICA		> 0, 1 ,0))	as '1',
				 SUM(IF(ind.QUIZ_U1S1_APRENDIZAGEM	> 0, 1 ,0))	as '2',
				 SUM(IF(ind.QUIZ_U1S2_DIAGNOSTICA		> 0, 1 ,0))	as '3',
				 SUM(IF(ind.QUIZ_U1S2_APRENDIZAGEM	> 0, 1 ,0))	as '4',
				 SUM(IF(ind.QUIZ_U1S3_DIAGNOSTICA		> 0, 1 ,0))	as '5',
				 SUM(IF(ind.QUIZ_U1S3_APRENDIZAGEM	> 0, 1 ,0))	as '6',
				 SUM(IF(ind.QUIZ_U1S4_DIAGNOSTICA		> 0, 1 ,0))	as '7',
				 SUM(IF(ind.QUIZ_U1S4_APRENDIZAGEM	> 0, 1 ,0))	as '8',
				 SUM(IF(ind.QUIZ_U1						> 0, 1 ,0))	as '9',
				 SUM(IF(ind.QUIZ_U2S1_DIAGNOSTICA		> 0, 1 ,0))	as '10',
				 SUM(IF(ind.QUIZ_U2S1_APRENDIZAGEM	> 0, 1 ,0))	as '11',
				 SUM(IF(ind.QUIZ_U2S2_DIAGNOSTICA		> 0, 1 ,0))	as '12',
				 SUM(IF(ind.QUIZ_U2S2_APRENDIZAGEM	> 0, 1 ,0))	as '13',
				 SUM(IF(ind.QUIZ_U2S3_DIAGNOSTICA		> 0, 1 ,0))	as '14',
				 SUM(IF(ind.QUIZ_U2S3_APRENDIZAGEM	> 0, 1 ,0))	as '15',
				 SUM(IF(ind.QUIZ_U2S4_DIAGNOSTICA		> 0, 1 ,0))	as '16',
				 SUM(IF(ind.QUIZ_U2S4_APRENDIZAGEM	> 0, 1 ,0))	as '17',
				 SUM(IF(ind.QUIZ_U2						> 0, 1 ,0))	as '18',
				 SUM(IF(ind.QUIZ_U3S1_DIAGNOSTICA		> 0, 1 ,0))	as '19',
				 SUM(IF(ind.QUIZ_U3S1_APRENDIZAGEM	> 0, 1 ,0))	as '20',
				 SUM(IF(ind.QUIZ_U3S2_DIAGNOSTICA		> 0, 1 ,0))	as '21',
				 SUM(IF(ind.QUIZ_U3S2_APRENDIZAGEM	> 0, 1 ,0))	as '22',
				 SUM(IF(ind.QUIZ_U3S3_DIAGNOSTICA		> 0, 1 ,0))	as '23',
				 SUM(IF(ind.QUIZ_U3S3_APRENDIZAGEM	> 0, 1 ,0))	as '24',
				 SUM(IF(ind.QUIZ_U3S4_DIAGNOSTICA		> 0, 1 ,0))	as '25',
				 SUM(IF(ind.QUIZ_U3S4_APRENDIZAGEM	> 0, 1 ,0))	as '26',
				 SUM(IF(ind.QUIZ_U3						> 0, 1 ,0))	as '27',
				 SUM(IF(ind.QUIZ_U4S4_APRENDIZAGEM	> 0, 1 ,0))	as '28',
				 SUM(IF(ind.QUIZ_U4S1_DIAGNOSTICA		> 0, 1 ,0))	as '29',
				 SUM(IF(ind.QUIZ_U4S1_APRENDIZAGEM	> 0, 1 ,0))	as '30',
				 SUM(IF(ind.QUIZ_U4S2_DIAGNOSTICA		> 0, 1 ,0))	as '31',
				 SUM(IF(ind.QUIZ_U4S2_APRENDIZAGEM	> 0, 1 ,0))	as '32',
				 SUM(IF(ind.QUIZ_U4S3_DIAGNOSTICA		> 0, 1 ,0))	as '33',
				 SUM(IF(ind.QUIZ_U4S3_APRENDIZAGEM	> 0, 1 ,0))	as '34',
				 SUM(IF(ind.QUIZ_U4S4_DIAGNOSTICA		> 0, 1 ,0))	as '35',
				 SUM(IF(ind.QUIZ_U4						> 0, 1 ,0))	as '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2  
			AND ind.QuantDiasAcesso > 0
		 GROUP BY ind.fullname, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C1_AMI ON tbl_lista_consolidado_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_lista_total_ami1;
	
	
	CREATE TABLE tbl_lista_total_ami1 AS (
		SELECT ind.fullname, 
				 ind.IDNUMBER_GRUPO,
				 SUM(IF(ind.QUIZ_U1S1_DIAGNOSTICA		>= 0,1,0))	as '1',
				 SUM(IF(ind.QUIZ_U1S1_APRENDIZAGEM	>= 0,1,0))	as '2',
				 SUM(IF(ind.QUIZ_U1S2_DIAGNOSTICA		>= 0,1,0))	as '3',
				 SUM(IF(ind.QUIZ_U1S2_APRENDIZAGEM	>= 0,1,0))	as '4',
				 SUM(IF(ind.QUIZ_U1S3_DIAGNOSTICA		>= 0,1,0))	as '5',
				 SUM(IF(ind.QUIZ_U1S3_APRENDIZAGEM	>= 0,1,0))	as '6',
				 SUM(IF(ind.QUIZ_U1S4_DIAGNOSTICA		>= 0,1,0))	as '7',
				 SUM(IF(ind.QUIZ_U1S4_APRENDIZAGEM	>= 0,1,0))	as '8',
				 SUM(IF(ind.QUIZ_U1						>= 0,1,0))	as '9',
				 SUM(IF(ind.QUIZ_U2S1_DIAGNOSTICA		>= 0,1,0))	as '10',
				 SUM(IF(ind.QUIZ_U2S1_APRENDIZAGEM	>= 0,1,0))	as '11',
				 SUM(IF(ind.QUIZ_U2S2_DIAGNOSTICA		>= 0,1,0))	as '12',
				 SUM(IF(ind.QUIZ_U2S2_APRENDIZAGEM	>= 0,1,0))	as '13',
				 SUM(IF(ind.QUIZ_U2S3_DIAGNOSTICA		>= 0,1,0))	as '14',
				 SUM(IF(ind.QUIZ_U2S3_APRENDIZAGEM	>= 0,1,0))	as '15',
				 SUM(IF(ind.QUIZ_U2S4_DIAGNOSTICA		>= 0,1,0))	as '16',
				 SUM(IF(ind.QUIZ_U2S4_APRENDIZAGEM	>= 0,1,0))	as '17',
				 SUM(IF(ind.QUIZ_U2						>= 0,1,0))	as '18',
				 SUM(IF(ind.QUIZ_U3S1_DIAGNOSTICA		>= 0,1,0))	as '19',
				 SUM(IF(ind.QUIZ_U3S1_APRENDIZAGEM	>= 0,1,0))	as '20',
				 SUM(IF(ind.QUIZ_U3S2_DIAGNOSTICA		>= 0,1,0))	as '21',
				 SUM(IF(ind.QUIZ_U3S2_APRENDIZAGEM	>= 0,1,0))	as '22',
				 SUM(IF(ind.QUIZ_U3S3_DIAGNOSTICA		>= 0,1,0))	as '23',
				 SUM(IF(ind.QUIZ_U3S3_APRENDIZAGEM	>= 0,1,0))	as '24',
				 SUM(IF(ind.QUIZ_U3S4_DIAGNOSTICA		>= 0,1,0))	as '25',
				 SUM(IF(ind.QUIZ_U3S4_APRENDIZAGEM	>= 0,1,0))	as '26',
				 SUM(IF(ind.QUIZ_U3						>= 0,1,0))	as '27',
				 SUM(IF(ind.QUIZ_U4S4_APRENDIZAGEM	>= 0,1,0))	as '28',
				 SUM(IF(ind.QUIZ_U4S1_DIAGNOSTICA		>= 0,1,0))	as '29',
				 SUM(IF(ind.QUIZ_U4S1_APRENDIZAGEM	>= 0,1,0))	as '30',
				 SUM(IF(ind.QUIZ_U4S2_DIAGNOSTICA		>= 0,1,0))	as '31',
				 SUM(IF(ind.QUIZ_U4S2_APRENDIZAGEM	>= 0,1,0))	as '32',
				 SUM(IF(ind.QUIZ_U4S3_DIAGNOSTICA		>= 0,1,0))	as '33',
				 SUM(IF(ind.QUIZ_U4S3_APRENDIZAGEM	>= 0,1,0))	as '34',
				 SUM(IF(ind.QUIZ_U4S4_DIAGNOSTICA		>= 0,1,0))	as '35',
				 SUM(IF(ind.QUIZ_U4						>= 0,1,0))	as '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
		   AND ind.QuantDiasAcesso > 0 
		 GROUP BY ind.fullname, ind.IDNUMBER_GRUPO);


	CREATE INDEX idx_T1_AMI ON tbl_lista_total_ami1 (IDNUMBER_GRUPO);
	



	DROP TABLE IF EXISTS tbl_lista_consolidado_ami2;
	
	
	CREATE TABLE tbl_lista_consolidado_ami2 AS (
		SELECT 2 as tipo,
				 ind.fullname, 
				 ind.Nome, 
				 ind.IDNUMBER_GRUPO,
				 IF(ind.QUIZ_U1S1_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '1',
				 IF(ind.QUIZ_U1S1_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '2',
				 IF(ind.QUIZ_U1S2_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '3',
				 IF(ind.QUIZ_U1S2_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '4',
				 IF(ind.QUIZ_U1S3_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '5',
				 IF(ind.QUIZ_U1S3_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '6',
				 IF(ind.QUIZ_U1S4_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '7',
				 IF(ind.QUIZ_U1S4_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '8',
				 IF(ind.QUIZ_U1							> 0,'Realizado','Pendente')	as '9',
				 IF(ind.QUIZ_U2S1_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '10',
				 IF(ind.QUIZ_U2S1_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '11',
				 IF(ind.QUIZ_U2S2_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '12',
				 IF(ind.QUIZ_U2S2_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '13',
				 IF(ind.QUIZ_U2S3_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '14',
				 IF(ind.QUIZ_U2S3_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '15',
				 IF(ind.QUIZ_U2S4_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '16',
				 IF(ind.QUIZ_U2S4_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '17',
				 IF(ind.QUIZ_U2							> 0,'Realizado','Pendente')	as '18',
				 IF(ind.QUIZ_U3S1_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '19',
				 IF(ind.QUIZ_U3S1_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '20',
				 IF(ind.QUIZ_U3S2_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '21',
				 IF(ind.QUIZ_U3S2_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '22',
				 IF(ind.QUIZ_U3S3_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '23',
				 IF(ind.QUIZ_U3S3_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '24',
				 IF(ind.QUIZ_U3S4_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '25',
				 IF(ind.QUIZ_U3S4_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '26',
				 IF(ind.QUIZ_U3							> 0,'Realizado','Pendente')	as '27',
				 IF(ind.QUIZ_U4S4_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '28',
				 IF(ind.QUIZ_U4S1_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '29',
				 IF(ind.QUIZ_U4S1_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '30',
				 IF(ind.QUIZ_U4S2_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '31',
				 IF(ind.QUIZ_U4S2_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '32',
				 IF(ind.QUIZ_U4S3_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '33',
				 IF(ind.QUIZ_U4S3_APRENDIZAGEM		> 0,'Realizado','Pendente')	as '34',
				 IF(ind.QUIZ_U4S4_DIAGNOSTICA		> 0,'Realizado','Pendente')	as '35',
				 IF(ind.QUIZ_U4							> 0,'Realizado','Pendente')	as '36'
		  FROM tbl_indicadores_ami ind
		 WHERE ind.ID_CATEGORIA = 2
			AND ind.QuantDiasAcesso > 0 
		 GROUP BY tipo, ind.fullname, ind.nome, ind.IDNUMBER_GRUPO);
		 

	CREATE INDEX idx_C2_AMI ON tbl_lista_consolidado_ami2 (IDNUMBER_GRUPO);

	

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
