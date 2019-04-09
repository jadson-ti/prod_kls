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

-- Copiando estrutura para procedure prod_kls.prc_aloc_erp_ava
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `prc_aloc_erp_ava`()
BEGIN  

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

  
  DECLARE Vid_pessoa      bigint(20);
  DECLARE Vlogin          varchar(255);
  DECLARE Vmin            INT;
  DECLARE Vmin2           INT;
  DECLARE Vmax            INT;
  DECLARE Vqt             INT;
  
  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_aloc_erp_ava', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
	SET ID_LOG_=LAST_INSERT_ID();
  
  
  TRUNCATE TABLE tmp_sgt_aloc_erp_ava;
  TRUNCATE TABLE tmp_sgt_aloc_erp_ava2;
  
  
  INSERT INTO tmp_sgt_aloc_erp_ava (id_pessoa,
                                cd_instituicao,
                                login,
                                nm_pessoa,
                                cd_disciplina,
                                ds_disciplina,
                                shortname,
                                modelo)
  SELECT DISTINCT
         p.id_pessoa,
         i.cd_instituicao,
         p.login,
         p.nm_pessoa,
         d.cd_disciplina, 
         d.ds_disciplina, 
         cd.shortname,
         
          CASE  WHEN tm.sigla = 'EST' THEN 'EST, ED 8, 9 e 10'
                WHEN tm.sigla = 'DI' THEN 'DI, ED 5, 6 e 7'
                WHEN tm.sigla = 'DIB' THEN 'DIB, ED 5, 6 e 7'
          ELSE tm.sigla
          END AS modelo
         
   FROM kls_lms_pessoa p 
        JOIN kls_lms_pessoa_curso_disc pcd  ON pcd.id_pessoa = p.id_pessoa AND pcd.fl_etl_atu REGEXP '[NA]'
        JOIN kls_lms_curso_disciplina cd    ON cd.id_curso_disciplina = pcd.id_curso_disciplina AND cd.fl_etl_atu REGEXP '[NA]'
        JOIN kls_lms_disciplina d 					ON d.id_disciplina = cd.id_disciplina AND d.fl_etl_atu REGEXP '[NA]'
        JOIN kls_lms_tipo_modelo tm         ON tm.id_tp_modelo = d.id_tp_modelo
		  JOIN kls_lms_curso c                ON c.id_curso = cd.id_curso 
		  JOIN kls_lms_instituicao i          ON i.id_ies = c.id_ies
        JOIN kls_lms_turmas t          ON t.id_curso_disciplina = cd.id_curso_disciplina AND t.fl_etl_atu REGEXP '[NA]'
        JOIN kls_lms_pessoa_turma pt   ON pt.id_turma = t.id_turma  AND pt.id_pes_cur_disc = pcd.id_pes_cur_disc AND pt.fl_etl_atu REGEXP '[NA]'
  		  where p.fl_etl_atu  REGEXP '[NA]'
        AND pcd.id_papel    = 1
        AND p.id_pessoa     > 0;
  
  
  COMMIT;

    
    INSERT INTO tmp_sgt_aloc_erp_ava2 ( id_pessoa, shortname, description, descriptionT)
      SELECT 
		tmp.id_pessoa, tmp.shortname,
      CONCAT_WS(';', c.fullname,g.name) description,
      IFNULL( REPLACE( g.name, 'GRUPO_','' ), '' )
	  
      FROM tmp_sgt_aloc_erp_ava tmp
      JOIN tbl_mdl_user u on u.username=tmp.login
		JOIN tbl_mdl_course c on c.shortname=tmp.shortname 
		JOIN mdl_groups g on g.courseid=c.id
		JOIN mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
		WHERE c.id > 1
		AND c.shortname REGEXP '^DI|^(EST|TCC)V|^NPJ|^ED|^HIB|^HAM'
		AND UPPER(g.name) REGEXP 'TUTOR'
		GROUP BY u.username , c.shortname;
		


    COMMIT;
    
  
  
  
    INSERT INTO tmp_sgt_aloc_erp_ava2 ( id_pessoa, shortname, description, descriptionT)
      SELECT 
		tmp.id_pessoa, tmp.shortname,
      CONCAT_WS(';', c.fullname,g.name) description,
	  	CASE 
			WHEN g.name LIKE '%TUTOR%' THEN 
				REPLACE(g.name, 'GRUPO_','') 
			ELSE '' 
		END
      FROM tmp_sgt_aloc_erp_ava tmp
      JOIN tbl_mdl_user u on u.username=tmp.login
		JOIN tbl_mdl_course c on c.shortname=tmp.shortname 
		JOIN mdl_groups g on g.courseid=c.id
		JOIN mdl_groups_members gm on gm.userid=u.id and gm.groupid=g.id
		WHERE c.id > 1
		AND c.shortname NOT REGEXP '^DI|^(EST|TCC)V|^NPJ|^ED|^HIB|^HAM'
		GROUP BY u.username , c.shortname;
		


    COMMIT;
    
  
  
  COMMIT;
  
  
  DROP TABLE IF EXISTS sgt_aloc_erp_ava;
  
  CREATE TABLE sgt_aloc_erp_ava (
          produto VARCHAR(30),
          cd_instituicao VARCHAR(30),
          login VARCHAR(50),
          nm_pessoa VARCHAR(255),
          cd_disciplina VARCHAR(50),
          ds_disciplina VARCHAR(255),
          shortname varchar(50),
          sala varchar(255),
          nome varchar(255)	
  );


  INSERT INTO sgt_aloc_erp_ava
  SELECT  DISTINCT
          tmp.modelo AS produto,
          tmp.cd_instituicao,
          tmp.login,
          tmp.nm_pessoa,
          tmp.cd_disciplina,
          tmp.ds_disciplina,
          tmp.shortname ,
          SUBSTR(tmp2.description,1,INSTR(tmp2.description,';')-1) as sala,
          u.nome AS tutor
    FROM tmp_sgt_aloc_erp_ava tmp
    LEFT JOIN tmp_sgt_aloc_erp_ava2 tmp2  ON tmp.id_pessoa = tmp2.id_pessoa AND tmp.shortname = tmp2.shortname
	 LEFT JOIN mdl_sgt_usuario_moodle umo ON umo.mdl_username=tmp2.descriptiont
	 LEFT JOIN mdl_sgt_usuario u on u.id=umo.id_usuario_id;
                                                                          
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_aloc_erp_ava)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
