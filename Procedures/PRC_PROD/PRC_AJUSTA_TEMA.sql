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

-- Copiando estrutura para procedure prod_kls.PRC_AJUSTA_TEMA
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AJUSTA_TEMA`()
BEGIN

DROP TABLE IF EXISTS tmp_tema_atual;
CREATE TABLE tmp_tema_atual (
	id_pessoa BIGINT(10),
	login VARCHAR(50),
	ordem INT(11),
	tema VARCHAR(30)
);	


SET @LOGIN='';
SET @LAST_THEME='';
SET @CONT=0;

INSERT INTO tmp_tema_atual 
SELECT p.id_pessoa,
	CASE
		WHEN @LOGIN<>p.login THEN 
			@LOGIN:=p.login
		ELSE 
			p.login
	END AS LOGIN,
	CASE
		WHEN @LOGIN=p.login AND tema.theme<>@LAST_THEME THEN 
			@CONT:=@CONT+1
		ELSE 
			@CONT:=1
	END AS ORDEM,	
	@LAST_THEME:=tema.theme AS TEMA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso pc on pc.id_pessoa=p.id_pessoa and pc.fl_etl_atu<>'E'
	JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel<>'PROFESSOR'
	JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'
	JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
	JOIN mdl_block_brands tema ON tema.theme=i.cd_marca 
	WHERE p.login<>'E'
ORDER BY login, tema.id;

INSERT INTO tmp_tema_atual 
SELECT p.id_pessoa,
	CASE
		WHEN @LOGIN<>p.login THEN 
			@LOGIN:=p.login
		ELSE 
			p.login
	END AS LOGIN,
	CASE
		WHEN @LOGIN=p.login AND tema.theme<>@LAST_THEME THEN 
			@CONT:=@CONT+1
		ELSE 
			@CONT:=1
	END AS ORDEM,	
	@LAST_THEME:=tema.theme AS TEMA
	FROM kls_lms_pessoa p
	JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu<>'E' 
	JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
	JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.fl_etl_atu<>'E'
	JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu<>'E'
	JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
	JOIN mdl_block_brands tema ON tema.theme=i.cd_marca 
	WHERE p.login<>'E'
ORDER BY login, tema.id;

DELETE FROM tmp_tema_atual WHERE ORDEM>1;

ALTER TABLE tmp_tema_atual DROP COLUMN ORDEM;

ALTER TABLE tmp_tema_atual ADD INDEX idx_tema_login (login);

UPDATE mdl_user u 
JOIN tmp_tema_atual t on u.username=t.login and u.mnethostid=1 
SET u.theme=t.tema
WHERE u.theme<>t.tema;

INSERT INTO mdl_block_brands_users (userid, brandid)
SELECT DISTINCT u.id, tema.id
FROM mdl_user u 
JOIN kls_lms_pessoa p ON u.username=p.login and p.fl_etl_atu<>'E' and u.mnethostid=1
JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu<>'E' 
JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.fl_etl_atu<>'E'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu<>'E'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
JOIN mdl_block_brands tema ON tema.theme=i.cd_marca 
LEFT JOIN mdl_block_brands_users bu on bu.userid=u.id and bu.brandid=tema.id
WHERE bu.id IS NULL;

INSERT INTO mdl_block_brands_users (userid, brandid)
SELECT DISTINCT u.id, tema.id
FROM mdl_user u 
JOIN kls_lms_pessoa p ON u.username=p.login and p.fl_etl_atu<>'E' and u.mnethostid=1
JOIN kls_lms_pessoa_curso pc on pc.id_pessoa=p.id_pessoa and pc.fl_etl_atu<>'E'
JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel<>'PROFESSOR'
JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
JOIN mdl_block_brands tema ON tema.theme=i.cd_marca 
LEFT JOIN mdl_block_brands_users bu on bu.userid=u.id and bu.brandid=tema.id
WHERE bu.id IS NULL;

DROP TABLE IF EXISTS tmp_tema_atual;
CREATE TABLE tmp_tema_atual (
	userid BIGINT(10),
	brandid BIGINT(10)
);	

INSERT INTO tmp_tema_atual 
SELECT DISTINCT u.id as userid, tema.id as brandid
FROM mdl_user u 
JOIN kls_lms_pessoa p ON u.username=p.login and p.fl_etl_atu<>'E' and u.mnethostid=1
JOIN kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu<>'E' 
JOIN kls_lms_papel pap on pap.id_papel=pcd.id_papel and pap.ds_papel='PROFESSOR'
JOIN kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.fl_etl_atu<>'E'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu<>'E'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
JOIN mdl_block_brands tema ON tema.theme=i.cd_marca 
UNION 
SELECT DISTINCT u.id, tema.id
FROM mdl_user u 
JOIN kls_lms_pessoa p ON u.username=p.login and p.fl_etl_atu<>'E' and u.mnethostid=1
JOIN kls_lms_pessoa_curso pc on pc.id_pessoa=p.id_pessoa and pc.fl_etl_atu<>'E'
JOIN kls_lms_papel pap on pap.id_papel=pc.id_papel and pap.ds_papel<>'PROFESSOR'
JOIN kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies 	
JOIN mdl_block_brands tema ON tema.theme=i.cd_marca;

ALTER TABLE tmp_tema_atual ADD PRIMARY KEY (userid, brandid);

DELETE a
FROM mdl_block_brands_users a 
LEFT JOIN tmp_tema_atual b on a.userid=b.userid and 
										a.brandid=b.brandid
WHERE b.userid IS NULL;


update mdl_user u
left join kls_lms_pessoa p on p.login=u.username and u.mnethostid=1
set theme='marca_kroton' 
where p.id_pessoa is null and u.theme<>'marca_krot';



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
