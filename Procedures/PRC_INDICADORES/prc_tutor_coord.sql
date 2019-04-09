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

-- Copiando estrutura para procedure prod_kls.prc_tutor_coord
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `prc_tutor_coord`()
MAIN: BEGIN  

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

  
  DECLARE VMin  int default 0;
  DECLARE VMin2 int default 0;
  DECLARE VMax  int default 0;
  
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);

	   END;
         
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_tutor_coord', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
  
  TRUNCATE TABLE sgt_tutor_coord;
  TRUNCATE TABLE sgt_tutor_coordDT;
  
  
  DROP TABLE IF EXISTS tbl_coordenadores;
  CREATE TABLE tbl_coordenadores (
  		id_usuario int(11),
  		id int(11),
  		nome varchar(100),
  		id_area_formacao int(11)
  	);
  	alter table tbl_coordenadores add index idx_qr1 (id_usuario, id_area_formacao); 
  
  INSERT INTO tbl_coordenadores 
						SELECT uf.id_usuario, ucoord.id, ucoord.nome, afc.id_area_formacao
						  FROM mdl_sgt_usuario_formacao uf
						 INNER JOIN mdl_sgt_af_conhecimento afc ON afc.id_area_formacao = uf.id_area_formacao
						 INNER JOIN mdl_sgt_usuario_ac uac ON uac.id_area_conhecimento = afc.id_area_conhecimento
						 INNER JOIN mdl_sgt_usuario ucoord ON ucoord.id = uac.id_usuario 
						 WHERE ucoord.id_perfil = 2
						   AND ucoord.`status` = 'A'
						 GROUP BY uf.id_usuario, ucoord.id, ucoord.nome, afc.id_area_formacao;
  
  
  INSERT INTO sgt_tutor_coord 
  SELECT distinct 
  			CASE  
			  		 WHEN um.mdl_user_id IS NOT NULL 
                THEN 'Sim'
          ELSE 'Nao'
          END AS tutoralocado,
          
          CASE  WHEN m.sigla = 'EST' 
                  THEN 'EST, ED 8, 9 e 10'
                WHEN m.sigla = 'DI' 
                  THEN 'DI, ED 5, 6 e 7'
                WHEN m.sigla = 'DIB' 
                  THEN 'DIB, ED 5, 6 e 7'
          ELSE m.sigla
          END AS produto,
          
          FROM_UNIXTIME(IF(us.timecreated = 0, null, us.timecreated),'%d/%m/%Y %H:%i:%s') as timecreated,
          us.username, 
          u.nome, 
          u.email,
          
          
			 '' AS area_formacao,
          

			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'ED') as Limite_ED ,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'DI') as Limite_DI,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'DIB') as Limite_DIB,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'TCC') as Limite_TCC,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'NPJ') as Limite_NPJ,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'EST') as Limite_EST,
			(select c.qtd_alunos
				from mdl_sgt_usuario_capacidade c  
				join mdl_sgt_modelo m on m.id = c.id_modelo
				where u.id = c.id_usuario
				and m.sigla = 'HIB') as Limite_HIB,				
          
               u.qtde_alunos,
           
			 IFNULL(tc.nome, '') AS nome_coord,
          concat('Grupo_', us.username) as nome_grupo,
          us.id,
          
			 IFNULL(tc.id, '') AS id_coordenador,
          u.id as sgt_user_id
  FROM mdl_sgt_usuario u
       JOIN mdl_sgt_usuario_modelo umo ON umo.id_usuario = u.id
       JOIN mdl_sgt_modelo m           ON m.id = umo.id_modelo
       JOIN mdl_sgt_usuario_moodle um  ON um.id_usuario_id = u.id
       JOIN mdl_user us            ON us.id = um.mdl_user_id
       JOIN mdl_sgt_usuario_formacao uf ON uf.id_usuario = u.id
       LEFT JOIN tbl_coordenadores tc ON tc.id_usuario = u.id 
		 										 AND tc.id_area_formacao = uf.id_area_formacao
  WHERE u.id_perfil = 1;
	 
  
  UPDATE sgt_tutor_coord fa
     SET fa.area_formacao = ( SELECT group_concat(distinct uf.nivel,'.',af.dsc_area_formacao order by uf.nivel separator ', ') AS area_formacao
                                    FROM mdl_sgt_usuario_formacao uf
                                    JOIN mdl_sgt_area_formacao af on af.id = uf.id_area_formacao
                                WHERE uf.id_usuario = fa.sgt_user_id);
  
    
    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='DI'
     GROUP BY tmp.nome_grupo, u.username;

    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='DIBV'
     GROUP BY tmp.nome_grupo, u.username;

    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='EDV'
     GROUP BY tmp.nome_grupo, u.username;
     
    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )	       
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='ESTV'
     GROUP BY tmp.nome_grupo, u.username;


    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='NPJV'
     GROUP BY tmp.nome_grupo, u.username ;     


    INSERT INTO sgt_tutor_coordDT(shortname,
                                  fullname,
                                  cd_instituicao,
                                  nm_ies,
                                  cd_curso,
                                  nm_curso,
                                  username,
                                  nm_pessoa,
                                  nome_grupo )
    SELECT  DISTINCT 
            cu.shortname, 
            cu.fullname, 
            i.cd_instituicao, 
            i.nm_ies, 
            c.cd_curso, 
            c.nm_curso, 
            u.username, 
            p.nm_pessoa, 
            tmp.nome_grupo
      FROM anh_aluno_matricula anh
      	 JOIN mdl_course cu on cu.shortname=anh.shortname
          JOIN mdl_user u               ON anh.username=u.username and u.mnethostid=1
          JOIN mdl_groups g             	ON g.courseid = cu.id and anh.GRUPO=g.description
          JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pes_cur_disc=anh.ID_PES_CUR_DISC
          JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina=pcd.id_curso_disciplina
          JOIN kls_lms_curso c 			 ON c.id_curso=cd.id_curso
          JOIN kls_lms_instituicao i 	 ON i.id_ies=c.id_ies
          JOIN kls_lms_pessoa p         ON p.id_pessoa=pcd.id_pessoa
          JOIN sgt_tutor_coord tmp      ON tmp.nome_grupo = g.name
		WHERE anh.TUTOR IS NOT NULL and anh.sigla='TCCV'
     GROUP BY tmp.nome_grupo, u.username;
  
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_tutor_coord)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
