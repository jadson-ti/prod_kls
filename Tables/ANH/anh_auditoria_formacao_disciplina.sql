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

-- Copiando estrutura para tabela prod_kls.anh_auditoria_formacao_disciplina
CREATE TABLE IF NOT EXISTS `anh_auditoria_formacao_disciplina` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shortname` varchar(50) DEFAULT NULL,
  `area_formacao_anterior` int(11) DEFAULT NULL,
  `area_formacao_nova` int(11) DEFAULT NULL,
  `nivel_anterior` int(11) DEFAULT NULL,
  `nivel_novo` int(11) DEFAULT NULL,
  `evento` varchar(10) DEFAULT NULL,
  `data_atualizacao` bigint(20) DEFAULT NULL,
  `usuario_atualizacao` int(11) DEFAULT NULL,
  `usuario_db` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
