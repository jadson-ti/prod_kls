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

-- Copiando estrutura para procedure prod_kls.prc_tutor_prod_area
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `prc_tutor_prod_area`()
BEGIN  

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

  
  DECLARE Vusername  VARCHAR(255);
  DECLARE Vexit_loop BOOLEAN;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET Vexit_loop = TRUE;
		
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_tutor_prod_area', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
  
  	SET ID_LOG_=LAST_INSERT_ID();
  
  TRUNCATE TABLE sgt_tutor_prod_areaDT;
  
  
  DROP table IF EXISTS sgt_tutor_prod_area;
  create table sgt_tutor_prod_area as
select
if(u.qtde_alunos>0, 'S','N') tutoralocado,
mo.sigla,
um.mdl_username as username,
u.nome,
GROUP_CONCAT(af.dsc_area_formacao) as area_formacao,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='ED'
),0) limite_ed,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='DI'
),0) limite_di,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='DIB'
),0) limite_diB,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='EST'
),0) limite_est,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='TCC'
),0) limite_tcc,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='NPJ'
),0) limite_npj,
coalesce(
(
select qtd_alunos
from mdl_sgt_usuario_capacidade uc
join mdl_sgt_modelo m1 on m1.id=uc.id_modelo
where id_usuario=u.id and m1.sigla='HIB'
),0) limite_hib,
u.id as sgt_user_id,
u.qtde_alunos
from mdl_sgt_usuario u
left join mdl_sgt_usuario_moodle um on um.id_usuario_id=u.id
left join mdl_sgt_usuario_modelo m on m.id_usuario=u.id
left join mdl_sgt_modelo mo on mo.id=m.id_modelo
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
group by u.id;
  
  CREATE INDEX stg_tutor_grupo_areaIX  ON sgt_tutor_prod_area (username);   
 --  CREATE INDEX stg_tutor_grupo_areaIX1 ON sgt_tutor_prod_area (produto);   
  CREATE INDEX stg_tutor_grupo_areaIX2 ON sgt_tutor_prod_area (sgt_user_id); 
  
  
  update sgt_tutor_prod_area fa
   set fa.area_formacao = ( SELECT group_concat(distinct uf.nivel,'.',af.dsc_area_formacao order by uf.nivel separator ', ') AS area_formacao
                              
                                  FROM mdl_sgt_usuario_formacao uf 
                                  JOIN mdl_sgt_area_formacao af on af.id = uf.id_area_formacao
                              WHERE uf.id_usuario = fa.sgt_user_id);
    
   INSERT INTO sgt_tutor_prod_areaDT(shortname, 
                                      fullname, 
                                      cd_instituicao, 
                                      nm_ies, 
                                      cd_curso, 
                                      nm_curso,
                                      username, 
                                      nm_pessoa,
                                      tutor)
   SELECT cu.shortname,
			 cu.fullname,
			 anh.UNIDADE,
			 u.institution,
			 anh.CURSO,
			 u.department,
			 u.username,
			 concat(u.firstname,' ',u.lastname) as nome,
			 anh.tutor
	  FROM mdl_course cu
	  JOIN mdl_context co             ON co.instanceid = cu.id and co.contextlevel = 50
  	  JOIN mdl_role_assignments ra    ON co.id = ra.contextid 
  	  JOIN mdl_role r on r.id=ra.roleid and r.shortname='student'
	  JOIN mdl_user u on u.id=ra.userid
	  JOIN anh_aluno_matricula anh on anh.shortname=cu.shortname and anh.USERNAME=u.username 
	  JOIN sgt_tutor_prod_area sgt on sgt.username=anh.tutor;

 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_tutor_prod_area)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
