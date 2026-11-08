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

-- El script deja la base de datos en un estado conocido: borra y vuelve a crear las tablas.
DROP TABLE IF EXISTS `transactions`, `products`, `creditcards`, `users`;

-- ========================================================
-- 1. PRIMERO CREAMOS LA TABLA USERS (para que las demás puedan enlazarla)
-- ========================================================
CREATE TABLE IF NOT EXISTS `users` (
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `documentIdentity` enum('DNI','NIE') DEFAULT NULL,
  `documentNumber` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `postalCode` varchar(50) DEFAULT NULL,
  `birthday` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.users
INSERT INTO `users` (`email`, `password`, `id`, `name`, `surname`, `documentIdentity`, `documentNumber`, `country`, `address`, `postalCode`, `birthday`) VALUES
	('prueba00@gmail.com', 'c893bad68927b457dbed39460e6afd62', 24, 'Ana', 'López Fernández', 'DNI', '11111111H', 'ES', 'Calle Uría 5', '33003', 631152000000),
	('prueba01@gmail.com', 'c893bad68927b457dbed39460e6afd62', 25, 'Luis', 'Martín Suárez', 'NIE', 'X1234567L', 'ES', 'Avenida Galicia 12', '33005', 725846400000),
	('prueba02@gmail.com', 'c893bad68927b457dbed39460e6afd62', 26, 'Marta', 'Ruiz García', 'DNI', '22222222J', 'ES', 'Calle Toreno 3', '33004', 883612800000),
	('pepito@email.com', '32164702f8ffd2b418d780ff02371e4c', 27, 'Pepito', 'Pérez García', 'DNI', '12345678Z', 'ES', 'Calle Mayor 10', '28001', 800409600000);


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
) ENGINE=InnoDB AUTO_INCREMENT=1042 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.products
-- 41 productos, todos con una de las 7 categorías de la aplicación (consola, movil, ropa, libros, hogar, planta, deportes).
-- FOTOS: la imagen de cada producto es public/images/<id>.png y la única foto del repositorio es public/images/60.png.
-- 12 productos llevan foto (copias de 60.png con su id) y los otros 29 no tienen foto, para probar ambos casos:
--   1001, 1003, 1009, 1013, 1018, 1021, 1024, 1027, 1030, 1033, 1036, 1039
-- Tras importar el script, ejecutar desde la carpeta del backend (las copias no se suben a git):
--   for id in 1001 1003 1009 1013 1018 1021 1024 1027 1030 1033 1036 1039; do cp public/images/60.png public/images/$id.png; done
-- Los ids empiezan en 1001 para que ningún producto coincida con otras imágenes que haya en public/images.
-- pepito@email.com (27) tiene 8 productos a la venta, 4 vendidos y 5 comprados; el resto de usuarios venden productos que pepito puede comprar.
-- Las fechas son relativas al momento de importar el script (hace N días).
INSERT INTO `products` (`title`, `id`, `date`, `description`, `buyerId`, `sellerId`, `price`, `category`) VALUES
	('Nintendo Switch con dos mandos', 1001, UNIX_TIMESTAMP(NOW(3)) * 1000 - 172800000, 'Consola en perfecto estado, incluye base, dos mandos y cargador original.', NULL, 27, 210, 'consola'),
	('iPhone 12 de 128 GB', 1002, UNIX_TIMESTAMP(NOW(3)) * 1000 - 259200000, 'Batería al 87 %, pantalla sin arañazos. Se entrega con funda.', NULL, 27, 320, 'movil'),
	('Abrigo de lana talla M', 1003, UNIX_TIMESTAMP(NOW(3)) * 1000 - 432000000, 'Abrigo largo gris, solo usado un invierno.', NULL, 27, 45.5, 'ropa'),
	('El nombre del viento', 1004, UNIX_TIMESTAMP(NOW(3)) * 1000 - 518400000, 'Novela de fantasía en tapa dura, como nueva.', NULL, 27, 12, 'libros'),
	('Lámpara de pie nórdica', 1005, UNIX_TIMESTAMP(NOW(3)) * 1000 - 691200000, 'Lámpara de madera con pantalla de tela blanca, 150 cm.', NULL, 27, 38, 'hogar'),
	('Monstera deliciosa', 1006, UNIX_TIMESTAMP(NOW(3)) * 1000 - 777600000, 'Planta de interior de 60 cm con maceta incluida.', NULL, 27, 25, 'planta'),
	('Bicicleta de montaña 29', 1007, UNIX_TIMESTAMP(NOW(3)) * 1000 - 950400000, 'Cuadro de aluminio talla L, frenos de disco revisados.', NULL, 27, 260, 'deportes'),
	('Mando PS5 DualSense', 1008, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1036800000, 'Mando blanco original, funciona perfectamente.', NULL, 27, 40, 'consola'),
	('PlayStation 4 Slim 500 GB', 1009, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2592000000, 'Consola con un mando y cable HDMI.', 24, 27, 150, 'consola'),
	('Samsung Galaxy A52', 1010, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2419200000, 'Móvil libre con cargador, pantalla impecable.', 25, 27, 140, 'movil'),
	('Zapatillas de running 43', 1011, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2073600000, 'Zapatillas con poco uso, suela en buen estado.', 26, 27, 35, 'deportes'),
	('Pack de novelas policíacas', 1012, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1814400000, 'Tres novelas de bolsillo en buen estado.', 24, 27, 15, 'libros'),
	('Xbox Series S', 1013, UNIX_TIMESTAMP(NOW(3)) * 1000 - 3024000000, 'Consola de 512 GB con mando, en su caja.', 27, 24, 190, 'consola'),
	('Funda para móvil universal', 1014, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2246400000, 'Funda de piel con tarjetero, ajustable.', 27, 25, 10, 'movil'),
	('Chaqueta vaquera talla L', 1015, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1987200000, 'Chaqueta clásica azul, poco uso.', 27, 26, 22, 'ropa'),
	('Cactus en maceta de barro', 1016, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1641600000, 'Pack de tres cactus pequeños.', 27, 24, 9, 'planta'),
	('Juego de sartenes', 1017, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1382400000, 'Tres sartenes antiadherentes de distintos tamaños.', 27, 25, 30, 'hogar'),
	('Mario Kart 8 Deluxe', 1018, UNIX_TIMESTAMP(NOW(3)) * 1000 - 86400000, 'Juego de Nintendo Switch, cartucho y caja.', NULL, 24, 35, 'consola'),
	('Steam Deck 64 GB', 1019, UNIX_TIMESTAMP(NOW(3)) * 1000 - 345600000, 'Consola portátil con funda de transporte.', NULL, 25, 280, 'consola'),
	('Auriculares gaming con micrófono', 1020, UNIX_TIMESTAMP(NOW(3)) * 1000 - 604800000, 'Auriculares con sonido envolvente y cable USB.', NULL, 26, 25, 'consola'),
	('Xiaomi Redmi Note 11', 1021, UNIX_TIMESTAMP(NOW(3)) * 1000 - 172800000, 'Móvil libre de 128 GB con cargador rápido.', NULL, 24, 120, 'movil'),
	('Cargador inalambrico rápido', 1022, UNIX_TIMESTAMP(NOW(3)) * 1000 - 864000000, 'Base de carga de 15 W compatible con Qi.', NULL, 26, 14, 'movil'),
	('Smartwatch deportivo', 1023, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1123200000, 'Reloj con GPS y pulsómetro, correa nueva.', NULL, 25, 55, 'movil'),
	('Sudadera con capucha', 1024, UNIX_TIMESTAMP(NOW(3)) * 1000 - 259200000, 'Sudadera negra talla M de algodón.', NULL, 24, 18, 'ropa'),
	('Vestido de verano', 1025, UNIX_TIMESTAMP(NOW(3)) * 1000 - 518400000, 'Vestido de flores talla S, sin usar.', NULL, 25, 20, 'ropa'),
	('Botas de montaña 41', 1026, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1296000000, 'Botas impermeables, usadas en dos rutas.', NULL, 26, 40, 'ropa'),
	('Harry Potter coleccion completa', 1027, UNIX_TIMESTAMP(NOW(3)) * 1000 - 345600000, 'Los siete libros en tapa blanda.', NULL, 25, 60, 'libros'),
	('Libro de cocina mediterránea', 1028, UNIX_TIMESTAMP(NOW(3)) * 1000 - 691200000, 'Más de cien recetas con fotos.', NULL, 26, 9.5, 'libros'),
	('Cómic Spider-Man tomo 1', 1029, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1036800000, 'Edición integral en tapa dura.', NULL, 24, 16, 'libros'),
	('Cafetera de cápsulas', 1030, UNIX_TIMESTAMP(NOW(3)) * 1000 - 432000000, 'Cafetera con depósito de un litro, descalcificada.', NULL, 24, 35, 'hogar'),
	('Silla de escritorio ergonómica', 1031, UNIX_TIMESTAMP(NOW(3)) * 1000 - 777600000, 'Silla regulable con soporte lumbar.', NULL, 26, 70, 'hogar'),
	('Espejo redondo de pared', 1032, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1209600000, 'Espejo de 60 cm con marco dorado.', NULL, 25, 28, 'hogar'),
	('Ficus benjamina', 1033, UNIX_TIMESTAMP(NOW(3)) * 1000 - 172800000, 'Árbol de interior de un metro de altura.', NULL, 25, 22, 'planta'),
	('Orquídea blanca', 1034, UNIX_TIMESTAMP(NOW(3)) * 1000 - 518400000, 'Orquídea con dos varas floridas y maceta.', NULL, 26, 15, 'planta'),
	('Set de suculentas', 1035, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1382400000, 'Cinco suculentas variadas en macetas de ceramica.', NULL, 24, 18, 'planta'),
	('Raqueta de pádel', 1036, UNIX_TIMESTAMP(NOW(3)) * 1000 - 259200000, 'Raqueta de carbono con funda, poco uso.', NULL, 24, 65, 'deportes'),
	('Mancuernas ajustables', 1037, UNIX_TIMESTAMP(NOW(3)) * 1000 - 604800000, 'Pareja de mancuernas de 2 a 10 kg.', NULL, 25, 45, 'deportes'),
	('Esterilla de yoga', 1038, UNIX_TIMESTAMP(NOW(3)) * 1000 - 864000000, 'Esterilla antideslizante de 6 mm con correa.', NULL, 26, 12, 'deportes'),
	('Tablet Android 10 pulgadas', 1039, UNIX_TIMESTAMP(NOW(3)) * 1000 - 3456000000, 'Tablet de 64 GB con funda teclado.', 25, 24, 95, 'movil'),
	('Balón de baloncesto', 1040, UNIX_TIMESTAMP(NOW(3)) * 1000 - 3283200000, 'Balón talla 7 de exterior.', 26, 25, 15, 'deportes'),
	('Mesa de centro de madera', 1041, UNIX_TIMESTAMP(NOW(3)) * 1000 - 3110400000, 'Mesa de roble de 90 x 50 cm.', 24, 26, 55, 'hogar');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla products.transactions
