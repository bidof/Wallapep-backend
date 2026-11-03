-- --------------------------------------------------------
-- Host:                     127.0.0.1
-- Versión del servidor:         11.0.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para products
CREATE DATABASE IF NOT EXISTS `products` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `products`;

-- ========================================================
-- 1. PRIMERO CREAMOS LA TABLA USERS (para que las demás puedan enlazarla)
-- ========================================================
CREATE TABLE IF NOT EXISTS `users` (
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `documentIdentity` varchar(50) DEFAULT NULL,
  `documentNumber` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `postalCode` varchar(50) DEFAULT NULL,
  `birthday` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.users
INSERT INTO `users` (`email`, `password`, `id`, `name`, `surname`, `documentIdentity`, `documentNumber`, `country`, `address`, `postalCode`, `birthday`) VALUES
	('prueba00@gmail.com', 'c893bad68927b457dbed39460e6afd62', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('prueba01@gmail.com', 'c893bad68927b457dbed39460e6afd62', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('prueba02@gmail.com', 'c893bad68927b457dbed39460e6afd62', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- ========================================================
-- 2. LUEGO LAS DEMÁS TABLAS (creditcards, products, transactions)
-- ========================================================

-- Volcando estructura para tabla products.creditcards
CREATE TABLE IF NOT EXISTS `creditcards` (
  `userId` bigint(20) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `expirationDate` bigint(20) DEFAULT NULL,
  `code` int(11) DEFAULT NULL,
  `alias` varchar(50) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `FK_creditcarts_users` (`userId`),
  CONSTRAINT `FK_creditcarts_users` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.creditcards
INSERT INTO `creditcards` (`userId`, `number`, `expirationDate`, `code`, `alias`, `id`) VALUES
	(24, '123123', 234324, 2323, 'miTarjeta', 1),
	(24, '123123', 234324, 2323, 'miTarjeta', 2),
	(24, '123123', 234324, 2323, 'miTarjeta', 3);

-- Volcando estructura para tabla products.products
CREATE TABLE IF NOT EXISTS `products` (
  `title` varchar(50) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` bigint(20) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `buyerId` bigint(20) DEFAULT NULL,
  `sellerId` bigint(20) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `buyer` (`buyerId`),
  KEY `seller` (`sellerId`),
  CONSTRAINT `buyer` FOREIGN KEY (`buyerId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `seller` FOREIGN KEY (`sellerId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.products
INSERT INTO `products` (`title`, `id`, `date`, `description`, `buyerId`, `sellerId`, `price`, `category`) VALUES
	('Consola Xbox', 72, 1698148654820, 'Consola Xbox descripcion', 24, 24, 120, 'consola'),
	('Product 2 ', 73, 1698153132849, 'description 2', NULL, 24, 231313, 'consola'),
	('product 3', 74, 1698153209775, 'description product 3', NULL, 24, 33, 'planta'),
	('product4', 75, 0, 'miproducto4', 24, 25, 100, NULL);

-- Volcando estructura para tabla products.transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `buyerId` bigint(20) DEFAULT NULL,
  `sellerId` bigint(20) DEFAULT NULL,
  `buyerCountry` varchar(50) DEFAULT NULL,
  `buyerAddress` varchar(50) DEFAULT NULL,
  `buyerPostCode` int(11) DEFAULT NULL,
  `productId` bigint(20) DEFAULT NULL,
  `productPrice` int(11) DEFAULT NULL,
  `buyerPaymentId` bigint(20) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `startDate` bigint(20) DEFAULT NULL,
  `endDate` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_transactions_users_2` (`sellerId`),
  KEY `FK_transactions_products` (`productId`),
  KEY `FK_transactions_users` (`buyerId`),
  KEY `FK_transactions_creditcards` (`buyerPaymentId`),
  CONSTRAINT `FK_transactions_products` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_transactions_users` FOREIGN KEY (`buyerId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_transactions_users_2` FOREIGN KEY (`sellerId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.transactions
INSERT INTO `transactions` (`buyerId`, `sellerId`, `buyerCountry`, `buyerAddress`, `buyerPostCode`, `productId`, `productPrice`, `buyerPaymentId`, `id`, `startDate`, `endDate`) VALUES
	(24, 24, NULL, NULL, NULL, 72, 120, NULL, 5, NULL, NULL),
	(24, 25, NULL, NULL, NULL, 75, 100, NULL, 6, NULL, NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;