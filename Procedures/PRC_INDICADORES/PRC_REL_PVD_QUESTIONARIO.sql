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

-- Copiando estrutura para procedure prod_kls.PRC_REL_PVD_QUESTIONARIO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_PVD_QUESTIONARIO`()
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
SELECT database(), 'PRC_REL_PVD_QUESTIONARIO', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
SET ID_LOG_=LAST_INSERT_ID();

DROP TABLE IF EXISTS rel_pvd_questionario;

CREATE TABLE rel_pvd_questionario (
	unidade VARCHAR(255),
	curso VARCHAR(255),
	login VARCHAR(50),
	nome VARCHAR(255),
	sexo VARCHAR(5),
	rotulo VARCHAR (255),
	resposta VARCHAR(255)
);

INSERT INTO rel_pvd_questionario
select distinct
	concat(i.cd_instituicao,' - ',i.nm_ies) as UNIDADE, 
	concat(c.cd_curso, ' - ',c.nm_curso) as CURSO, 
	p.login, 
	concat(u.firstname,' ',u.lastname) as NOME,  
	p.sexo as SEXO, 
	qu.name as ROTULO_PERGUNTA, 
	qat.responsesummary AS RESPOSTA 
from mdl_user u 
join kls_lms_pessoa p on u.username=p.login and u.mnethostid=1 
join kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and pcd.fl_etl_atu REGEXP '[NA]'
join kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='ALUNO' 
join kls_lms_curso c on c.id_curso=cd.id_curso  
join kls_lms_instituicao i on i.id_ies=c.id_ies 
join mdl_question_attempt_steps qas on qas.userid=u.id and qas.state='complete' 
join mdl_question_attempts qat on qat.id=qas.questionattemptid 
join mdl_quiz_slots qs on qat.slot=qs.slot 
join mdl_question qu on qu.id=qat.questionid 
where cd.shortname='ED_PVD'
order by 1,2,4;

		
UPDATE tbl_prc_log pl
SET pl.FIM = sysdate(),
pl.`STATUS` = CODE_, 
pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM rel_pvd_questionario)),
pl.INFO = MSG_
WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
