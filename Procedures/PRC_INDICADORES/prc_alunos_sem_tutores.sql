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

-- Copiando estrutura para procedure prod_kls.prc_alunos_sem_tutores
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `prc_alunos_sem_tutores`()
BEGIN  

	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

  
  DECLARE Vexiste       INT;
  DECLARE Vshortname    VARCHAR(255);
  DECLARE Vcodigo_polo  VARCHAR(255);
  DECLARE Vcd_curso     VARCHAR(255);
  DECLARE Vexit_loop    BOOLEAN;
  
  
  
  
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_alunos_sem_tutores', user(), sysdate(), 'PROCESSANDO' FROM DUAL;

	SET ID_LOG_=LAST_INSERT_ID();
	
  
  TRUNCATE TABLE sgt_alunos_sem_tutores;
  TRUNCATE TABLE sgt_alunos_sem_tutoresDT;

  
  SELECT COUNT(1) 
    INTO Vexiste
    FROM INFORMATION_SCHEMA.STATISTICS
   WHERE table_schema=DATABASE() 
     AND table_name='sgt_alunos_sem_tutores' 
     AND index_name='sgt_alunos_sem_tutoresIDX';
  
  
  IF Vexiste != 0 THEN
    DROP INDEX sgt_alunos_sem_tutoresIDX ON sgt_alunos_sem_tutores;                                       
  END IF;
  
  
  SELECT COUNT(1) 
    INTO Vexiste
    FROM INFORMATION_SCHEMA.STATISTICS
   WHERE table_schema=DATABASE() 
     AND table_name = 'sgt_alunos_sem_tutoresDT' 
     AND index_name = 'sgt_alunos_sem_tutoresDTIDX';
  
  
  IF Vexiste != 0 THEN
    DROP INDEX sgt_alunos_sem_tutoresDTIDX ON sgt_alunos_sem_tutoresDT;                                       
  END IF;
  
    
    INSERT INTO sgt_alunos_sem_tutores( produto,
                                        shortname,
                                        sala,
                                        area_formacao,
                                        codigo_polo,
                                        nome_polo,
                                        codigo_curso,
                                        nome_curso,
                                        qtd)
    
    SELECT  DISTINCT
            CASE  WHEN i.sigla = 'EST' 
                    THEN 'EST, ED 8, 9 e 10'
                  WHEN i.sigla = 'DI' 
                    THEN 'DI, ED 5, 6 e 7'
                  WHEN i.sigla = 'DIBV' 
                    THEN 'DIB, ED 5, 6 e 7'
            ELSE i.sigla
            END AS produto,
            i.shortname, 
            i.NOME_DISCIPLINA, 
            null as area_formacao,
            i.codigo_polo, 
            i.NOME_POLO, 
            i.CODIGO_CURSO, 
            i.NOME_CURSO,
            count(DISTINCT i.username)
      FROM anh_import_aluno_curso i
     WHERE i.LOG LIKE 'Não foi possível alocar um tutor, aguardando cadastro'
     GROUP BY i.shortname, i.codigo_polo, i.CODIGO_CURSO;
    
    
    INSERT INTO sgt_alunos_sem_tutoresDT( codigo_disciplina,
                                          nome_disciplina,
                                          username,
                                          nm_pessoa, 
                                          data_importacao,
                                          shortname,
                                          codigo_polo,
                                          codigo_curso)
    
     SELECT DISTINCT
            i.CODIGO_DISCIPLINA,
            i.NOME_DISCIPLINA,
            i.username,
            concat(a.FIRSTNAME,' ',a.LASTNAME) as nome_pessoa,
            i.data_importacao,
            i.shortname, 
            i.codigo_polo, 
            i.CODIGO_CURSO
     FROM anh_import_aluno_curso i
     JOIN anh_import_aluno a on i.USERNAME=a.USERNAME
     WHERE i.LOG LIKE 'Não foi possível alocar um tutor, aguardando cadastro'
     GROUP BY i.shortname, i.codigo_polo, i.CODIGO_CURSO, i.username;
  
   
    
    COMMIT;

  
  UPDATE sgt_alunos_sem_tutores ast
     SET ast.area_formacao = (SELECT group_concat(distinct fd.nivel,'.',af.dsc_area_formacao order by fd.nivel separator ', ') AS area_formacao
                                FROM mdl_sgt_formacao_disciplina fd
                                     JOIN mdl_sgt_area_formacao af ON fd.id_area_formacao = af.ID
                               WHERE fd.shortname = ast.shortname);

  
  CREATE INDEX sgt_alunos_sem_tutoresIDX ON sgt_alunos_sem_tutores(codigo_polo,codigo_curso);                                          
  CREATE INDEX sgt_alunos_sem_tutoresDTIDX ON sgt_alunos_sem_tutoresDT(shortname,codigo_polo,codigo_curso);
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_alunos_sem_tutores)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
