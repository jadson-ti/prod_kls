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

-- Copiando estrutura para procedure prod_kls.PRC_ATUALIZA_TMP_ALUNO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_ATUALIZA_TMP_ALUNO`()
BEGIN



DROP TABLE IF EXISTS tmp_report_course;
CREATE TABLE tmp_report_course AS 
select distinct shortname from mdl_course c
join mdl_course_categories cc on c.category = cc.id
where 
shortname REGEXP '^(DI|TCCV|ESTV|ED|NPJ).*' 
and shortname not like '%ADP'
and shortname not like 'ed_eng%'
and cc.name not like '%homol%'
and c.visible = 1;
ALTER TABLE tmp_report_course ADD PRIMARY KEY (shortname);

DROP TABLE IF EXISTS tmp_curso_alunos;
CREATE TABLE tmp_curso_alunos AS
		   select cd.shortname, count(1) as qtd
			from kls_lms_pessoa_curso_disc pcd
			inner join kls_lms_pessoa p on p.id_pessoa = pcd.id_pessoa and p.fl_etl_atu <> 'E'
			inner join kls_lms_curso_disciplina cd on pcd.id_curso_disciplina = cd.id_curso_disciplina and cd.fl_etl_atu <> 'E'
			inner join tmp_report_course t on t.shortname=cd.shortname 
			inner join kls_lms_disciplina d on d.id_disciplina = cd.id_disciplina
			and d.fl_etl_atu <> 'E'
			where 
			pcd.fl_etl_atu <> 'E' and pcd.id_papel = 1
			group by cd.shortname;
			
			
ALTER TABLE tmp_curso_alunos ADD PRIMARY KEY (shortname);
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
