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

-- Copiando estrutura para procedure prod_kls.PRC_MATRICULA_TUTOR
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_MATRICULA_TUTOR`()
    COMMENT '** Procedure utilizada para alocar tutores que imprevisivelmente não estavam presentes em uma das tabelas: mdl_role_assignments | mdl_user_enrolments | mdl_groups_members'
BEGIN



DROP TABLE IF EXISTS tmp_grupos_tutores;

CREATE TABLE tmp_grupos_tutores AS
SELECT DISTINCT 
	anh.SHORTNAME,
	anh.GRUPO,
	anh.TUTOR
FROM anh_aluno_matricula anh
WHERE GRUPO LIKE '%TUTOR%';

ALTER TABLE tmp_grupos_tutores ADD PRIMARY KEY (SHORTNAME,GRUPO);	

INSERT INTO mdl_role_assignments (roleid, contextid, userid, timemodified, modifierid) 
SELECT 
	
	r.id,
	co.id,
	u.id,
	unix_timestamp(), 2
FROM tmp_grupos_tutores anh
JOIN tbl_mdl_user u on u.username=anh.TUTOR
JOIN mdl_role r on r.shortname='tutor' 
JOIN mdl_course c on c.shortname=anh.shortname
JOIN mdl_enrol e on e.courseid=c.id and e.enrol='manual' and e.roleid=r.id
JOIN mdl_context co on co.contextlevel=50 and co.instanceid=c.id
LEFT JOIN mdl_role_assignments ra on ra.userid=u.id and ra.contextid=co.id and ra.roleid=r.id
WHERE GRUPO LIKE '%TUTOR%' AND ra.id IS NULL;


INSERT INTO mdl_user_enrolments(status, enrolid, userid, timestart, timecreated, timemodified, timeend, modifierid) 
SELECT 
	'0',
	e.id,
	u.id,
	UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 2
FROM tmp_grupos_tutores anh
JOIN tbl_mdl_user u on u.username=anh.TUTOR
JOIN mdl_role r on r.shortname='tutor' 
JOIN mdl_course c on c.shortname=anh.shortname
JOIN mdl_enrol e on e.courseid=c.id and e.enrol='manual'  and e.roleid=r.id
JOIN mdl_context co on co.contextlevel=50 and co.instanceid=c.id
LEFT JOIN mdl_user_enrolments ue on ue.userid=u.id and ue.enrolid=e.id
WHERE GRUPO LIKE '%TUTOR%' AND ue.id IS NULL;

INSERT INTO mdl_groups_members (groupid, userid, timeadded) 
SELECT 
	g.id,
	u.id,
	UNIX_TIMESTAMP()
FROM tmp_grupos_tutores anh
JOIN tbl_mdl_user u on u.username=anh.TUTOR
JOIN mdl_role r on r.shortname='tutor' 
JOIN mdl_course c on c.shortname=anh.shortname
JOIN mdl_enrol e on e.courseid=c.id and e.enrol='manual' and e.roleid=r.id
JOIN mdl_context co on co.contextlevel=50 and co.instanceid=c.id
JOIN mdl_groups g on g.courseid=c.id and g.description=anh.grupo
LEFT JOIN mdl_groups_members gm on gm.userid=u.id and g.id=gm.groupid
WHERE GRUPO LIKE '%TUTOR%' AND gm.id IS NULL;

DROP TABLE IF EXISTS tmp_grupos_tutores;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
