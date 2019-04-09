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

-- Copiando estrutura para procedure prod_kls.PRC_BLOQUEIOS_DUARTE
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_BLOQUEIOS_DUARTE`()
BEGIN
CREATE TEMPORARY TABLE tmp_bloqueios (username VARCHAR(50), shortname VARCHAR(50));

INSERT INTO tmp_bloqueios
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='SISTEMAS DE INFORMAÇÃO' and 
		c.fullname='Sistemas de Informação Gerencial'
union
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='ENGENHARIA ELÉTRICA' and 
		c.fullname like '%Cin_tica%C_lculo de Reatores'
union
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='ENGENHARIA CIVIL' and 
		c.fullname ='Princípios de Telecomunicações'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='ENGENHARIA DE PRODUÇÃO' and 
		c.fullname ='Legislação e Segurança do Trabalho'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='ARQUITETURA' and 
		c.fullname ='Arte Brasileira'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='ADMINISTRAÇÃO' and 
		c.fullname ='Administração e Planejamento do Serviço Social'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='FÍSICA' and 
		c.fullname ='Fisiologia do Exercício'
union
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='CIÊNCIAS AERONÁUTICAS' and 
		c.fullname ='Sistemas Embarcados'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='CIÊNCIAS BIOLÓGICAS' and 
		c.fullname ='Didática: Planejamento e Avaliação'
UNION
select 
	anh.username, anh.shortname
from mdl_sgt_formacao_disciplina fd
join anh_aluno_matricula anh on anh.shortname=fd.shortname
join mdl_sgt_usuario_moodle um on um.mdl_username=anh.tutor
join mdl_sgt_usuario u on u.id=um.id_usuario_id
join mdl_sgt_usuario_formacao uf on uf.id_usuario=u.id and uf.id_area_formacao=fd.id_area_formacao
join mdl_sgt_area_formacao af on af.id=uf.id_area_formacao
join mdl_course c on c.shortname=anh.shortname
where af.dsc_area_formacao='MATEMÁTICA' and 
		c.fullname ='Matemática Financeira';

INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
											   CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO, 
												GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA) 
		SELECT 
		DISTINCT 
		0 AS ID_PESSOA_CURSO,
		anh.ID_PES_CUR_DISC,
		anh.ID_PESSOA_TURMA AS ID_PESSOA_TURMA,
		'DIBP' AS SIGLA,
		'KHUB' AS ORIGEM,
		anh.username AS USERNAME,
		anh.shortname AS SHORTNAME,
		iac.CODIGO_POLO,
		iac.NOME_POLO,
		iac.CODIGO_CURSO,
		iac.NOME_CURSO,
		iac.CODIGO_DISCIPLINA,
		iac.NOME_DISCIPLINA, 
		NULL AS SERIE, 
		NULL AS TURNO,
		NULL AS TURMA,
		iac.GRUPO,
		iac.ROLE, 
		date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
	   'B' AS SITUACAO,
		NULL AS STATUS,
		NULL AS NOVA_TENTATIVA
FROM anh_aluno_matricula anh
JOIN anh_import_aluno_curso iac on iac.ID=anh.id_matricula_atual 
JOIN tmp_bloqueios bloq ON bloq.username=anh.username and bloq.shortname=anh.shortname 
where anh.grupo REGEXP 'TUTOR';

CALL PRC_CARGA_MATRICULAS;

DELETE anh FROM anh_aluno_matricula anh
JOIN tmp_bloqueios bloq ON bloq.username=anh.username and bloq.shortname=anh.shortname 
where anh.grupo REGEXP 'TUTOR';

CALL PRC_LIMPA_GRUPOS;

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where fullname='Sistemas de Informação Gerencial' and
		dsc_area_formacao='SISTEMAS DE INFORMAÇÃO';
		
delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='ENGENHARIA ELÉTRICA' and 
		c.fullname like '%Cin_tica%C_lculo de Reatores';
		
		
delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='ENGENHARIA CIVIL' and 
		c.fullname ='Princípios de Telecomunicações';

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='ENGENHARIA DE PRODUÇÃO' and 
		c.fullname ='Legislação e Segurança do Trabalho';
		
delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='ARQUITETURA' and 
		c.fullname ='Arte Brasileira';
		
		
delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='ADMINISTRAÇÃO' and 
		c.fullname ='Administração e Planejamento do Serviço Social';

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='FÍSICA' and 
		c.fullname ='Fisiologia do Exercício';

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='CIÊNCIAS AERONÁUTICAS' and 
		c.fullname ='Sistemas Embarcados';

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='CIÊNCIAS BIOLÓGICAS' and 
		c.fullname ='Didática: Planejamento e Avaliação';

delete s 
from mdl_course c
join mdl_sgt_formacao_disciplina s on s.shortname=c.shortname
join mdl_sgt_area_formacao f on f.id=s.id_area_formacao
where f.dsc_area_formacao='MATEMÁTICA' and 
		c.fullname ='Matemática Financeira';


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
