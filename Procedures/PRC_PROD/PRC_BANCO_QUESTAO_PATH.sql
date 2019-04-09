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

-- Copiando estrutura para procedure prod_kls.PRC_BANCO_QUESTAO_PATH
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_BANCO_QUESTAO_PATH`()
BEGIN

DROP TABLE IF EXISTS tbl_banco_questao_path;

CREATE TABLE tbl_banco_questao_path AS (
SELECT DISTINCT 
d.cd_disciplina AS COD_DISCIPLINA,
TRIM(SUBSTRING_INDEX(CAMINHO, '>', -1)) AS TIPO_ATIVIDADE,
sqa.*
FROM sgt_questionario_associado sqa 
JOIN kls_lms_curso_disciplina cd ON cd.shortname = sqa.SHORTNAME
JOIN kls_lms_disciplina d ON d.id_disciplina = cd.id_disciplina
WHERE cd.fl_etl_atu <> 'E'
AND d.fl_etl_atu <> 'E');

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
