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

-- Copiando estrutura para tabela prod_kls.sgt_tutor_coord
CREATE TABLE IF NOT EXISTS `sgt_tutor_coord` (
  `tutoralocado` varchar(3) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `produto` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `timecreated` varchar(30) CHARACTER SET utf8mb4 DEFAULT NULL,
  `username` varchar(100) NOT NULL DEFAULT '',
  `nome` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `email` varchar(100) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `area_formacao` varchar(200) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `limite_ed` int(11) NOT NULL DEFAULT '0',
  `limite_di` int(11) NOT NULL DEFAULT '0',
  `limite_dib` int(11) NOT NULL DEFAULT '0',
  `limite_tcc` int(11) NOT NULL DEFAULT '0',
  `limite_npj` int(11) NOT NULL DEFAULT '0',
  `limite_est` int(11) NOT NULL DEFAULT '0',
  `limite_hib` int(11) NOT NULL DEFAULT '0',
  `qtd_alunos` int(11) DEFAULT NULL,
  `nome_coord` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `nome_grupo` varchar(254) NOT NULL DEFAULT '',
  `id` bigint(10) NOT NULL DEFAULT '0',
  `id_coordenador` int(11) NOT NULL DEFAULT '0',
  `sgt_user_id` int(11) NOT NULL DEFAULT '0',
  KEY `sgt_tutor_coordIDX` (`id`),
  KEY `idx_nome_grupo` (`nome_grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
