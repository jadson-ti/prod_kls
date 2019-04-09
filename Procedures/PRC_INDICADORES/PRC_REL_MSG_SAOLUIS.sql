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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG_SAOLUIS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG_SAOLUIS`()
BEGIN

DECLARE V_LOG INT;

INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
SELECT database(), 'PRC_REL_MSG_SAOLUIS', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

SET V_LOG=LAST_INSERT_ID();

DROP TABLE IF EXISTS tbl_rel_msg_saoluis;

CREATE TABLE tbl_rel_msg_saoluis (
	ID_MSG INT,
	CODIGO_CURSO VARCHAR(20),
	CURSO VARCHAR(255),
	ASSUNTO VARCHAR(255),
	DATAENVIO DATETIME,
	PAPEL VARCHAR(20),
	ID_REMETENTE INT,
	LOGIN_REMETENTE VARCHAR(50),
	NOME_REMETENTE VARCHAR(255),
	ID_DESTINATARIO INT,
	LOGIN_DESTINATARIO VARCHAR(50),
	NOME_DESTINATARIO VARCHAR(255),
	LIDA VARCHAR(3),
	DATA_RESPOSTA DATETIME,
	PRIMARY KEY (ID_MSG)
);

INSERT INTO tbl_rel_msg_saoluis 
	SELECT 
		 m.id AS ID_MSG,
		 kc.cd_curso AS CODIGO_CURSO,
		 kc.nm_curso AS CURSO,
		 m.subject AS ASSUNTO,
		 CASE 
			WHEN SUMMER_TIME(m.time) = 0 THEN 
  				FROM_UNIXTIME((m.time - 7200))
			ELSE  
  				FROM_UNIXTIME((m.time - 10800))
   	 END AS DATA_ENVIO,
	    'ALUNO' AS PAPEL,
		 us.id AS ID_REMETENTE,
		us.username AS LOGIN_REMETENTE,
		CONCAT(us.firstname, ' ', us.lastname) AS NOME_REMETENTE,
		ud.id as ID_DESTINATARIO,
		ud.username AS LOGIN_DESTINATARIO,
		CONCAT(ud.firstname, ' ', ud.lastname) AS NOME_DESTINATARIO,
		CASE WHEN unread=1 THEN 'NAO' ELSE 'SIM' END AS LIDA,
		NULL AS DATA_RESPOSTA						 
		FROM mdl_local_mail_messages m
		JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
		INNER JOIN tbl_mdl_course co ON co.id = m.courseid
		INNER JOIN mdl_context c ON c.instanceid = co.id
		INNER JOIN mdl_role_assignments ra ON c.id = ra.contextid AND ra.userid = ur.id_from
		INNER JOIN tbl_mdl_user us ON us.id = ur.id_from
		INNER JOIN kls_lms_pessoa p on p.login=us.username  and p.fl_etl_atu<>'E'
		INNER JOIN kls_lms_pessoa_curso pc on pc.id_pessoa=p.id_pessoa and pc.fl_etl_atu<>'E' and pc.id_papel=1
		INNER JOIN kls_lms_curso kc on kc.id_curso=pc.id_curso 
		INNER JOIN kls_lms_instituicao i on i.id_ies=kc.id_ies
		INNER JOIN tbl_mdl_user ud ON ud.id=ur.userid
		WHERE m.draft = 0
			AND m.type<>'massive' 
		   AND ur.role = 'to'
			AND ur.id_from IS NOT NULL
			AND c.contextlevel = 50
			AND ra.roleid = 5
			AND us.deleted = 0
			AND (us.institution IN ('OLIM-535','OLIM-519'))
		GROUP BY m.id;

RESPOSTAS: BEGIN

	DECLARE NODATA INT DEFAULT FALSE;
	DECLARE V_ID_MSG INT;
	DECLARE V_ID_DESTINATARIO INT;
	DECLARE V_RESPOSTA DATETIME;
	DECLARE MENSAGENS CURSOR FOR SELECT ID_MSG, ID_DESTINATARIO FROM tbl_rel_msg_saoluis;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;
	
	OPEN MENSAGENS;
	SET V_RESPOSTA=NULL;
	
	MENSAGEM: LOOP
	
		SET NODATA=FALSE;
		
		FETCH MENSAGENS INTO V_ID_MSG, V_ID_DESTINATARIO;
		
		IF NODATA THEN LEAVE MENSAGEM; END IF;

		SET V_RESPOSTA=NULL;

		SELECT 
		 CASE 
			WHEN SUMMER_TIME(m.time) = 0 THEN 
  				FROM_UNIXTIME((m.time - 7200))
			ELSE  
  				FROM_UNIXTIME((m.time - 10800))
   	 END
		INTO V_RESPOSTA
		FROM mdl_local_mail_message_refs rf 
		JOIN mdl_local_mail_messages m on m.id=rf.messageid
		JOIN mdl_local_mail_message_users mu on mu.id_from=V_ID_DESTINATARIO and mu.messageid=m.id
		WHERE reference=V_ID_MSG and m.id>reference
		ORDER BY rf.messageid
		LIMIT 1;
		
		IF V_RESPOSTA IS NOT NULL THEN 
			UPDATE tbl_rel_msg_saoluis SET DATA_RESPOSTA=V_RESPOSTA WHERE ID_MSG=V_ID_MSG;
		END IF;
	
	END LOOP MENSAGEM;

END RESPOSTAS;		 				 

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = 'PRONTO', 
	 		 pl.REGISTROS = (SELECT COUNT(1) FROM tbl_rel_msg_saoluis),
	 		 pl.INFO = NULL
	 WHERE pl.ID = V_LOG;	

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
