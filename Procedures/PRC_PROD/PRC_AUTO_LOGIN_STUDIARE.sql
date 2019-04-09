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

-- Copiando estrutura para procedure prod_kls.PRC_AUTO_LOGIN_STUDIARE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AUTO_LOGIN_STUDIARE`()
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
		SELECT database(), 'PRC_AUTO_LOGIN_STUDIARE', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

TRUNCATE TABLE mdl_format_autologin_studiare;


INSERT INTO mdl_format_autologin_studiare (courseid,userid,cpf,cod_unidade,cod_turma,cod_disciplina,cod_curso,periodo,nome_unidade,nome_curso,cod_aluno,nome_aluno,email,nome_disciplina,ra_aluno,situacao_aluno,senha)
SELECT    id AS courseid,
          userid AS userid,
          cpf,
          UNIDADE AS cod_unidade,
          turma AS 'cod_turma',
          cd_disciplina AS cod_disciplina,
          cd_curso AS cod_curso,
          '2017.1' AS 'periodo',
          nm_ies AS nome_unidade,     
          nm_curso AS nome_curso,
          RA AS cod_aluno,
          nm_pessoa AS nome_aluno,
          email,
          shortname AS nome_disciplina,
          login AS ra_aluno,
          'ATIVO' AS 'situacao_aluno',
          senha AS senha
FROM vw_studiare v;


SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM mdl_format_autologin_studiare)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
