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

-- Copiando estrutura para procedure prod_kls.PRC_CARGA_THEME
DELIMITER //
CREATE DEFINER=`jsilva`@`%` PROCEDURE `PRC_CARGA_THEME`()
BEGIN

drop table if exists tmp_user_brand; 

create temporary table tmp_user_brand (
	username varchar(100),
	theme varchar(10),
	primary key (username)
); 

insert into tmp_user_brand
select u.username, b.theme from  kls_lms_pessoa p 
join kls_lms_pessoa_curso pc on pc.id_pessoa=p.id_pessoa and pc.fl_etl_atu<>'E' 
join kls_lms_curso c on c.id_curso=pc.id_curso and c.fl_etl_atu<>'E' 
join kls_lms_instituicao i on i.id_ies=c.id_ies 
join mdl_block_brands b on b.theme=i.cd_marca 
join tbl_mdl_user u on u.username=p.login   
group by u.username 
order by b.id; 

insert into tmp_user_brand
select u.username, b.theme from  kls_lms_pessoa p 
join kls_lms_pessoa_curso_disc pcd on pcd.id_pessoa=p.id_pessoa and pcd.fl_etl_atu<>'E' and pcd.id_papel=3
join kls_lms_curso_disciplina cd on cd.id_curso_disciplina=pcd.id_curso_disciplina and cd.fl_etl_atu<>'E' 
join kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu<>'E' 
join kls_lms_instituicao i on i.id_ies=c.id_ies 
join mdl_block_brands b on b.theme=i.cd_marca 
join tbl_mdl_user u on u.username=p.login 
left join kls_lms_pessoa_curso pc on pc.id_pessoa=pcd.id_pessoa and pc.fl_etl_atu <> 'E'
where pc.id_pessoa_curso is null
group by u.username 
order by b.id; 

update mdl_user u 
join tmp_user_brand b on u.username=b.username and u.mnethostid=1 
set u.theme=lower(b.theme)
where u.theme<>b.theme; 



update mdl_user u 
left join kls_lms_pessoa p on u.username=p.login and u.mnethostid=1 
set u.theme='marca_krot' 
where p.id_pessoa is null and theme<>'marca_krot'; 

drop table if exists tmp_user_brand; 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
