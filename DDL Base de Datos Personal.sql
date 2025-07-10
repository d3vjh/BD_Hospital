DDL para la Base de Datos: Personal
-- Incluye EMPLEADO, ROL_EMPLEADO, USUARIO_SISTEMA, SESION_USUARIO
CREATE TYPE estado_empleado_enum AS ENUM ('ACTIVO', 'INACTIVO', 'VACACIONES', 'LICENCIA', 'SUSPENDIDO');
CREATE TYPE estado_sesion_enum AS ENUM ('ACTIVA', 'CERRADA', 'EXPIRADA');

-- Rol de empleados
CREATE TABLE rol_empleado (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion_rol TEXT,
    permisos_sistema JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de empleados
CREATE TABLE empleado (
    id_emp SERIAL PRIMARY KEY,
    nom_emp VARCHAR(50) NOT NULL,
    apellido_emp VARCHAR(50) NOT NULL,
    dir_emp VARCHAR(200),
    tel_emp VARCHAR(20),
    email_emp VARCHAR(100),
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    fecha_nacimiento DATE,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    estado_empleado estado_empleado_enum DEFAULT 'ACTIVO',
    id_dept INTEGER NOT NULL, 
    id_rol INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_empleado_rol FOREIGN KEY (id_rol)
        REFERENCES rol_empleado(id_rol),
    CONSTRAINT ck_empleado_email CHECK (email_emp ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE),
    CONSTRAINT ck_fecha_contratacion CHECK (fecha_contratacion >= fecha_nacimiento + INTERVAL '18 years')
);


-- Tabla de usuarios del sistema
CREATE TABLE usuario_sistema (
    id_usuario SERIAL PRIMARY KEY,
    id_emp INTEGER NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP,
    intentos_fallidos INTEGER DEFAULT 0,
    cuenta_activa BOOLEAN DEFAULT TRUE,
    token_recuperacion VARCHAR(255),
    token_expiracion TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_empleado FOREIGN KEY (id_emp)
        REFERENCES empleado(id_emp),
    CONSTRAINT ck_intentos_fallidos CHECK (intentos_fallidos >= 0),
    CONSTRAINT ck_username_length CHECK (LENGTH(username) >= 3)
);

-- Tabla de sesiones de usuario
CREATE TABLE sesion_usuario (
    id_sesion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP,
    ip_acceso INET,
    user_agent TEXT,
    estado_sesion estado_sesion_enum DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario_sistema(id_usuario),
    CONSTRAINT ck_fecha_fin CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- Vista de empleados con información básica de esta DB
CREATE VIEW v_empleados_personal AS
SELECT
    e.id_emp,
    e.nom_emp || ' ' || e.apellido_emp AS nombre_completo,
    e.cedula,
    e.tel_emp,
    e.email_emp,
    r.nombre_rol,
    e.estado_empleado,
    e.fecha_contratacion
FROM empleado e
JOIN rol_empleado r ON e.id_rol = r.id_rol;

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

DML:

-- Insertar roles de empleado
INSERT INTO rol_empleado (nombre_rol, descripcion_rol, permisos_sistema) VALUES
('Médico General', 'Médico para consultas generales',
  '{"historias_clinicas": {"leer": true, "escribir": true}, "medicamentos": {"prescribir": true}}'),
('Médico Especialista', 'Médico especialista en área específica',
  '{"historias_clinicas": {"leer": true, "escribir": true}, "acceso_inter_departamental": true}'),
('Administrativo', 'Personal administrativo',
  '{"pacientes": {"registrar": true, "modificar": true}, "citas": {"crear": true}}'),
('Farmacéutico', 'Personal de farmacia',
  '{"medicamentos": {"gestionar": true, "dispensar": true}}');

AÑADIR INFO A DIR EMP

-- Insertar empleados
INSERT INTO empleado (nom_emp, apellido_emp, cedula, tel_emp, email_emp,fecha_nacimiento, estado_empleado, id_dept, id_rol) VALUES
-- Cardiología
('Carlos', 'Rodríguez', '12345678', '+57-300-1234567', 'carlos.rodriguez@hospital.com','1985-08-12', 'ACTIVO', 1, 2),
('Ana', 'Martínez', '23456789', '+57-300-2345678', 'ana.martinez@hospital.com','1982-11-25', 'ACTIVO', 1, 3),
-- Urgencias
('Roberto', 'Silva', '78901234', '+57-300-7890123', 'roberto.silva@hospital.com','1980-09-18', 'ACTIVO', 2, 1),
('Carmen', 'Ruiz', '89012345', '+57-300-8901234', 'carmen.ruiz@hospital.com','1985-02-28', 'ACTIVO', 2, 3),
-- Farmacia
('Sandra', 'Pérez', '23456780', '+57-300-2345679', 'sandra.perez@hospital.com','1984-01-30', 'ACTIVO', 3, 4);


AGREAGAR INFO ULTIMO ACCESO, TOKEN RECUPER, TOKEN EXPIRAC
INSERT INTO usuario_sistema (id_emp, username, password_hash, salt,intentos_fallidos, cuenta_activa) VALUES
(1, 'carlos.rodriguez', 'hashed_password_123', 'salt_random_1', 0, TRUE),
(3, 'roberto.silva', 'hashed_password_789', 'salt_random_3', 0, TRUE),
(5, 'sandra.perez', 'hashed_password_def', 'salt_random_5', 0, TRUE);


INSERT INTO sesion_usuario (id_usuario, fecha_inicio, fecha_fin, ip_acceso, estado_sesion) VALUES
(1, '2025-07-03 08:00:00', NULL, '192.168.1.101', 'ACTIVA'),
(2, '2025-07-03 09:00:00', NULL, '192.168.1.103', 'ACTIVA'),
(3, '2025-07-02 14:00:00', '2025-07-02 18:00:00', '192.168.1.105', 'CERRADA');