INSERT INTO `transactions` (`buyerId`, `sellerId`, `buyerCountry`, `buyerAddress`, `buyerPostCode`, `productId`, `productPrice`, `buyerPaymentId`, `id`, `startDate`, `endDate`) VALUES
	(24, 27, 'ES', 'Calle Uría 5', 33003, 1009, 150, NULL, 1, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2160000000, NULL),
	(25, 27, 'ES', 'Avenida Galicia 12', 33005, 1010, 140, NULL, 2, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1728000000, NULL),
	(26, 27, 'ES', 'Calle Toreno 3', 33004, 1011, 35, NULL, 3, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1296000000, NULL),
	(24, 27, 'ES', 'Calle Uría 5', 33003, 1012, 15, NULL, 4, UNIX_TIMESTAMP(NOW(3)) * 1000 - 864000000, NULL),
	(27, 24, 'ES', 'Calle Mayor 10', 28001, 1013, 190, NULL, 5, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2332800000, NULL),
	(27, 25, 'ES', 'Calle Mayor 10', 28001, 1014, 10, NULL, 6, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1555200000, NULL),
	(27, 26, 'ES', 'Calle Mayor 10', 28001, 1015, 22, NULL, 7, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1209600000, NULL),
	(27, 24, 'ES', 'Calle Mayor 10', 28001, 1016, 9, NULL, 8, UNIX_TIMESTAMP(NOW(3)) * 1000 - 604800000, NULL),
	(27, 25, 'ES', 'Calle Mayor 10', 28001, 1017, 30, NULL, 9, UNIX_TIMESTAMP(NOW(3)) * 1000 - 345600000, NULL),
	(25, 24, 'ES', 'Avenida Galicia 12', 33005, 1039, 95, NULL, 10, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2851200000, NULL),
	(26, 25, 'ES', 'Calle Toreno 3', 33004, 1040, 15, NULL, 11, UNIX_TIMESTAMP(NOW(3)) * 1000 - 2505600000, NULL),
	(24, 26, 'ES', 'Calle Uría 5', 33003, 1041, 55, NULL, 12, UNIX_TIMESTAMP(NOW(3)) * 1000 - 1900800000, NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;