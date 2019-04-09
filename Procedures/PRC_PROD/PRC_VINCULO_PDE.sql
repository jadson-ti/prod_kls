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

-- Copiando estrutura para procedure prod_kls.PRC_VINCULO_PDE
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_VINCULO_PDE`()
BEGIN


INSERT INTO mdl_teaching_plan_discipline (erp_discipline_id, siscon_discipline_id)
SELECT DISTINCT
 d.id_disciplina,
 UC.ID_UC siscon_discipline_id
FROM kls_lms_disciplina d
JOIN SISCON_UNIDADE_CURRICULAR UC ON UC.ID_UC_ORIGINAL=d.cd_disciplina
LEFT JOIN mdl_teaching_plan_discipline tpd on tpd.erp_discipline_id=d.id_disciplina 
WHERE d.fl_etl_atu REGEXP '[NA]' and tpd.id is null;



INSERT INTO mdl_teaching_plan_discipline (siscon_discipline_id,erp_discipline_id)
SELECT DISTINCT
  UC.ID_UC, d.id_disciplina
FROM SISCON_UNIDADE_CURRICULAR UC 
JOIN kls_lms_curso_disciplina cd on cd.shortname REGEXP '^ESTV' and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
LEFT JOIN mdl_teaching_plan_discipline pd on pd.erp_discipline_id=d.id_disciplina 
WHERE UC.NOME_UNIDADE_CURRICULAR REGEXP 'EST.*SUPORTE AVA$' AND pd.id IS NULL;

INSERT INTO mdl_teaching_plan_discipline (siscon_discipline_id,erp_discipline_id)
SELECT DISTINCT
  UC.ID_UC, d.id_disciplina
FROM SISCON_UNIDADE_CURRICULAR UC 
JOIN kls_lms_curso_disciplina cd on cd.shortname REGEXP '^TCCV' and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
LEFT JOIN mdl_teaching_plan_discipline pd on pd.erp_discipline_id=d.id_disciplina
WHERE UC.NOME_UNIDADE_CURRICULAR REGEXP 'TRABALHO.*SUPORTE AVA$' AND pd.id IS NULL;

INSERT INTO mdl_teaching_plan_discipline (siscon_discipline_id,erp_discipline_id)
SELECT DISTINCT 
  UC.ID_UC, d.id_disciplina
FROM SISCON_UNIDADE_CURRICULAR UC 
JOIN kls_lms_curso_disciplina cd on cd.shortname REGEXP '^NPJ' and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
LEFT JOIN mdl_teaching_plan_discipline pd on pd.erp_discipline_id=d.id_disciplina 
WHERE UC.NOME_UNIDADE_CURRICULAR REGEXP 'NÚCLEO.*SUPORTE AVA$' AND pd.id IS NULL;

INSERT INTO mdl_teaching_plan_discipline (siscon_discipline_id,erp_discipline_id)
SELECT DISTINCT
  UC.ID_UC, d.id_disciplina
FROM SISCON_UNIDADE_CURRICULAR UC 
JOIN kls_lms_curso_disciplina cd on cd.shortname REGEXP '^TCCP' and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
LEFT JOIN mdl_teaching_plan_discipline pd on pd.erp_discipline_id=d.id_disciplina 
WHERE UC.NOME_UNIDADE_CURRICULAR='TRABALHO DE CONCLUSÃO DE CURSO' AND pd.id IS NULL;

INSERT INTO mdl_teaching_plan_discipline (siscon_discipline_id,erp_discipline_id)
SELECT DISTINCT
  UC.ID_UC, d.id_disciplina
FROM SISCON_UNIDADE_CURRICULAR UC 
JOIN kls_lms_curso_disciplina cd on cd.shortname REGEXP '^ESTP' and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
LEFT JOIN mdl_teaching_plan_discipline pd on pd.erp_discipline_id=d.id_disciplina 
WHERE UC.NOME_UNIDADE_CURRICULAR='ESTÁGIO SUPERVISIONADO OBRIGATÓRIO' AND pd.id IS NULL;

INSERT INTO mdl_teaching_plan_discipline (erp_discipline_id, siscon_discipline_id)
SELECT DISTINCT
 d2.id_disciplina,
 MAX(tpd1.siscon_discipline_id)
FROM kls_lms_disciplina d
JOIN mdl_teaching_plan_discipline tpd1 on tpd1.erp_discipline_id=d.id_disciplina 
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso_disciplina cd2 on cd2.shortname=cd.shortname and cd2.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d2 on d2.id_disciplina=cd2.id_disciplina and d2.fl_etl_atu REGEXP '[NA]'
JOIN mdl_course co on co.shortname = cd.shortname
LEFT JOIN mdl_teaching_plan_discipline tpd on tpd.erp_discipline_id=d2.id_disciplina 
WHERE d.fl_etl_atu REGEXP '[NA]' and tpd.id is null
GROUP BY d2.id_disciplina;



INSERT INTO mdl_teaching_plan_discipline (erp_discipline_id, siscon_discipline_id)
SELECT DISTINCT
 d.id_disciplina,
 MAX(UC.ID_UC) siscon_discipline_id
FROM kls_lms_disciplina d
JOIN SISCON_UNIDADE_CURRICULAR UC ON UC.NOME_UNIDADE_CURRICULAR=d.ds_disciplina
LEFT JOIN mdl_teaching_plan_discipline tpd on tpd.erp_discipline_id=d.id_disciplina 
WHERE d.fl_etl_atu REGEXP '[NA]' and tpd.id is null
GROUP BY  d.id_disciplina;

INSERT INTO mdl_teaching_plan_discipline (erp_discipline_id, siscon_discipline_id)
SELECT DISTINCT
 d.id_disciplina,
 UC.ID_UC siscon_discipline_id
FROM kls_lms_disciplina d
JOIN SISCON_UNIDADE_CURRICULAR UC ON UC.NOME_UNIDADE_CURRICULAR=d.ds_disciplina AND UC.TIPO_SISCON=2
LEFT JOIN mdl_teaching_plan_discipline tpd on tpd.erp_discipline_id=d.id_disciplina 
WHERE d.fl_etl_atu REGEXP '[NA]' and tpd.id is null;


INSERT INTO mdl_teaching_plan_discipline (erp_discipline_id, siscon_discipline_id)
SELECT 
DISTINCT
 d.id_disciplina,
 MAX(UC.ID_UC) siscon_discipline_id
FROM anh_shortname_exc anh
JOIN kls_lms_curso_disciplina cd on cd.shortname=anh.shortname and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_disciplina d on d.ds_disciplina=anh.fullname and d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP'[NA]'
JOIN mdl_course c on c.shortname=cd.shortname 
JOIN SISCON_UNIDADE_CURRICULAR UC ON UC.NOME_UNIDADE_CURRICULAR=c.fullname 
LEFT JOIN mdl_teaching_plan_discipline tpd on tpd.erp_discipline_id=d.id_disciplina 
WHERE tpd.id is null
GROUP BY  d.id_disciplina;





DROP TABLE IF EXISTS tmp_planos_atuais;
CREATE TABLE tmp_planos_atuais (
  tp_id BIGINT(10),
  cd_instituicao VARCHAR(30),
  shortname VARCHAR(55),
  carga_horaria BIGINT(10),
  tipo_avaliacao VARCHAR(10),
  professores VARCHAR(255)
);

INSERT INTO tmp_planos_atuais 
SELECT * FROM (
SELECT 
  MIN(p.id) as tp_id,
  i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao,
  (  
    select group_concat(distinct p.nm_pessoa order by p.nm_pessoa) as professores
    from kls_lms_pessoa_turma pt
    join kls_lms_turmas t1 on t1.id_turma=pt.id_turma and t1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=pt.id_pes_cur_disc and pcd.id_papel=3 and pcd.fl_etl_atu REGEXP '[NA]' 
    join kls_lms_curso_disciplina cd1 on cd1.id_curso_disciplina=pcd.id_curso_disciplina and cd1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_disciplina d1 on d1.id_disciplina=cd1.id_disciplina and d1.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_curso c1 on c1.id_curso=cd1.id_curso and c1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_instituicao i1 on i1.id_ies=c1.id_ies
    join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
    where 
         t1.id_turma=t.id_turma and
        pt.fl_etl_atu REGEXP '[NA]'
  ) as professores  
FROM mdl_teaching_plan p
JOIN mdl_teaching_plan_class tc on (tc.tp_id=p.id)
JOIN kls_lms_turmas t on (t.id_turma=tc.erp_class_id)
join kls_lms_curso_disciplina cd on (cd.id_curso_disciplina=t.id_curso_disciplina)
join kls_lms_disciplina d on (d.id_disciplina=cd.id_disciplina)
join kls_lms_curso c on (c.id_curso=cd.id_curso)
join kls_lms_instituicao i on (i.id_ies=c.id_ies)
where 
  cd.shortname REGEXP '^AM[IP]|^(EST|TCC)P|^DIB|^HAM' AND 
  p.active='yes' 
group by i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao,
  (  
    select group_concat(distinct p.nm_pessoa order by p.nm_pessoa) as professores
    from kls_lms_pessoa_turma pt
    join kls_lms_turmas t1 on t1.id_turma=pt.id_turma and t1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=pt.id_pes_cur_disc and pcd.id_papel=3 and pcd.fl_etl_atu REGEXP '[NA]' 
    join kls_lms_curso_disciplina cd1 on cd1.id_curso_disciplina=pcd.id_curso_disciplina and cd1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_disciplina d1 on d1.id_disciplina=cd1.id_disciplina and d1.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_curso c1 on c1.id_curso=cd1.id_curso and c1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_instituicao i1 on i1.id_ies=c1.id_ies
    join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
    where 
          t1.id_turma=t.id_turma and
        pt.fl_etl_atu REGEXP '[NA]'
  )
) A WHERE professores IS NOT NULL;


INSERT INTO tmp_planos_atuais 
SELECT * FROM (
SELECT 
  MIN(p.id) as tp_id,
  i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao,
  NULL as professores  
FROM mdl_teaching_plan p
JOIN mdl_teaching_plan_class tc on (tc.tp_id=p.id)
JOIN kls_lms_turmas t on (t.id_turma=tc.erp_class_id)
join kls_lms_curso_disciplina cd on (cd.id_curso_disciplina=t.id_curso_disciplina)
join kls_lms_disciplina d on (d.id_disciplina=cd.id_disciplina)
join kls_lms_curso c on (c.id_curso=cd.id_curso)
join kls_lms_instituicao i on (i.id_ies=c.id_ies)
where 
  cd.shortname REGEXP '^(DI\_)|^(EST|TCC)V|^NPJ[12]' AND 
  p.active='yes' 
group by i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao
) A ;


DROP TABLE IF EXISTS tmp_turmas_sem_vinculo;
CREATE TABLE tmp_turmas_sem_vinculo (  
  id_turma BIGINT(10),
  cd_instituicao VARCHAR(30),
  shortname VARCHAR(55),
  carga_horaria BIGINT(10),
  tipo_avaliacao VARCHAR(10),
  professores VARCHAR(500)
);  

INSERT INTO tmp_turmas_sem_vinculo 
SELECT * FROM (
SELECT DISTINCT
  t.id_turma,
  i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao,
  (  
    select group_concat(distinct p.nm_pessoa order by p.nm_pessoa) as professores
    from kls_lms_pessoa_turma pt
    join kls_lms_turmas t1 on t1.id_turma=pt.id_turma and t1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=pt.id_pes_cur_disc and pcd.id_papel=3 and pcd.fl_etl_atu REGEXP '[NA]' 
    join kls_lms_curso_disciplina cd1 on cd1.id_curso_disciplina=pcd.id_curso_disciplina and cd1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_disciplina d1 on d1.id_disciplina=cd1.id_disciplina and d1.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_curso c1 on c1.id_curso=cd1.id_curso and c1.fl_etl_atu REGEXP '[NA]'
    join kls_lms_instituicao i1 on i1.id_ies=c1.id_ies
    join kls_lms_pessoa p on p.id_pessoa=pcd.id_pessoa and p.fl_etl_atu REGEXP '[NA]'
    where 
         t1.id_turma=t.id_turma and
        pt.fl_etl_atu REGEXP '[NA]'
  ) as professores  
FROM kls_lms_turmas t 
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_instituicao i on i.id_ies=c.id_ies
join mdl_course mc on mc.shortname=cd.shortname 
left join mdl_teaching_plan_class tc on tc.erp_class_id=t.id_turma
where 
  cd.shortname REGEXP '^AM[IP]|^(EST|TCC)P|^DIB|^HAM' AND 
  t.fl_etl_atu REGEXP '[NA]'  AND
  tc.id is null AND
  t.tipo_avaliacao IS NOT NULL
) A WHERE professores IS NOT NULL;

INSERT INTO tmp_turmas_sem_vinculo 
SELECT DISTINCT
  t.id_turma,
  i.cd_instituicao, 
  cd.shortname, 
  cd.carga_horaria, 
  t.tipo_avaliacao,
  NULL as professores  
FROM kls_lms_turmas t 
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina and cd.fl_etl_atu REGEXP '[NA]'
join kls_lms_disciplina d on d.id_disciplina=cd.id_disciplina and d.fl_etl_atu REGEXP '[NA]'
join kls_lms_curso c on c.id_curso=cd.id_curso
join kls_lms_instituicao i on i.id_ies=c.id_ies
join mdl_course mc on mc.shortname=cd.shortname 
left join mdl_teaching_plan_class tc on tc.erp_class_id=t.id_turma
where 
  cd.shortname REGEXP '^(DI\_)|^(EST|TCC)V|^NPJ[12]' AND 
  t.fl_etl_atu REGEXP '[NA]'  AND
  tc.id is null AND
  t.tipo_avaliacao IS NOT NULL;

insert into mdl_teaching_plan_class (erp_class_id, tp_id)
select distinct
  a.id_turma, MIN(b.tp_id)
from tmp_turmas_sem_vinculo a
join tmp_planos_atuais b on 
                    a.cd_instituicao=b.cd_instituicao and
                   a.shortname=b.shortname and
                   a.carga_horaria=b.carga_horaria and
                   a.tipo_avaliacao=b.tipo_avaliacao and 
                   (
                     (a.shortname REGEXP '^(DI\_)|^(EST|TCC)V|^NPJ[12]')
                     OR
                     (a.shortname REGEXP '^AM[IP]|^(EST|TCC)P|^DIB|^HAM' AND a.professores=b.professores)
                   )
GROUP BY id_turma;

insert into mdl_teaching_plan_class (erp_class_id, tp_id)
select distinct
  a.id_turma, MIN(b.tp_id)
from tmp_turmas_sem_vinculo a
join tmp_planos_atuais b on a.cd_instituicao=b.cd_instituicao and
                   a.shortname=b.shortname and
                   a.carga_horaria=b.carga_horaria and
                   a.tipo_avaliacao=b.tipo_avaliacao and 
                   (
                     (a.shortname REGEXP '^(DI\_)|^(EST|TCC)V|^NPJ[12]')
                     OR
                     (a.shortname REGEXP '^AM[IP]|^(EST|TCC)P|^DIB|^HAM' AND a.professores=b.professores)
                   )
GROUP BY id_turma;

DROP TABLE IF EXISTS tmp_novos_pde;
set @proximo_pde:=coalesce((select max(id) from mdl_teaching_plan),0);
create temporary table tmp_novos_pde as
select 
  @proximo_pde:=@proximo_pde+1 as tp_id,
  group_concat(t.id_turma) turmas,
  t.cd_instituicao, 
  t.shortname, 
  t.carga_horaria, 
  t.tipo_avaliacao, 
  t.professores
from tmp_turmas_sem_vinculo t
LEFT JOIN mdl_teaching_plan_class tp ON t.id_turma = tp.erp_class_id
WHERE tp.id IS NULL
group by t.cd_instituicao, t.shortname, t.carga_horaria, t.tipo_avaliacao, t.professores;

INSERT INTO mdl_teaching_plan (id, parent_id, status, active, creation_date)
SELECT DISTINCT tp_id, 0, 'waiting_for_elaboration', 'yes', now()
FROM tmp_novos_pde a;

INSERT INTO mdl_teaching_plan_class (erp_class_id, tp_id) 
SELECT 
  t.id_turma,
  a.tp_id
FROM tmp_novos_pde a
JOIN kls_lms_turmas t on FIND_IN_SET(t.id_turma, a.turmas);

UPDATE mdl_teaching_plan tp
JOIN mdl_teaching_plan_class tpc on tpc.tp_id=tp.id
JOIN kls_lms_turmas t on t.id_turma=tpc.erp_class_id
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=t.id_curso_disciplina
SET siscon_discipline_id = (SELECT tpd.siscon_discipline_id
                              FROM mdl_teaching_plan_discipline tpd
                             WHERE tpd.erp_discipline_id=cd.id_disciplina
                             ORDER BY tpd.id DESC
                             LIMIT 1

);

DROP TABLE IF EXISTS tmp_turmas_sem_vinculo;
DROP TABLE IF EXISTS tmp_novos_pde;  

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
