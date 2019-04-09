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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT2_DDC
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT2_DDC`()
BEGIN

 DECLARE V_RECURSOS_OBRIGATORIOS INT(11);
 
 SELECT  
  COUNT(1) INTO V_RECURSOS_OBRIGATORIOS
 FROM tbl_ddc_obrigatorio pvd
 JOIN mdl_course_modules cm on cm.id=pvd.cmid
 JOIN mdl_modules m on m.id=cm.module
 WHERE m.name IN ('activityvideo','url');

 DROP TABLE IF EXISTS tbl_retorno_nt2_ddc;

 CREATE TABLE tbl_retorno_nt2_ddc (
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
    RECURSOS_ACESSADOS  SMALLINT(10) DEFAULT 0,
    NOTA     DECIMAL(3,1) DEFAULT 0
 );

 CREATE INDEX idx_NT_PVD ON tbl_retorno_nt2_ddc (USERNAME);
 CREATE INDEX idx_NT_ED1 ON tbl_retorno_nt2_ddc (SHORTNAME);
alter table tbl_retorno_nt2_ddc add index dx_userid (userid);
 
 INSERT INTO tbl_retorno_nt2_ddc (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERID, USERNAME, NOME_USUARIO, COURSEID, SHORTNAME,
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
       JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo
       JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
       JOIN mdl_course tc ON tc.shortname = cd.shortname
	   LEFT JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc
	   LEFT JOIN kls_lms_turmas t on t.id_turma=pt.id_turma
      WHERE pcd.id_papel = 1 AND cd.shortname='ED_DDC'
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

update tbl_retorno_nt2_ddc a
set RECURSOS_ACESSADOS=(
   select count(distinct o.cmid)
   from mdl_logstore_standard_log l
   JOIN tbl_ddc_obrigatorio o on o.cmid=l.contextinstanceid
   where userid=a.userid and
   		contextlevel=70 and
   		contextinstanceid=o.cmid
);		

update tbl_retorno_nt2_ddc set nota=10 where RECURSOS_ACESSADOS=V_RECURSOS_OBRIGATORIOS;
			
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
