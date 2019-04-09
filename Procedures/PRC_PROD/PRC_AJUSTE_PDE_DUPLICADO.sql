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

-- Copiando estrutura para procedure prod_kls.PRC_AJUSTE_PDE_DUPLICADO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AJUSTE_PDE_DUPLICADO`()
BEGIN


CALL PRC_REL_PLANOS_DUPLICADOS;

	FASE1: BEGIN 
		
		delete tc from mdl_teaching_plan_class tc
		join mdl_teaching_plan tp on tp.id=tc.tp_id and tp.`status`='waiting_for_elaboration'
		join tmp_chk_planos_duplicados a on find_in_set(tc.erp_class_id, a.id_turmas) and find_in_set(tc.tp_id, tp.id);

	END FASE1;


CALL PRC_REL_PLANOS_DUPLICADOS;

	FASE2:BEGIN 

			
			delete tc
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.`status` regexp 'waiting for elaboration' and 
				(a.status regexp 'approved' and a.status regexp 'waiting for elaboration');
				
	
			delete tc
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.`status`='in_elaboration' and 
				(a.status regexp 'approved' and a.status regexp 'in_elaboration');

	END FASE2;


CALL PRC_REL_PLANOS_DUPLICADOS;

	FASE3:BEGIN  

			delete tc
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.`status` regexp 'waiting for elaboration' and 
				(a.status regexp 'approved' and a.status regexp 'waiting for elaboration');
				
	END FASE3;


CALL PRC_REL_PLANOS_DUPLICADOS;	

	FASE4: BEGIN 
	
			delete tc 
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.modification_date=(select min(modification_date) from teaching_plans where id in (a.planos))
				and 
				(
					a.status regexp 'approved' and 
					a.status not regexp 'elaboration' and
					a.status not regexp 'waiting' and
					a.status not regexp 'reproved' and
					a.status not in ('partial_linked','empty')
				);

		END FASE4;


CALL PRC_REL_PLANOS_DUPLICADOS;

	FASE5: BEGIN 
	
			delete tc 
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.modification_date=(select max(modification_date) from teaching_plans where id in (a.planos))
				and 
				(
					a.status regexp 'in_elaboration' and 
					a.status not regexp 'waiting' and
					a.status not regexp 'approved' and
					a.status not regexp 'reproved' and
					a.status not in ('partial_linked','empty')
				);

		END FASE5;


CALL PRC_REL_PLANOS_DUPLICADOS;

	FASE6: BEGIN 
	
			delete tc
			from tmp_chk_planos_duplicados a
			join mdl_teaching_plan_class tc on FIND_IN_SET(tc.erp_class_id, a.id_turmas)
			join mdl_teaching_plan tp on tc.tp_id=tp.id
			where 
				tp.modification_date=(select min(modification_date) from teaching_plans where id in (a.planos))
				and 
				(
					a.status regexp 'waiting_for_approval' and 
					a.status not regexp 'partial_linked' and 
					a.status not regexp 'empty' and 
					a.status not regexp 'elaboration' and 
					a.status not regexp 'approved' and 
					a.status not regexp 'reproved'
				);

		END FASE6;


CALL PRC_REL_PLANOS_DUPLICADOS;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
