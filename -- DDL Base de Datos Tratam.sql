-- DDL para la Base de Datos: Tratamientos
-- Incluye PRESCRIPCION, DETALLE_PRESCRIPCION

CREATE TYPE estado_prescripcion_enum AS ENUM ('ACTIVA', 'COMPLETADA', 'CANCELADA', 'SUSPENDIDA', 'VENCIDA');

-- Tabla de prescripciones
CREATE TABLE prescripcion (
    cod_prescripcion SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL, -- FK a HISTORIA_CLINICA (DB Historias)
    id_emp_prescriptor INTEGER NOT NULL, -- FK a EMPLEADO (DB Personal)
    fecha_prescripcion DATE DEFAULT CURRENT_DATE,
    observaciones_prescripcion TEXT,
    estado_prescripcion estado_prescripcion_enum DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- Las FK a `historia_clinica` y `empleado` deberán ser manejadas por la aplicación
    -- o mediante replicación/vistas materializadas a las DB correspondientes.
);

-- Tabla de detalles de prescripción
CREATE TABLE detalle_prescripcion (
    id_detalle SERIAL PRIMARY KEY,
    cod_prescripcion INTEGER NOT NULL,
    cod_med INTEGER NOT NULL, -- FK a MEDICAMENTO (DB Farmacia)
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    instrucciones_especiales TEXT,
    cantidad_total INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_detalle_prescripcion FOREIGN KEY (cod_prescripcion)
        REFERENCES prescripcion(cod_prescripcion) ON DELETE CASCADE,
    -- La FK a `medicamento` deberá ser manejada por la aplicación o mediante replicación/vistas materializadas
    -- a la DB de Farmacia.
    CONSTRAINT ck_duracion_positiva CHECK (duracion_dias > 0),
    CONSTRAINT ck_cantidad_positiva CHECK (cantidad_total > 0)
);

-- Vista de prescripciones con detalles de medicamentos
CREATE VIEW v_prescripciones_medicamentos_basico AS
SELECT
    dp.id_detalle,
    dp.cod_prescripcion,
    dp.cod_med,
    dp.dosis,
    dp.frecuencia,
    dp.duracion_dias,
    dp.cantidad_total
FROM detalle_prescripcion dp;

-- Vista de prescripciones (sin detalles de medicamentos específicos, para evitar dependencias)
CREATE VIEW v_prescripciones_basico AS
SELECT
    pr.cod_prescripcion,
    pr.fecha_prescripcion,
    pr.estado_prescripcion,
    pr.observaciones_prescripcion
FROM prescripcion pr;

CONEXION A LAS DEMAS BASES DE DATOS

CREATE EXTENSION dblink;
CREATE FOREIGN DATA WRAPPER dblink;
SELECT fdwname, fdwowner FROM pg_foreign_data_wrapper WHERE fdwname = 'dblink';

CREATE EXTENSION IF NOT EXISTS dblink;

-- Servidor para Historias
CREATE SERVER db_historias_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Historias');

CREATE USER MAPPING FOR current_user
    SERVER db_historias_server
    OPTIONS (user 'postgres', password '1234');

-- Servidor para Personal
CREATE SERVER db_personal_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Personal');

CREATE USER MAPPING FOR current_user
    SERVER db_personal_server
    OPTIONS (user 'postgres', password '1234');

-- Servidor para Farmacia (si existe esta DB)
-- SI NO TIENES DB_FARMACIA, OMITE ESTE BLOQUE
CREATE SERVER db_farmacia_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Farmacia');

CREATE USER MAPPING FOR current_user
    SERVER db_farmacia_server
    OPTIONS (user 'postgres', password '1234');


DML:

INSERT INTO prescripcion (cod_hist, id_emp_prescriptor, observaciones_prescripcion, estado_prescripcion) VALUES
(1, 1, 'Continuar tratamiento antihipertensivo', 'ACTIVA'),
(2, 1, 'Ajuste de dosis de metformina', 'ACTIVA'),
(3, 3, 'Analgesia para dolor', 'ACTIVA');

INSERT INTO detalle_prescripcion (cod_prescripcion, cod_med, dosis, frecuencia, duracion_dias,instrucciones_especiales, cantidad_total) VALUES
-- Prescripción 1 (Hipertensión)
(1, 3, '50mg', 'Una vez al día', 30, 'Tomar en ayunas', 30),
-- Prescripción 2 (Diabetes)
(2, 4, '850mg', 'Dos veces al día', 30, 'Tomar con las comidas', 60),
-- Prescripción 3 (Dolor)
(3, 1, '500mg', 'Cada 8 horas', 3, 'Solo si hay dolor', 9);