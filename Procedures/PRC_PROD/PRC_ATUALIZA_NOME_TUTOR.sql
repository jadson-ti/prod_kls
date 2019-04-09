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

-- Copiando estrutura para procedure prod_kls.PRC_ATUALIZA_NOME_TUTOR
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ATUALIZA_NOME_TUTOR`()
BEGIN

UPDATE mdl_user u 
JOIN mdl_sgt_usuario_moodle um on um.mdl_user_id=u.id
JOIN mdl_sgt_usuario sgtu on sgtu.id=um.id_usuario_id
SET 
	u.firstname=SUBSTR(trim(sgtu.nome),1,LOCATE(' ',trim(sgtu.nome))-1),
	u.lastname=SUBSTRING_INDEX(trim(sgtu.nome),' ',-1)
WHERE 
	(
	u.firstname<>SUBSTR(trim(sgtu.nome),1,LOCATE(' ',trim(sgtu.nome))-1)
	OR
	u.lastname<>SUBSTRING_INDEX(trim(sgtu.nome),' ',-1)
	) AND sgtu.id_perfil=1;
	

insert into mdl_user_preferences (userid, name, value) 
select u.id, 'auth_forcepasswordchange', 1
from mdl_user u 
join mdl_sgt_usuario_moodle um on um.mdl_user_id=u.id
join mdl_sgt_usuario su on su.id=um.id_usuario_id and su.id_perfil=1
LEFT JOIN tbl_login tl ON tl.USERID = u.id
left join mdl_user_preferences up on up.userid=u.id and up.name='auth_forcepasswordchange'
WHERE tl.ID IS NULL 
AND up.id is null;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
