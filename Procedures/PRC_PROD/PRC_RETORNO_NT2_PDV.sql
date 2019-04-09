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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_PDV
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_PDV`()
BEGIN


 DECLARE V_ASSIGN_OBRIGATORIOS INT(11) DEFAULT 0;
 DECLARE V_RECURSOS_OBRIGATORIOS INT(11) DEFAULT 0;
 DECLARE V_QUIZ_OBRIGATORIOS INT(11) DEFAULT 0;

 select count(1) INTO V_ASSIGN_OBRIGATORIOS
 from tbl_projetovida_obrigatorio a
 join mdl_course_modules cm on cm.id=a.cmid
 join mdl_modules m on m.id=cm.module and m.name='assign';

 select count(1) INTO V_RECURSOS_OBRIGATORIOS
 from tbl_projetovida_obrigatorio a
 join mdl_course_modules cm on cm.id=a.cmid
 join mdl_modules m on m.id=cm.module and m.name in ('activityvideo','url');
 
 select count(1) INTO V_QUIZ_OBRIGATORIOS
 from tbl_projetovida_obrigatorio a
 join mdl_course_modules cm on cm.id=a.cmid
 join mdl_modules m on m.id=cm.module and m.name='quiz';
 
 DROP TABLE IF EXISTS tbl_retorno_nt2_pvd;

 CREATE TABLE tbl_retorno_nt2_pvd (
    CD_INSTITUICAO   VARCHAR(20),
    NM_IES     VARCHAR(200),
    CD_PESSOA    VARCHAR(100),
    USERID     BIGINT(10),
    USERNAME    VARCHAR(200),
    NOME_USUARIO   VARCHAR(200),
    COURSEID    BIGINT(10),
    SHORTNAME    VARCHAR(200),
    FULLNAME    VARCHAR(200),
    CD_CURSO    VARCHAR(100),
    CURSO     VARCHAR(200),
    CD_DISCIPLINA   VARCHAR(100),
    DISCIPLINA    VARCHAR(200),
    TURMA     VARCHAR(100),
    CARGA_HORARIA   SMALLINT(10),
    ATIVIDADES_ENTREGUES SMALLINT(10) DEFAULT 0,
    RECURSOS_ACESSADOS  SMALLINT(10) DEFAULT 0,
	QUIZ_FINALIZADOS	SMALLINT(10) DEFAULT 0,
    NOTA     DECIMAL(3,1) DEFAULT 0
 );

 CREATE INDEX idx_NT_PVD ON tbl_retorno_nt2_pvd (USERNAME);
 CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_pvd (SHORTNAME);
 alter table tbl_retorno_nt2_pvd add index dx_userid (userid);
 
 INSERT INTO tbl_retorno_nt2_pvd (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERID, USERNAME, NOME_USUARIO, COURSEID, SHORTNAME,
          FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, CARGA_HORARIA)
     SELECT i.cd_instituicao,
       i.nm_ies, 
        p.cd_pessoa,
		tu.id,
        tu.username,
        p.nm_pessoa AS NOME_USUARIO,
        tc.id AS COURSE_ID,
        tc.shortname,
        tc.fullname,
        c.cd_curso AS COD_CURSO,
        c.nm_curso AS CURSO,
        d.cd_disciplina AS CD_DISCIPLINA,
        d.ds_disciplina AS DISCIPLINA,
        IFNULL(t.cd_turma, '') AS TURMA,
        cd.carga_horaria
       FROM kls_lms_pessoa p
       JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA = p.id_pessoa
       JOIN kls_lms_curso_disciplina cd ON cd.ID_CURSO_DISCIPLINA = pcd.ID_CURSO_DISCIPLINA
       JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO
       JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
       JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina 
       JOIN kls_lms_turmas t ON t.id_curso_disciplina = cd.id_curso_disciplina  AND t.fl_etl_atu != 'E'
       JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
       JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
       JOIN mdl_course tc ON tc.shortname = cd.shortname
      WHERE pcd.id_papel = 1 AND cd.shortname='ED_PDV'
         GROUP BY i.cd_instituicao,
        i.nm_ies, 
        p.cd_pessoa,
        tu.username,
        
        tc.id,
        tc.shortname,
        tc.fullname,
        c.cd_curso,
        c.nm_curso,
        d.cd_disciplina,
        d.ds_disciplina,
        cd.carga_horaria;

  update tbl_retorno_nt2_pvd a
  join mdl_user u on u.username=a.USERNAME and u.mnethostid=1
  join mdl_certificate c on c.course=a.COURSEID
  join mdl_certificate_issues ci on ci.userid=u.id and ci.certificateid=c.id
  set a.NOTA=10;

  update tbl_retorno_nt2_pvd r 
  join mdl_user u on u.username=r.USERNAME and u.mnethostid=1 
  set ATIVIDADES_ENTREGUES=(
   SELECT COUNT(DISTINCT a.id)
   FROM mdl_assign_submission s
   JOIN mdl_assign a on a.id=s.assignment 
   JOIN mdl_modules m on m.name='assign'
   JOIN mdl_course_modules cm on cm.course=a.course and cm.module=m.id and cm.instance=a.id
   JOIN tbl_projetovida_obrigatorio o on o.cmid=cm.id
   where s.userid=u.id and s.status<>'new'
  );

  UPDATE tbl_retorno_nt2_pvd a
  SET QUIZ_FINALIZADOS=(
   SELECT COUNT(DISTINCT q.id)
   FROM mdl_quiz_attempts qa
   JOIN mdl_quiz q on q.id=qa.quiz 
   JOIN mdl_modules m on m.name='quiz'
   JOIN mdl_course_modules cm on cm.course=q.course and cm.module=m.id and cm.instance=q.id
   JOIN tbl_projetovida_obrigatorio o on o.cmid=cm.id
   where qa.userid=a.USERID and qa.state='finished'
  );
  
update tbl_retorno_nt2_pvd a
set RECURSOS_ACESSADOS=(
   select count(distinct o.cmid)
   from mdl_logstore_standard_log l
   JOIN tbl_projetovida_obrigatorio o on o.cmid=l.contextinstanceid
   join mdl_course_modules cm on cm.id=o.cmid
   join mdl_modules m on m.id=cm.module
   where userid=a.userid and
   		contextlevel=70 and
   		contextinstanceid=o.cmid and
   		action in ('viewed','updated') and
		m.name IN ('url','activityvideo')
)
where atividades_entregues=V_ASSIGN_OBRIGATORIOS and QUIZ_FINALIZADOS=V_QUIZ_OBRIGATORIOS and nota=0 ;			

update tbl_retorno_nt2_pvd set nota=10 where nota=0 and atividades_entregues=V_ASSIGN_OBRIGATORIOS AND QUIZ_FINALIZADOS=V_QUIZ_OBRIGATORIOS
AND RECURSOS_ACESSADOS=V_RECURSOS_OBRIGATORIOS;
		
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
