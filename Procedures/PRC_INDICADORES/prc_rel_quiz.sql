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

-- Copiando estrutura para procedure prod_kls.prc_rel_quiz
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `prc_rel_quiz`()
BEGIN
	
    DECLARE VCOURSE		bigint;
    DECLARE Vexit_loop	INT DEFAULT 0;
    
    DECLARE CCUR CURSOR FOR
    SELECT DISTINCT c.id
      FROM mdl_course_categories cc
			JOIN mdl_course c on cc.id=c.category
      WHERE cc.id in (2, 4, 6, 55, 56 );
      
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET Vexit_loop = TRUE;
    
    
    truncate TABLE tbl_rel_quiz;
    
    
    OPEN CCUR;
    
	cur_loop: LOOP
		
        FETCH CCUR INTO VCOURSE;
        
        
        IF Vexit_loop THEN
			CLOSE CCUR;
            LEAVE cur_loop;
        END IF;
        
        
        START TRANSACTION;
        
        
        INSERT INTO tbl_rel_quiz(	nome_categoria, 
									id_categoria, 
                                    id_curso, 
                                    shortname, 
                                    curso, 
                                    quiz_id, 
                                    quiz, 
                                    category_id, 
                                    category, 
                                    questao, 
                                    texto_questao)
        
		select distinct 
				cc.name as nome_categoria, 
				c.category as id_categoria, 
				c.id as id_curso, 
				c.shortname, 
				c.fullname as curso, 
				q.id as quiz_id, 
				q.name as quiz , 
				qc.id as category_id, 
				qc.name as category, 
				quf.name as questao, 
				quf.questiontext as texto_questao 
			from mdl_course_categories cc
				join mdl_course c on cc.id=c.category
				join mdl_quiz q on q.course=c.id 
				join mdl_question qu on find_in_set(qu.id,q.questions) 
				join mdl_question quf on quf.category=qu.category and quf.qtype<>'random' 
				join mdl_question_categories qc on qc.id=quf.category 
		WHERE c.id = VCOURSE
		
        UNION
        
		select distinct 
				cc.name as nome_categoria, 
				c.category as id_categoria, 
				c.id as id_curso, 
				c.shortname, 
				c.fullname as curso, 
				q.id as quiz_id, 
				q.name as quiz , 
				qc.id as category_id, 
				qc.name as category, 
				qu.name as questao, 
				qu.questiontext as texto_questao 
			from mdl_course_categories cc
				join mdl_course c on cc.id=c.category
				join mdl_quiz q on q.course=c.id 
				join mdl_question qu on find_in_set(qu.id,q.questions) and qu.qtype<>'random' 
				join mdl_question_categories qc on qc.id=qu.category 
		WHERE c.id = VCOURSE;
        
        
        COMMIT;
        
	
	END LOOP cur_loop;
    
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
