-- DDL para la Base de Datos: Atencion
-- Incluye CITA, TIPO_CITA

CREATE TYPE estado_cita_enum AS ENUM ('PROGRAMADA', 'CONFIRMADA', 'REALIZADA', 'CANCELADA', 'NO_ASISTIO', 'REPROGRAMADA');

-- Tabla de tipos de cita
CREATE TABLE tipo_cita (
    id_tipo_cita SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE,
    duracion_default_min INTEGER DEFAULT 30,
    costo_base DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_tipo_cita_nombre UNIQUE (nombre_tipo),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_default_min > 0),
    CONSTRAINT ck_costo_positivo CHECK (costo_base >= 0)
);

-- Tabla de citas
CREATE TABLE cita (
    id_cita SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL, -- FK a PACIENTE (DB Pacientes)
    id_emp INTEGER NOT NULL, -- FK a EMPLEADO (DB Personal)
    id_tipo_cita INTEGER NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    duracion_real_min INTEGER,
    motivo_consulta TEXT,
    diagnostico_preliminar TEXT,
    observaciones_cita TEXT,
    estado_cita estado_cita_enum DEFAULT 'PROGRAMADA',
    id_dept INTEGER NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Las FK a `paciente`, `empleado` y `departamento` deberán ser manejadas por la aplicación
    -- o mediante replicación/vistas materializadas a las DB correspondientes.
    CONSTRAINT fk_cita_tipo FOREIGN KEY (id_tipo_cita)
        REFERENCES tipo_cita(id_tipo_cita),
    CONSTRAINT ck_fecha_cita CHECK (fecha_cita >= CURRENT_DATE),
    CONSTRAINT ck_duracion_real_positiva CHECK (duracion_real_min > 0)
);

-- Vista de citas con información básica de esta DB
CREATE VIEW v_citas_basico AS
SELECT
    c.id_cita,
    c.fecha_cita,
    c.hora_inicio,
    tc.nombre_tipo AS tipo_cita,
    c.estado_cita,
    c.motivo_consulta
FROM cita c
JOIN tipo_cita tc ON c.id_tipo_cita = tc.id_tipo_cita;


CONEXION A LAS DEMAS BASES DE DATOS

CREATE EXTENSION dblink;
CREATE FOREIGN DATA WRAPPER dblink;
SELECT fdwname, fdwowner FROM pg_foreign_data_wrapper WHERE fdwname = 'dblink';

CREATE EXTENSION IF NOT EXISTS dblink;

CREATE SERVER db_pacientes_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Pacientes');

CREATE USER MAPPING FOR current_user
    SERVER db_pacientes_server
    OPTIONS (user 'postgres', password '1234');

-- Servidor para Personal
CREATE SERVER db_personal_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Personal');

CREATE USER MAPPING FOR current_user
    SERVER db_personal_server
    OPTIONS (user 'postgres', password '1234');

-- Servidor para Catalogos
CREATE SERVER db_catalogos_server
    FOREIGN DATA WRAPPER dblink
    OPTIONS (host 'localhost', port '5432', dbname 'Catalogos'); 

CREATE USER MAPPING FOR current_user
    SERVER db_catalogos_server
    OPTIONS (user 'postgres', password '1234');

DML:

-- Insertar tipos de cita
INSERT INTO tipo_cita (nombre_tipo, duracion_default_min, costo_base) VALUES
('Consulta General', 30, 50000),
('Consulta Especializada', 45, 80000),
('Control de Rutina', 20, 40000);

AGREGAR INFO A DURACION REAL, DIAGBOSTICO PREELIM, OBSERVACIONES CITA

INSERT INTO cita (cod_pac, id_emp, id_tipo_cita, fecha_cita, hora_inicio,motivo_consulta, estado_cita, id_dept) VALUES
(1, 1, 2, '2025-07-10', '09:00:00', 'Control cardiológico', 'PROGRAMADA', 1),
(2, 1, 1, '2025-07-11', '10:30:00', 'Control diabetes', 'PROGRAMADA', 1),
(3, 3, 1, '2025-07-12', '14:00:00', 'Consulta por dolor', 'PROGRAMADA', 2),
(4, 1, 3, '2025-07-13', '11:00:00', 'Control de rutina', 'PROGRAMADA', 1);
