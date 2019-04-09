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

-- Copiando estrutura para procedure prod_kls.PRC_REL_MSG
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_MSG`()
BEGIN

DECLARE ID_LOG_              INT(10);
DECLARE CODE_                      VARCHAR(50) DEFAULT 'SUCESSO';
DECLARE MSG_                       VARCHAR(200);
DECLARE REGISTROS_           BIGINT DEFAULT NULL;
DECLARE v_finished      TINYINT(1) DEFAULT 0;
DECLARE CURSOS_         BIGINT(10);
DECLARE FUSOHORARIO INT(11);
DECLARE c_cursos CURSOR FOR
SELECT DISTINCT m.courseid
FROM mdl_local_mail_messages m
ORDER BY m.courseid DESC;


DECLARE CONTINUE HANDLER FOR NOT FOUND
SET v_finished = 1;


DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN

GET DIAGNOSTICS CONDITION 1
CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;

SET CODE_ = CONCAT('ERRO - ', CODE_);

ROLLBACK;

END;


SELECT IF(EXECUT=0,10800, 7200) INTO FUSOHORARIO FROM tbl_event_set WHERE NAME='summertime';

INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
SELECT database(), 'PRC_REL_MSG', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

SET ID_LOG_=LAST_INSERT_ID();

DROP TABLE IF EXISTS tbl_rel_msg;

CREATE TABLE tbl_rel_msg (
AREA_CONHECIMENTO VARCHAR(200),
CATEGORIA               VARCHAR(100) DEFAULT 'HOME',
CODIGO_CURSO            BIGINT(10),
CURSO                        VARCHAR(200) DEFAULT 'HOME',
DATA_ENVIO              DATETIME,
QUEM_MANDOU             BIGINT(10),
PAPEL                        VARCHAR(50),
LOGIN_ALUNO             VARCHAR(200),
ALUNO                        VARCHAR(200),
QUEM_RECEBEU            BIGINT(10),
LOGIN_TUTOR             VARCHAR(200),
TUTOR                        VARCHAR(200),
QTD_MSG                      INT
);

CREATE INDEX idx_CODIGO_CURSO ON tbl_rel_msg (CODIGO_CURSO);


OPEN c_cursos;

get_CURSOS: LOOP

FETCH c_cursos INTO CURSOS_;

IF v_finished = 1 THEN
LEAVE get_CURSOS;
END IF;

INSERT INTO tbl_rel_msg
SELECT 
	AREA_CONHECIMENTO,
	CATEGORIA,
	CODIGO_CURSO,
	CURSO,
	DATA_ENVIO,
	QUEM_MANDOU,
	PAPEL,
	LOGIN_ALUNO,
	ALUNO,
	QUEM_RECEBEU,
	LOGIN_TUTOR,
	TUTOR,
	QTD_MSG
FROM (
	SELECT '' AS AREA_CONHECIMENTO,
	IFNULL((SELECT cc.name FROM mdl_course_categories cc WHERE cc.id = co.category), 'HOME') AS CATEGORIA,
	co.id AS CODIGO_CURSO,
	co.fullname AS CURSO,
	FROM_UNIXTIME((m.time - 10800)) AS DATA_ENVIO,
	ur.id_from AS QUEM_MANDOU,
	r.name AS PAPEL,
	us.username AS LOGIN_ALUNO,
	CONCAT(us.firstname, ' ', us.lastname) AS ALUNO,
	ur.userid AS QUEM_RECEBEU,
	um.mdl_username AS LOGIN_TUTOR,
	u.nome AS TUTOR,
	COUNT(ur.id) AS QTD_MSG,
	(
		SELECT COUNT(1) FROM mdl_local_mail_index WHERE messageid=m.id and type='drafts'
	) 	draftscount
	FROM mdl_local_mail_messages m
	JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
	JOIN mdl_sgt_usuario_moodle um ON um.mdl_user_id = ur.userid
	JOIN mdl_sgt_usuario u ON u.id = um.id_usuario_id
	JOIN mdl_groups_members gm_destino ON gm_destino.userid = ur.userid
	JOIN mdl_groups_members gm_origem ON gm_origem.userid = ur.id_from AND gm_origem.groupid = gm_destino.groupid
	JOIN mdl_groups g ON g.id = gm_destino.groupid AND g.courseid = m.courseid
	JOIN mdl_course co ON co.id = g.courseid
	JOIN mdl_context c ON c.instanceid = co.id
	JOIN mdl_role_assignments ra ON c.id = ra.contextid AND ra.userid = ur.id_from
	JOIN mdl_role r ON r.id = ra.roleid
	JOIN mdl_user us ON us.id = ur.id_from
	JOIN mdl_enrol e ON e.courseid = co.id
	JOIN mdl_user_enrolments ue ON ue.userid = ur.id_from AND ue.enrolid = e.id
	left join mdl_local_mail_index mi on mi.messageid=m.id and mi.`type`='trash' and mi.userid=ur.id_from
	WHERE m.draft = 0
		AND mi.id IS NULL
		AND ur.role = 'to'
		AND ur.id_from IS NOT NULL
		AND u.id_perfil = 1
	AND u.`status` = 'A'
	AND c.contextlevel = 50
	AND ra.roleid = 5
	AND us.deleted = 0
	AND ue.`status` = 0
	AND m.status is not null 
	AND NOT EXISTS (SELECT DISTINCT ref.id
							FROM mdl_local_mail_message_refs ref
							WHERE ref.reference = m.id)
	GROUP BY co.fullname , m.time, ur.id_from ,  ur.userid
) A
WHERE draftscount=0;


INSERT INTO tbl_rel_msg
SELECT 
	AREA_CONHECIMENTO,
	CATEGORIA,
	CODIGO_CURSO,
	CURSO,
	DATA_ENVIO,
	QUEM_MANDOU,
	PAPEL,
	LOGIN_ALUNO,
	ALUNO,
	QUEM_RECEBEU,
	LOGIN_TUTOR,
	TUTOR,
	QTD_MSG
FROM (
SELECT '' AS AREA_CONHECIMENTO,
IFNULL((SELECT cc.name FROM mdl_course_categories cc WHERE cc.id = co.category), 'HOME') AS CATEGORIA,
co.id AS CODIGO_CURSO,
co.fullname AS CURSO,
FROM_UNIXTIME((m.time - FUSOHORARIO)) AS DATA_ENVIO,
ur.id_from AS QUEM_MANDOU,
r.name AS PAPEL,
us.username AS LOGIN_ALUNO,
CONCAT(us.firstname, ' ', us.lastname) AS ALUNO,
ur.userid AS QUEM_RECEBEU,
um.mdl_username AS LOGIN_TUTOR,
u.nome AS TUTOR,
COUNT(ur.id) AS QTD_MSG,
	(
		SELECT COUNT(1) FROM mdl_local_mail_index WHERE messageid=m.id and type='drafts'
	) 	draftscount
FROM mdl_local_mail_messages m
INNER JOIN mdl_local_mail_message_users ur ON ur.messageid = m.id
INNER JOIN mdl_sgt_usuario_moodle um ON um.mdl_user_id = ur.userid
INNER JOIN mdl_sgt_usuario u ON u.id = um.id_usuario_id
INNER JOIN mdl_role_assignments ra ON  ra.userid = ur.id_from
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_context c ON c.id = ra.contextid
INNER JOIN mdl_course co ON co.id = m.courseid AND co.id = c.instanceid
INNER JOIN mdl_user us ON us.id = ur.id_from
left join mdl_local_mail_index mi on mi.messageid=m.id and mi.`type`='trash' and mi.userid=ur.id_from
WHERE m.`type` = 'mail'
AND m.draft = 0 
and mi.id is null
AND m.courseid = CURSOS_
AND ur.role = 'to'
AND ur.id_from IS NOT NULL
AND u.id_perfil = 1
AND u.`status` = 'A'
AND r.shortname IN ('editingteacher','regional','coordarea','coordteacher','diretor','c_academico')
AND c.contextlevel = 50
AND us.deleted = 0
AND NOT EXISTS (SELECT DISTINCT ref.id
FROM mdl_local_mail_message_refs ref
WHERE ref.reference = m.id)
GROUP BY co.fullname , ur.id_from ,  ur.userid
) A
WHERE draftscount=0;

UPDATE tbl_rel_msg t
SET t.AREA_CONHECIMENTO = (SELECT DISTINCT ac.dsc_area_conhecimento
FROM mdl_sgt_formacao_disciplina fd
JOIN mdl_sgt_af_conhecimento afc ON fd.id_area_formacao = afc.id_area_formacao
JOIN mdl_sgt_area_conhecimento ac ON ac.id = afc.id_area_conhecimento
JOIN tbl_mdl_course tc ON tc.shortname = fd.shortname
WHERE tc.id = t.CODIGO_CURSO
LIMIT 1)
WHERE t.CODIGO_CURSO = CURSOS_;


END LOOP get_CURSOS;

CLOSE c_cursos;


UPDATE tbl_prc_log pl
SET pl.FIM = sysdate(),
pl.`STATUS` = CODE_,
pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_rel_msg)),
pl.INFO = MSG_
WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
