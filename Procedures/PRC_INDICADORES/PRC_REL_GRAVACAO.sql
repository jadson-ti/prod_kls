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

-- Copiando estrutura para procedure prod_kls.PRC_REL_GRAVACAO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_GRAVACAO`()
BEGIN

DECLARE v_COURSEID BIGINT(10);
DECLARE v_CONTEXTINSTANCEID BIGINT(10);
DECLARE v_finished        INT DEFAULT 0;

DECLARE c_activityvideo CURSOR FOR
select courseid, contextinstanceid
from tmp_activityvideo 
;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION



DROP TABLE IF EXISTS tmp_activityvideo;
create table tmp_activityvideo
as
select co.shortname, co.fullname sala_ava, a.name recurso,
       co.id as courseid, cm.id as contextinstanceid

from mdl_course co
join mdl_activityvideo a on a.course = co.id
join mdl_course_modules cm on cm.course = co.id and cm.instance = a.id
join mdl_modules m on m.id = cm.module
where  co.shortname in ('AMI_LEG_ACA_SOC', 'AMI_ENG_PRO', 'AMI_CEI_MOL_CEL', 'AMI_GES_AMB','AMI_GEOME_ANALI', 'AMI_ADM_ECO_ENG')
and a.name like '%revis%'
;

CREATE INDEX idx_tmp_video ON tmp_activityvideo (courseid,contextinstanceid);

DROP TABLE IF EXISTS tb_activityvideo;
CREATE TABLE tb_activityvideo (
shortname   VARCHAR(255) ,
sala_ava    VARCHAR(254),
recurso     VARCHAR(255) ,
login       VARCHAR(100),
nome        VARCHAR(255) ,
data_acesso DATETIME 
);


OPEN c_activityvideo;
     get_video: LOOP

     FETCH c_activityvideo INTO v_COURSEID, v_CONTEXTINSTANCEID;
     
     IF v_finished = 1 THEN LEAVE get_video; END IF;
     
   INSERT INTO tb_activityvideo
   select tmp.shortname, 
		    tmp.sala_ava, 
			 tmp.recurso,
		    u1.username Login,
		    concat(u1.firstname, ' ', u1.lastname) Nome,  
		    from_unixtime(l.timecreated) Data_Acesso

   from tmp_activityvideo tmp
   join mdl_logstore_standard_log l on (l.courseid = tmp.courseid and l.contextinstanceid = tmp.contextinstanceid)
   join mdl_user u1 on (u1.id = l.userid)
   where l.contextlevel = 70
     and l.component = 'mod_activityvideo'
     and l.courseid = v_COURSEID and l.contextinstanceid = v_CONTEXTINSTANCEID
   ;

 END LOOP get_video;
 CLOSE c_activityvideo;
 

DROP TABLE IF EXISTS tb_rel_gravacao;
CREATE TABLE tb_rel_gravacao
as
select distinct shortname, sala_ava, recurso, login, nome, data_acesso
from tb_activityvideo;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
