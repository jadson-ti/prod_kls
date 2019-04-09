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

-- Copiando estrutura para procedure prod_kls.prc_questionario_associado
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `prc_questionario_associado`()
BEGIN
   DECLARE ID_LOG_      INT(10);
   DECLARE CODE_        VARCHAR(50) DEFAULT 'SUCESSO';
   DECLARE MSG_         VARCHAR(200);
   DECLARE REGISTROS_   BIGINT DEFAULT NULL;

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   BEGIN
      GET DIAGNOSTICS
         CONDITION 1 CODE_ = RETURNED_SQLSTATE, MSG_ = MESSAGE_TEXT;

      SET CODE_ = CONCAT('ERRO - ', CODE_);

      ROLLBACK;
   END;


   INSERT INTO tbl_prc_log(BANCO,
                           OBJETO,
                           AUTOR,
                           INICIO,
                           `STATUS`)
      SELECT database(),
             'prc_questionario_associado',
             user(),
             sysdate(),
             'PROCESSANDO'
        FROM DUAL;

   SET ID_LOG_ = LAST_INSERT_ID();

   
   DROP TABLE IF EXISTS sgt_questionario_associado;

   CREATE TABLE sgt_questionario_associado
   (
      ID_CATEGORIA_CURSO      BIGINT(10),
      NOME_CATEGORIA_CURSO    VARCHAR(255),
      ID_CURSO                BIGINT(10),
      DISCIPLINA              VARCHAR(254),
      SHORTNAME               VARCHAR(255),
      ID_QUESTIONARIO         BIGINT(10),
      NOME_QUIZ               VARCHAR(255),
      ID_QUESTAO              BIGINT(10),
      NOME_QUESTAO            VARCHAR(255),
      TIPO                    VARCHAR(20),
      TEXTO_QUESTAO           LONGTEXT,
      DATA_MODIFICACAO        VARCHAR(15),
      CAMINHO                 LONGTEXT,
      STATUS                  VARCHAR(50)
   );

   
   CREATE INDEX sgt_questionario_associadoIX
      ON sgt_questionario_associado(ID_CURSO);

   CREATE INDEX sgt_questionario_associadoIX1
      ON sgt_questionario_associado(DISCIPLINA);

   CREATE INDEX sgt_questionario_associadoIX2
      ON sgt_questionario_associado(SHORTNAME);

   
   INSERT INTO sgt_questionario_associado(ID_CATEGORIA_CURSO,
                                          NOME_CATEGORIA_CURSO,
                                          ID_CURSO,
                                          SHORTNAME,
                                          DISCIPLINA,
                                          ID_QUESTIONARIO,
                                          NOME_QUIZ,
                                          ID_QUESTAO,
                                          NOME_QUESTAO,
                                          TIPO,
                                          TEXTO_QUESTAO,
                                          DATA_MODIFICACAO,
                                          CAMINHO,
                                          STATUS)
      
      SELECT DISTINCT
             cc.id
                AS 'ID_CATEGORIA_CURSO',
             cc.name
                AS 'NOME_CATEGORIA_CURSO',
             c1.id
                'ID_CURSO',
             c1.shortname,
             c1.fullname
                AS 'DISCIPLINA',
             cm.id
                AS 'ID_QUESTIONARIO',
             qz1.name
                AS 'NOME_QUIZ',
             q1.id
                AS ID_QUESTAO,
             q1.name
                'NOME_QUESTAO',
             q1.qtype
                AS TIPO,
             strip_tags(q1.questiontext)
                'TEXTO_QUESTAO',
             FROM_UNIXTIME(q1.timemodified, '%d/%m/%Y'),
             fnc_question_categories(q1.category)
                AS 'CAMINHO',
             CASE
                WHEN q1.canceled = 1 THEN 'CANCELADO'
                WHEN q1.canceled = 2 THEN 'CANCELADO E REGRADE'
                ELSE 'OK'
             END
                AS `STATUS`
        FROM mdl_question q1
             JOIN mdl_quiz_slots qqi ON qqi.questionid = q1.id
             JOIN mdl_quiz qz1 ON qz1.id = qqi.quizid
             JOIN mdl_course c1 ON c1.id = qz1.course
             JOIN mdl_course_modules cm
                ON cm.course = c1.id AND cm.instance = qz1.id
             JOIN mdl_course_categories cc ON cc.id = c1.category
       WHERE     qz1.id > 0
             AND q1.qtype <> 'random'
             AND cc.name NOT LIKE 'Miscelânea'
             AND cc.name NOT LIKE 'Aula TESTE'
             AND cm.idnumber <> 'teacher_class';


   INSERT INTO sgt_questionario_associado(ID_CATEGORIA_CURSO,
                                          NOME_CATEGORIA_CURSO,
                                          ID_CURSO,
                                          SHORTNAME,
                                          DISCIPLINA,
                                          ID_QUESTIONARIO,
                                          NOME_QUIZ,
                                          ID_QUESTAO,
                                          NOME_QUESTAO,
                                          TIPO,
                                          TEXTO_QUESTAO,
                                          DATA_MODIFICACAO,
                                          CAMINHO,
                                          STATUS)
      SELECT DISTINCT
             cc.id
                AS 'ID_CATEGORIA_CURSO',
             cc.name
                AS 'NOME_CATEGORIA_CURSO',
             c1.id
                'ID_CURSO',
             c1.shortname,
             c1.fullname
                AS 'DISCIPLINA',
             cm.id
                AS 'ID_QUESTIONARIO',
             qz1.name
                AS 'NOME_QUIZ',
             q2.id
                AS ID_QUESTAO,
             q2.name
                'NOME_QUESTAO',
             q2.qtype
                AS TIPO,
             strip_tags(q2.questiontext)
                'TEXTO_QUESTAO',
             FROM_UNIXTIME(q2.timemodified, '%d/%m/%Y'),
             fnc_question_categories(q2.category)
                AS 'CAMINHO',
             CASE
                WHEN q2.canceled = 1 THEN 'CANCELADO'
                WHEN q2.canceled = 2 THEN 'CANCELADO E REGRADE'
                ELSE 'OK'
             END
                AS `STATUS`
        FROM mdl_question q1
             JOIN mdl_quiz_slots qqi ON qqi.questionid = q1.id
             JOIN mdl_quiz qz1 ON qz1.id = qqi.quizid
             JOIN mdl_course c1 ON c1.id = qz1.course
             JOIN mdl_course_modules cm
                ON cm.course = c1.id AND cm.instance = qz1.id
             JOIN mdl_course_categories cc ON cc.id = c1.category
             JOIN mdl_question_categories qc ON qc.id = q1.category
             JOIN mdl_question q2 ON q2.category = qc.id
       WHERE     qz1.id > 0
             AND q1.qtype = 'random'
             AND q2.qtype <> 'random'
             AND cc.name NOT LIKE 'Miscelânea'
             AND cc.name NOT LIKE 'Aula TESTE'
             AND cm.idnumber <> 'teacher_class';

   UPDATE tbl_prc_log pl
      SET pl.FIM = sysdate(),
          pl.`STATUS` = CODE_,
          pl.REGISTROS =
             IFNULL(REGISTROS_,
                    (SELECT COUNT(1) FROM sgt_questionario_associado)),
          pl.INFO = MSG_
    WHERE pl.ID = ID_LOG_;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
