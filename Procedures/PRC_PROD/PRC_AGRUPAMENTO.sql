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

-- Copiando estrutura para procedure prod_kls.PRC_AGRUPAMENTO
DELIMITER //
CREATE DEFINER=`mveras`@`%` PROCEDURE `PRC_AGRUPAMENTO`()
BEGIN

DECLARE V_OPERACAO_ID INT;

UPDATE kls_lms_curso_disciplina set shortname='NPJ1/2' where shortname='NPJV1/2';
UPDATE kls_lms_curso_disciplina set shortname='NPJ2/2' where shortname='NPJV2/2';

update kls_lms_curso set cd_agrupamento = concat('GSEEM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Segurança Empresarial%'; 
update kls_lms_curso set cd_agrupamento = concat('GTRIB', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão Tributária%'; 
update kls_lms_curso set cd_agrupamento = concat('SUCRO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Sucroalcooleira%'; 
update kls_lms_curso set cd_agrupamento = concat('GDESL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão Desportiva e de Lazer%'; 
update kls_lms_curso set cd_agrupamento = concat('ADMIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'adm%';
update kls_lms_curso set cd_agrupamento = concat('ENFER', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Enferm%';
update kls_lms_curso set cd_agrupamento = concat('FISIO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Fisio%';
update kls_lms_curso set cd_agrupamento = concat('PSICO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Psic%';
update kls_lms_curso set cd_agrupamento = concat('ODONT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Odont%';
update kls_lms_curso set cd_agrupamento = concat('LETRA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Letra%';
update kls_lms_curso set cd_agrupamento = concat('CONTA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Contab%';
update kls_lms_curso set cd_agrupamento = concat('DIREI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and (nm_curso like 'Direit%' or nm_curso like 'Bacharelado em Direito%'); 
update kls_lms_curso set cd_agrupamento = concat('BIOLO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Ciencias Biolog%';
update kls_lms_curso set cd_agrupamento = concat('SERVI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Servico Social%';
update kls_lms_curso set cd_agrupamento = concat('ENGPM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenharia de Producao Mec%';
update kls_lms_curso set cd_agrupamento = concat('ENGPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenharia de Producao%' and nm_curso not like '%meca%';
update kls_lms_curso set cd_agrupamento = concat('ENGME', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenh%' and nm_curso like '%Mec%';
update kls_lms_curso set cd_agrupamento = concat('FABME', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Fabricação Mecânica%';
update kls_lms_curso set cd_agrupamento = concat('ELEIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Tecnologia em Eletrotécnica Industrial%' ;
update kls_lms_curso set cd_agrupamento = concat('SEGPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and (nm_curso like 'Tecnologia em Gestão de Segurança Privada%' or nm_curso like '%Gestão de Segurança Privada%'); 
update kls_lms_curso set cd_agrupamento = concat('EDFIS', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Educacao Fis%';
update kls_lms_curso set cd_agrupamento = concat('FARMA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Farm%' and nm_curso not like '%Farmacia e Bio%';
update kls_lms_curso set cd_agrupamento = concat('FARMB', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Farmacia e Bio%';
update kls_lms_curso set cd_agrupamento = concat('NORMA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Normal Sup%' or nm_curso like '%CNS Educacao infantil';
update kls_lms_curso set cd_agrupamento = concat('GASTR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gastr%' and nm_curso not like '%alimen%';
update kls_lms_curso set cd_agrupamento = concat('ENGCO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso regexp 'engenharia d[ea] comput';
update kls_lms_curso set cd_agrupamento = concat('MATEM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Matemática%';
update kls_lms_curso set cd_agrupamento = concat('GEOGR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Geog%';
update kls_lms_curso set cd_agrupamento = concat('COMSO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso regexp 'comunica(çã|ca)o social';
update kls_lms_curso set cd_agrupamento = concat('ARTEV', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Artes V%';
update kls_lms_curso set cd_agrupamento = concat('HISTL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Hist%';
update kls_lms_curso set cd_agrupamento = concat('CSOCI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Ciencias So%';
update kls_lms_curso set cd_agrupamento = concat('ARQUI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Arquit%';
update kls_lms_curso set cd_agrupamento = concat('TURIS', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%turis%';
update kls_lms_curso set cd_agrupamento = concat('PEDAG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and (nm_curso like 'Pedag%' or nm_curso like '(Ped)-Pedagogia (Mat)' or nm_curso like 'Licenciatura em Pedagogia (Ves)'); 
update kls_lms_curso Set cd_agrupamento = concat('PEDAA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Pedag%' or nm_curso like 'Pedagogia Lic Plena Hab Administração Escolar';
update kls_lms_curso set cd_agrupamento = concat('DMODA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%moda%';
update kls_lms_curso set cd_agrupamento = concat('ENGAM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='')and (nm_curso like '%engenharia ambien%' or nm_curso like '%cst em gestao ambi%') and nm_curso not like '%gest%';
update kls_lms_curso set cd_agrupamento = concat('EDUAR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%artist%' or nm_curso like '%Artís%';
update kls_lms_curso set cd_agrupamento = concat('CCOMP', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%ciencia da comput%' or nm_curso like '%ciencias da comput%'or  nm_curso like 'comput%';
update kls_lms_curso set cd_agrupamento = concat('RADIO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%radiol%';
update kls_lms_curso set cd_agrupamento = concat('AGROM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Agronomia%';
update kls_lms_curso set cd_agrupamento = concat('BOVIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%bovino%';
update kls_lms_curso set cd_agrupamento = concat('ENGQU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%engenharia qui%';
update kls_lms_curso set cd_agrupamento = concat('BIOME', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%biomed%';
update kls_lms_curso set cd_agrupamento = concat('AGRON', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%agrone%';
update kls_lms_curso set cd_agrupamento = concat('HOSPI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%hospit%' and nm_curso not like '%adm%';
update kls_lms_curso set cd_agrupamento = concat('ESTCO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%estetica e cosm%';
update kls_lms_curso set cd_agrupamento = concat('ESTET', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%estetica%' and nm_curso not like '%cosme%' and nm_curso not like '%capilar%' and nm_curso not like '%imag%';
update kls_lms_curso set cd_agrupamento = concat('MEDVE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Medicina Veterinária%';
update kls_lms_curso set cd_agrupamento = concat('MEDIC', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'medici%' and nm_curso not like '%veterin%';
update kls_lms_curso set cd_agrupamento = concat('NUTRI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%nutri%';
update kls_lms_curso set cd_agrupamento = concat('ENGAL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%engenharia de alim%' and nm_curso not like '%gastr%';
update kls_lms_curso set cd_agrupamento = concat('TALIM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%alim%' and nm_curso not like '%gastr%';
update kls_lms_curso set cd_agrupamento = concat('ENGCI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenh%' and nm_curso like '%civil%';
update kls_lms_curso set cd_agrupamento = concat('ENGEL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenharia eletrica%' or nm_curso like '%Engenharia  eletrica%';
update kls_lms_curso set cd_agrupamento = concat('ENGTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenharia de telec%';
update kls_lms_curso set cd_agrupamento = concat('DECOI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%decoracao de in%';
update kls_lms_curso set cd_agrupamento = concat('DECOC', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%decoracao e cen%';
update kls_lms_curso set cd_agrupamento = concat('AUDVI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%audiov%';
update kls_lms_curso set cd_agrupamento = concat('HOTEL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%hotelari%' and nm_curso not like '%turismo%';
update kls_lms_curso set cd_agrupamento = concat('PUBPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%prop%' and nm_curso like '%pub%';
update kls_lms_curso set cd_agrupamento = concat('RECHU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%human%' and nm_curso not like '%admi%' and nm_curso not like '%aividade comp%';
update kls_lms_curso set cd_agrupamento = concat('FOTOG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%fotografia%';
update kls_lms_curso set cd_agrupamento = concat('FONOA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%fonoau%';
update kls_lms_curso set cd_agrupamento = concat('PDADO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%processamento de dad%';
update kls_lms_curso set cd_agrupamento = concat('GECON', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%cien%' and nm_curso like '%econ%';
update kls_lms_curso set cd_agrupamento = concat('SETRI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%tril%';
update kls_lms_curso set cd_agrupamento = concat('ENGCA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%autom%' and   nm_curso like '%contr%';
update kls_lms_curso set cd_agrupamento = concat('ENAUT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Engenharia Automotiva%';
update kls_lms_curso set cd_agrupamento = concat('DINTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%desig%' and   nm_curso like '%inte%';
update kls_lms_curso set cd_agrupamento = concat('GPUBL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gestao public%';
update kls_lms_curso set cd_agrupamento = concat('DPROD', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%design%' and nm_curso like '%prod%';
update kls_lms_curso set cd_agrupamento = concat('REDES', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%redes%' and nm_curso like '%comp%' and nm_curso not like 'segur%';
update kls_lms_curso set cd_agrupamento = concat('MUSIC', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%musica%';
update kls_lms_curso set cd_agrupamento = concat('RELIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%relacoes internacionais%';
update kls_lms_curso set cd_agrupamento = concat('CERIM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%cerim%';
update kls_lms_curso set cd_agrupamento = concat('ENGCC', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%eng%' and nm_curso like '%ciclo%';
update kls_lms_curso set cd_agrupamento = concat('EVENT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%event%' and nm_curso not like '%turis%' and nm_curso not like '%cerim%';
update kls_lms_curso set cd_agrupamento = concat('MOVEL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%move%' and   nm_curso not like '%desi%';
update kls_lms_curso set cd_agrupamento = concat('DMOVE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%move%' and   nm_curso like '%desi%';
update kls_lms_curso set cd_agrupamento = concat('PPUBL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%publicit%';
update kls_lms_curso set cd_agrupamento = concat('GSAUD', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gerenci%' and   nm_curso like '%sau%';
update kls_lms_curso set cd_agrupamento = concat('PGERE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gerenci%' and   nm_curso not like '%saud%' and   nm_curso like '%process%';
update kls_lms_curso set cd_agrupamento = concat('GSEXE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gerenci%' and   nm_curso not like '%saud%' and   nm_curso like '%exec%';
update kls_lms_curso set cd_agrupamento = concat('SINTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%intern%' and nm_curso not like '%Tecnico %' and nm_curso not like '%interna%' and nm_curso not like '%eletro%';
update kls_lms_curso set cd_agrupamento = concat('INTEL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%intern%' and nm_curso not like '%Tecnico %' and nm_curso like '%eletro%';
update kls_lms_curso set cd_agrupamento = concat('ACENI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%artes cenicas%';
update kls_lms_curso set cd_agrupamento = concat('PCENI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%cenicas%' and   nm_curso not like '%art%';
update kls_lms_curso set cd_agrupamento = concat('GMAVE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='')and ((nm_curso like '%gestao em market%' or nm_curso like '%gestao de marketin%') or (nm_curso like '%market%' and nm_curso like '%vend%')) and nm_curso not like '%vend%';
update kls_lms_curso set cd_agrupamento = concat('GMARK', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='')and (nm_curso like '%gestao em market%' or nm_curso like '%gestao de marketin%') and nm_curso not like '%vend%';
update kls_lms_curso set cd_agrupamento = concat('MARKE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%market%' and nm_curso not like '%gest%' and nm_curso not like '%admin%' and nm_curso not like '%prop%' and nm_curso not like '%vare%';
update kls_lms_curso set cd_agrupamento = concat('EDIFI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%edifi%';
update kls_lms_curso set cd_agrupamento = concat('LOGIS', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%logist%'  and nm_curso not like '%admi%' and nm_curso not like '%empres%';
update kls_lms_curso set cd_agrupamento = concat('LOGIE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%logist%'  and nm_curso not like '%admi%' and nm_curso like '%empres%';
update kls_lms_curso set cd_agrupamento = concat('GFINA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%finan%'  and nm_curso like '%gestao%' and nm_curso not like '%admin%';
update kls_lms_curso set cd_agrupamento = concat('CNATU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%natureza%';
update kls_lms_curso set cd_agrupamento = concat('GCOME', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%comercial%';
update kls_lms_curso set cd_agrupamento = concat('SECRE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%secretar%' and nm_curso not like '%executiv%';
update kls_lms_curso set cd_agrupamento = concat('SECEX', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%secretar%' and nm_curso like '%executiv%';
update kls_lms_curso set cd_agrupamento = concat('AGROI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%agroind%' and nm_curso not like '%prod%';
update kls_lms_curso set cd_agrupamento = concat('PAGRO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%agroind%' and nm_curso like '%prod%';
update kls_lms_curso set cd_agrupamento = concat('SEGTR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%segur%' and nm_curso like '%trab%' ;
update kls_lms_curso set cd_agrupamento = concat('SEGIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%segur%' and nm_curso like '%infor%';
update kls_lms_curso set cd_agrupamento = concat('SISIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%sistem%' and nm_curso like '%infor%';
update kls_lms_curso set cd_agrupamento = concat('MULTI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%multimi%';
update kls_lms_curso set cd_agrupamento = concat('MULDI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%multime%';
update kls_lms_curso set cd_agrupamento = concat('COMEX', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%comerc%' and nm_curso like '%exter%' and nm_curso not like '%admin%';
update kls_lms_curso set cd_agrupamento = concat('FONOG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%fonogr%';
update kls_lms_curso set cd_agrupamento = concat('ANDES', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='')and (nm_curso like '%analis%' or nm_curso like '%desenv%') and (nm_curso like '%sis%' or nm_curso like '%soft%')  and nm_curso not like '%inform%';
update kls_lms_curso set cd_agrupamento = concat('JORNA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%jorna%' and nm_curso not like '%publ%';
update kls_lms_curso set cd_agrupamento = concat('ESTVI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%visag%';
update kls_lms_curso set cd_agrupamento = concat('ATUAR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%atuar%';
update kls_lms_curso set cd_agrupamento = concat('QUIIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%quimi%' and nm_curso not like 'Tecnico em %' and nm_curso not like '%Enge%' and nm_curso like '%Indus%' and nm_curso not like '%proc%';
update kls_lms_curso set cd_agrupamento = concat('QUIIL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%quimi%' and nm_curso not like 'Tecnico em %' and nm_curso not like '%Enge%' and nm_curso like '%Indus%';
update kls_lms_curso set cd_agrupamento = concat('QUIIB', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%quimi%' and nm_curso not like 'Tecnico em %' and nm_curso not like '%Enge%' and nm_curso like '%Indus%';
update kls_lms_curso set cd_agrupamento = concat('QUIML', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Química%';
update kls_lms_curso set cd_agrupamento = concat('SISEL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'CST em Sistemas Elétricos%';
update kls_lms_curso set cd_agrupamento = concat('GQUAL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Tecnologia em Gestão da Qualidade%';
update kls_lms_curso set cd_agrupamento = concat('PQUIM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%quimi%' and nm_curso not like 'Tecnico em %' and nm_curso not like '%Enge%' and nm_curso not like '%Indus%' and nm_curso not like '%farm%' and nm_curso not like '%natur%' and nm_curso like '%proc%';
update kls_lms_curso set cd_agrupamento = concat('DINSD', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%indus%' and nm_curso not like '%Prod%' and nm_curso like '%Desen%';
update kls_lms_curso set cd_agrupamento = concat('MINDU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%indus%' and nm_curso not like '%Prod%' and nm_curso not like '%Desen%' and nm_curso not like '%quim%' and nm_curso not like '%agroin%' and nm_curso like '%manut%';
update kls_lms_curso set cd_agrupamento = concat('AINDU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%indus%' and nm_curso like '%autom%';
update kls_lms_curso set cd_agrupamento = concat('PRIND', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%indus%' and nm_curso like '%producao%' and nm_curso not like '%Gest%' and nm_curso not like '%agro%';
update kls_lms_curso set cd_agrupamento = concat('GPRIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%indus%' and nm_curso like '%producao%' and nm_curso like '%Gest%' and nm_curso not like '%agro%';
update kls_lms_curso set cd_agrupamento = concat('MARPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%market%' and nm_curso like '%propaga%';
update kls_lms_curso set cd_agrupamento = concat('RPUBL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%relac%' and nm_curso like '%publ%';
update kls_lms_curso set cd_agrupamento = concat('GAMBI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%ambient%' and nm_curso like '%gest%';
update kls_lms_curso set cd_agrupamento = concat('TINFO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%tecnolog%' and nm_curso like '%informa%';
update kls_lms_curso set cd_agrupamento = concat('PILAE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%aeron%' and   nm_curso like '%pil%';
update kls_lms_curso set cd_agrupamento = concat('CAERO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%aeron%' and   nm_curso like '%cie%';
update kls_lms_curso set cd_agrupamento = concat('BIBLI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%bibliot%';
update kls_lms_curso set cd_agrupamento = concat('FPEDA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%pedagogica%';
update kls_lms_curso set cd_agrupamento = concat('ENGMI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%engen%' and nm_curso like '%minas%';
update kls_lms_curso set cd_agrupamento = concat('ENGFL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%engen%' and nm_curso like '%flore%';
update kls_lms_curso set cd_agrupamento = concat('SEGPU', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%seg%' and nm_curso like '%publ%';
update kls_lms_curso set cd_agrupamento = concat('MARVA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%market%' and nm_curso like '%vare%';
update kls_lms_curso set cd_agrupamento = concat('MARTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%market%' and nm_curso like '%tel%';
update kls_lms_curso set cd_agrupamento = concat('MARSA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%market%' and nm_curso like '%sau%';
update kls_lms_curso set cd_agrupamento = concat('GAGRO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gest%' and nm_curso like '%agro%';
update kls_lms_curso set cd_agrupamento = concat('TOCUP', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'terapia%';
update kls_lms_curso set cd_agrupamento = concat('NUCIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso regexp 'cleo de dis(ci|ic)plinas integrada';
update kls_lms_curso set cd_agrupamento = concat('ENMET', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Engenharia Metalúrgica%';
update kls_lms_curso set cd_agrupamento = concat('GCIDA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gerente%' and nm_curso like '%cida%';
update kls_lms_curso set cd_agrupamento = concat('CIMAT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%cienc%' and nm_curso like '%mate%' and nm_curso not like '%natu%';
update kls_lms_curso set cd_agrupamento = concat('PETRO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%petr%';
update kls_lms_curso set cd_agrupamento = concat('PLENL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%plenifi%' or nm_curso like '%plen.%';
update kls_lms_curso set cd_agrupamento = concat('GNRIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gest%' and nm_curso like '%inter%' and nm_curso not like '%admin%';
update kls_lms_curso set cd_agrupamento = concat('GIMES', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gest%' and nm_curso like '%mark%' and nm_curso like '%estr%';
update kls_lms_curso set cd_agrupamento = concat('ALIME', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%alime%' and nm_curso not like '%eng%' and nm_curso not like '%gest%';
update kls_lms_curso set cd_agrupamento = concat('GALIM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%alime%' and nm_curso not like '%eng%' and nm_curso like '%gest%';
update kls_lms_curso set cd_agrupamento = concat('BANCO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%banco%' and nm_curso like '%dados%' and nm_curso not like '%gest%';
update kls_lms_curso set cd_agrupamento = concat('GBANC', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão Bancária%'; 
update kls_lms_curso set cd_agrupamento = concat('COMEM', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%comun%' and nm_curso like '%empre%';
update kls_lms_curso set cd_agrupamento = concat('DGRAF', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%desig%' and nm_curso like '%graf%';
update kls_lms_curso set cd_agrupamento = concat('JDIGI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%jogos%' and nm_curso like '%dig%';
update kls_lms_curso set cd_agrupamento = concat('MECAG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%mecaniz%' and nm_curso like '%agri%';
update kls_lms_curso set cd_agrupamento = concat('MECAT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%mecatro%' and nm_curso not like '%eng%';
update kls_lms_curso set cd_agrupamento = concat('IMOBI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%imobil%';
update kls_lms_curso set cd_agrupamento = concat('PAISA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%paisa%';
update kls_lms_curso set cd_agrupamento = concat('DINPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%dese%' and nm_curso like '%indus%' and nm_curso like '%prod%';
update kls_lms_curso set cd_agrupamento = concat('ENGET', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%eng%' and nm_curso like '%eletron%';
update kls_lms_curso set cd_agrupamento = concat('PUBJO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%publ%' and nm_curso like '%jorn%';
update kls_lms_curso set cd_agrupamento = concat('IMPES', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%imag%' and nm_curso like '%pess%';
update kls_lms_curso set cd_agrupamento = concat('WEBSI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%website%';
update kls_lms_curso set cd_agrupamento = concat('DESIG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso in ('design','Design - M' ,'Design - N','Design - Bacharelado - N');
update kls_lms_curso set cd_agrupamento = concat('COMIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%inst%';
update kls_lms_curso set cd_agrupamento = concat('GRAOS', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%grao%';
update kls_lms_curso set cd_agrupamento = concat('ALESP', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%especia%' and nm_curso like '%alun%';
update kls_lms_curso set cd_agrupamento = concat('GEEMP', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gestao%' and nm_curso like '%empresa%';
update kls_lms_curso set cd_agrupamento = concat('GESVE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso regexp 'Gestão Estratégica de Vendas';
update kls_lms_curso set cd_agrupamento = concat('DEPIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso regexp 'depend(ê|e)ncia interativa';
update kls_lms_curso set cd_agrupamento = concat('TECPO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and (nm_curso regexp 'tecnologia em pol(i|í)meros'  or nm_curso like 'Cst em Polímeros%'); 
update kls_lms_curso set cd_agrupamento = concat('ELIND', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'CST em Eletrotécnica Industrial%';
update kls_lms_curso set cd_agrupamento = concat('GEQUA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'CST em Gestão da Qualidade%';
update kls_lms_curso set cd_agrupamento = concat('ENGFL', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Engenharia Florestal%';
update kls_lms_curso set cd_agrupamento = concat('ENGMI', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Engenharia de Minas%';
update kls_lms_curso set cd_agrupamento = concat('DINSD', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'Desenho Industrial - Programação Visual%';
update kls_lms_curso set cd_agrupamento = concat('AGRON', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like 'CST em Agronegócio%';
update kls_lms_curso set cd_agrupamento = concat('DGRAF', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Design Gráfico%';
update kls_lms_curso set cd_agrupamento = concat('FOTOG', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%fotografia%';
update kls_lms_curso set cd_agrupamento = concat('PILOT', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Pilotagem Prof. de Aeronaves%';
update kls_lms_curso set cd_agrupamento = concat('ENMET', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Engenharia Metalúrgica%';
update kls_lms_curso set cd_agrupamento = concat('TECIN', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Tecnologia em Gestão da Tecnologia da Informação%'; 
update kls_lms_curso set cd_agrupamento = concat('ENGCA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'Engenharia de Cont e Automação - Mista';
update kls_lms_curso set cd_agrupamento = concat('SINTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'Curso Sup. de tec em Sistemas Para Inter';
update kls_lms_curso set cd_agrupamento = concat('TINFO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso in ('CST em Gestão Tecnol da Informação - N','CST em Gestão Tecnol da Informação - M','CST em Gestão da TI - N');
update kls_lms_curso set cd_agrupamento = concat('ARTEV', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso in ('Tec. em Artes Visuais (Not)','Tec. em Artes Visuais (Mat)');
update kls_lms_curso set cd_agrupamento = concat('SEGPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'CST em Gestão de Segurança Privada - N';
update kls_lms_curso set cd_agrupamento = concat('ENGMA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'Engenharia de Materiais - M';
update kls_lms_curso set cd_agrupamento = concat('ENGCA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'Engenharia de Cont e Automação - Mista';
update kls_lms_curso set cd_agrupamento = concat('DANCA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso = 'DANCA'; 
update kls_lms_curso set cd_agrupamento = concat('QUIMA', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Química Ambiental%'; 
update kls_lms_curso set cd_agrupamento = concat('GCOMV', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão de Comércio Varejista%'; 
update kls_lms_curso set cd_agrupamento = concat('SISTE', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Sistemas de Telecomunicações%'; 
update kls_lms_curso set cd_agrupamento = concat('EDSET', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Educação e Segurança Para o Trânsito%'; 
update kls_lms_curso set cd_agrupamento = concat('GCOMS', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão de Comércio e Serviços%'; 
update kls_lms_curso set cd_agrupamento = concat('GSEPR', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%Gestão de Seguros e Previd%'; 
update kls_lms_curso set cd_agrupamento = concat('TINFO', titulacao) where titulacao in ('T','B','L') and (cd_agrupamento is null or cd_agrupamento='') and nm_curso like '%gestão de Ti%'; 


-- PROJETO PILOTO 2019/01

-- PROJETO PILOTO 1

UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_METOD_CIENT_PILOT_1'
WHERE	
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Metodologia Cie' AND
	i.cd_instituicao REGEXP '^OLIM-(552|637|663)';

UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_PROBI_ESTAT_PILOT_1'
WHERE
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Probabilidade e Es' AND
	i.cd_instituicao REGEXP '^OLIM-(552|637|663)';

-- PROJETO PILOTO 2	
	
UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_METOD_CIENT_PILOT_2'
WHERE	
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Metodologia Cie' AND
	i.cd_instituicao REGEXP '^OLIM-(502|554)';

UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_PROBI_ESTAT_PILOT_2'
WHERE
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Probabilidade e Es' AND
	i.cd_instituicao REGEXP '^OLIM-(502|554)';

-- PROJETO PILOTO 3

UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_METOD_CIENT_PILOT_3'
WHERE	
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Metodologia Cie' AND
	i.cd_instituicao REGEXP '^OLIM-(616|633|666)';

UPDATE kls_lms_disciplina d
JOIN kls_lms_tipo_modelo m on m.id_tp_modelo=d.id_tp_modelo
JOIN kls_lms_curso_disciplina cd on cd.id_disciplina=d.id_disciplina and cd.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_curso c on c.id_curso=cd.id_curso and c.fl_etl_atu REGEXP '[NA]'
JOIN kls_lms_instituicao i on i.id_ies=c.id_ies and i.fl_etl_atu REGEXP '[NA]'
SET cd.shortname='DIPP_PROBI_ESTAT_PILOT_3'
WHERE
	cd.shortname='A DEFINIR' AND
	d.fl_etl_atu REGEXP '[NA]' AND
	m.sigla='DI' AND 
	d.ds_disciplina REGEXP 'Probabilidade e Es' AND
	i.cd_instituicao REGEXP '^OLIM-(616|633|666)';


-- FIM DA MARCAÇÃO DO PROJETO PILOTO 2019/01
	

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA  and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo and tm.sigla='DI'
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) and c.shortname like 'DI\_%'
	
	set kls.shortname=c.shortname 
	where (length(kls.shortname)<=1 OR kls.shortname='A DEFINIR' OR kls.shortname IS NULL) and kls.FL_ETL_ATU<>'E';

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA  and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo and tm.sigla='DIB'
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) and c.shortname like 'DIB\_%'
	
	set kls.shortname=c.shortname 
	where (length(kls.shortname)<=1 OR kls.shortname='A DEFINIR' OR kls.shortname IS NULL) and kls.FL_ETL_ATU<>'E';

	
	UPDATE kls_lms_curso_disciplina kcd
	JOIN kls_lms_curso kc ON kc.id_curso = kcd.id_curso
	JOIN kls_lms_agrupamento ka ON ka.cd_agrupamento = kc.cd_agrupamento 
	JOIN kls_lms_disciplina kd ON kcd.ID_DISCIPLINA = kd.ID_DISCIPLINA
	JOIN mdl_course c ON c.shortname = CONCAT(kcd.shortname ,'_' ,kc.cd_agrupamento) AND c.shortname LIKE 'TCCV%'
	SET kcd.SHORTNAME = c.shortname
	WHERE c.visible=1 AND kcd.shortname REGEXP 'TCCVU$|TCCV[1-3]/[1-3]$';

	
	update kls_lms_curso_disciplina kcd
	join kls_lms_curso kc on kc.id_curso=kcd.id_curso
	join kls_lms_agrupamento ka on ka.cd_agrupamento=kc.cd_agrupamento 
	join kls_lms_disciplina kd on kcd.ID_DISCIPLINA=kd.ID_DISCIPLINA
	join kls_lms_tipo_modelo tm on tm.id_tp_modelo=kd.id_tp_modelo
	join mdl_course c on upper(c.fullname)=concat(upper(kd.DS_DISCIPLINA),' - ',ka.ds_agrupamento) and c.shortname LIKE 'ESTV%'
	SET kcd.SHORTNAME=c.shortname							
	where 
		kcd.shortname IN ('ESTV','ESTVI', 'ESTVII', 'ESTVIII') and 
		c.visible=1 AND
		tm.sigla='EST';

	
	update kls_lms_curso_disciplina kcd
	join kls_lms_curso kc on kc.id_curso=kcd.id_curso
	join kls_lms_agrupamento ka on ka.cd_agrupamento=kc.cd_agrupamento 
	join kls_lms_disciplina kd on kcd.ID_DISCIPLINA=kd.ID_DISCIPLINA
	join kls_lms_tipo_modelo tm on tm.id_tp_modelo=kd.id_tp_modelo
	JOIN anh_shortname_exc exc on exc.fullname=concat(upper(kd.DS_DISCIPLINA),' - ',ka.ds_agrupamento) and exc.tipo_modelo='ESTV'
	join mdl_course c on c.shortname=exc.shortname
	SET kcd.SHORTNAME=c.shortname							
	where kcd.shortname IN ('ESTV','ESTVI', 'ESTVII', 'ESTVIII') and c.visible=1 AND tm.sigla='EST' ;

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='DI'
	join mdl_course c on c.shortname=exc.shortname 
	join mdl_course_categories cc on cc.id=c.category and cc.name REGEXP 'Disciplinas Interativas KLS [12].0'	
	set kls.shortname=c.shortname 
	where tm.sigla='DI' and  (length(kls.shortname)<=1 or kls.shortname='A DEFINIR' or kls.shortname is null);

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='DIB'
	join mdl_course c on c.shortname=exc.shortname 
	
	set kls.shortname=c.shortname 
	where tm.sigla='DIB' and  (length(kls.shortname)<=1 or kls.shortname='A DEFINIR' or kls.shortname is null);

	
	update kls_lms_curso_disciplina kcd
	join kls_lms_curso kc on kc.id_curso=kcd.id_curso
	join kls_lms_disciplina kd on kcd.ID_DISCIPLINA=kd.ID_DISCIPLINA
	join kls_lms_tipo_modelo tm on kd.id_tp_modelo=tm.id_tp_modelo 
	join mdl_course c on upper(c.fullname)=concat(upper(kd.DS_DISCIPLINA)) and c.shortname LIKE 'ESTP%'
	SET kcd.SHORTNAME=c.shortname							
	where kcd.shortname='ESTP' AND tm.sigla='EST';	

	
	update kls_lms_curso_disciplina kcd
	join kls_lms_curso kc on kc.id_curso=kcd.id_curso
	join kls_lms_agrupamento ka on ka.cd_agrupamento=kc.cd_agrupamento 
	join kls_lms_disciplina kd on kcd.ID_DISCIPLINA=kd.ID_DISCIPLINA
	join mdl_course c on upper(c.fullname)=concat(upper(kd.DS_DISCIPLINA))
								and c.shortname LIKE 'TCCP%'
	SET kcd.SHORTNAME=c.shortname							
	where kcd.shortname='TCCP';	


	  
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 	
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) and c.shortname LIKE 'AMI\_%'
	
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMI' and kls.shortname='A DEFINIR' ;

	  

	update kls_lms_curso_disciplina kls 
	join kls_lms_curso kc on kc.id_curso=kls.id_curso and kc.cd_agrupamento='MEDICB'
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU REGEXP '[NA]'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 	
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) AND c.shortname REGEXP '^AMP_MEDIC'
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMP' and kls.shortname='A DEFINIR' and kls.fl_etl_atu REGEXP '[NA]';

	update kls_lms_curso_disciplina kls 
	join kls_lms_curso kc on kc.id_curso=kls.id_curso and kc.cd_agrupamento<>'MEDICB'
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU  REGEXP '[NA]'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 	
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) AND c.shortname LIKE 'AMP\_%' AND c.shortname NOT REGEXP '^AMP_MEDIC' 
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMP' and kls.shortname='A DEFINIR'  and kls.fl_etl_atu REGEXP '[NA]';

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU  REGEXP '[NA]'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='AMI'
	join mdl_course c on c.shortname=exc.shortname AND c.shortname LIKE 'AMI\_%'
	
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMI' and kls.shortname='A DEFINIR' ;	

	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='AMI'
	join mdl_course c on c.shortname=exc.shortname AND c.shortname LIKE 'AMI\_%'
	
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMI' and kls.shortname='A DEFINIR' ;	

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_curso kc on kc.id_curso=kls.id_curso and kc.cd_agrupamento='MEDICB'
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='AMP'
	join mdl_course c on c.shortname=exc.shortname AND c.shortname REGEXP '^AMP\_MEDIC'		
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMP' and kls.shortname='A DEFINIR' ;	

	update kls_lms_curso_disciplina kls 
	join kls_lms_curso kc on kc.id_curso=kls.id_curso and kc.cd_agrupamento<>'MEDICB'
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='AMP'
	join mdl_course c on c.shortname=exc.shortname AND c.shortname LIKE 'AMP\_%' AND c.shortname NOT REGEXP '^AMP\_MEDIC'	
	set kls.shortname=c.shortname 
	where tm.SIGLA='AMP' and kls.shortname='A DEFINIR' ;


	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='ESTP'
	join mdl_course c on c.shortname=exc.shortname
	set kls.shortname=c.shortname 
	where tm.SIGLA='EST' and kls.shortname='ESTP' ;

	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 		
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='TCCP'
	join mdl_course c on c.shortname=exc.shortname
	set kls.shortname=c.shortname 
	where tm.SIGLA='TCC' and kls.shortname='TCCP' ;
	

 
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA  and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo and tm.sigla='HIB'
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) and c.shortname like 'HAMP\_%'
	set kls.shortname=c.shortname 
	where (length(kls.shortname)<=1 OR kls.shortname='HAMP' OR kls.shortname IS NULL) and kls.FL_ETL_ATU<>'E';
	
	
	 
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA  and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo and tm.sigla='HIB'
	join mdl_course c on upper(d.ds_disciplina)=upper(c.fullname) and c.shortname like 'HAMI\_%'
	set kls.shortname=c.shortname 
	where (length(kls.shortname)<=1 OR kls.shortname='HAMI' OR kls.shortname IS NULL) and kls.FL_ETL_ATU<>'E';
	
	
	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='HAMI'
	join mdl_course c on c.shortname=exc.shortname 
		set kls.shortname=c.shortname 
	where tm.sigla='HIB' and  (length(kls.shortname)<=1 or kls.shortname='HAMI' or kls.shortname is null);
 
 
	
	update kls_lms_curso_disciplina kls 
	join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA and d.FL_ETL_ATU<>'E'
	join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo 
   join anh_shortname_exc exc on upper(d.ds_disciplina)=upper(exc.fullname) and exc.tipo_modelo='HAMP'
	join mdl_course c on c.shortname=exc.shortname 
		set kls.shortname=c.shortname 
	where tm.sigla='HIB' and  (length(kls.shortname)<=1 or kls.shortname='HAMP' or kls.shortname is null);

update kls_lms_curso_disciplina kls 
join kls_lms_disciplina d on kls.ID_DISCIPLINA=d.ID_DISCIPLINA  and d.FL_ETL_ATU<>'E'
join kls_lms_curso cu on cu.id_curso = kls.id_curso
join kls_lms_agrupamento a on a.cd_agrupamento = cu.cd_agrupamento
join kls_lms_tipo_modelo tm on d.id_tp_modelo=tm.id_tp_modelo and tm.sigla='DI'
join mdl_course c on upper(concat(d.ds_disciplina,' ', a.ds_agrupamento))=upper(c.fullname) AND c.shortname like 'DI\_%'
JOIN mdl_course_categories cc on cc.id=c.category and cc.name REGEXP 'Disciplina Interativa [12].0'
set kls.shortname=c.shortname 
where (length(kls.shortname)<=1 OR kls.shortname='A DEFINIR' OR kls.shortname IS NULL) and kls.FL_ETL_ATU<>'E';




UPDATE mdl_course c
JOIN mdl_course_categories cc on cc.id=c.category and cc.name REGEXP '1'
set c.idnumber='DI1'
where shortname LIKE 'DI%' AND c.idnumber<>'DI1';
UPDATE mdl_course c
JOIN mdl_course_categories cc on cc.id=c.category and cc.name REGEXP '2'
set c.idnumber='DI2'
where shortname LIKE 'DI%' AND c.idnumber<>'DI2';
UPDATE mdl_course SET idnumber=SUBSTR(shortname,1,4) WHERE shortname REGEXP '^TCCP|^ESTP';
UPDATE mdl_course SET idnumber='EST' where shortname LIKE 'ESTV%' AND idnumber<>'EST';
UPDATE mdl_course SET idnumber='TCC' where shortname LIKE 'TCCV%' AND idnumber<>'TCC';
UPDATE mdl_course SET idnumber='AMI' where shortname LIKE 'AMI%' AND idnumber<>'AMI';
UPDATE mdl_course SET idnumber='HIB' where shortname LIKE 'HAM%' AND idnumber<>'HIB';
UPDATE mdl_course SET idnumber='AMP' where shortname LIKE 'AMP%' AND idnumber<>'AMP';

 

insert into mdl_block_instances (blockname, parentcontextid, 
showinsubcontexts, requiredbytheme, pagetypepattern,
defaultregion, defaultweight, configdata)
select distinct
	'completionstatus', co.id, 0, 0, 'course-view-*', 'side-pre',
	3,''
from mdl_context co 
left join mdl_block_instances i on i.parentcontextid=co.id and i.blockname='completionstatus'
where contextlevel=50 and i.id is null;




INSERT INTO anh_carga_log (DATA_CARGA,ETAPA,INICIO) VALUES (NOW()-interval 3 hour,'MARCACAO TIPO AVALIACAO', NOW()-interval 3 hour);
SET V_OPERACAO_ID=LAST_INSERT_ID();
CALL PRC_TIPO_AVALIACAO;
UPDATE anh_carga_log SET TERMINO=NOW()-interval 3 hour WHERE ID=V_OPERACAO_ID;
COMMIT;


INSERT INTO anh_carga_log (DATA_CARGA,ETAPA,INICIO) VALUES (NOW()-interval 3 hour,'AUTO VÍNCULO DO PLANO DE ENSINO', NOW()-interval 3 hour);
SET V_OPERACAO_ID=LAST_INSERT_ID();
CALL PRC_VINCULO_PDE;
UPDATE anh_carga_log SET TERMINO=NOW()-interval 3 hour WHERE ID=V_OPERACAO_ID;
COMMIT;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
