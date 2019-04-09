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

-- Copiando estrutura para procedure prod_kls.PRC_REL_CARGA
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_CARGA`()
BEGIN

	DECLARE ID_LOG_			INT(10);
	DECLARE CODE_ 				VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 				VARCHAR(200);
	DECLARE REGISTROS_		BIGINT DEFAULT NULL;
	
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_REL_CARGA', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		



drop table if exists tmp_mdl_usercourse;
create temporary table tmp_mdl_usercourse (
	chave varchar(150)
);

insert into tmp_mdl_usercourse
select distinct concat(username, shortname) as chave from anh_aluno_matricula where sigla<>'KLS';
alter table tmp_mdl_usercourse add primary key (chave);

drop table if exists tmp_kls_usercourse;
create temporary table tmp_kls_usercourse (
	chave varchar(150),
	id_pes_cur_disc bigint (10)
);
insert into tmp_kls_usercourse
select distinct concat(p.login, cd.shortname) as chave, pcd.id_pes_cur_disc
from kls_lms_pessoa p
join kls_lms_pessoa_curso_disc pcd on p.id_pessoa = pcd.id_pessoa and pcd.fl_etl_atu <> 'E'
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina = pcd.id_curso_disciplina and cd.fl_etl_atu <> 'E'
join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina and d.fl_etl_atu <> 'E'
join kls_lms_tipo_modelo tm on tm.id_tp_modelo = d.id_tp_modelo and tm.sigla <> 'OUTROS'
join kls_lms_turmas t on t.id_curso_disciplina = cd.id_curso_disciplina
							and t.fl_etl_atu <> 'E'
join kls_lms_pessoa_turma pt on pt.id_pes_cur_disc = pcd.id_pes_cur_disc 
									 and pt.id_turma = t.id_turma 
									 and pt.fl_etl_atu <> 'E'
join kls_lms_curso c on c.id_curso = cd.id_curso
join kls_lms_instituicao i on i.id_ies = c.id_ies
where pcd.id_papel = 1
and p.fl_etl_atu <> 'E'


and i.cd_instituicao not like 'fama'  and i.cd_instituicao not like 'olim%';

alter table tmp_kls_usercourse add index idx_chave (chave);

delete a
from tmp_kls_usercourse a
join tmp_mdl_usercourse b on a.chave=b.chave;

drop table if exists relatorio_carga_siae;
create table relatorio_carga_siae as
select pcd.* from tmp_kls_usercourse tmp
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=tmp.id_pes_cur_disc;

drop table if exists tmp_kls_usercourse;
drop table if exists tmp_mdl_usercourse;





drop table if exists tmp_mdl_usercourse;
create temporary table tmp_mdl_usercourse as
select distinct concat(username, shortname) as chave from anh_aluno_matricula where sigla<>'KLS';
alter table tmp_mdl_usercourse add primary key (chave);

drop table if exists tmp_kls_usercourse;
create temporary table tmp_kls_usercourse (
	chave varchar(150),
	id_pes_cur_disc bigint (10)
);
insert into tmp_kls_usercourse
select distinct concat(p.login, cd.shortname) as chave, pcd.id_pes_cur_disc
from kls_lms_pessoa p
join kls_lms_pessoa_curso_disc pcd on p.id_pessoa = pcd.id_pessoa and pcd.fl_etl_atu <> 'E'
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina = pcd.id_curso_disciplina and cd.fl_etl_atu <> 'E'
join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina and d.fl_etl_atu <> 'E'
join kls_lms_tipo_modelo tm on tm.id_tp_modelo = d.id_tp_modelo and tm.sigla <> 'OUTROS'
join kls_lms_curso c on c.id_curso = cd.id_curso
join kls_lms_turmas t on t.id_curso_disciplina=cd.id_curso_disciplina and t.fl_etl_atu<>'E'
join kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc and pt.id_turma=t.id_turma and pt.fl_etl_atu<>'E'
join kls_lms_instituicao i on i.id_ies = c.id_ies
where pcd.id_papel = 1
and p.fl_etl_atu <> 'E'


and i.cd_instituicao like'olim%';

alter table tmp_kls_usercourse add index idx_chave (chave);

delete a
from tmp_kls_usercourse a
join tmp_mdl_usercourse b on a.chave=b.chave;

drop table if exists relatorio_carga_olim;
create table relatorio_carga_olim as
select pcd.* from tmp_kls_usercourse tmp
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=tmp.id_pes_cur_disc;

drop table if exists tmp_kls_usercourse;
drop table if exists tmp_mdl_usercourse;






drop table if exists tmp_mdl_usercourse;
create temporary table tmp_mdl_usercourse (
	chave varchar(150)
);
insert into tmp_mdl_usercourse
select distinct concat(username, shortname) as chave from anh_aluno_matricula where sigla<>'KLS';
alter table tmp_mdl_usercourse add primary key (chave);

drop table if exists tmp_kls_usercourse;
create temporary table tmp_kls_usercourse (
	chave varchar(150),
	id_pes_cur_disc bigint (10)
);
insert into tmp_kls_usercourse
select distinct concat(p.login, cd.shortname) as chave, pcd.id_pes_cur_disc
from kls_lms_pessoa p
join kls_lms_pessoa_curso_disc pcd on p.id_pessoa = pcd.id_pessoa and pcd.fl_etl_atu <> 'E'
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina = pcd.id_curso_disciplina and cd.fl_etl_atu <> 'E'
join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina and d.fl_etl_atu <> 'E'
join kls_lms_tipo_modelo tm on tm.id_tp_modelo = d.id_tp_modelo and tm.sigla <> 'OUTROS'
join kls_lms_turmas t on t.id_curso_disciplina = cd.id_curso_disciplina
							and t.fl_etl_atu <> 'E'
join kls_lms_pessoa_turma pt on pt.id_pes_cur_disc = pcd.id_pes_cur_disc 
									 and pt.id_turma = t.id_turma 
									 and pt.fl_etl_atu <> 'E'
join kls_lms_curso c on c.id_curso = cd.id_curso
join kls_lms_instituicao i on i.id_ies = c.id_ies
where pcd.id_papel = 1
and p.fl_etl_atu <> 'E'


and i.cd_instituicao not like 'fama'  and i.cd_instituicao not like 'olim%';
alter table tmp_kls_usercourse add index idx_chave (chave);

delete a
from tmp_kls_usercourse a
join tmp_mdl_usercourse b on a.chave=b.chave;

drop table if exists relatorio_carga_fama;
create table relatorio_carga_fama as
select pcd.* from tmp_kls_usercourse tmp
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=tmp.id_pes_cur_disc;

drop table if exists tmp_kls_usercourse;
drop table if exists tmp_mdl_usercourse;





	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, 0),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
	 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
