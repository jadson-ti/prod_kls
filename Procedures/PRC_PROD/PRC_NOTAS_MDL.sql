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

-- Copiando estrutura para procedure prod_kls.PRC_NOTAS_MDL
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_NOTAS_MDL`()
MAIN: BEGIN

	DECLARE nowid_  INT(15);
	DECLARE limitid_ INT(15);
	DECLARE maxid_	INT(15);

   TRUNCATE TABLE tbl_notas;

	SET nowid_ := 1;
	SET limitid_ := 0;
	
   SELECT MAX(t.id) INTO maxid_ FROM mdl_grade_grades t WHERE t.finalgrade IS NOT NULL;
	
	NOTAS: LOOP
			
			SET limitid_:=limitid_+50000;
	
			INSERT INTO tbl_notas
				SELECT t.id,
					   t.itemid,
					   t.userid,
					   t.finalgrade,
					   t.timemodified
				  FROM mdl_grade_grades t
				 WHERE t.finalgrade IS NOT NULL
				   AND t.id>nowid_ and t.id<=limitid_;

			SET nowid_:=nowid_+50000;
	
	
		IF nowid_>=maxid_ THEN
			LEAVE MAIN;
		END IF;
		

	END LOOP NOTAS;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
