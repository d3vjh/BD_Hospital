-- DDL para la Base de Datos: Historias
-- Incluye HISTORIA_CLINICA, ACCESO_HISTORIA

CREATE TYPE estado_historia_enum AS ENUM ('ACTIVA', 'CERRADA', 'ARCHIVADA');
CREATE TYPE tipo_operacion_enum AS ENUM ('LECTURA', 'ESCRITURA', 'MODIFICACION', 'ELIMINACION');

-- Tabla de historias clínicas
CREATE TABLE historia_clinica (
    cod_hist SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL, -- FK a PACIENTE (DB Pacientes, acceso compartido/réplica)
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    observaciones_generales TEXT,
    peso_kg DECIMAL(5,2),
    altura_cm DECIMAL(5,2),
    alergias_conocidas TEXT,
    id_dept_origen INTEGER NOT NULL, -- FK a departamento
    estado_historia estado_historia_enum DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- La FK a `paciente` y `departamento` deberán ser manejadas por la aplicación
    -- o mediante replicación/vistas materializadas a las DB correspondientes.
    CONSTRAINT uk_historia_paciente UNIQUE (cod_pac),
    CONSTRAINT ck_peso_positivo CHECK (peso_kg > 0 AND peso_kg <= 500),
    CONSTRAINT ck_altura_positiva CHECK (altura_cm > 0 AND altura_cm <= 300)
);

-- Tabla de acceso a historias clínicas (Auditoría)
CREATE TABLE acceso_historia (
    id_acceso SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp INTEGER NOT NULL, -- FK a EMPLEADO (DB Personal)
    fecha_hora_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion tipo_operacion_enum NOT NULL,
    justificacion_acceso TEXT,
    ip_acceso INET,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_acceso_historia FOREIGN KEY (cod_hist)
        REFERENCES historia_clinica(cod_hist),
    -- La FK a `empleado` deberá ser manejada por la aplicación o mediante replicación/vistas materializadas
    -- a la DB de Personal.
);

-- Vista de historias clínicas con información básica
CREATE VIEW v_historias_basico AS
SELECT
    hc.cod_hist,
    hc.cod_pac,
    hc.fecha_creacion,
    hc.estado_historia,
    hc.observaciones_generales
FROM historia_clinica hc;



CONEXION A LAS DEMAS BASES DE DATOS

CREATE EXTENSION dblink;
CREATE FOREIGN DATA WRAPPER dblink;
SELECT fdwname, fdwowner FROM pg_foreign_data_wrapper WHERE fdwname = 'dblink';

CREATE EXTENSION IF NOT EXISTS dblink;

-- Servidor para Pacientes
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

INSERT INTO historia_clinica (cod_pac, observaciones_generales, peso_kg, altura_cm,alergias_conocidas, id_dept,id_dept_origen, estado_historia) VALUES
(1, 'Paciente con antecedentes de hipertensión arterial', 78.5, 175.0, 'Penicilina', 1,1, 'ACTIVA'),
(2, 'Paciente con diabetes tipo 2 controlada', 65.2, 162.0, 'Ninguna conocida', 2,1, 'ACTIVA'),
(3, 'Paciente joven, deportista, sin antecedentes relevantes', 82.0, 180.0, 'Polen', 2,2, 'ACTIVA'),
(4, 'Paciente sana, control de rutina', 58.4, 168.0, 'Ninguna conocida', 3,1, 'ACTIVA');


INSERT INTO acceso_historia (cod_hist, id_emp, tipo_operacion, justificacion_acceso, ip_acceso) VALUES
(3, 1, 'LECTURA', 'Consulta de control cardiológico', '192.168.1.101'),
(3, 1, 'MODIFICACION', 'Actualización de observaciones tras consulta', '192.168.1.101'),
(5, 1, 'LECTURA', 'Revisión de historia para control diabetológico', '192.168.1.101'),
(3, 3, 'LECTURA', 'Evaluación en urgencias', '192.168.1.103'),
-- Acceso inter-departamental (urgencias accede a historia de cardiología)
(4, 3, 'LECTURA', 'Paciente cardíaco consulta en urgencias', '192.168.1.103');