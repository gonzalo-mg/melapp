DROP DATABASE apicultura;
CREATE DATABASE IF NOT EXISTS apicultura;
USE apicultura;

DROP TABLE IF EXISTS usuarios;
CREATE TABLE IF NOT EXISTS usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE,
    pass VARCHAR(100) NOT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS proveedores;
CREATE TABLE IF NOT EXISTS proveedores (
    idProveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100),
    web VARCHAR(100),
    localidad VARCHAR(100),
    calle VARCHAR(100),
    numero INT,
    notas VARCHAR(500),
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario) ON DELETE CASCADE,
	created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS clientes;
CREATE TABLE IF NOT EXISTS clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Productos', 'Polinización'),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    localidad VARCHAR(100),
    calle VARCHAR(100),
    numero INT,
    notas VARCHAR(500),
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario) ON DELETE CASCADE,
	created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS apiarios;
CREATE TABLE IF NOT EXISTS apiarios (
    idApiario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    localidad VARCHAR(100) NOT NULL,
    latitud DECIMAL(10, 8) NOT NULL,
    longitud DECIMAL(10, 8) NOT NULL,
    nomada BOOLEAN NOT NULL DEFAULT FALSE,
    vegetacion VARCHAR(50) NOT NULL,
    distanciaAgua INT NOT NULL,
    fechaEstablecimiento DATE NOT NULL,
    fechaDesmantelamiento DATE,
    propietario BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (propietario = FALSE OR idCliente IS NULL),
    CHECK (propietario = TRUE OR idCliente IS NOT NULL),
    idUsuario INT,
    idCliente INT DEFAULT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario) ON DELETE CASCADE,
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente) ON DELETE CASCADE,
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS reinas;
CREATE TABLE IF NOT EXISTS reinas (
    idReina INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    anoNacimiento YEAR NOT NULL,
    anoMuerte YEAR,
    origen ENUM('capturada', 'criada', 'comprada') NOT NULL DEFAULT 'comprada',
    madre INT,
    idProveedor INT,
    FOREIGN KEY (madre) REFERENCES reinas(idReina) ON DELETE CASCADE,
    FOREIGN KEY (idProveedor) REFERENCES proveedores(idProveedor) ON DELETE CASCADE,
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS colmenas;
CREATE TABLE IF NOT EXISTS colmenas (
    idColmena INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Langstroth', 'Warré', 'WBC', 'Horizontal') NOT NULL DEFAULT 'Langstroth',
    nTableros TINYINT UNSIGNED NOT NULL,
    nCamarasMeliferas TINYINT UNSIGNED NOT NULL,
    rejaAntiReina BOOLEAN DEFAULT FALSE,
    rampaVuelo BOOLEAN DEFAULT FALSE,
    sueloSanitario BOOLEAN DEFAULT FALSE,
    idReina INT NOT NULL,
    idApiario INT NOT NULL,
    FOREIGN KEY (idReina) REFERENCES reinas(idReina) ON DELETE CASCADE,
    FOREIGN KEY (idApiario) REFERENCES apiarios(idApiario) ON DELETE CASCADE,
    created DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS cosechas;
CREATE TABLE IF NOT EXISTS cosechas (
	-- atributos historicos que deben quedar ligados al estado de la colmena en el momento de la cosecha, y no reflejar cambios en el estado de la colmena
    idCosecha INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    kgMiel TINYINT UNSIGNED NOT NULL,
    kgCera TINYINT UNSIGNED NOT NULL,
    idReina INT NOT NULL,
    idColmena INT NOT NULL,
    nTableros TINYINT UNSIGNED NOT NULL,
    nCamarasMeliferas TINYINT UNSIGNED NOT NULL,
    rejaAntiReina BOOLEAN DEFAULT FALSE,
    rampaVuelo BOOLEAN DEFAULT FALSE,
    sueloSanitario BOOLEAN DEFAULT FALSE,
    vegetacion VARCHAR(50) NOT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idColmena) REFERENCES colmenas(idColmena) ON DELETE CASCADE
);

-- Inserción de datos test
-- usuarios
INSERT INTO usuarios (correo, pass) VALUES ('usuarioTest@example.com', 'usuarioTest');

-- proveedores
INSERT INTO proveedores (nombre, telefono, correo, web, localidad, calle, numero, idUsuario) 
VALUES ('proveedorTest', '123456789', 'proveedorTest@example.com', 'www.proveedorTest.com', 'LocalidadTest', 'Calle Test', 1, 1);

-- clientes
INSERT INTO clientes (nombre, telefono, correo, localidad, calle, numero, idUsuario) 
VALUES ('clienteTest', '987654321', 'clienteTest@example.com', 'LocalidadTest', 'Calle Test', 2, 1);

-- apiario fijo
INSERT INTO apiarios (nombre, localidad, latitud, longitud, nomada, propietario, vegetacion, distanciaAgua, fechaEstablecimiento, idUsuario, idCliente) 
VALUES ('apiarioTest', 'LocalidadTest', 40.123456, -3.123456, FALSE, TRUE, 'flores silvestres', 5, '2020-01-01', 1, null);

-- apiario nómada
INSERT INTO apiarios (nombre, localidad, latitud, longitud, nomada, propietario, vegetacion, distanciaAgua, fechaEstablecimiento, idUsuario, idCliente) 
VALUES ('apiarioNomadaTest', 'LocalidadTest', 40.654321, -3.654321, TRUE, FALSE, 'naranjos', 100, '2021-01-01', 1, 1);

-- reinas
INSERT INTO reinas (nombre, anoNacimiento, anoMuerte, origen, idProveedor) 
VALUES ('reina1', 2020, NULL, 'comprada', 1);

INSERT INTO reinas (nombre, anoNacimiento, anoMuerte, origen, idProveedor) 
VALUES ('reina2', 2021, NULL, 'comprada', 1);

INSERT INTO reinas (nombre, anoNacimiento, anoMuerte, madre, origen, idProveedor) 
VALUES ('reinaHija', 2022, NULL, 1, 'criada', 1);  -- reina criada hija de reina1

INSERT INTO reinas (nombre, anoNacimiento, anoMuerte, origen, idProveedor) 
VALUES ('reinaNómada', 2021, NULL, 'comprada', 1);

-- colmenas en apiarioTest
INSERT INTO colmenas (tipo, nTableros, nCamarasMeliferas, idReina, idApiario) 
VALUES ('Langstroth', 10, 2, 1, 1);

INSERT INTO colmenas (tipo, nTableros, nCamarasMeliferas, idReina, idApiario) 
VALUES ('Warré', 8, 1, 2, 1);

INSERT INTO colmenas (tipo, nTableros, nCamarasMeliferas, idReina, idApiario) 
VALUES ('Horizontal', 12, 3, 3, 1);

-- colmenas en apiarioNomadaTest
INSERT INTO colmenas (tipo, nTableros, nCamarasMeliferas, idReina, idApiario) 
VALUES ('Langstroth', 10, 2, 4, 2);

-- cosechas para apiarioTest
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2020-01-01', 100, 20, 1, 1, 12, 2, "flores silvestres");
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2021-01-01', 150, 30, 2, 2, 12, 2, "flores silvestres");
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2022-01-01', 200, 40, 3, 3, 12, 2, "flores silvestres");
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2023-01-01', 120, 25, 1, 1, 12, 2, "flores silvestres");
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2024-01-01', 180, 35, 2, 2, 12, 2, "flores silvestres");

-- cosechas para apiarioNomadaTest
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2021-01-01', 90, 15, 4, 4, 12, 2, "castaños");
INSERT INTO cosechas (fecha, kgMiel, kgCera, idReina, idColmena, nTableros, nCamarasMeliferas, vegetacion) 
VALUES ('2022-01-01', 110, 20, 4, 4, 12, 2, "naranjos");
