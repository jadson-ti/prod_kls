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

-- Copiando estrutura para procedure prod_kls.PRC_REL_RECURSOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_RECURSOS`()
BEGIN
drop table if exists rel_recursos;
create table rel_recursos as 
select 
	@label:=m.name as module,
	c.id as course, 
	cc.name,
	c.shortname,
	c.fullname as nome_curso,
	cs.name as section_name,
	if(if(@topico,@topico,0)=cs.section,
		@same_section:=1,
		concat(@aula:='',@same_section=0)
	) as same_section,
	@topico:=cs.section as topico,
	find_in_set(cm.id, cs.sequence) as seq,
	case
		when @label='label' then 
			@aula:=GET_MOD_NAME(m.name, cm.instance)
		when @label<>'label' and @same_section=0 then
			concat(@aula:='',GET_MOD_NAME(m.name, cm.instance))
		else 
			GET_MOD_NAME(m.name, cm.instance)
	end as nome_recurso,
	if(@label='label' or @same_section=1,@aula,'N/A') as etapa,
   case when rm.id is null then 'N' else 'S' end as config_rating
	
from mdl_course c
join mdl_course_categories cc on (cc.id=c.category)
join mdl_course_sections cs on (cs.course=c.id)
join mdl_course_modules cm on (cm.course=c.id and cm.section=cs.id and find_in_set(cm.id, cs.sequence))
join mdl_modules m on (m.id=cm.module)
left join mdl_myrating_modules rm on (rm.cmid = cm.id)
where cm.idnumber <> 'teacher_class'
order by c.id, cs.section, find_in_set(cm.id, cs.sequence);
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
