-- DDL para la Base de Datos: Pacientes
-- Incluye PACIENTE

CREATE TYPE estado_paciente_enum AS ENUM ('ACTIVO', 'INACTIVO', 'FALLECIDO', 'TRANSFERIDO');
CREATE TYPE genero_enum AS ENUM ('M', 'F', 'OTRO');

-- Tabla de pacientes
CREATE TABLE paciente (
    cod_pac SERIAL PRIMARY KEY,
    nom_pac VARCHAR(50) NOT NULL,
    apellido_pac VARCHAR(50) NOT NULL,
    dir_pac VARCHAR(200),
    tel_pac VARCHAR(20),
    email_pac VARCHAR(100),
    fecha_nac DATE NOT NULL,
    genero genero_enum,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    num_seguro VARCHAR(50),
    id_tipo_sangre INTEGER,
    estado_paciente estado_paciente_enum DEFAULT 'ACTIVO',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- CONSTRAINT fk_paciente_tipo_sangre FOREIGN KEY (id_tipo_sangre)
    --     REFERENCES tipo_sangre(id_tipo_sangre), -- Esta FK deberá ser manejada por la aplicación o mediante replicación/vistas materializadas
    CONSTRAINT ck_paciente_email CHECK (email_pac ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento_paciente CHECK (fecha_nac <= CURRENT_DATE)
);

-- Vista de pacientes con información básica
CREATE VIEW v_pacientes_basico AS
SELECT
    p.cod_pac,
    p.nom_pac || ' ' || p.apellido_pac AS nombre_completo,
    p.cedula,
    p.tel_pac,
    p.email_pac,
    p.fecha_nac,
    EXTRACT(YEAR FROM AGE(p.fecha_nac)) AS edad,
    p.genero,
    p.estado_paciente
FROM paciente p;

DML:

AGREGAR INFO DIR PAC Y EMAIL PAC
INSERT INTO paciente (nom_pac, apellido_pac, cedula, tel_pac, fecha_nac, genero, num_seguro, id_tipo_sangre, estado_paciente) VALUES
('Juan', 'Pérez', '11111111', '+57-310-1111111', '1975-03-15', 'M', 'SEG001', 1, 'ACTIVO'),
('María', 'González', '22222222', '+57-310-2222222', '1982-07-22', 'F', 'SEG002', 2, 'ACTIVO'),
('Carlos', 'López', '33333333', '+57-310-3333333', '1990-11-08', 'M', 'SEG003', 3, 'ACTIVO'),
('Ana', 'Martín', '44444444', '+57-310-4444444', '1988-05-18', 'F', 'SEG004', 4, 'ACTIVO');
