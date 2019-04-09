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

-- Copiando estrutura para procedure prod_kls.PRC_TOPICOS_LABELS_CURSO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_TOPICOS_LABELS_CURSO`()
BEGIN
 
	DECLARE ID_LOG_		 	INT(10);
	DECLARE CODE_ 			VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			VARCHAR(200);
	DECLARE REGISTROS_	 	BIGINT DEFAULT NULL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
	   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT database(), 'PRC_TOPICOS_LABELS_CURSO', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	
    DROP TABLE IF EXISTS tbl_labels_curso;
 
    CREATE TABLE tbl_labels_curso
	select
		 mcc.name 		as nome_categoria,
		 cou.shortname	as shortname,
		 cou.id 		as id_course,
		 cou.fullname 	as sala_ava,
		 mcs.name		as topicos,
		 ml.name		as labels
	from mdl_course cou
	join mdl_course_categories mcc on mcc.id = cou.category
	join mdl_course_sections mcs on mcs.course = cou.id
	join mdl_course_modules mcd on find_in_set(mcd.id, mcs.sequence)
		and mcd.course = mcs.course
	join mdl_modules mm on mm.id = mcd.module and mm.name = 'label'
	join mdl_label ml on ml.id = mcd.instance;
			
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_labels_curso)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
