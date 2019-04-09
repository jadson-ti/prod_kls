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

-- Copiando estrutura para procedure prod_kls.PRC_RETORNO_NT_DI2
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_RETORNO_NT_DI2`()
BEGIN


	DECLARE ID_LOG_		 INT(10);
	DECLARE CODE_ 			 VARCHAR(50) DEFAULT 'SUCESSO';
	DECLARE MSG_ 			 VARCHAR(200);
	DECLARE REGISTROS_	 BIGINT DEFAULT NULL;

	DECLARE v_finished 	   INT DEFAULT 0;
	DECLARE SHORTNAME_		VARCHAR(100);
	DECLARE QTD_ALU_			INT;
	DECLARE QTD_ATIVIDADE_	INT(3);


	DECLARE c_cursos CURSOR FOR
             SELECT di.SHORTNAME,
             		  (SELECT COUNT(gi.id)
							  FROM mdl_course tc
							  JOIN mdl_grade_items gi ON gi.courseid = tc.id
                        JOIN mdl_course_modules cm on cm.instance=gi.iteminstance and
                                                    cm.idnumber<>'teacher_class' and
                                                    cm.course=tc.id and
                                                    cm.visible=1
                        JOIN mdl_modules m on m.id=cm.module and m.name='quiz'
							 WHERE (gi.itemname REGEXP '^U1'
							     OR gi.itemname REGEXP '^U2')
							   AND (gi.itemname REGEXP 'dade$' OR gi.itemname REGEXP 'agem$' OR gi.itemname REGEXP 'tica$')
								AND tc.SHORTNAME = di.SHORTNAME) AS QTD_ATIVIDADE
					FROM tbl_retorno_nt_di2 di
				  GROUP BY di.SHORTNAME;

   DECLARE CONTINUE HANDLER
     FOR NOT FOUND SET v_finished = 1;


	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	   BEGIN
	    	
			GET DIAGNOSTICS CONDITION 1
	        CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;
	        
	      SET CODE_ = CONCAT('ERRO - ', CODE_);
	      
	      ROLLBACK;
		   
	   END;
        
   
	INSERT INTO tbl_prc_log (BANCO, OBJETO, AUTOR, INICIO, `STATUS`)
		SELECT database(), 'PRC_RETORNO_NT_DI2', user(), sysdate(), 'PROCESSANDO' FROM DUAL;
		

	DROP TABLE IF EXISTS tbl_retorno_base;

	CREATE TABLE tbl_retorno_base (
															SHORTNAME			VARCHAR(100),
															FULLNAME				VARCHAR(200),
															USERID				BIGINT,
															USERNAME				VARCHAR(100),
															ITEMNAME				VARCHAR(100),
															NOTA					DECIMAL(4,1)
									 				    );

	CREATE INDEX idx_BASE ON tbl_retorno_base (SHORTNAME);


	DROP TABLE IF EXISTS tbl_retorno_base1;

	CREATE TABLE tbl_retorno_base1 (
															SHORTNAME		VARCHAR(100),
															USERNAME			VARCHAR(100),
															ITEMNAME			VARCHAR(100),
															NOTA				DECIMAL(4,1)
									 				   );

	CREATE INDEX idx_BASE1 ON tbl_retorno_base1 (SHORTNAME);



	DROP TABLE IF EXISTS tbl_retorno_base2;

	CREATE TABLE tbl_retorno_base2 (
															SHORTNAME		VARCHAR(100),
															USERNAME			VARCHAR(100),
															NOTA				DECIMAL(4,1)
									 				   );

	CREATE INDEX idx_BASE2 ON tbl_retorno_base2 (SHORTNAME, USERNAME);



	DROP TABLE IF EXISTS tbl_retorno_nt_di2;

	CREATE TABLE tbl_retorno_nt_di2 (
													CD_INSTITUICAO			VARCHAR(20),
												   NM_IES					VARCHAR(200),
													CD_PESSOA				VARCHAR(100),
													USERNAME					VARCHAR(200),
													NOME_USUARIO			VARCHAR(200),
													COURSE_ID				BIGINT,
													SHORTNAME				VARCHAR(200),
													FULLNAME					VARCHAR(200),
													CD_CURSO					VARCHAR(100),
													CURSO						VARCHAR(200),
													CD_DISCIPLINA			VARCHAR(100),
													DISCIPLINA				VARCHAR(200),
													TURMA						VARCHAR(100),
												 	ORIGEM					VARCHAR(100),
													CARGA_HORARIA			SMALLINT(10),
													AUSENCIA					BIGINT,
													NOTA						DECIMAL(3,1) DEFAULT 0												
											 );

 	CREATE INDEX idx_NT2_DI2 ON tbl_retorno_nt_di2 (SHORTNAME, USERNAME);

	INSERT INTO tbl_retorno_nt_di2 (CD_INSTITUICAO, NM_IES, CD_PESSOA, USERNAME, NOME_USUARIO, COURSE_ID, SHORTNAME,
												  FULLNAME, CD_CURSO, CURSO, CD_DISCIPLINA, DISCIPLINA, TURMA, ORIGEM, CARGA_HORARIA,
												  AUSENCIA)
					SELECT i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							 p.nm_pessoa AS NOME_USUARIO,
							 mc.id AS COURSE_ID,
							 mc.shortname,
							 mc.fullname,
							 c.cd_curso AS COD_CURSO,
							 c.nm_curso AS CURSO,
							 d.cd_disciplina AS CD_DISCIPLINA,
							 d.ds_disciplina AS DISCIPLINA,
							 IFNULL(t.cd_turma, '') AS TURMA,
							 'OLIMPO' AS ORIGEM,
							 cd.carga_horaria,
							 cd.id_curso_disciplina AS AUSENCIA
        FROM kls_lms_pessoa p
        JOIN mdl_user tu ON tu.username = p.login AND tu.mnethostid = 1
        JOIN kls_lms_pessoa_curso_disc pcd ON pcd.id_pessoa = p.id_pessoa
        JOIN kls_lms_curso_disciplina cd ON cd.id_curso_disciplina = pcd.id_curso_disciplina 
        JOIN mdl_course mc on mc.shortname=cd.shortname and mc.visible=1
        JOIN mdl_course_categories cc on cc.id=mc.category and cc.name REGEXP '2'
        JOIN kls_lms_curso c ON c.id_curso = cd.id_curso 
        JOIN kls_lms_instituicao i ON i.id_ies = c.id_ies
        JOIN kls_lms_disciplina d ON cd.id_disciplina = d.id_disciplina 
        JOIN kls_lms_tipo_modelo tm ON tm.id_tp_modelo = d.id_tp_modelo AND tm.sigla='DI'
        LEFT JOIN kls_lms_pessoa_turma pt on pt.id_pes_cur_disc=pcd.id_pes_cur_disc 
        LEFT JOIN kls_lms_turmas t ON pt.id_turma=t.id_turma  AND t.id_curso_disciplina = cd.id_curso_disciplina 
        WHERE pcd.id_papel = 1
					 GROUP BY i.cd_instituicao,
							 i.nm_ies, 
							 p.cd_pessoa,
							 tu.username,
							
							 mc.id,
							 mc.shortname,
							 mc.fullname,
							 c.cd_curso,
							 c.nm_curso,
							 d.cd_disciplina,
							 d.ds_disciplina,
							 cd.carga_horaria;

	
		UPDATE tbl_retorno_nt_di2 di
		  JOIN kls_lms_turmas t ON t.id_curso_disciplina = di.AUSENCIA
		   SET di.TURMA = t.cd_turma
		 WHERE di.TURMA = '';
	
		UPDATE tbl_retorno_nt_di2 di
		  SET di.AUSENCIA = 0;

	OPEN c_cursos;

	  get_CURSOS: LOOP

	  FETCH c_cursos INTO SHORTNAME_, QTD_ATIVIDADE_;

	  IF v_finished = 1 THEN
	  		LEAVE get_CURSOS;
	  END IF;

			  INSERT INTO tbl_retorno_base
					SELECT c.shortname,
					       UPPER(c.fullname) AS FULLNAME,
							 u.id AS USERID,
							 u.username AS USERNAME,
							 UPPER(gi.itemname) AS ITEMNAME,
							 MAX(gg.finalgrade) AS NOTA
					  FROM tbl_retorno_nt_di2 di1
					  JOIN mdl_user u ON u.username = di1.USERNAME
					  JOIN mdl_course c ON c.shortname = di1.SHORTNAME
					  JOIN mdl_grade_items gi ON gi.courseid = c.id
													 AND gi.itemtype = 'mod'
													 AND gi.itemmodule = 'quiz'
													 AND (gi.itemname REGEXP '^U1' OR gi.itemname REGEXP '^U2')
													 AND (gi.itemname REGEXP 'dade$' OR gi.itemname REGEXP 'agem$' OR gi.itemname REGEXP 'tica$')
					  JOIN mdl_course_modules cm ON cm.course = c.id
					  									 AND cm.instance = gi.iteminstance
					  									 AND cm.idnumber<>'teacher_class' 
					  									 AND cm.module IN (select id from mdl_modules where name = 'quiz')
					  JOIN mdl_grade_grades gg ON gi.id = gg.itemid  AND gg.userid = u.id
					 WHERE di1.SHORTNAME = SHORTNAME_
					   AND cm.visible = 1
						AND gg.finalgrade IS NOT NULL
					   AND gg.finalgrade > 0
					 GROUP BY c.fullname, u.id, gi.itemname;
	
				INSERT INTO tbl_retorno_base1(SHORTNAME, USERNAME, ITEMNAME, NOTA)
							SELECT tb.SHORTNAME,
									 tb.USERNAME,
									 tb.ITEMNAME,
									 MAX(tb.NOTA) AS NOTA
							  FROM tbl_retorno_base tb
							 WHERE tb.SHORTNAME = SHORTNAME_
							 GROUP BY tb.SHORTNAME, tb.USERNAME, tb.ITEMNAME;
	
		IF QTD_ATIVIDADE_ > 0 THEN
		
					INSERT INTO tbl_retorno_base2(SHORTNAME, USERNAME, NOTA)
								SELECT tb.SHORTNAME,
										 tb.USERNAME,
										 ROUND((SUM(tb.NOTA) / QTD_ATIVIDADE_), 1) AS NOTA
								  FROM tbl_retorno_base1 tb
								 WHERE tb.SHORTNAME = SHORTNAME_
								 GROUP BY tb.SHORTNAME, tb.USERNAME;
		
	 	END IF;
  

					UPDATE tbl_retorno_nt_di2 di1
					  JOIN tbl_retorno_base2 rb ON rb.USERNAME = di1.USERNAME
													   AND rb.SHORTNAME = di1.SHORTNAME
					   SET di1.NOTA = rb.NOTA
					 WHERE di1.SHORTNAME = SHORTNAME_;


	END LOOP get_CURSOS;

 	CLOSE c_cursos;

	DROP TABLE IF EXISTS tbl_retorno_base;

	DROP TABLE IF EXISTS tbl_retorno_base1;

	
	SELECT pl.ID
	  INTO ID_LOG_
	  FROM tbl_prc_log pl
	 ORDER BY ID DESC
	 LIMIT 1;
	 
	UPDATE tbl_prc_log pl
		SET pl.FIM = sysdate(),
	 		 pl.`STATUS` = CODE_, 
	 		 pl.REGISTROS = IFNULL(REGISTROS_, (SELECT COUNT(1) FROM tbl_retorno_nt_di2)),
	 		 pl.INFO = MSG_
	 WHERE pl.ID = ID_LOG_;
	
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
