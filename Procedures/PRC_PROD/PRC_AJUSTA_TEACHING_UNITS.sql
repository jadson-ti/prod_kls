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

-- Copiando estrutura para procedure prod_kls.PRC_AJUSTA_TEACHING_UNITS
DELIMITER //
CREATE DEFINER=`fsantini`@`%` PROCEDURE `PRC_AJUSTA_TEACHING_UNITS`()
BEGIN


DECLARE NODATA INT DEFAULT FALSE;
DECLARE TP_ID INT;
DECLARE SISCON_ID INT;
DECLARE TPS CURSOR FOR 
	SELECT DISTINCT tp.id, tp.siscon_discipline_id 
	FROM teaching_plans tp
	LEFT JOIN teaching_plan_parts tpp on tpp.teaching_plan_id=tp.id and tpp.part_type='teaching_units'
	WHERE tpp.id IS NULL and tp.active='yes' and status<>'waiting_for_elaboration';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;


OPEN TPS;

	PARTTYPE: LOOP
	
		SET NODATA=FALSE;

		FETCH TPS INTO TP_ID, SISCON_ID;
		
		IF NODATA THEN LEAVE PARTTYPE; END IF;
		
		INSERT INTO teaching_plan_parts (teaching_plan_id, part_type, html, hours, origin,
		has_changed, active, creation_date, `order`, digital, link) 
			select distinct TP_ID, 'teaching_units', ue.NOME_UNIDADE_ENSINO,
			0, null, 'no', 'yes', now(), 1, null, null
			from SISCON_UNIDADE_CURRICULAR uc
			join SISCON_UC_UNIDADE_ENSINO ucue on ucue.ID_UC = uc.ID_UC
			join SISCON_UNIDADE_ENSINO ue on ue.ID_UNIDADE_ENSINO = ucue.ID_UNIDADE_ENSINO
			join SISCON_UE_CONTEUDO uec on uec.ID_UNIDADE_ENSINO = ue.ID_UNIDADE_ENSINO
			join SISCON_CONTEUDO c on c.ID_CONTEUDO = uec.ID_CONTEUDO
			where uc.ID_UC = SISCON_ID;

		INSERT INTO teaching_plan_part_items (teaching_plan_part_id, description, active, 
		creation_date, modification_date)
			select distinct tpp.id, NOME_CONTEUDO, 'yes', now(), now()
			from SISCON_UNIDADE_CURRICULAR uc
			join SISCON_UC_UNIDADE_ENSINO ucue on ucue.ID_UC = uc.ID_UC
			join SISCON_UNIDADE_ENSINO ue on ue.ID_UNIDADE_ENSINO = ucue.ID_UNIDADE_ENSINO
			join SISCON_UE_CONTEUDO uec on uec.ID_UNIDADE_ENSINO = ue.ID_UNIDADE_ENSINO
			join SISCON_CONTEUDO c on c.ID_CONTEUDO = uec.ID_CONTEUDO
			join teaching_plan_parts tpp on tpp.teaching_plan_id=TP_ID and tpp.part_type='teaching_units' and 
											html=ue.NOME_UNIDADE_ENSINO
			where uc.ID_UC = SISCON_ID;		

	END LOOP PARTTYPE;

CLOSE TPS;


PARTITEMSBLOCK: BEGIN

DECLARE TPI CURSOR FOR 
		SELECT DISTINCT tp.id, tp.siscon_discipline_id
		FROM teaching_plans tp
		JOIN teaching_plan_parts tpp on tpp.teaching_plan_id=tp.id and tpp.part_type='teaching_units'
		LEFT JOIN teaching_plan_part_items ppi on ppi.teaching_plan_part_id=tpp.id
		WHERE 
			ppi.id IS NULL and 
			tp.active='yes' and 
			status<>'waiting_for_elaboration';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET NODATA=TRUE;

OPEN TPI;

	PARTITEMS: LOOP
	
		SET NODATA=FALSE;
		
		FETCH TPI INTO TP_ID, SISCON_ID;
		
		IF NODATA THEN LEAVE PARTITEMS; END IF;
		
		INSERT INTO teaching_plan_part_items (teaching_plan_part_id, description, active, 
		creation_date, modification_date)
			select distinct tpp.id, NOME_CONTEUDO, 'yes', now(), now()
			from SISCON_UNIDADE_CURRICULAR uc
			join SISCON_UC_UNIDADE_ENSINO ucue on ucue.ID_UC = uc.ID_UC
			join SISCON_UNIDADE_ENSINO ue on ue.ID_UNIDADE_ENSINO = ucue.ID_UNIDADE_ENSINO
			join SISCON_UE_CONTEUDO uec on uec.ID_UNIDADE_ENSINO = ue.ID_UNIDADE_ENSINO
			join SISCON_CONTEUDO c on c.ID_CONTEUDO = uec.ID_CONTEUDO
			join teaching_plan_parts tpp on tpp.teaching_plan_id=TP_ID and tpp.part_type='teaching_units' and 
											html=ue.NOME_UNIDADE_ENSINO
			where uc.ID_UC = SISCON_ID;			
		
	END LOOP PARTITEMS;
	CLOSE TPI;
END PARTITEMSBLOCK;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
