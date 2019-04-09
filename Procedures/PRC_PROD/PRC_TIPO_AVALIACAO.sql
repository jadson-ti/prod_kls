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

-- Copiando estrutura para procedure prod_kls.PRC_TIPO_AVALIACAO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_TIPO_AVALIACAO`()
BEGIN



drop table if exists tmp_tipo_avaliacao;
create temporary table tmp_tipo_avaliacao (
	cd_instituicao varchar(10), 
	cd_disciplina varchar(30), 
	cd_turma varchar(30),
	sent_date date
);
alter table tmp_tipo_avaliacao add index idx_ta (cd_instituicao,cd_turma,sent_date);
insert into tmp_tipo_avaliacao
select 
	cd_instituicao, 
	cd_disciplina, 
	cd_turma, 
	max(date(sent_date))
from mdl_local_kca_imp_tag 
group by
	cd_instituicao, 
	cd_disciplina, 
	cd_turma;
	

UPDATE kls_lms_turmas t
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies
JOIN tmp_tipo_avaliacao   tmp on tmp.cd_instituicao=i.cd_instituicao and
										 tmp.cd_disciplina=d.cd_disciplina and
										 tmp.cd_turma=t.cd_turma
JOIN mdl_local_kca_imp_tag lk on lk.cd_instituicao=i.cd_instituicao and
											lk.cd_disciplina=d.cd_disciplina and
											lk.cd_turma=t.cd_turma and
											date(lk.sent_date)=tmp.sent_date
SET t.tipo_avaliacao=lk.tipo_avaliacao
WHERE t.tipo_avaliacao IS NULL;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
