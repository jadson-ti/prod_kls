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

-- Copiando estrutura para procedure prod_kls.PRC_ACESSOS_MANUAIS
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_ACESSOS_MANUAIS`()
BEGIN

replace into kls_lms_pessoa (id_pessoa, cd_pessoa, nm_pessoa, cpf,sexo,email,login,fl_etl_atu)
values(9999999,'9999999', 'Luis Coimbra', '05630051652', 'MASCULINO', 'luis.coimbra@kroton.com.br','luis.coimbra','N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999999,9999999, 1868235, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999999,99999999, 2930606,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999998,9999999, 1868793, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999998,99999998, 2931490,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999997,9999999, 2058793, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999997,99999997, 3206263,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999996,9999999, 1869151, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999996,99999996, 2931992,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999995,9999999, 1868521, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999995,99999995, 2931050,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999994,9999999, 2037596, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999994,99999994, 3178272,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999993,9999999, 1868085, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999993,99999993, 2930375,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999992,9999999, 1869148, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999992,99999992, 2931989,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999991,9999999, 1868851, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999991,99999991, 2931551,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999990,9999999, 1868897, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999990,99999990, 2931597,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999989,9999999, 1868608, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999989,99999989, 2931162,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999988,9999999, 1868577, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999988,99999988, 2931121,  'N');

replace into kls_lms_pessoa_curso (id_pessoa_curso, id_curso, id_pessoa, id_papel, cd_turma_mat,termo_turma,fl_etl_atu )
values(9999999,67677, 9999999, 1,'6768620161A1', '1º semestre', 'N');

replace into kls_lms_pessoa (id_pessoa, cd_pessoa, nm_pessoa, cpf,sexo,email,login,fl_etl_atu)
values(9999998,'9999998', 'Felipe Mattos', '05630051652', 'MASCULINO', 'felipe.mattos@kroton.com.br','felipe.mattos.aluno','N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999987,9999998, 1868235, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999987,99999987, 2930606,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999986,9999998, 1868793, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999986,99999986, 2931490,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999985,9999998, 2058793, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999985,99999985, 3206263,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999984,9999998, 1869151, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999984,99999984, 2931992,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999983,9999998, 1868521, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999983,99999983, 2931050,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999982,9999998, 2037596, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999982,99999982, 3178272,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999981,9999998, 1868085, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999981,99999981, 2930375,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999980,9999998, 1869148, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999980,99999980, 2931989,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999979,9999998, 1868851, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999979,99999979, 2931551,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999978,9999998, 1868897, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999978,99999978, 2931597,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999977,9999998, 1868608, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999977,99999977, 2931162,  'N');

replace into kls_lms_pessoa_curso_disc (id_pes_cur_disc, id_pessoa, id_curso_disciplina, tipo_matricula,fl_etl_atu,id_papel)
values(99999976,9999998, 1868577, 'R', 'N', '1');

replace into kls_lms_pessoa_turma (id_pes_turma_disciplina, id_pes_cur_disc, id_turma,fl_etl_atu)
values(99999976,99999976, 2931121,  'N');

replace into kls_lms_pessoa_curso (id_pessoa_curso, id_curso, id_pessoa, id_papel, cd_turma_mat,termo_turma,fl_etl_atu )
values(9999998,67677, 9999998, 1,'6768620161A1', '1º semestre', 'N');

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
