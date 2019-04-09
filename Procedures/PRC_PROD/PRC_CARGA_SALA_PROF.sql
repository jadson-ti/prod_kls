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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_SALA_PROF
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_SALA_PROF`()
BEGIN
drop table if exists tmp_carga_sala_professor;

create table tmp_carga_sala_professor (
	userid bigint(10),
	shortname varchar(50),
	grupo varchar(50)
);

insert into tmp_carga_sala_professor
select distinct
	u.id as userid, c.shortname, g.description
from mdl_course c
join mdl_groups g on g.courseid=c.id
join kls_lms_curso_disciplina cd on cd.shortname=g.description and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso kc on 
									kc.id_curso=cd.id_curso and 
									kc.fl_etl_atu REGEXP '[NA]'
								   and kc.cd_agrupamento=replace(c.shortname,'SALA_PROF_','')
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_pessoa_curso pc on pc.id_curso=kc.id_curso and pc.fl_etl_atu REGEXP '[NA]'
join kls_lms_pessoa p on p.id_pessoa=pc.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
join kls_lms_papel pap on pap.id_papel=pc.id_papel 
join mdl_role r on r.id=pap.id_role
join tbl_mdl_user u on u.username=p.login
where 
	c.shortname regexp 'sala_prof' and 
	pap.ds_papel='COORDENADOR DE CURSO';

insert into tmp_carga_sala_professor
select distinct
	u.id,c.shortname, g.description
from mdl_course c
join mdl_groups g on g.courseid=c.id
join kls_lms_curso_disciplina cd on cd.shortname=g.description and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso kc on 
									kc.id_curso=cd.id_curso and 
									kc.fl_etl_atu REGEXP '[NA]'
								   and kc.cd_agrupamento=replace(c.shortname,'SALA_PROF_','')
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_pessoa_curso_disc pcd on pcd.id_curso_disciplina=cd.id_curso_disciplina and pcd.fl_etl_atu REGEXP '[NA]'
join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
join tbl_mdl_user u on u.username=p.login
join kls_lms_papel pap on pap.id_papel=pcd.id_papel 
join mdl_role r on r.id=pap.id_role
where 
	c.shortname regexp 'sala_prof' and 
	pap.ds_papel='PROFESSOR';
	
	   INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
													   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
														GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		0 AS ID_PES_CUR_DISC,
		0 AS ID_PESSOA_TURMA,
		'SPF' AS SIGLA,
		'KHUB' AS ORIGEM,
		u.username AS USERNAME,
		a.shortname AS SHORTNAME,
		'SPF' AS CODIGO_POLO,
		'SPF' AS NOME_POLO,
		g.cd_agrupamento AS CODIGO_CURSO,
		g.ds_agrupamento AS NOME_CURSO,
		'SPF' AS CODIGO_DISCIPLINA,
		c.fullname AS NOME_DISCIPLINA, 
		'NA' AS SERIE, 
		'NA' AS TURNO,
		'NA' AS TURMA,
		c.shortname AS GRUPO,
		'student' AS ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'I' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
	FROM tmp_carga_sala_professor a
	join mdl_course c on c.shortname=a.grupo
	join kls_lms_agrupamento g on g.cd_agrupamento=replace(a.shortname,'SALA_PROF_','')
	join tbl_mdl_user u on u.id=a.userid
	left join anh_academico_matricula anh on anh.SIGLA='SPF' and 
														  anh.username=u.username and
														  anh.SHORTNAME=a.shortname and
														  anh.grupo=a.grupo
	where anh.id IS NULL;
   CALL PRC_CARGA_MATRICULAS;
   
   
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
