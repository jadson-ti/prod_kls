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

-- Copiando estrutura para procedure prod_kls.PRC_MIGRA_ARMARIO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_MIGRA_ARMARIO`()
BEGIN

insert into mdl_unifiedcloset_directory (username, parent, name, timecreated, status)
select distinct
	udm.username, 
	udm.parent,
	udm.name,
	udm.timecreated,
	udm.status
from mig_unifiedcloset_directory udm
join mdl_user u on u.username=udm.username and u.mnethostid=1
left join mdl_unifiedcloset_directory ud on ud.username=u.username and ud.name=udm.name
where ud.id is null;

insert into mdl_unifiedcloset (userid, username, typeid, licenceid, title, link, filename, timecreated,
timemodified,	status, directoryid)
select distinct
	u.id,
	u.username,
	mig.typeid,
	mig.licenceid,
	mig.title,
	mig.link,
	mig.filename,
	mig.timecreated,
	mig.timemodified,
	mig.`status`,
	ud.id
from mig_unifiedcloset mig
join mig_unifiedcloset_directory migd on migd.id=mig.directoryid
join mdl_user u on u.username=mig.username and u.mnethostid=1
join mdl_unifiedcloset_directory ud on ud.username=u.username and ud.parent=migd.parent and ud.name=migd.name
left join mdl_unifiedcloset uc on uc.userid=u.id and uc.typeid=mig.typeid and uc.title=mig.title
where uc.id is null;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
