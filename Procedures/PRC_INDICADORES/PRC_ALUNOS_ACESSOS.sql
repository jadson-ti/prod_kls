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

-- Copiando estrutura para procedure prod_kls.PRC_ALUNOS_ACESSOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ALUNOS_ACESSOS`()
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
		SELECT database(), 'PRC_ALUNOS_ACESSOS', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
		

	DROP TABLE IF EXISTs tbl_alunos_acessos;

	CREATE TABLE tbl_alunos_acessos (
												USERID 			BIGINT(10),
												TIMEZONE			VARCHAR(100),
												UNIDADE			VARCHAR(30),
												NOME_UNIDADE	VARCHAR(100),
												NOME_ALU			VARCHAR(200),
												RA					VARCHAR(100),
												FL_ALUNO_BLOQUEADO	INT DEFAULT 0,
												FIRSTACCESS		DATETIME DEFAULT 0,
												LASTACCESS 		DATETIME DEFAULT 0
										  	  );
	
   CREATE INDEX idx_ALU_ACESS ON tbl_alunos_acessos (USERID);	
   
	DROP TABLE IF EXISTs tmp1;
	
	CREATE TABLE tmp1 (
								USERID 			BIGINT(10),
								DT_ACESSO		BIGINT(10)
							);
   CREATE INDEX idx_user ON tmp1 (USERID);								
							
	DROP TABLE IF EXISTs tmp2;
	
	CREATE TABLE tmp2 (
								USERID 			BIGINT(10),
								DT_ACESSO		BIGINT(10)
							);

   CREATE INDEX idx_user ON tmp2 (USERID);			

	START TRANSACTION;

		INSERT tbl_alunos_acessos (USERID, TIMEZONE, UNIDADE, NOME_UNIDADE, NOME_ALU, RA, FL_ALUNO_BLOQUEADO)
			SELECT DISTINCT 
					 u.id AS USERID
					,u.timezone
					,i.cd_instituicao AS UNIDADE
					,i.nm_ies AS NOME_UNIDADE
					,CONCAT(u.firstname, ' ', u.lastname) AS NOME_ALU
					,p.cd_pessoa as RA
					,u.deleted AS FL_ALUNO_BLOQUEADO
			  FROM tbl_mdl_user u
			  JOIN kls_lms_pessoa p ON p.login = u.username
			  JOIN kls_lms_pessoa_curso pc ON p.id_pessoa = pc.id_pessoa 
			  JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel='ALUNO'
			  JOIN kls_lms_curso c ON c.id_curso = pc.id_curso
			  JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
			  GROUP BY u.id;

    COMMIT;
    

    
    
	 START TRANSACTION;

		INSERT INTO tmp1
	    	SELECT l.USERID, MIN(l.DT)
			  FROM tbl_login l
			 INNER JOIN tbl_alunos_acessos ac ON ac.USERID = l.USERID
			 GROUP BY l.USERID;

	 COMMIT;
	 
	 
	 START TRANSACTION;

		INSERT INTO tmp2
	    	SELECT l.USERID, MAX(l.DT)
			  FROM tbl_login l
			 INNER JOIN tbl_alunos_acessos ac ON ac.USERID = l.USERID
			 GROUP BY l.USERID;

	 COMMIT;
	 
	 
	 START TRANSACTION;
	 
	 	UPDATE tbl_alunos_acessos ac
	 	 INNER JOIN tmp1 t ON t.USERID = ac.USERID
	 	   SET ac.FIRSTACCESS = DATE_FORMAT(FROM_UNIXTIME(t.DT_ACESSO),'%Y-%m-%d %H:%i:%s')
	    WHERE ac.TIMEZONE = 99;
	 
	 COMMIT;
	 
	 START TRANSACTION;
	 
	 	UPDATE tbl_alunos_acessos ac
	 	 INNER JOIN tmp1 t ON t.USERID = ac.USERID
	 	   SET ac.FIRSTACCESS = DATE_FORMAT(FROM_UNIXTIME(t.DT_ACESSO + (ac.TIMEZONE * 3600)),'%Y-%m-%d %H:%i:%s')
	    WHERE ac.FIRSTACCESS = 0;
	 
	 COMMIT;
	 
	 
	 START TRANSACTION;
	 
	 	UPDATE tbl_alunos_acessos ac
	 	 INNER JOIN tmp2 t ON t.USERID = ac.USERID
	 	   SET ac.LASTACCESS = DATE_FORMAT(FROM_UNIXTIME(t.DT_ACESSO),'%Y-%m-%d %H:%i:%s')
	    WHERE ac.TIMEZONE = 99;
	 
	 COMMIT;
	 
	 START TRANSACTION;
	 
	 	UPDATE tbl_alunos_acessos ac
	 	 INNER JOIN tmp2 t ON t.USERID = ac.USERID
	 	   SET ac.LASTACCESS = DATE_FORMAT(FROM_UNIXTIME(t.DT_ACESSO + (ac.TIMEZONE * 3600)),'%Y-%m-%d %H:%i:%s')
	    WHERE ac.LASTACCESS = 0;
	 
	 COMMIT;


	DROP TABLE IF EXISTs tmp1;

	DROP TABLE IF EXISTs tmp2;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_alunos_acessos)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
