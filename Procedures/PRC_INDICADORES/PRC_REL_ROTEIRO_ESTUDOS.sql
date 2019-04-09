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

-- Copiando estrutura para procedure prod_kls.PRC_REL_ROTEIRO_ESTUDOS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_ROTEIRO_ESTUDOS`()
BEGIN

 
	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;
	DECLARE SUMMERTIME    INT DEFAULT 0;
	DECLARE FUSOHORARIO	 INT DEFAULT 10800;
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;	
	
   SELECT EXECUT INTO SUMMERTIME FROM tbl_event_set WHERE NAME='summertime';

   IF SUMMERTIME IS NULL OR SUMMERTIME=0 THEN 
   	SET FUSOHORARIO=10800;
   END IF;

   IF SUMMERTIME=1 THEN 
		SET FUSOHORARIO=7200; 
	END IF;
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
	SELECT database(), 'PRC_REL_ROTEIRO_ESTUDOS', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();


drop table if exists tbl_roteiro_estudos_sumarizado;

create table tbl_roteiro_estudos_sumarizado (
cd_instituicao varchar(30),
nm_ies varchar(255),
ds_marca varchar(50),
cd_marca varchar(50),
cd_curso varchar(30),
nm_curso varchar(255),
id_sala_ava bigint(10),
fullname varchar(255),
quizid bigint(10),
quizname varchar(255),
data_entrega date,
qtd_usuarios int(11)
);

insert into tbl_roteiro_estudos_sumarizado
select    
ins.cd_instituicao, ins.nm_ies, 
ins.ds_marca, ins.cd_marca,
kc.cd_curso, kc.nm_curso,
c.id as 'ID_Sala_AVA',
c.fullname as 'Sala_AVA',
qz.id as 'ID_questionario',
qz.name,
DATE(FROM_UNIXTIME(qa.timemodified-10800)),
count(distinct u.username) as qtd_usuario
from mdl_question_attempts qa    
join mdl_question_attempt_steps qas on qas.questionattemptid = qa.id    
join mdl_question q on qa.questionid = q.id    
join mdl_quiz_attempts qza on qza.uniqueid = qa.questionusageid and qza.userid = qas.userid
join mdl_quiz qz on qza.quiz = qz.id
join mdl_course c on c.id = qz.course
join mdl_user u on u.id= qas.userid and u.mnethostid = 1
join kls_lms_pessoa p on p.login=u.username and p.fl_etl_atu REGEXP '[NA]'    
join kls_lms_pessoa_curso pc on pc.id_pessoa = p.id_pessoa and pc.fl_etl_atu REGEXP '[NA]' and pc.id_papel = 1
join kls_lms_curso kc on kc.id_curso = pc.id_curso and kc.fl_etl_atu REGEXP '[NA]'    
join kls_lms_instituicao ins on ins.id_ies= kc.id_ies
where qza.attempt=1 and qza.state= 'finished'
and qz.name = 'Roteiro de Estudos - Disciplinas Interativas'
group by ins.cd_instituicao,     kc.cd_curso, c.id , qz.id , DATE(FROM_UNIXTIME(qa.timemodified-10800));




drop table if exists tbl_roteiro_estudos_detalhe;

create table tbl_roteiro_estudos_detalhe (
cd_instituicao varchar(30),
nm_ies varchar(255),
ds_marca varchar(50),
cd_marca varchar(50),
cd_curso varchar(30),
nm_curso varchar(255),
ra varchar(30),
username varchar(50),
nome_usuario varchar(255),
cpf varchar(20),
id_sala_ava bigint(10),
fullname varchar(255),
quizid bigint(10),
quiz_name varchar(255),
numero_questao int(11),
respostaaluno varchar(30),
respostacorreta varchar(30),
data_entrega date,
resultado varchar(30)
);


insert into tbl_roteiro_estudos_detalhe 
select distinct
ins.cd_instituicao, ins.nm_ies, ins.ds_marca, ins.cd_marca,
kc.cd_curso, kc.nm_curso,
p.cd_pessoa as 'RA',
u.username as 'username',
p.nm_pessoa as 'nome_usuario',
p.cpf,
c.id as 'ID_Sala_AVA',
c.fullname as 'Sala_AVA',    
q.id as 'ID_questionario',
q.name as 'questionario',
qa.slot as 'NumeroQuestão',
qa.rightanswer as 'RespostaAluno' ,
qa.responsesummary as 'RespostaCorreta',
DATE(FROM_UNIXTIME(qa.timemodified-10800)) as 'DataEntrega',
case when qa.rightanswer <> qa.responsesummary then 'erro'
when qa.rightanswer = qa.responsesummary then 'acerto'
when qa.responsesummary is NULL then 'SemResposta'
end as 'Resultado'
from mdl_question_attempts qa    
join mdl_question_attempt_steps qas on qas.questionattemptid = qa.id    
join mdl_question q on qa.questionid = q.id    
join mdl_quiz_attempts qza on qza.uniqueid = qa.questionusageid and qza.userid = qas.userid
join mdl_quiz qz on qza.quiz = qz.id
join mdl_course c on c.id = qz.course
join mdl_user u on u.id= qas.userid and u.mnethostid = 1
join kls_lms_pessoa p on p.login=u.username and p.fl_etl_atu REGEXP '[NA]'    
join kls_lms_pessoa_curso pc on pc.id_pessoa = p.id_pessoa and pc.fl_etl_atu REGEXP '[NA]'    
join kls_lms_curso kc on kc.id_curso = pc.id_curso and kc.fl_etl_atu REGEXP '[NA]'    
join kls_lms_instituicao ins on ins.id_ies= kc.id_ies
where qza.attempt=1 and qza.state= 'finished'
and qz.name = 'Roteiro de Estudos - Disciplinas Interativas'
and pc.id_papel = 1;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_roteiro_estudos_detalhe)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
