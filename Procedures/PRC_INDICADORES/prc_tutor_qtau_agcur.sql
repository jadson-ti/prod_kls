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

-- Copiando estrutura para procedure prod_kls.prc_tutor_qtau_agcur
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `prc_tutor_qtau_agcur`()
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
SELECT database(), 'prc_tutor_qtau_agcur', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

SET ID_LOG_=LAST_INSERT_ID();

TRUNCATE TABLE sgt_tutor_qtau_agcur;
INSERT INTO sgt_tutor_qtau_agcur
select 
	CASE WHEN m.sigla = 'EST' then 'EST, ED 8, 9 e 10'
   WHEN m.sigla = 'DI' then 'DI, ED 5, 6 e 7'
   WHEN m.sigla = 'DIBV' then 'DIB, ED 5, 6 e 7'
   ELSE m.sigla
   END produto,	
	umo.mdl_username,
	u.nome,
	i.cd_instituicao, 
   i.nm_ies,
   a.cd_agrupamento,
   a.ds_agrupamento,	
	count(distinct mat.USERNAME) as alunos,
	CONCAT('GRUPO_',umo.mdl_username) 
from mdl_sgt_usuario u
join mdl_sgt_usuario_modelo um on um.id_usuario=u.id
join mdl_sgt_modelo m on m.id=um.id_modelo
join mdl_sgt_usuario_moodle umo on umo.id_usuario_id=u.id
join anh_aluno_matricula mat on mat.TUTOR=umo.mdl_username
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=mat.ID_PES_CUR_DISC
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_agrupamento a on a.cd_agrupamento=c.cd_agrupamento
join kls_lms_instituicao i on i.id_ies=c.id_ies
group by m.sigla,	
	u.nome,
	i.cd_instituicao, 
   i.nm_ies,
   a.cd_agrupamento,
   a.ds_agrupamento;
   

TRUNCATE TABLE sgt_tutor_qtau_agcurDT;
INSERT INTO sgt_tutor_qtau_agcurDT( shortname, 
                                        fullname, 
                                        username, 
                                        nm_pessoa, 
                                        cd_agrupamento, 
                                        cd_instituicao,
                                        grupo_tutor)
                                        
select 
	cd.shortname,
	d.ds_disciplina,
	p.login,
	p.nm_pessoa as nome_aluno,
	a.cd_agrupamento,
   i.cd_instituicao,
	CONCAT('GRUPO_',umo.mdl_username) 
from mdl_sgt_usuario u
join mdl_sgt_usuario_modelo um on um.id_usuario=u.id
join mdl_sgt_modelo m on m.id=um.id_modelo
join mdl_sgt_usuario_moodle umo on umo.id_usuario_id=u.id
join anh_aluno_matricula mat on mat.TUTOR=umo.mdl_username
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=mat.ID_PES_CUR_DISC
join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa 
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_agrupamento a on a.cd_agrupamento=c.cd_agrupamento
join kls_lms_instituicao i on i.id_ies=c.id_ies;                                     
   

  
  	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_tutor_qtau_agcur)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
