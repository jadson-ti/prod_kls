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

-- Copiando estrutura para procedure prod_kls.prc_aloc_det
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `prc_aloc_det`()
BEGIN  

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
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'prc_aloc_det', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
  
  SET ID_LOG_=LAST_INSERT_ID();
  
   TRUNCATE TABLE sgt_aloc_det;
  
  
 
    INSERT INTO sgt_aloc_det (username,
                              nm_pessoa,
                              sigla,
                              shortname,
                              fullname,
                              codigo_disciplina,
                              nome_disciplina,
                              tutor,
                              matricula,
                              bloqueio,
                              ativo)
 SELECT
	anh.USERNAME,
	p.nm_pessoa,
   CASE  WHEN anh.sigla = 'ESTV' then 'EST, ED 8, 9 e 10'
         WHEN anh.sigla = 'DI' then 'DI, ED 5, 6 e 7'
         WHEN anh.sigla = 'DIBV' then 'DIB, ED 5, 6 e 7'
         WHEN anh.sigla = 'EDV' then 'ED'
         WHEN anh.sigla = 'NPJV' then 'NPJ'
         WHEN anh.sigla = 'TCCV' then 'TCC' 
			WHEN anh.sigla = 'HIBV' then 'HIB'               
   ELSE anh.sigla
	END as sigla,
	anh.shortname,
   c.fullname,
	anh.codigo_disciplina,
   anh.nome_disciplina,
   anh.tutor,
	anh.DATA_IMPORTACAO as matricula,
	@bloqueio:=(select data_importacao from anh_import_aluno_curso
	 where username=anh.username and shortname=anh.shortname
	 and grupo=anh.grupo and situacao in ('B','S') and status='OK' AND sigla=anh.sigla
	 and data_importacao>anh.data_importacao 
	 order by data_importacao limit 1
	 ) as bloqueio,
	 if(
	  (
	 	(mat.ID IS NOT NULL AND anh.SIGLA<>'TCCV')
	 	OR
	 	(anh.SIGLA='TCCV' AND @bloqueio IS NULL)
	  )	
     ,'S','N') ativo
FROM anh_import_aluno_curso anh
JOIN mdl_course c on c.shortname=anh.SHORTNAME
JOIN kls_lms_pessoa p on p.login=anh.USERNAME 
left join anh_aluno_matricula mat on anh.username=mat.username and anh.shortname=mat.shortname and anh.sigla=mat.sigla
WHERE anh.SIGLA IN ('DI','DIBV','TCCV','ESTV','NPJV','PVDV','HIBV') AND
		anh.SITUACAO in ('I','D') AND
		anh.STATUS='OK' ; 
   

DROP TABLE IF EXISTS tmp_aloc_det_tcc;
CREATE TEMPORARY TABLE tmp_aloc_det_tcc (username VARCHAR(50), shortname VARCHAR(50), PRIMARY KEY (username, shortname));
INSERT INTO tmp_aloc_det_tcc 
SELECT DISTINCT username, shortname 
FROM sgt_aloc_det 
WHERE ativo='S' AND shortname REGEXP '^TCC';
UPDATE sgt_aloc_det a
JOIN tmp_aloc_det_tcc b ON a.username=b.username AND a.shortname=b.shortname
SET ativo='S' 
WHERE ativo='N';
DROP TABLE IF EXISTS tmp_aloc_det_tcc;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM sgt_aloc_det)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	 
  
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
