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

-- Copiando estrutura para procedure prod_kls.PRC_AVALIACAO_CONTEUDO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AVALIACAO_CONTEUDO`()
BEGIN

drop table if exists rel_recursos;
set @etapa:=null;
set @seq:=0;
create table rel_recursos as 
select 
	b.name as categoria,
	b.course as courseid,
	b.shortname,
	b.nome_curso,
	b.section_name as nome_secao,
	b.topico,
	b.nome_recurso,
	b.etapa
from (
select 
	a.*,
	case
		when a.module='label' then
			@etapa:=a.nome_recurso
		when (a.module<>'label' and a.same_section=0) or a.topico=0 then
			@etapa:=null
		when a.module<>'label' and a.same_section=1 then 
			@etapa
	end as etapa	
from (
select 
	@label:=m.name as module,
	c.id as course, 
	cc.name,
	c.shortname,
	c.fullname as nome_curso,
	cs.name as section_name,
	if(if(@topico,@topico,0)=cs.section,
		@same_section:=1,
		concat(@aula:='',@same_section:=0)
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
	end as nome_recurso
from mdl_course c
join mdl_course_categories cc on cc.id=c.category
join mdl_course_sections cs on cs.course=c.id
join mdl_course_modules cm on cm.course=c.id and cm.section=cs.id and find_in_set(cm.id, cs.sequence) and cm.idnumber<>'teacher_class'
join mdl_modules m on m.id=cm.module
order by c.id, cs.section, find_in_set(cm.id, cs.sequence)
) a ) b where b.module<>'label';


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
