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

-- Copiando estrutura para procedure prod_kls.PRC_REL_QUEST
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_QUEST`()
BEGIN

	DROP TABLE IF EXISTS tbl_rel_quest;
	
	CREATE TABLE tbl_rel_quest (
						ID_QUESTAO			BIGINT(10),
						CATEGORIA			BIGINT(10),
						NOME_QUESTAO		VARCHAR(255),
						DATA_CRIACAO		VARCHAR(50),
						DATA_MODIFICADO	VARCHAR(50),
						CRIADOR				VARCHAR(200),
						MODIFICADOR			VARCHAR(200),
						PARENT				BIGINT(10),
						ID_cat				BIGINT(10),
						nome_sub_cat		VARCHAR(100),
						ID_cat1				BIGINT(10),
						nome_sub_cat1		VARCHAR(100),
						ID_cat2				BIGINT(10),
						nome_sub_cat2		VARCHAR(100),
						ID_cat3				BIGINT(10),
						nome_sub_cat3		VARCHAR(100),
						ID_cat4				BIGINT(10),
						nome_sub_cat4		VARCHAR(100),
						ID_cat5				BIGINT(10),
						nome_sub_cat5		VARCHAR(100)
					 );
	
	INSERT INTO tbl_rel_quest
		SELECT q.id AS ID_QUESTAO, 
				 q.category AS CATEGORIA, 
				 q.name AS NOME_QUESTAO, 
				 DATE_FORMAT(FROM_UNIXTIME(q.timecreated), '%d-%m-%Y %H:%i:%s') AS DATA_CRIACAO, 
				 DATE_FORMAT(FROM_UNIXTIME(q.timemodified), '%d-%m-%Y %H:%i:%s') AS DATA_MODIFICADO, 
				 (SELECT CONCAT(u.firstname, ' ', u.lastname) FROM tbl_mdl_user u WHERE u.id = q.createdby) AS CRIADOR, 
				 (SELECT CONCAT(u.firstname, ' ', u.lastname) FROM tbl_mdl_user u WHERE u.id = q.modifiedby) AS MODIFICADOR,
				 qc.parent,
				 qc.id AS ID_cat, 
				 qc.name AS nome_sub_cat,
				 qc1.id AS ID_cat1, 
				 qc1.name AS nome_sub_cat1,
				 qc2.id AS ID_cat2, 
				 qc2.name AS nome_sub_cat2,
				 qc3.id AS ID_cat3, 
				 qc3.name AS nome_sub_cat3,
				 qc4.id AS ID_cat4, 
				 qc4.name AS nome_sub_cat4,
				 qc5.id AS ID_cat5, 
				 qc5.name AS nome_sub_cat5
		  FROM mdl_question q
		 INNER JOIN mdl_question_categories qc ON qc.id=q.category
		  LEFT JOIN mdl_question_categories qc1 ON qc1.id=qc.parent
		  LEFT JOIN mdl_question_categories qc2 ON qc2.id=qc1.parent
		  LEFT JOIN mdl_question_categories qc3 ON qc3.id=qc2.parent
		  LEFT JOIN mdl_question_categories qc4 ON qc4.id=qc3.parent
		  LEFT JOIN mdl_question_categories qc5 ON qc5.id=qc4.parent;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
