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

-- Copiando estrutura para procedure prod_kls.PRC_ANH_SITU_I
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ANH_SITU_I`()
BEGIN

	DECLARE nowid_ INT(15);
	DECLARE maxid_ INT(15);
	
	TRUNCATE TABLE tbl_anh_situ_i;
	
	SET nowid_ := 0;
	
	SELECT MAX(t.id) INTO maxid_ FROM anh_import_aluno_curso t;
	
	WHILE nowid_ <  maxid_ DO
		
	
		START TRANSACTION;
		
			INSERT INTO tbl_anh_situ_i
				SELECT t.USERNAME, t.SHORTNAME, t.CODIGO_CURSO, t.CODIGO_DISCIPLINA
				  FROM anh_import_aluno_curso t
				 WHERE t.id > nowid_
				 ORDER BY t.id
				 LIMIT 0, 100000;
		
		COMMIT;
	
	
		SELECT MAX(t.id) INTO nowid_ FROM tbl_anh_situ_i t;
		
	
	END WHILE;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
