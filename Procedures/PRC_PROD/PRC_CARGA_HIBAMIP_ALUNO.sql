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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_HIBAMIP_ALUNO
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_CARGA_HIBAMIP_ALUNO`()
BEGIN

DELETE FROM anh_import_aluno_curso PARTITION (HAMIP) WHERE STATUS IS NULL;



DROP TABLE IF EXISTS alunos_hibami_mdl;
CREATE TEMPORARY TABLE alunos_hibami_mdl AS SELECT DISTINCT md5(CONCAT(USERNAME, SHORTNAME, GRUPO)) AS CHAVE
FROM anh_aluno_matricula PARTITION (HAMIP) ;
ALTER TABLE alunos_hibami_mdl ADD PRIMARY KEY pk_shortname (chave);

DROP TABLE IF EXISTS alunos_hibami_kls;
CREATE TEMPORARY TABLE alunos_hibami_kls AS
    SELECT DISTINCT md5(CONCAT(p.login, cd.shortname,t.shortname)) AS CHAVE
    FROM kls_lms_pessoa p
    JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa AND pcd.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA  AND cd.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc and pt.fl_etl_atu<>'E'
    JOIN kls_lms_turmas t on t.id_turma=pt.id_turma and t.fl_etl_atu<>'E'
    JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
    JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
    JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina AND d.FL_ETL_ATU REGEXP '[NA]'
    JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel AND pap.ds_papel='ALUNO'
    JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='HIB'
    JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1
where p.FL_ETL_ATU != 'E' and cd.shortname regexp '^HAMI' ;
ALTER TABLE alunos_hibami_kls ADD PRIMARY KEY pk_shortname (chave);    



DELETE t1
FROM alunos_hibami_mdl t1
JOIN alunos_hibami_kls t2 on t1.chave=t2.chave;



       INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
                                                       CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO,
                                                        GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA)
        SELECT
        DISTINCT
        0 AS ID_PESSOA_CURSO,
        anh.ID_PES_CUR_DISC,
        anh.ID_PESSOA_TURMA AS ID_PESSOA_TURMA,
        'HAMIP' AS SIGLA,
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
    FROM anh_aluno_matricula PARTITION (HAMIP)  anh
    JOIN anh_import_aluno_curso iac on iac.ID=anh.id_matricula_atual
    JOIN alunos_hibami_mdl b on b.chave=md5(concat(anh.username,anh.shortname,anh.grupo));
    

    
CALL PRC_CARGA_MATRICULAS;


DELETE anh
FROM anh_aluno_matricula PARTITION (HAMIP)  anh
JOIN anh_import_aluno_curso PARTITION (HAMIP)  iac on anh.id_matricula_atual=iac.id
JOIN alunos_hibami_mdl b on b.chave=md5(concat(anh.username,anh.shortname,anh.grupo));





DROP TABLE IF EXISTS alunos_hibami_mdl;
CREATE TEMPORARY TABLE alunos_hibami_mdl AS SELECT DISTINCT md5(CONCAT(USERNAME, SHORTNAME, GRUPO)) AS CHAVE
FROM anh_aluno_matricula PARTITION (HAMIP) ;
ALTER TABLE alunos_hibami_mdl ADD PRIMARY KEY pk_shortname (chave);




DELETE t1
FROM alunos_hibami_kls t1
JOIN alunos_hibami_mdl t2 on t1.chave=t2.chave;



       INSERT INTO anh_import_aluno_curso (ID_PESSOA_CURSO,ID_PES_CUR_DISC, ID_PESSOA_TURMA,SIGLA,ORIGEM,USERNAME,SHORTNAME,CODIGO_POLO,NOME_POLO,
                                                       CODIGO_CURSO,NOME_CURSO,CODIGO_DISCIPLINA,NOME_DISCIPLINA,SERIE_ALUNO,TURNO_CURSO,TURMA_ALUNO,
                                                        GRUPO,ROLE, DATA_IMPORTACAO,SITUACAO, STATUS,NOVA_TENTATIVA)
        SELECT
        DISTINCT
        0 AS ID_PESSOA_CURSO,
        pcd.ID_PES_CUR_DISC,
        pt.id_pes_turma_disciplina AS ID_PESSOA_TURMA,
        'HAMIP' AS SIGLA,
        'KHUB' AS ORIGEM,
        p.login AS USERNAME,
        cd.SHORTNAME AS SHORTNAME,
        i.cd_instituicao AS CODIGO_POLO,
        i.nm_ies AS NOME_POLO,
        c.cd_agrupamento AS CODIGO_CURSO,
        c.nm_curso AS NOME_CURSO,
        d.cd_disciplina AS CODIGO_DISCIPLINA,
        d.ds_disciplina AS NOME_DISCIPLINA,
        t.termo_turma AS SERIE,
        c.turno AS TURNO,
        t.cd_turma AS TURMA,
        t.SHORTNAME AS GRUPO,
        'student' AS ROLE,
        date_format(now(),'%Y-%m-%d') AS DATA_IMPORTACAO,
       'I' AS SITUACAO,
        NULL AS STATUS,
        NULL AS NOVA_TENTATIVA
    FROM kls_lms_pessoa p
    JOIN kls_lms_pessoa_curso_disc pcd ON pcd.ID_PESSOA=p.id_pessoa
    JOIN kls_lms_curso_disciplina cd on cd.ID_CURSO_DISCIPLINA=pcd.ID_CURSO_DISCIPLINA and cd.fl_etl_atu REGEXP '[NA]'
    JOIN kls_lms_curso c ON c.id_curso = cd.ID_CURSO AND c.FL_ETL_ATU<>'E'
    JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies AND i.FL_ETL_ATU<>'E'
    JOIN kls_lms_disciplina d ON cd.ID_DISCIPLINA = d.id_disciplina and d.FL_ETL_ATU REGEXP '[NA]'
    JOIN kls_lms_pessoa_turma pt on pt.ID_PES_CUR_DISC=pcd.ID_PES_CUR_DISC and pt.FL_ETL_ATU<>'E'
    JOIN kls_lms_turmas t on t.ID_TURMA=pt.ID_TURMA and t.FL_ETL_ATU<>'E'
    JOIN kls_lms_papel pap ON pap.id_papel = pcd.id_papel
    JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='HIB'
    JOIN tbl_mdl_user u ON u.username=p.login AND u.mnethostid=1
    JOIN mdl_course mdlc on mdlc.shortname=cd.shortname
    JOIN alunos_hibami_kls anh ON anh.chave=md5(CONCAT(p.login,cd.shortname,t.shortname))
  WHERE
          LENGTH(c.cd_agrupamento)>0 AND
       p.FL_ETL_ATU != 'E'  AND
        pap.ds_papel = 'ALUNO' AND
         cd.shortname regexp '^HAMI'
    GROUP BY p.login,cd.shortname,t.shortname;
    


CALL PRC_CARGA_GRUPO;

CALL PRC_CARGA_MATRICULAS;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
