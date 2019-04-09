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

-- Copiando estrutura para procedure prod_kls.PRC_REL_ED_5_10
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_ED_5_10`()
BEGIN
 
	DECLARE ID_LOG_		 	INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_	 	BIGINT DEFAULT NULL;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
	   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT database(), 'PRC_REL_ED_5_10', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
	
    DROP TABLE IF EXISTS tbl_rel_ed_5_10;
 
    CREATE TABLE tbl_rel_ed_5_10
	 select distinct  co.shortname, co.fullname, 
	 case
		when m.name = 'assign' then a.name
		when m.name = 'quiz' then q.name
	 end recurso
	 from mdl_course co
	 join mdl_course_modules cm on co.id = cm.course
	 join mdl_modules m on m.id = cm.module
	 left join mdl_assign a on a.course = co.id and a.id = cm.instance
	 left join mdl_quiz q on q.course = co.id and q.id = cm.instance
	 where co.summary in ('ED5', 'ED6', 'ED7', 'ED8', 'ED9', 'ED10')
	 and m.name in ('assign', 'quiz')
	 order by 2, 3;
			
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_rel_ed_5_10)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
