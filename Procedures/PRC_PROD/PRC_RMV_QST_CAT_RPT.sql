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

-- Copiando estrutura para procedure prod_kls.PRC_RMV_QST_CAT_RPT
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RMV_QST_CAT_RPT`()
BEGIN


	DECLARE IDS_ LONGTEXT;
	
	DECLARE v_finished 	TINYINT DEFAULT 0;


	DECLARE c_quest CURSOR FOR
       SELECT qd.IDS
		   FROM tbl_question_cat_dpl qd;
				  
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;
		

	DROP TABLE IF EXISTS tbl_question_cat_dpl;

	CREATE TABLE tbl_question_cat_dpl AS (SELECT GROUP_CONCAT(qc.id SEPARATOR ',') AS IDS
													FROM mdl_question_categories qc
												  GROUP BY qc.name, qc.parent
												 HAVING COUNT(qc.id) > 1);

	
	DROP TABLE IF EXISTS tbl_quest_cat_usg;
	
	CREATE TABLE tbl_quest_cat_usg (
											CATEGORY		BIGINT(10),
											QUESTION		BIGINT(10)
										);
										
										
	DROP TABLE IF EXISTS tbl_quest_cat_dp;
	
	CREATE TABLE tbl_quest_cat_dp (
											ID		BIGINT(10)
									  );										
										

	OPEN c_quest;

		get_QUEST: LOOP

			FETCH c_quest INTO IDS_;

		   IF v_finished = 1 THEN
		  		LEAVE get_QUEST;
		   END IF;
	  			
	  			START TRANSACTION;
	  			
	  				SET @query = CONCAT('INSERT INTO tbl_quest_cat_usg 
				  									SELECT DISTINCT 
													  		  q.category AS CATEGORY, q.id AS QUESTION
				  								  	  FROM mdl_question q
											 	 	 WHERE q.category IN (',IDS_,')');
				
				PREPARE stmt FROM @query;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;
				
				COMMIT;
				
				START TRANSACTION;
	  			
	  				SET @query = CONCAT('INSERT INTO tbl_quest_cat_dp 
				  									SELECT DISTINCT 
													  		  qc.id
				  								  	  FROM mdl_question_categories qc
											 	 	 WHERE qc.id IN (',IDS_,')');
				
				PREPARE stmt FROM @query;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;
				
				COMMIT;
				
		END LOOP get_QUEST;

 	CLOSE c_quest;
 	
 	
 	DROP TABLE IF EXISTS tbl_question_cat_dpl;
 	
 	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
