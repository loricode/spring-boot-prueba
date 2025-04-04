-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-04-2025 a las 20:32:51
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pruebadb`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarInventario` (IN `p_id_producto` INT, IN `p_ubicacion` VARCHAR(255))   BEGIN
    -- Si se pasa un ID de producto (no es NULL), buscar por el ID
    IF p_id_producto IS NOT NULL THEN
        SELECT * 
        FROM inventario
        WHERE id_producto = p_id_producto;
    
    -- Si se pasa una ubicación (no es NULL), buscar por ubicación
    ELSEIF p_ubicacion IS NOT NULL THEN
        SELECT * 
        FROM inventario
        WHERE ubicacion = p_ubicacion;
    
    -- Si no se pasa ninguno de los dos parámetros, mostrar todo
    ELSE
        SELECT * 
        FROM inventario;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_inventory` (IN `p_id_inventario` INT)   BEGIN
    -- Intentar eliminar el registro de inventario por id
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el inventario';

        -- Eliminar el registro de inventario
        DELETE FROM inventario
        WHERE id = p_id_inventario;
    END;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_inventory` (IN `p_id_producto` INT, IN `p_ubicacion` VARCHAR(255), IN `p_cantidad_disponible` INT, OUT `p_resultado` BOOLEAN)   BEGIN
    DECLARE v_new_id INT;
    DECLARE v_count INT;
    DECLARE v_producto_exists INT;

    -- Manejador de excepciones
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET p_resultado = FALSE;

    -- Verificar si el producto existe en la tabla producto
    SELECT COUNT(*) INTO v_producto_exists
    FROM producto
    WHERE id_producto = p_id_producto;

    -- Si el producto no existe en la tabla producto, retornar FALSE
    IF v_producto_exists = 0 THEN
        SET p_resultado = FALSE;
    ELSE
        -- Verificar si el producto ya existe en la ubicación en la tabla inventario
        SELECT COUNT(*) INTO v_count
        FROM inventario
        WHERE id_producto = p_id_producto AND ubicacion = p_ubicacion;

        -- Si el producto ya existe en la ubicación, retornar FALSE
        IF v_count > 0 THEN
            SET p_resultado = FALSE;
        ELSE
            -- Obtener el próximo valor de id (el máximo + 1)
            SELECT IFNULL(MAX(id), 0) + 1 INTO v_new_id FROM inventario;

            -- Insertar el nuevo registro de inventario con el id manualmente incrementado
            INSERT INTO inventario (id, id_producto, ubicacion, cantidad_disponible)
            VALUES (v_new_id, p_id_producto, p_ubicacion, p_cantidad_disponible);

            -- Si todo fue bien, retornar TRUE
            SET p_resultado = TRUE;
        END IF;
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_productOrLocation` (IN `p_id_producto` INT, IN `p_ubicacion` VARCHAR(255))   BEGIN
    -- Si se pasa un ID de producto (no es NULL), buscar por el ID
    IF p_id_producto IS NOT NULL THEN
        SELECT * 
        FROM inventario
        WHERE id_producto = p_id_producto;
    
    -- Si se pasa una ubicación (no es NULL), buscar por ubicación
    ELSEIF p_ubicacion IS NOT NULL THEN
        SELECT * 
        FROM inventario
        WHERE ubicacion = p_ubicacion;
    
    -- Si no se pasa ninguno de los dos parámetros, mostrar todo
    ELSE
        SELECT * 
        FROM inventario;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_inventory` (IN `p_id_inventario` INT, IN `p_cantidad_disponible` INT)   BEGIN
    -- Actualizar la cantidad disponible en la tabla inventario
    UPDATE inventario
    SET cantidad_disponible = p_cantidad_disponible
    WHERE id = p_id_inventario;

    -- Puedes añadir aquí un bloque de manejo de errores, si lo necesitas
    -- Ejemplo de cómo hacerlo:
    -- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    --   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al actualizar el inventario';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id` int(11) NOT NULL,
  `cantidad_disponible` int(11) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id`, `cantidad_disponible`, `ubicacion`, `id_producto`) VALUES
(1, 4, 'A1', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario_seq`
--

CREATE TABLE `inventario_seq` (
  `next_not_cached_value` bigint(21) NOT NULL,
  `minimum_value` bigint(21) NOT NULL,
  `maximum_value` bigint(21) NOT NULL,
  `start_value` bigint(21) NOT NULL COMMENT 'start value when sequences is created or value if RESTART is used',
  `increment` bigint(21) NOT NULL COMMENT 'increment value',
  `cache_size` bigint(21) UNSIGNED NOT NULL,
  `cycle_option` tinyint(1) UNSIGNED NOT NULL COMMENT '0 if no cycles are allowed, 1 if the sequence should begin a new cycle when maximum_value is passed',
  `cycle_count` bigint(21) NOT NULL COMMENT 'How many cycles have been done'
) ENGINE=InnoDB;

--
-- Volcado de datos para la tabla `inventario_seq`
--

INSERT INTO `inventario_seq` (`next_not_cached_value`, `minimum_value`, `maximum_value`, `start_value`, `increment`, `cache_size`, `cycle_option`, `cycle_count`) VALUES
(1, 1, 9223372036854775806, 1, 50, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id` int(11) NOT NULL,
  `categoria` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `precio` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id`, `categoria`, `descripcion`, `nombre`, `precio`) VALUES
(2, 'TestTecnologia', 'Dsc test 1', 'test1', 1000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_seq`
--

CREATE TABLE `producto_seq` (
  `next_not_cached_value` bigint(21) NOT NULL,
  `minimum_value` bigint(21) NOT NULL,
  `maximum_value` bigint(21) NOT NULL,
  `start_value` bigint(21) NOT NULL COMMENT 'start value when sequences is created or value if RESTART is used',
  `increment` bigint(21) NOT NULL COMMENT 'increment value',
  `cache_size` bigint(21) UNSIGNED NOT NULL,
  `cycle_option` tinyint(1) UNSIGNED NOT NULL COMMENT '0 if no cycles are allowed, 1 if the sequence should begin a new cycle when maximum_value is passed',
  `cycle_count` bigint(21) NOT NULL COMMENT 'How many cycles have been done'
) ENGINE=InnoDB;

--
-- Volcado de datos para la tabla `producto_seq`
--

INSERT INTO `producto_seq` (`next_not_cached_value`, `minimum_value`, `maximum_value`, `start_value`, `increment`, `cache_size`, `cycle_option`, `cycle_count`) VALUES
(101, 1, 9223372036854775806, 1, 50, 0, 0, 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK16el5pdq2g1pnr09yx5scqmav` (`id_producto`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `FK16el5pdq2g1pnr09yx5scqmav` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
