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

-- Copiando estrutura para procedure prod_kls.PRC_REL_FEEDBACK_PVD
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_REL_FEEDBACK_PVD`()
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
SELECT database(), 'PRC_REL_FEEDBACK_PVD', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
SET ID_LOG_=LAST_INSERT_ID();

DROP TABLE IF EXISTS rel_pvd_feedback;

CREATE TABLE rel_pvd_feedback (
	cd_instituicao VARCHAR(20),
	nm_ies VARCHAR(255),
	cd_curso VARCHAR(30),
	nm_curso VARCHAR(255),
	login VARCHAR(50),
	nm_pessoa VARCHAR(255),
	sexo VARCHAR(5),
	shortname varchar(350),
	atividade VARCHAR(255),
	rotulo VARCHAR (255),
	resposta VARCHAR(255)
);

INSERT INTO rel_pvd_feedback
SELECT distinct
	cd_instituicao, nm_ies, cd_curso, nm_curso, login, nm_pessoa, 
	sexo, shortname, atividade, rotulo, resposta
FROM (	
SELECT 
	i.cd_instituicao, 
	i.nm_ies, 
	c.cd_curso, 
	c.nm_curso, 
	p.login, 
	p.nm_pessoa, 
	p.sexo,
	mdlc.shortname,
	f.name as atividade,
	strip_tags(fi.name) as rotulo,
	@opcoes:=replace(replace(fi.presentation,'r>>>>>',''),'<<<<<1',''),
	@qtd_opcoes:=ROUND((LENGTH(presentation)-LENGTH(REPLACE(presentation,'|',''))))+2,
	@resposta_aluno:=concat(substring_index(@opcoes,'|',-(@qtd_opcoes-fv.value)),'|'),
	substring(@resposta_aluno, 1, locate('|',@resposta_aluno)-1) as resposta
FROM anh_aluno_matricula PARTITION (EDV) anh
join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina
join kls_lms_curso  c on c.id_curso = cd.id_curso
join kls_lms_instituicao i on i.id_ies = c.id_ies
join kls_lms_regional reg on reg.id_regional = i.id_regional
join kls_lms_papel pa on pa.id_papel = pcd.id_papel
JOIN mdl_user u on u.username=p.login and u.mnethostid=1
JOIN mdl_course mdlc on mdlc.shortname=cd.shortname
JOIN mdl_course_modules cm on cm.course=mdlc.id 
JOIN mdl_modules m on m.id=cm.module and m.name='feedback'
JOIN mdl_feedback f on f.id=cm.instance
JOIN mdl_feedback_item fi on fi.feedback=f.id
JOIN mdl_feedback_completed fc on fc.feedback=f.id and fc.userid=u.id
JOIN mdl_feedback_value fv on fv.completed=fc.id and fv.item=fi.id
WHERE mdlc.shortname = 'ED_PDV'
) A;

	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM rel_pvd_feedback)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
