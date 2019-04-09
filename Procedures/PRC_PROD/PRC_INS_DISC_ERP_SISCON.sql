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

-- Copiando estrutura para procedure prod_kls.PRC_INS_DISC_ERP_SISCON
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_INS_DISC_ERP_SISCON`()
BEGIN

	START TRANSACTION;
	
		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
		select distinct d.id_disciplina, uc.ID_UC from teaching_plans_disciplines_erp_siscon tpdes
		inner join kls_lms_curso_disciplina cd on cd.shortname = tpdes.shortname
		inner join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina
		inner join SISCON_UNIDADE_CURRICULAR uc on uc.NOME_UNIDADE_CURRICULAR = tpdes.NOME_UNIDADE_CURRICULAR
		and tpdes.TIPO_SISCON = uc.TIPO_SISCON
		where d.fl_etl_atu <> 'E' and tpdes.TIPO_SISCON = 1 and cd.fl_etl_atu <> 'E' and cd.shortname <> 'A DEFINIR'
		and d.id_disciplina not in (select erp_discipline_id from teaching_plans_discipline);
	
	COMMIT;
	
	START TRANSACTION;
	
		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
		select distinct d.id_disciplina, uc.ID_UC from teaching_plans_disciplines_erp_siscon tpdes
		inner join kls_lms_curso_disciplina cd on cd.shortname = tpdes.shortname
		inner join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina
		inner join SISCON_UNIDADE_CURRICULAR uc on uc.NOME_UNIDADE_CURRICULAR = tpdes.NOME_UNIDADE_CURRICULAR
		and tpdes.TIPO_SISCON = uc.TIPO_SISCON
		inner join SISCON_CURSO_UC cuc on cuc.ID_UC = uc.ID_UC
		inner join SISCON_CURSO sc on sc.ID_CURSO = cuc.ID_CURSO and sc.VIGENCIA = '2017.2'
		where d.fl_etl_atu <> 'E' and tpdes.TIPO_SISCON = 2 and cd.shortname <> 'A DEFINIR'
		and d.id_disciplina not in (select erp_discipline_id from teaching_plans_discipline);
	
	COMMIT;

	START TRANSACTION;
	
		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
			select distinct d.id_disciplina, uc.ID_UC from teaching_plans_disciplines_erp_siscon tpdes
			inner join kls_lms_disciplina d on d.cd_disciplina = tpdes.cd_disciplina
			inner join SISCON_UNIDADE_CURRICULAR uc on uc.NOME_UNIDADE_CURRICULAR = tpdes.NOME_UNIDADE_CURRICULAR
			and tpdes.TIPO_SISCON = uc.TIPO_SISCON
			where d.fl_etl_atu <> 'E' and tpdes.TIPO_SISCON = 1
			and d.id_disciplina not in (select erp_discipline_id from teaching_plans_discipline);
			
	COMMIT;
 
	START TRANSACTION;

		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
			select distinct d.id_disciplina, uc.ID_UC from teaching_plans_disciplines_erp_siscon tpdes
			inner join kls_lms_disciplina d on d.cd_disciplina = tpdes.cd_disciplina
			inner join SISCON_UNIDADE_CURRICULAR uc on uc.NOME_UNIDADE_CURRICULAR = tpdes.NOME_UNIDADE_CURRICULAR
			and tpdes.TIPO_SISCON = uc.TIPO_SISCON
			inner join SISCON_CURSO_UC cuc on cuc.ID_UC = uc.ID_UC
			inner join SISCON_CURSO sc on sc.ID_CURSO = cuc.ID_CURSO and sc.VIGENCIA = '2017.2'
			where d.fl_etl_atu <> 'E' and tpdes.TIPO_SISCON = 2
			and d.id_disciplina not in (select erp_discipline_id from teaching_plans_discipline);
			
	COMMIT;

	START TRANSACTION;
	
		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
			SELECT DISTINCT d.id_disciplina, min(uc.ID_UC)
			FROM kls_lms_disciplina d
			INNER JOIN kls_lms_curso_disciplina cd ON cd.id_disciplina = d.id_disciplina
			INNER JOIN kls_lms_curso c ON c.id_curso = cd.id_curso
			INNER JOIN kls_lms_instituicao ins ON ins.id_ies = c.id_ies
			INNER JOIN SISCON_UNIDADE_CURRICULAR uc ON uc.NOME_UNIDADE_CURRICULAR = d.ds_disciplina
			WHERE d.id_tp_modelo IN (SELECT tm.id_tp_modelo
			FROM kls_lms_tipo_modelo tm
			WHERE sigla IN ('AMP','AMI','DI','DIB','OUTROS','NPJ','TCC','EST'))
			AND d.fl_etl_atu <> 'E' AND cd.fl_etl_atu <> 'E' AND c.fl_etl_atu <> 'E'
			AND ins.fl_etl_atu <> 'E' and
			d.id_disciplina not in (SELECT erp_discipline_id FROM teaching_plans_discipline)
			group by d.id_disciplina;
	
	COMMIT;

	START TRANSACTION;
	
		INSERT INTO teaching_plans_discipline (erp_discipline_id, siscon_discipline_id)
		select id_disciplina, id_uc from (select distinct opa.id_disciplina,
		if(opa.modelo = 'TCCV' AND ds_disciplina like 'Trabalho%', 1002440,
		if(opa.modelo = 'TCCP' AND ds_disciplina like 'Trabalho%', 1002441,
		if(opa.modelo = 'ESTV' AND ds_disciplina like 'Estágio%', 1002438,
		if(opa.modelo = 'ESTP' AND ds_disciplina like 'Estágio%', 1002439, 0)
		))) id_uc from
		(select distinct tm.sigla, d.ds_disciplina, left(cd.shortname,4) as modelo, d.id_disciplina
		from  kls_lms_disciplina d
		inner join kls_lms_tipo_modelo tm on tm.id_tp_modelo = d.id_tp_modelo
		inner join kls_lms_curso_disciplina cd on cd.id_disciplina = d.id_disciplina
		where tm.sigla in ('TCC','EST')) opa) total where id_uc <> 0 and
		id_disciplina not in (select erp_discipline_id from teaching_plans_discipline);

	COMMIT;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
