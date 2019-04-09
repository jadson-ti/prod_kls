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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG_ROLE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG_ROLE`()
BEGIN

DECLARE V_ROLEID_FROM INT;
DECLARE V_ROLEID_TO INT;
DECLARE V_ROLENAME_FROM VARCHAR(20);
DECLARE V_ROLENAME_TO VARCHAR(20);
DECLARE FIM1 INT DEFAULT FALSE;
DECLARE LISTA_FROM CURSOR FOR
	select 3 as roleid union 
	select 5 union 
	select 11 union 
	select 14 union 
	select 18 union 
	select 21 union
	select 28;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET FIM1=TRUE;




DROP TABLE IF EXISTS tmp_user_role;

CREATE TABLE tmp_user_role (userid bigint(10), roleid int);
INSERT INTO tmp_user_role  
SELECT userid, p2.id_role as roleid FROM (
SELECT userid, MIN(relevancia) as relevancia FROM (
SELECT
	userid,	
	roleid, 
	relevancia
FROM mdl_role_assignments r
JOIN kls_lms_papel p on r.roleid=p.id_role
GROUP BY userid, roleid
ORDER BY userid,relevancia
) a
GROUP BY  userid
) b 
JOIN kls_lms_papel p2 on p2.relevancia=b.relevancia;
ALTER TABLE tmp_user_role ADD PRIMARY KEY (userid,roleid);
ALTER TABLE tmp_user_role ADD INDEX IDX_ROLE (roleid);

INSERT INTO tmp_local_mail_mu
SELECT 
	messageid,
	ur1.roleid as 'from',
	ur2.roleid as 'to',
	count(1)
FROM mdl_local_mail_message_users base 
JOIN tmp_user_role ur1 on base.userid=ur1.userid
JOIN tmp_user_role ur2 on base.id_from=ur2.userid
WHERE base.ROLE=CONVERT('to' USING latin1) AND base.messageid>(SELECT CAST(MAX(messageid) AS UNSIGNED) FROM tmp_local_mail_mu)
GROUP BY messageid;

















DROP TABLE IF EXISTS tbl_rel_msg_role;

CREATE TABLE tbl_rel_msg_role (
	role_from VARCHAR(30),
	role_to VARCHAR(30),
	qtd INT DEFAULT 0
);	


OPEN LISTA_FROM;

ORIGEM: LOOP

	FETCH LISTA_FROM INTO V_ROLEID_FROM;
	
	IF FIM1 THEN LEAVE ORIGEM; END IF;
	
	INTERNO: BEGIN
	
		DECLARE FIM2 INT DEFAULT FALSE;
		DECLARE LISTA_TO CURSOR FOR
			select 3 as roleid union 
			select 5 union 
			select 11 union 
			select 14 union 
			select 18 union 
			select 21 union
			select 28;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET FIM2=TRUE;
	
		OPEN LISTA_TO;
		
		DESTINO: LOOP
			
			FETCH LISTA_TO INTO V_ROLEID_TO;
			SET FIM1=FALSE;
			IF FIM2 THEN LEAVE DESTINO; END IF;
			
			SELECT shortname INTO V_ROLENAME_FROM FROM mdl_role WHERE id=V_ROLEID_FROM;
			SELECT shortname INTO V_ROLENAME_TO FROM mdl_role WHERE id=V_ROLEID_TO;
			
			INSERT INTO tbl_rel_msg_role 
				select 
					V_ROLENAME_FROM,
					V_ROLENAME_TO,
					SUM(qtd)
				from tmp_local_mail_mu 
				where 
					roleto=V_ROLEID_FROM and 
					rolefrom=V_ROLEID_TO
				group by V_ROLENAME_FROM,V_ROLENAME_TO;
					
		END LOOP DESTINO;

		CLOSE LISTA_TO;
	
	END INTERNO;
	
END LOOP ORIGEM;

CLOSE LISTA_FROM;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
