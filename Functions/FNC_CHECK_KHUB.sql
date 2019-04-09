-- --------------------------------------------------------
-- Servidor:                     cm-kls.cluster-cu0eljf5y2ht.us-east-1.rds.amazonaws.com
-- Versão do servidor:           5.6.10-log - MySQL Community Server (GPL)
-- OS do Servidor:               Linux
-- HeidiSQL Versão:              10.1.0
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Copiando estrutura para função prod_kls.FNC_CHECK_KHUB
DELIMITER //
CREATE DEFINER=`fsantini`@`%` FUNCTION `FNC_CHECK_KHUB`() RETURNS int(11)
BEGIN

DECLARE VDIF INT;

SELECT COUNT(1) INTO VDIF FROM (
select 
	'kls_lms_instituicao' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_instituicao)-
		(select count(1) from khub.kls_lms_instituicao)=0,
		'OK','NOK') as Dif
union
select 
	'kls_lms_curso' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_curso)-
		(select count(1) from khub.kls_lms_curso)=0,
		'OK','NOK') as Dif
union
select 
	'kls_lms_disciplina' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_disciplina)-
		(select count(1) from khub.kls_lms_disciplina)=0,
		'OK','NOK') as Dif
union
select 
	'kls_lms_curso_disciplina' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_curso_disciplina)-
		(select count(1) from khub.kls_lms_curso_disciplina)=0,
		'OK','NOK') as Dif
union		
select 
	'kls_lms_turmas' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_turmas)-
		(select count(1) from khub.kls_lms_turmas)=0,
		'OK','NOK') as Dif	
union	
select 
	'kls_lms_pessoa' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_pessoa)-
		(select count(1) from khub.kls_lms_pessoa)=0,
		'OK','NOK') as Dif	
union	
select 
	'kls_lms_pessoa_curso' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_pessoa_curso)-
		(select count(1) from khub.kls_lms_pessoa_curso)=0,
		'OK','NOK') as Dif			
union
select 
	'kls_lms_pessoa_curso_disc' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_pessoa_curso_disc)-
		(select count(1) from khub.kls_lms_pessoa_curso_disc)=0,
		'OK','NOK') as Dif			
union
select 
	'kls_lms_pessoa_turma' as tabela,
	if(
		(select count(1) from prod_kls.kls_lms_pessoa_turma)-
		(select count(1) from khub.kls_lms_pessoa_turma)=0,
		'OK','NOK') as Dif			
) A
WHERE DIF='NOK';


SET VDIF=VDIF;
		
		
		
		

set @qtd_bkp_ies=(select count(1) from bkp_lms_instituicao);
set @qtd_kls_ies=(select count(1) from kls_lms_instituicao);

set @qtd_bkp_curso=(select count(1) from bkp_lms_curso);
set @qtd_kls_curso=(select count(1) from kls_lms_curso);

set @qtd_bkp_disciplina=(select count(1) from bkp_lms_disciplina);
set @qtd_kls_disciplina=(select count(1) from kls_lms_disciplina);

set @qtd_bkp_curso_disciplina=(select count(1) from bkp_lms_curso_disciplina);
set @qtd_kls_curso_disciplina=(select count(1) from kls_lms_curso_disciplina);

set @qtd_bkp_turmas=(select count(1) from bkp_lms_turmas);
set @qtd_kls_turmas=(select count(1) from kls_lms_turmas);

set @qtd_bkp_pessoa=(select count(1) from bkp_lms_pessoa);
set @qtd_kls_pessoa=(select count(1) from kls_lms_pessoa);

set @qtd_bkp_pessoa_curso=(select count(1) from bkp_lms_pessoa_curso);
set @qtd_kls_pessoa_curso=(select count(1) from kls_lms_pessoa_curso);

set @qtd_bkp_pessoa_curso_disc=(select count(1) from bkp_lms_pessoa_curso_disc);
set @qtd_kls_pessoa_curso_disc=(select count(1) from kls_lms_pessoa_curso_disc);

set @qtd_bkp_pessoa_turma=(select count(1) from bkp_lms_pessoa_turma);
set @qtd_kls_pessoa_turma=(select count(1) from kls_lms_pessoa_turma);

SET VDIF=VDIF+(
select 
	if((@qtd_bkp_ies-@qtd_kls_ies)>0,1,0)+
	if((@qtd_bkp_curso-@qtd_kls_curso)>0,1,0)+
	if((@qtd_bkp_disciplina-@qtd_kls_disciplina)>0,1,0)+
	if((@qtd_bkp_curso_disciplina-@qtd_kls_curso_disciplina)>0,1,0)+
	if((@qtd_bkp_turmas-@qtd_kls_turmas)>0,1,0)+
	if((@qtd_bkp_pessoa-@qtd_kls_pessoa)>0,1,0)+
	if((@qtd_bkp_pessoa_curso-@qtd_kls_pessoa_curso)>0,1,0)+
	if((@qtd_bkp_pessoa_curso_disc-@qtd_kls_pessoa_curso_disc)>0,1,0)+
	if((@qtd_bkp_pessoa_turma-@qtd_kls_pessoa_turma)>0,1,0)
);

SET VDIF=VDIF+(
SELECT 
	IF(@qtd_kls_ies=0,1,0)+
	IF(@qtd_kls_curso=0,1,0)+
	IF(@qtd_kls_disciplina=0,1,0)+
	IF(@qtd_kls_curso_disciplina=0,1,0)+
	IF(@qtd_kls_turmas=0,1,0)+
	IF(@qtd_kls_pessoa=0,1,0)+
	IF(@qtd_kls_pessoa_curso=0,1,0)+
	IF(@qtd_kls_pessoa_curso_disc=0,1,0)+
	IF(@qtd_kls_pessoa_turma=0,1,0)
);

RETURN VDIF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
