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

-- Copiando estrutura para procedure prod_kls.PRC_LIMPA_GRUPOS
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_LIMPA_GRUPOS`()
BEGIN
	
	DECLARE v_finished 	 TINYINT DEFAULT 0;   
   DECLARE GRP_ID_		 BIGINT(10);
   
	DECLARE USERID_		 BIGINT(10);
	DECLARE USERNAME_		 VARCHAR(100);
	DECLARE COURSEID_		 BIGINT(10);
	DECLARE SHORTNAME_	 VARCHAR(255);
   DECLARE ENROLID_		 BIGINT(10);
   
   DECLARE CONTEXTID_	 BIGINT(10);
   DECLARE ROLEID_		 BIGINT(10);
   
   DECLARE QTD_GRP_		 INT(10) DEFAULT 0;
	

	DECLARE c_grupos CURSOR FOR
SELECT g.id
  FROM mdl_groups g
  JOIN mdl_course c on c.id=g.courseid
  LEFT JOIN mdl_groups_members gm ON gm.groupid = g.id
  WHERE c.shortname not regexp binary '^SALA_PROF'
GROUP BY g.id
HAVING COUNT(DISTINCT gm.userid) = 0;

	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET v_finished = 1;
        
   
	SET QTD_GRP_ = 0;     
	
	OPEN c_grupos;
	  
		get_GRUPOS: LOOP
		
		FETCH c_grupos INTO GRP_ID_;
										 
		IF v_finished = 1 THEN 
			LEAVE get_GRUPOS;
		END IF;
		
			DELETE g FROM mdl_groups g WHERE g.id = GRP_ID_;
			
			SET QTD_GRP_ = QTD_GRP_ + 1;
		
		END LOOP get_GRUPOS;
 
 	CLOSE c_grupos;
	
	INSERT INTO tbl_prc_log
				SET BANCO = DATABASE(),
					 OBJETO = 'PRC_LIMPA_GRUPOS',
					 AUTOR = USER(),
					 INICIO = SYSDATE(),
					 FIM = SYSDATE(),
			 		 `STATUS` = 'GRUPO APAGADO', 
			 		 REGISTROS = QTD_GRP_,
					 INFO = 'GRUPOS VAZIOS';		 



/* comentado em 02/04/2019 - Marcelo Veras - Reduzir o tempo da carga
drop table if exists tmp_grupos_tutores;
create temporary table tmp_grupos_tutores (
	shortname varchar(50), grupo varchar(50)
);
alter table tmp_grupos_tutores add primary key (shortname, grupo);
insert into tmp_grupos_tutores
select distinct
		shortname, grupo
	from anh_aluno_matricula 
	where grupo REGEXP 'GRUPO_TUTOR';

delete gm
from mdl_groups g 
join mdl_course c on c.id=g.courseid 
join mdl_groups_members gm on gm.groupid=g.id
left join tmp_grupos_tutores t on t.shortname=c.shortname and t.grupo=g.description
where g.description  REGEXP 'GRUPO_TUTOR' and t.grupo is null;
*/

/* Novo trecho 02/04/2019 */

drop table if exists tmp_grupos_tutores;
create temporary table tmp_grupos_tutores (
	courseid BIGINT(10), groupid BIGINT(10)
);
alter table tmp_grupos_tutores add primary key (groupid);
insert into tmp_grupos_tutores
select distinct
		c.id, g.id
	from anh_aluno_matricula anh
	JOIN mdl_course c ON c.shortname=anh.SHORTNAME
	JOIN mdl_groups g on g.courseid=c.id AND g.description=anh.GRUPO
	where grupo REGEXP 'GRUPO_TUTOR';

delete gm
from mdl_groups g
JOIN mdl_groups_members gm ON g.id=gm.groupid
left join tmp_grupos_tutores t on t.groupid=g.id
WHERE 
		g.description REGEXP 'GRUPO_TUTOR' and 
		t.groupid is NULL;

/* Fim do novo trecho */

delete g
from mdl_groups g 
join mdl_course c on c.id=g.courseid 
left join tmp_grupos_tutores t on t.shortname=c.shortname and t.grupo=g.description
where g.description  REGEXP 'GRUPO_TUTOR' and t.grupo is null;


drop table if exists tmp_cursos_tutores;
create temporary table tmp_cursos_tutores (
	shortname varchar(50), tutor varchar(50)
);
alter table tmp_cursos_tutores add primary key (shortname, tutor);
insert into tmp_cursos_tutores
select distinct
		shortname, tutor
	from anh_aluno_matricula 
	where grupo REGEXP 'GRUPO_TUTOR'
;

delete ra
from tbl_mdl_user u
join mdl_role_assignments ra on ra.userid=u.id
join mdl_context co on co.id=ra.contextid
join mdl_course c on c.id=co.instanceid
left join tmp_cursos_tutores t on t.shortname=c.shortname and t.tutor=u.username 
where u.username REGEXP 'TUTOR_' and c.shortname<>'KLS' and u.mnethostid=1 and t.tutor is null;

delete ue
from tbl_mdl_user u
join mdl_user_enrolments ue on ue.userid=u.id
join mdl_enrol e on e.id=ue.enrolid and e.enrol='manual'
join mdl_course c on c.id=e.courseid and c.id>1
left join tmp_cursos_tutores t on t.shortname=c.shortname and t.tutor=u.username 
where u.username REGEXP 'TUTOR_' and c.shortname<>'KLS' and u.mnethostid=1 and t.tutor is null;

	INSERT INTO tbl_prc_log
				SET BANCO = DATABASE(),
					 OBJETO = 'PRC_LIMPA_GRUPOS',
					 AUTOR = USER(),
					 INICIO = SYSDATE(),
					 FIM = SYSDATE(),
			 		 `STATUS` = 'BLOQUEIOS DE TUTORES EM DISCIPLINAS', 
			 		 REGISTROS = ROW_COUNT(),
					 INFO = 'BLOQUEIOS DE TUTORES EM DISCIPLINAS';

drop table if exists tmp_grupos_tutores;
drop table if exists tmp_cursos_tutores;

	


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
