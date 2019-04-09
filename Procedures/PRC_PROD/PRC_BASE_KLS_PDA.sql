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

-- Copiando estrutura para procedure prod_kls.PRC_BASE_KLS_PDA
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_BASE_KLS_PDA`()
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
		SELECT database(), 'PRC_BASE_KLS_PDA', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	set ID_LOG_=LAST_INSERT_ID();

	TRUNCATE TABLE tbl_base_pda;

	INSERT INTO tbl_base_pda
		SELECT DISTINCT 
					'KLS' AS Ambiente,
					c.cd_curso AS Codigo_curso, 
					c.nm_curso AS Nome_curso, 
					d.cd_disciplina AS Codigo_disciplina, 
					d.ds_disciplina AS Nome_disciplina, 
					SUBSTR(ies.cd_instituicao, INSTR(ies.cd_instituicao,'-')+1, LENGTH(ies.cd_instituicao)) AS Codigo_unidade,
					c.turno AS Turno,
					cd.cd_curriculo AS Curriculo,
					cd.shortname AS Shortname_moodle,
					ies.nm_ies AS Nome_unidade, 
					ies.cd_marca AS Marca,
					CASE 
						WHEN ies.cd_instituicao LIKE 'OLIM%' THEN 
							'OLIMPO'
		      		WHEN ies.cd_instituicao LIKE 'FAM%' THEN
							'FAMA'  
					 END AS Origem_ERP,
					'2018' AS ano_ofertado,
					'2' AS periodo_ofertado,
					d.fl_etl_atu AS STATUS,
					'https://avaeduc.com.br/auth/pda/login.php' AS URL
			FROM kls_lms_instituicao ies
			JOIN kls_lms_curso c ON c.id_ies = ies.id_ies
			JOIN kls_lms_curso_disciplina cd ON cd.id_curso = c.id_curso
			JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina AND d.id_ies = ies.id_ies
			JOIN mdl_course cu ON cu.shortname = cd.shortname
			JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina 
		  WHERE c.fl_etl_atu REGEXP '[NA]'
			 AND cd.fl_etl_atu REGEXP '[NA]'
			 AND cd.shortname NOT IN ('A DEFINIR','')
			 AND d.fl_etl_atu REGEXP '[NA]'
			 AND t.fl_etl_atu REGEXP '[NA]';


	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_base_pda)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
