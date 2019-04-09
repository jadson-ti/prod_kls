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

-- Copiando estrutura para procedure prod_kls.PRC_REL_PLANOS_DUPLICADOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_PLANOS_DUPLICADOS`()
BEGIN

TRUNCATE TABLE tmp_chk_planos_duplicados;

INSERT INTO tmp_chk_planos_duplicados 
select 
	group_concat(t.id_turma),
	i.cd_instituicao, 
	cd.shortname, 
	cd.carga_horaria, 
	t.tipo_avaliacao, 
	(	
		select group_concat(distinct p.nm_pessoa order by p.nm_pessoa) as professores
		from kls_lms_pessoa_turma pt
		join kls_lms_turmas t1 on t1.id_turma=pt.id_turma and t1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=pt.id_pes_cur_disc and pcd.id_papel=3 and pcd.fl_etl_atu REGEXP '[NA]' 
		join kls_lms_curso_disciplina cd1 on cd1.id_curso_disciplina=pcd.id_curso_disciplina and cd1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_disciplina d1 on d1.id_disciplina=cd1.id_disciplina and d1.fl_etl_atu REGEXP '[NA]'
		JOIN kls_lms_curso c1 on c1.id_curso=cd1.id_curso and c1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_instituicao i1 on i1.id_ies=c1.id_ies
		join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
		where 
			   t1.id_turma=t.id_turma and
				pt.fl_etl_atu REGEXP '[NA]'
	) as professores,
	group_concat(DISTINCT tc.tp_id order by tp_id) as planos,
	'' AS status
from kls_lms_turmas t
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_instituicao i on i.id_ies=c.id_ies
JOIN mdl_teaching_plan_class tc on tc.erp_class_id=t.id_turma
JOIN mdl_teaching_plan tp on tp.id=tc.tp_id and tp.`active`='yes'
WHERE cd.shortname REGEXP '^(AM[IP]\_)|^(EST|TCC)P|^DIB|^NPJP'
GROUP BY 
	i.cd_instituicao, 
	cd.shortname, 
	cd.carga_horaria, 
	t.tipo_avaliacao, 
	(	
		select group_concat(distinct p.nm_pessoa order by p.nm_pessoa) as professores
		from kls_lms_pessoa_turma pt
		join kls_lms_turmas t1 on t1.id_turma=pt.id_turma and t1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=pt.id_pes_cur_disc and pcd.id_papel=3 and pcd.fl_etl_atu REGEXP '[NA]' 
		join kls_lms_curso_disciplina cd1 on cd1.id_curso_disciplina=pcd.id_curso_disciplina and cd1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_disciplina d1 on d1.id_disciplina=cd1.id_disciplina and d1.fl_etl_atu REGEXP '[NA]'
		JOIN kls_lms_curso c1 on c1.id_curso=cd1.id_curso and c1.fl_etl_atu REGEXP '[NA]'
		join kls_lms_instituicao i1 on i1.id_ies=c1.id_ies
		join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
		where 
			   t1.id_turma=t.id_turma and
				pt.fl_etl_atu REGEXP '[NA]'
	)
HAVING COUNT(DISTINCT tc.tp_id)>1;

INSERT INTO tmp_chk_planos_duplicados 
select 
	group_concat(t.id_turma),
	i.cd_instituicao, 
	cd.shortname, 
	cd.carga_horaria, 
	t.tipo_avaliacao, 
	null,
	group_concat(DISTINCT tc.tp_id order by tp_id) as planos,
	'' AS status
from kls_lms_turmas t
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_instituicao i on i.id_ies=c.id_ies
JOIN mdl_teaching_plan_class tc on tc.erp_class_id=t.id_turma
JOIN mdl_teaching_plan tp on tp.id=tc.tp_id and tp.`active`='yes'
WHERE cd.shortname REGEXP '^(DI\_)|^(EST|TCC)V|^NPJ[12]'
GROUP BY 
	i.cd_instituicao, 
	cd.shortname, 
	cd.carga_horaria, 
	t.tipo_avaliacao
HAVING COUNT(DISTINCT tc.tp_id)>1;


drop table if exists tmp_complete;
create temporary table tmp_complete as
select 
a.id_turmas, a.cd_instituicao, a.shortname, a.carga_horaria,
a.tipo_avaliacao, a.professores, a.planos, group_concat(b.status order by b.id) 
from tmp_chk_planos_duplicados a
join mdl_teaching_plan b on find_in_set(b.id, a.planos)
group by a.cd_instituicao, a.shortname, a.carga_horaria, a.professores, a.planos;

truncate table tmp_chk_planos_duplicados;
insert into tmp_chk_planos_duplicados 
select * from tmp_complete;
drop table tmp_complete;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
