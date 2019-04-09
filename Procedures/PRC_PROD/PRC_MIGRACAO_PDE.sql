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

-- Copiando estrutura para procedure prod_kls.PRC_MIGRACAO_PDE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_MIGRACAO_PDE`()
MAIN: BEGIN

DECLARE ID_LOG_               INT(10);
DECLARE CODE_                      VARCHAR(50) DEFAULT 'SUCESSO';
DECLARE MSG_                       VARCHAR(200);
DECLARE REGISTROS_            BIGINT DEFAULT NULL;
DECLARE V_OLD_TP INT;
DECLARE V_NEW_TP INT;
DECLARE NODATA INT DEFAULT FALSE;
DECLARE MIGRAR CURSOR FOR
select  
	tpm.id as old_tp
	,tp.id as new_tp
	
	
	
	
	
	from kls_lms_turmas t
	join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina AND cd.fl_etl_atu REGEXP '[NA]'
	join mdl_course mdlc on mdlc.shortname=cd.shortname
	join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina AND d.fl_etl_atu REGEXP '[NA]'
	join kls_lms_curso c on c.id_curso=cd.id_curso AND c.fl_etl_atu<>'E'
	join kls_lms_instituicao i on i.id_ies=c.id_ies AND i.fl_etl_atu<>'E'
	join tmp_turma_professor prof on prof.id_turma=t.id_turma and prof.id_curso_disciplina=cd.id_curso_disciplina
	join mdl_teaching_plan_class tpc on tpc.erp_class_id=t.id_turma
	join mdl_teaching_plan tp on tp.id=tpc.tp_id and tp.status='waiting_for_elaboration'
	join teaching_plans_mig_201901 tpm on tpm.cd_instituicao=i.cd_instituicao and 
													  tpm.ds_disciplina=cd.shortname and
													  tpm.carga_horaria=cd.carga_horaria and
													  tpm.professores=prof.professores
	where 
		t.tipo_avaliacao=tpm.tipo_avaliacao and
		not exists (select * from mdl_teaching_plan_parts tpp where tpp.teaching_plan_id=tp.id)
		and 
		(
			(
				prof.professores is not null and 
				cd.shortname REGEXP '^(AM[IP]\_)|^(EST|TCC)P|^DIBP|^NPJP'
			)
			or 
			(
				prof.professores is null and 
				cd.shortname REGEXP '^(DI\_)|^(EST|TCC|NPJ|DIB)V'
			)
		) AND 
		t.fl_etl_atu<>'E'
group by
	i.cd_instituicao, 
	cd.shortname, 
	cd.carga_horaria, 
	prof.professores,
	t.tipo_avaliacao;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
		GET DIAGNOSTICS CONDITION 1
      CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	   SET CODE_ = CONCAT('ERRO - ', CODE_, ' - ',MSG_);
      ROLLBACK;
      SELECT CODE_;
   END;	



DROP TABLE IF EXISTS tmp_turma_professor;
CREATE TABLE tmp_turma_professor (
	id_turma BIGINT(10),
	id_curso_disciplina BIGINT(10),
	professores VARCHAR(255),
	PRIMARY KEY (id_turma, id_curso_disciplina)
);

INSERT INTO tmp_turma_professor (id_turma, id_curso_disciplina, professores)
	SELECT 
		t.id_turma, 
		pcd.id_curso_disciplina,
		GROUP_CONCAT(distinct p.login order by t.id_turma separator ';')
	FROM kls_lms_pessoa_curso_disc pcd
	JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc and pt.fl_etl_atu<>'E'
	JOIN kls_lms_turmas t on  t.id_turma=pt.id_turma and t.fl_etl_atu<>'E'
	JOIN kls_lms_papel pp on pp.id_papel=pcd.id_papel and pp.ds_papel='PROFESSOR'
	JOIN kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu<>'E'
	WHERE pcd.fl_etl_atu<>'E' 
	GROUP BY t.id_turma,pcd.id_curso_disciplina;

INSERT INTO tmp_turma_professor (id_turma, id_curso_disciplina, professores)
	SELECT 
		t.id_turma, 
		cd.id_curso_disciplina,
		null
	FROM kls_lms_turmas t
	JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu<>'E'
	JOIN kls_lms_papel pp on pp.ds_papel='PROFESSOR'
	LEFT JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_curso_disciplina=cd.id_curso_disciplina and pcd.fl_etl_atu<>'E' AND pcd.id_papel=pp.id_papel
	WHERE pcd.id_pes_cur_disc IS NULL AND t.fl_etl_atu<>'E';



OPEN MIGRAR;

MIGRACAO: LOOP

	SET NODATA=FALSE;
	
	FETCH MIGRAR INTO V_OLD_TP, V_NEW_TP;
	
	IF NODATA THEN LEAVE MIGRACAO; END IF;
	
	START TRANSACTION;
	
	INSERT INTO mdl_teaching_plan_parts (teaching_plan_id, part_type, html, hours, origin, has_changed, active, creation_date, 
												`order`, digital, link) 
	SELECT V_NEW_TP, part_type, html, hours, origin, has_changed, active, creation_date, `order`, digital, link
	FROM teaching_plan_parts_201901 mig
	WHERE mig.teaching_plan_id=V_OLD_TP and mig.part_type IN (
		'methodology',
		'evaluation',
		'basic_references',
		'additional_references',
		'other_references'
	);
	
	INSERT INTO mdl_teaching_plan_part_items (teaching_plan_part_id, description, active, 
	creation_date)
	SELECT tpp.id, tppi.description, tppi.active, now()
	FROM mdl_teaching_plan_parts tpp
	JOIN teaching_plan_parts_201901 tppold on tppold.teaching_plan_id=V_OLD_TP AND 
															tpp.part_type=tppold.part_type and 
															tpp.html=tppold.html and 
															tpp.active=tppold.active
 	JOIN teaching_plan_part_items_201901 tppi on tppi.teaching_plan_part_id=tppold.id
	WHERE tpp.id=V_NEW_TP;
	
	

	COMMIT;


END LOOP MIGRACAO;

CLOSE MIGRAR;

END MAIN//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
