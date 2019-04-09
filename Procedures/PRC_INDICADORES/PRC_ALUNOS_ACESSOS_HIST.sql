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

-- Copiando estrutura para procedure prod_kls.PRC_ALUNOS_ACESSOS_HIST
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ALUNOS_ACESSOS_HIST`()
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
		SELECT database(), 'PRC_ALUNOS_ACESSOS_HIST', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		
	SET ID_LOG_=LAST_INSERT_ID();		

	DROP TABLE IF EXISTS tbl_base_alunos;

	CREATE TABLE tbl_base_alunos (
												USERID 					BIGINT(10),
												TIMEZONE					VARCHAR(100),
												UNIDADE					VARCHAR(30),
												NOME_UNIDADE			VARCHAR(100),
												NOME_ALU					VARCHAR(200),
												RA							VARCHAR(100),
												FL_ALUNO_BLOQUEADO	INT DEFAULT 0,
												PRIMARY KEY (USERID)
										  );


	DROP TABLE IF EXISTs tbl_base_alunos1;

	CREATE TABLE tbl_base_alunos1 (
												USERID 					BIGINT(10),
												TIMEZONE					VARCHAR(100),
												UNIDADE					VARCHAR(30),
												NOME_UNIDADE			VARCHAR(100),
												NOME_ALU					VARCHAR(200),
												RA							VARCHAR(100),
												FL_ALUNO_BLOQUEADO	INT DEFAULT 0,
												DATA_ACESSO				DATE DEFAULT NULL
										  	);

	ALTER TABLE tbl_base_alunos1 ADD INDEX idx_userid (USERID);
	
	DROP TABLE IF EXISTs tbl_alunos_acessos_hist;

	CREATE TABLE tbl_alunos_acessos_hist (
														USERID 					BIGINT(10),
														TIMEZONE					VARCHAR(100),
														UNIDADE					VARCHAR(30),
														NOME_UNIDADE			VARCHAR(100),
														NOME_ALU					VARCHAR(200),
														RA							VARCHAR(100),
														FL_ALUNO_BLOQUEADO	INT DEFAULT 0,
														DATA_ACESSO				DATE DEFAULT NULL,
														QTD_ACESSO 				INT DEFAULT NULL
												  	 );
												  	 
	ALTER TABLE tbl_alunos_acessos_hist ADD INDEX idx_userid (USERID);


	START TRANSACTION;

		INSERT tbl_base_alunos (USERID, TIMEZONE, UNIDADE, NOME_UNIDADE, NOME_ALU, RA, FL_ALUNO_BLOQUEADO)
			SELECT u.id AS USERID
					,u.timezone
					,i.cd_instituicao AS UNIDADE
					,i.nm_ies AS NOME_UNIDADE
					,CONCAT(u.firstname, ' ', u.lastname) AS NOME_ALU
					,p.cd_pessoa as RA
					,u.deleted AS FL_ALUNO_BLOQUEADO
			  FROM tbl_mdl_user u			  
			  JOIN kls_lms_pessoa p ON p.login = u.username
			  JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa
			  JOIN kls_lms_curso c ON c.id_curso = pc.id_curso
			  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
			 WHERE pc.id_papel = 1 
	       GROUP BY u.id;

    COMMIT;


	 START TRANSACTION;

    	INSERT INTO tbl_base_alunos1 (USERID, TIMEZONE, UNIDADE, NOME_UNIDADE, NOME_ALU, RA, FL_ALUNO_BLOQUEADO, DATA_ACESSO)
	    	SELECT t.USERID
	    			,t.TIMEZONE
					,t.UNIDADE
					,t.NOME_UNIDADE
					,t.NOME_ALU
					,t.RA
					,t.FL_ALUNO_BLOQUEADO
	    			,DATE_FORMAT(FROM_UNIXTIME(l.DT),'%Y-%m-%d') AS DATA_ACESSO
	    	  FROM tbl_base_alunos t
	    	  JOIN tbl_login l ON l.USERID = t.USERID
			 WHERE t.TIMEZONE = 99;

	 COMMIT;


	 START TRANSACTION;

    	INSERT INTO tbl_base_alunos1 (USERID, TIMEZONE, UNIDADE, NOME_UNIDADE, NOME_ALU, RA, FL_ALUNO_BLOQUEADO, DATA_ACESSO)
	    	SELECT t.USERID
	    			,t.TIMEZONE
					,t.UNIDADE
					,t.NOME_UNIDADE
					,t.NOME_ALU
					,t.RA
					,t.FL_ALUNO_BLOQUEADO
	    			,DATE_FORMAT(FROM_UNIXTIME(l.DT + (t.TIMEZONE * 3600)),'%Y-%m-%d') AS DATA_ACESSO
	    	  FROM tbl_base_alunos t
	    	  JOIN tbl_login l ON l.USERID = t.USERID
			 WHERE t.TIMEZONE <> 99;

	 COMMIT;
	 
	 

	 START TRANSACTION;

    	INSERT INTO tbl_alunos_acessos_hist
	    	SELECT t.USERID
	    			,t.TIMEZONE
					,t.UNIDADE
					,t.NOME_UNIDADE
					,t.NOME_ALU
					,t.RA
					,t.FL_ALUNO_BLOQUEADO
	    			,t.DATA_ACESSO
	    			,COUNT(t.DATA_ACESSO) AS QTD_ACESSO
	    	  FROM tbl_base_alunos1 t
	    	 GROUP BY t.USERID, t.TIMEZONE, t.UNIDADE, t.NOME_UNIDADE, t.NOME_ALU, t.RA, t.FL_ALUNO_BLOQUEADO, t.DATA_ACESSO;

	 COMMIT;


	 DROP TABLE IF EXISTs tbl_base_alunos;

	 DROP TABLE IF EXISTs tbl_base_alunos1;

 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_alunos_acessos_hist)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
