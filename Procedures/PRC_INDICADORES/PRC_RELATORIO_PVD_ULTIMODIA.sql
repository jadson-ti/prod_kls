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

-- Copiando estrutura para procedure prod_kls.PRC_RELATORIO_PVD_ULTIMODIA
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RELATORIO_PVD_ULTIMODIA`()
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
   
   END;

INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
SELECT database(), 'PRC_RELATORIO_PVD_ULTIMODIA', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
SET ID_LOG_=LAST_INSERT_ID();

DROP TABLE IF EXISTS rel_acessos_pvd_dia_anterior;

CREATE TABLE rel_acessos_pvd_dia_anterior (
	nm_regional VARCHAR(255),
	cd_instituicao VARCHAR(20),
	nm_ies VARCHAR(255),
	cd_curso VARCHAR(30),
	nm_curso VARCHAR(255),
   shortname  VARCHAR(255),
     fullname  VARCHAR(255),
	papel VARCHAR(50),
	login VARCHAR(50),
	nm_pessoa VARCHAR(255),
	data_hora_login TIMESTAMP
);

INSERT INTO rel_acessos_pvd_dia_anterior
select distinct 
reg.nm_regional, 
i.cd_instituicao, i.nm_ies, 
c.cd_curso, c.nm_curso, mdlc.shortname, mdlc.fullname, pap.ds_papel, u.username, 
concat(u.firstname, ' ', u.lastname), 
from_unixtime(l.DT)- INTERVAL 3 HOUR as Data_Hora_Login
from tbl_login l
join mdl_user u on u.id = l.userid
join mdl_role_assignments ra on ra.userid=u.id
join mdl_role r on  r.id= ra.roleid
join kls_lms_papel pap on pap.id_role=r.id
join mdl_context co on co.id=ra.contextid
join mdl_course mdlc on mdlc.id=co.instanceid 
join anh_aluno_matricula partition (edv) anh on anh.username=u.username and anh.shortname=mdlc.shortname
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina
join kls_lms_curso  c on c.id_curso = cd.id_curso
join kls_lms_instituicao i on i.id_ies = c.id_ies
join kls_lms_regional reg on reg.id_regional = i.id_regional
join kls_lms_papel pa on pa.id_papel = pcd.id_papel
where u.username <> 'admin' and mdlc.shortname ='ED_PDV'
and date_format(from_unixtime(l.DT)- INTERVAL 3 HOUR,'%Y-%m-%d') = current_date() - interval 1 day
order by 9;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM rel_acessos_pvd_dia_anterior)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
