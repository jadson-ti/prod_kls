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

-- Copiando estrutura para procedure prod_kls.PRC_IMAGEM_PADRAO
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_IMAGEM_PADRAO`()
    COMMENT 'PROC que ajustar a imagem padrão dos cursos por categoria'
BEGIN


insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='AMP.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='AMP.jpg'
where shortname like 'AMP%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='AMI.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='AMI.jpg'
where shortname like 'AMI%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='DI.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='DI.jpg'
where shortname like 'DI\_%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='DIB.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='DIB.jpg'
where shortname like 'DIB\_%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='hamp-01.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='hamp-01.jpg'
where shortname like 'HAMI\_%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='hamp-02.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='hamp-02.jpg'
where shortname like 'HAMP\_%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='TCC_unidade.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='TCC_unidade.jpg'
where shortname like 'TCCP\_%' and test.id IS NULL
group by co.id;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='TCC_AVA.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='TCC_AVA.jpg'
where shortname like 'TCCV%' and test.id IS NULL
group by co.id;


insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='Estagio_Supervisionado.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='Estagio_Supervisionado.jpg'
where shortname like 'ESTP\_%' and test.id IS NULL;

insert into mdl_files (contenthash, pathnamehash, contextid, component,
filearea, itemid, filepath, filename, userid, filesize, mimetype, 
status, source, author, license, timecreated, timemodified, sortorder,
referencefileid)
select distinct f.contenthash, 
sha1(concat('/',co.id,'/course/overviewfiles/0/',f.filename)), 
co.id as contextid,
'course' as component, 'overviewfiles' as filearea, f.itemid,
f.filepath, f.filename, f.userid, f.filesize, f.mimetype,
f.status, f.source, f.author, f.license, unix_timestamp(now()) as timecreated,
unix_timestamp(now()) as timemodified, f.sortorder, f.referencefileid
from mdl_course c
JOIN mdl_context co on co.instanceid=c.id and co.contextlevel=50
JOIN mdl_files f on f.component='course' and 
						  f.filearea='overviewfiles' and 
						  f.filesize<>0 and
						  f.filename='Estagio_Supervisionado_AVA.jpg' 
left join mdl_files test on test.contextid=co.id and test.filename='Estagio_Supervisionado_AVA.jpg'
where shortname like 'ESTV\_%' and test.id IS NULL;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
