-- DDL para la Base de Datos: Catalogos
-- Incluye TIPO_SANGRE, TIPO_EQUIPAMIENTO, PROVEEDOR, DEPARTAMENTO

-- Tabla de tipos de sangre
CREATE TABLE tipo_sangre (
    id_tipo_sangre SERIAL PRIMARY KEY,
    tipo_sangre VARCHAR(5) NOT NULL UNIQUE,
    descripcion VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Tabla de tipos de equipamiento
CREATE TABLE tipo_equipamiento (
    id_tipo_equipo SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
    descripcion_tipo TEXT,
    vida_util_anos INTEGER DEFAULT 10,
    frecuencia_mantenimiento_dias INTEGER DEFAULT 365,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_tipo_equipamiento_nombre UNIQUE (nombre_tipo),
    CONSTRAINT ck_vida_util_positiva CHECK (vida_util_anos > 0),
    CONSTRAINT ck_frecuencia_positiva CHECK (frecuencia_mantenimiento_dias > 0)
);

-- Tabla de proveedores
CREATE TABLE proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre_proveedor VARCHAR(100) NOT NULL,
    telefono_prov VARCHAR(20),
    email_prov VARCHAR(100),
    direccion_prov VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_proveedor_nombre UNIQUE (nombre_proveedor),
    CONSTRAINT ck_proveedor_email CHECK (email_prov ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Tabla de departamentos (ubicada aquí por ser un catálogo para otras tablas)
CREATE TABLE departamento (
    id_dept SERIAL PRIMARY KEY,
    nom_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200),
    tipo_especialidad VARCHAR(100),
    telefono_dept VARCHAR(20),
    email_dept VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_departamento_nombre UNIQUE (nom_dept),
    CONSTRAINT ck_departamento_email CHECK (email_dept ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Vista de departamentos
CREATE VIEW v_departamentos AS
SELECT
    d.id_dept,
    d.nom_dept,
    d.ubicacion,
    d.tipo_especialidad
FROM departamento d;

DML :
-- Insertar tipos de sangre
INSERT INTO tipo_sangre (tipo_sangre, descripcion) VALUES
('A+', 'Tipo A positivo'),
('B+', 'Tipo B positivo'),
('O+', 'Tipo O positivo'),
('O-', 'Tipo O negativo');

-- Insertar tipos de equipamiento
INSERT INTO tipo_equipamiento (nombre_tipo, descripcion_tipo, vida_util_anos, frecuencia_mantenimiento_dias) VALUES
('Monitor de Signos Vitales', 'Monitores cardíacos y de presión', 8, 90),
('Electrocardiografo', 'Equipos para electrocardiogramas', 10, 180),
('Desfibrilador', 'Equipos de emergencia cardíaca', 10, 90);

-- Insertar proveedores
INSERT INTO proveedor (nombre_proveedor, telefono_prov, email_prov, direccion_prov) VALUES
('Medtronic Colombia', '+57-1-5551234', 'ventas@medtronic.co', 'Bogotá, Colombia'),
('GE Healthcare', '+57-1-5555678', 'info@gehealthcare.co', 'Bogotá, Colombia');

-- Insertar departamentos
INSERT INTO departamento (nom_dept, ubicacion, tipo_especialidad, telefono_dept, email_dept) VALUES
('Cardiología', 'Piso 3 - Ala Norte', 'Medicina Cardiovascular', '+57-1-2345001', 'cardiologia@hospital.com'),
('Urgencias', 'Piso 1 - Entrada Principal', 'Medicina de Emergencias', '+57-1-2345003', 'urgencias@hospital.com'),
('Farmacia', 'Piso 1 - Centro', 'Farmacia Hospitalaria', '+57-1-2345005', 'farmacia@hospital.com');