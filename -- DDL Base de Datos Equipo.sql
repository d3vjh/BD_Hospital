-- DDL para la Base de Datos: Equipos
-- Incluye EQUIPAMIENTO, MANTENIMIENTO_EQUIPO


CREATE TYPE estado_equipo_enum AS ENUM ('OPERATIVO', 'MANTENIMIENTO', 'FUERA_SERVICIO', 'RETIRADO', 'CALIBRACION');
CREATE TYPE tipo_mantenimiento_enum AS ENUM ('PREVENTIVO', 'CORRECTIVO', 'CALIBRACION');

-- Tabla de equipamiento
CREATE TABLE equipamiento (
    cod_eq SERIAL PRIMARY KEY,
    nom_eq VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    numero_serie VARCHAR(50) UNIQUE,
    descripcion_eq TEXT,
    id_dept INTEGER NOT NULL, -- FK, pertenece a la DB de Departamentos
    id_tipo_equipo INTEGER NOT NULL, -- FK, pertenece a la DB de Catálogos
    id_proveedor INTEGER, -- FK, pertenece a la DB de Catálogos
    estado_equipo estado_equipo_enum DEFAULT 'OPERATIVO',
    fecha_adquisicion DATE DEFAULT CURRENT_DATE,
    costo_adquisicion DECIMAL(12,2),
    proxima_calibracion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Las FK a `departamento`, `tipo_equipamiento` y `proveedor` deberán ser manejadas por la aplicación
    -- o mediante replicación/vistas materializadas a las DB correspondientes.
    CONSTRAINT ck_costo_positivo CHECK (costo_adquisicion >= 0),
    CONSTRAINT ck_fecha_adquisicion CHECK (fecha_adquisicion <= CURRENT_DATE)
);

-- Tabla de mantenimiento de equipos
CREATE TABLE mantenimiento_equipo (
    id_mantenimiento SERIAL PRIMARY KEY,
    cod_eq INTEGER NOT NULL,
    fecha_mantenimiento DATE NOT NULL,
    tipo_mantenimiento tipo_mantenimiento_enum NOT NULL,
    descripcion_trabajo TEXT NOT NULL,
    costo_mantenimiento DECIMAL(10,2) DEFAULT 0,
    id_emp_responsable INTEGER, -- FK a EMPLEADO (DB Personal)
    empresa_externa VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_mantenimiento_equipo FOREIGN KEY (cod_eq)
        REFERENCES equipamiento(cod_eq),
    -- La FK a `empleado` deberá ser manejada por la aplicación o mediante replicación/vistas materializadas
    -- a la DB de Personal.
    CONSTRAINT ck_costo_mantenimiento_positivo CHECK (costo_mantenimiento >= 0),
    CONSTRAINT ck_fecha_mantenimiento CHECK (fecha_mantenimiento <= CURRENT_DATE)
);

-- Vista de equipamiento con información básica
CREATE VIEW v_equipamiento_basico AS
SELECT
    eq.cod_eq,
    eq.nom_eq,
    eq.modelo,
    eq.numero_serie,
    eq.estado_equipo,
    eq.fecha_adquisicion,
    eq.proxima_calibracion,
    CASE
        WHEN eq.proxima_calibracion <= CURRENT_DATE THEN 'CALIBRACION_VENCIDA'
        WHEN eq.proxima_calibracion <= CURRENT_DATE + INTERVAL '1 month' THEN 'CALIBRACION_PROXIMA'
        ELSE 'CALIBRACION_OK'
    END AS estado_calibracion
FROM equipamiento eq;


-- Vista de mantenimientos
CREATE VIEW v_mantenimientos_basico AS
SELECT
    me.id_mantenimiento,
    me.cod_eq,
    me.fecha_mantenimiento,
    me.tipo_mantenimiento,
    me.costo_mantenimiento
FROM mantenimiento_equipo me;

CONEXION A LAS DEMAS BASES DE DATOS

CREATE EXTENSION dblink;
CREATE FOREIGN DATA WRAPPER dblink;
SELECT fdwname, fdwowner FROM pg_foreign_data_wrapper WHERE fdwname = 'dblink';

CREATE EXTENSION IF NOT EXISTS dblink;

-- Servidor para Catalogos
CREATE SERVER db_catalogos_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Catalogos');

CREATE USER MAPPING FOR current_user
    SERVER db_catalogos_server
    OPTIONS (user 'postgres', password '1234');

-- Servidor para Personal
CREATE SERVER db_personal_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Personal');

CREATE USER MAPPING FOR current_user
    SERVER db_personal_server
    OPTIONS (user 'postgres', password '1234');

DML:

AGREGAR INFO A DESC EQUIPO

INSERT INTO equipamiento (nom_eq, modelo, numero_serie, id_dept, id_tipo_equipo, id_proveedor, estado_equipo, costo_adquisicion, proxima_calibracion) VALUES
('Monitor Cardíaco', 'Lifepak 15', 'MC001', 1, 1, 1, 'OPERATIVO', 25000000.00, '2025-12-30'),
('Electrocardiógrafo', 'PageWriter TC70', 'EC001', 1, 2, 2, 'OPERATIVO', 15000000.00, '2025-09-15'),
('Desfibrilador', 'AED Plus', 'DEF001', 2, 3, 1, 'OPERATIVO', 12000000.00, '2025-08-25');

INSERT INTO mantenimiento_equipo (cod_eq, fecha_mantenimiento, tipo_mantenimiento, descripcion_trabajo,costo_mantenimiento, id_emp_responsable, empresa_externa) VALUES
(1, '2024-06-15', 'PREVENTIVO', 'Verificación de sensores y actualización', 750000.00, 2, 'Medtronic Service'),
(2, '2024-05-10', 'CALIBRACION', 'Calibración anual del equipo', 500000.00, 2, 'GE Healthcare'),
(3, '2024-06-25', 'PREVENTIVO', 'Calibración de energía y verificación', 300000.00, 4, 'Medtronic Service');


