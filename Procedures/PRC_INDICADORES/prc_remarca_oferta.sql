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

-- Copiando estrutura para procedure prod_kls.prc_remarca_oferta
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `prc_remarca_oferta`()
BEGIN

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_remarca_oferta', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();

  DROP TABLE IF EXISTS sgt_alert_oferta;
  CREATE TABLE sgt_alert_oferta as
  select  distinct 
          i.cd_instituicao, 
          i.nm_ies, 
          c.cd_curso, 
          c.nm_curso, 
          d.cd_disciplina, 
          d.ds_disciplina, 
          tm.sigla,
          cd.cd_curriculo,
          
          (select cd1.shortname
             from kls_lms_curso_disciplina cd1
            where cd1.id_curso_disciplina = cd.id_cd_remarc) as OfertaAntiga,
          
          cd.shortname as OfertaAtual, 
          count(pcd.id_pessoa) as QtdeAlunosImpactados
    from kls_lms_disciplina d
        join kls_lms_tipo_modelo tm         on tm.id_tp_modelo = d.id_tp_modelo
        join kls_lms_curso_disciplina cd    on cd.id_disciplina = d.id_disciplina
        join kls_lms_curso c                on c.id_curso = cd.id_curso
        join kls_lms_instituicao i          on c.id_ies = i.id_ies
        join kls_lms_pessoa_curso_disc pcd  on pcd.id_curso_disciplina = cd.id_curso_disciplina 
                                            and pcd.fl_etl_atu <> 'E'
        join kls_lms_pessoa p               on p.id_pessoa = pcd.id_pessoa 
                                            and p.id_pessoa <> 'E' 
        left join kls_lms_turmas t          on t.id_curso_disciplina = cd.id_curso_disciplina 
                                            and t.fl_etl_atu <> 'E' 
        left join kls_lms_pessoa_turma pt   on pt.id_pes_cur_disc = pcd.id_pes_cur_disc 
                                            and pt.id_turma = t.id_turma 
                                            and pt.fl_etl_atu <> 'E'
   where cd.fl_etl_atu = 'R'
     and d.fl_etl_atu <> 'E'
     and pcd.id_papel = 1
   group by i.cd_instituicao, i.nm_ies, c.cd_curso, c.nm_curso, d.cd_disciplina, d.ds_disciplina, tm.sigla,
            (select cd1.shortname
               from kls_lms_curso_disciplina cd1
              where cd1.id_curso_disciplina = cd.id_cd_remarc),
          cd.shortname;
  
  
  DROP TABLE IF EXISTS sgt_alert_modelo;
  CREATE TABLE sgt_alert_modelo
  select  distinct  
          i.cd_instituicao, 
          i.nm_ies,  
          d.cd_disciplina, 
          d.ds_disciplina,
          c.cd_curso,
          c.nm_curso,
          
          (select tm1.sigla
             from kls_lms_disciplina d1
                 join kls_lms_tipo_modelo tm1 on d1.id_tp_modelo = tm1.id_tp_modelo
            where d1.id_disciplina = d.id_disciplina_remarc) as SiglaAntiga,
          
          tm.sigla as SiglaAtual , 
          d.create_dat , 
          count(pcd.id_pessoa) as QtdeAlunosImpactados
    from kls_lms_disciplina d
        join kls_lms_instituicao i          on d.id_ies = i.id_ies
        join kls_lms_tipo_modelo tm         on tm.id_tp_modelo = d.id_tp_modelo
        join kls_lms_curso_disciplina cd    on cd.id_disciplina = d.id_disciplina 
                                            and cd.fl_etl_atu <> 'E'
        join kls_lms_pessoa_curso_disc pcd  on pcd.id_curso_disciplina = cd.id_curso_disciplina 
                                            and pcd.fl_etl_atu <> 'E'
        join kls_lms_curso c 					on c.id_curso = cd.id_curso
      join kls_lms_pessoa p         		on p.id_pessoa = pcd.id_pessoa 
                                            and p.id_pessoa <> 'E' 
        left join kls_lms_turmas t          on t.id_curso_disciplina = cd.id_curso_disciplina 
                                            and t.fl_etl_atu <> 'E' 
        left join kls_lms_pessoa_turma pt   on pt.id_pes_cur_disc = pcd.id_pes_cur_disc 
                                            and pt.id_turma = t.id_turma 
                                            and pt.fl_etl_atu <> 'E'
   where d.fl_etl_atu = 'R'
     and pcd.id_papel = 1
   group by  i.cd_instituicao, i.nm_ies,  d.cd_disciplina, d.ds_disciplina,
            (select tm1.sigla
               from kls_lms_disciplina d1
                   join kls_lms_tipo_modelo tm1 on d1.id_tp_modelo = tm1.id_tp_modelo
              where d1.id_disciplina = d.id_disciplina_remarc) ,
            tm.sigla;
  
  
  drop view if exists vw_sgt_sala_area_formacao;
  create view vw_sgt_sala_area_formacao as
  SELECT CASE WHEN i.sigla = 'ESTV'
          THEN 'EST, ED 8, 9 e 10'
        WHEN i.sigla REGEXP 'DI[BV]'
          THEN 'DI, ED 5, 6 e 7'
      ELSE i.sigla
          end as produto,
          i.shortname, 
          i.nome_disciplina,
          count(distinct(p.id_pessoa)) as qt_alunos
    FROM anh_import_aluno_curso i
      JOIN kls_lms_pessoa p 				ON p.login = i.username
          JOIN kls_lms_pessoa_curso_disc pcd 	ON pcd.id_pessoa = p.id_pessoa
          JOIN kls_lms_curso_disciplina cd 	ON cd.id_curso_disciplina = pcd.id_curso_disciplina
          JOIN kls_lms_disciplina d 			ON d.id_disciplina = cd.id_disciplina
          JOIN kls_lms_curso c 				ON c.id_curso = cd.id_curso
   WHERE i.log = convert('Disciplina não possui área de conhecimento' using latin1)
     AND pcd.fl_etl_atu not in('E', 'R')
     AND cd.fl_etl_atu not in('E', 'R') 
     AND d.fl_etl_atu not in('E', 'R')
   GROUP BY i.shortname;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_alert_oferta)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
