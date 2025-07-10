-- ===============================================
-- DDL - HOSPITAL CENTRAL (BD COMPARTIDA)
-- Base de datos para datos compartidos entre departamentos
-- ===============================================

-- Crear base de datos
-- CREATE DATABASE hospital_central;
-- \c hospital_central;

-- ===============================================
-- TIPOS ENUMERADOS (ENUMS)
-- ===============================================
CREATE TYPE estado_paciente_enum AS ENUM ('ACTIVO', 'INACTIVO', 'FALLECIDO', 'TRANSFERIDO');
CREATE TYPE estado_historia_enum AS ENUM ('ACTIVA', 'CERRADA', 'ARCHIVADA');
CREATE TYPE tipo_operacion_enum AS ENUM ('LECTURA', 'ESCRITURA', 'MODIFICACION', 'ELIMINACION');
CREATE TYPE genero_enum AS ENUM ('M', 'F', 'OTRO');

-- ===============================================
-- CATÁLOGOS MAESTROS CENTRALIZADOS
-- ===============================================

-- Tabla de tipos de sangre (catálogo global)
CREATE TABLE tipo_sangre (
    id_tipo_sangre SERIAL PRIMARY KEY,
    tipo_sangre VARCHAR(5) NOT NULL UNIQUE,
    descripcion VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tipos de equipamiento (catálogo global)
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

-- Tabla de proveedores (catálogo global)
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

-- Tabla de tipos de cita generales (cada departamento puede tener específicos)
CREATE TABLE tipo_cita_general (
    id_tipo_cita SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
    descripcion_tipo TEXT,
    duracion_sugerida_min INTEGER DEFAULT 30,
    categoria VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_tipo_cita_nombre UNIQUE (nombre_tipo),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_sugerida_min > 0)
);

-- ===============================================
-- CONTROL MAESTRO DE DEPARTAMENTOS
-- ===============================================

-- Tabla maestra de todos los departamentos del hospital
CREATE TABLE departamento_master (
    id_dept SERIAL PRIMARY KEY,
    nom_dept VARCHAR(100) NOT NULL,
    tipo_especialidad VARCHAR(100),
    ubicacion VARCHAR(200),
    telefono_dept VARCHAR(20),
    email_dept VARCHAR(100),
    database_name VARCHAR(50),
    servidor_host VARCHAR(100) DEFAULT 'localhost',
    servidor_puerto INTEGER DEFAULT 5432,
    estado_departamento VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_departamento_nombre UNIQUE (nom_dept),
    CONSTRAINT uk_departamento_database UNIQUE (database_name),
    CONSTRAINT ck_departamento_email CHECK (email_dept ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- ===============================================
-- DATOS COMPARTIDOS GLOBALES
-- ===============================================

-- Tabla global de pacientes (maestro único)
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
    departamentos_atencion JSON DEFAULT '[]',
    id_dept_principal INTEGER,
    fecha_ultima_atencion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_paciente_tipo_sangre FOREIGN KEY (id_tipo_sangre) 
        REFERENCES tipo_sangre(id_tipo_sangre),
    CONSTRAINT fk_paciente_dept_principal FOREIGN KEY (id_dept_principal) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT ck_paciente_email CHECK (email_pac ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento_paciente CHECK (fecha_nac <= CURRENT_DATE)
);

-- Tabla global de historias clínicas (acceso transversal)
CREATE TABLE historia_clinica (
    cod_hist SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    observaciones_generales TEXT,
    peso_kg DECIMAL(5,2),
    altura_cm DECIMAL(5,2),
    alergias_conocidas TEXT,
    antecedentes_familiares TEXT,
    antecedentes_personales TEXT,
    id_dept_origen INTEGER NOT NULL,
    departamentos_acceso JSON DEFAULT '[]',
    confidencial BOOLEAN DEFAULT FALSE,
    estado_historia estado_historia_enum DEFAULT 'ACTIVA',
    fecha_ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_historia_paciente FOREIGN KEY (cod_pac) 
        REFERENCES paciente(cod_pac),
    CONSTRAINT fk_historia_departamento FOREIGN KEY (id_dept_origen) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT uk_historia_paciente UNIQUE (cod_pac),
    CONSTRAINT ck_peso_positivo CHECK (peso_kg > 0 AND peso_kg <= 500),
    CONSTRAINT ck_altura_positiva CHECK (altura_cm > 0 AND altura_cm <= 300)
);

-- ===============================================
-- AUDITORÍA Y CONTROL GLOBAL
-- ===============================================

-- Tabla de auditoría de accesos inter-departamentales
CREATE TABLE acceso_historia (
    id_acceso SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp_externo INTEGER NOT NULL,
    id_dept_empleado INTEGER NOT NULL,
    nombre_empleado VARCHAR(100),
    cedula_empleado VARCHAR(20),
    fecha_hora_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion tipo_operacion_enum NOT NULL,
    justificacion_acceso TEXT NOT NULL,
    ip_acceso INET,
    ubicacion_geografica VARCHAR(100),
    acceso_autorizado BOOLEAN DEFAULT TRUE,
    id_autorizador INTEGER,
    fecha_autorizacion TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_acceso_historia FOREIGN KEY (cod_hist) 
        REFERENCES historia_clinica(cod_hist),
    CONSTRAINT fk_acceso_departamento FOREIGN KEY (id_dept_empleado) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT ck_justificacion_requerida CHECK (LENGTH(justificacion_acceso) >= 10)
);

-- Tabla de permisos inter-departamentales
CREATE TABLE permisos_inter_departamental (
    id_permiso SERIAL PRIMARY KEY,
    id_emp_externo INTEGER NOT NULL,
    id_dept_origen INTEGER NOT NULL,
    nombre_empleado VARCHAR(100) NOT NULL,
    id_dept_destino INTEGER NOT NULL,
    tipo_acceso VARCHAR(20) NOT NULL,
    recursos_permitidos JSON DEFAULT '[]',
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_fin DATE,
    activo BOOLEAN DEFAULT TRUE,
    justificacion TEXT NOT NULL,
    id_autorizador INTEGER,
    fecha_autorizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_permiso_dept_origen FOREIGN KEY (id_dept_origen) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT fk_permiso_dept_destino FOREIGN KEY (id_dept_destino) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT ck_fechas_validas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT ck_departamentos_diferentes CHECK (id_dept_origen != id_dept_destino)
);

-- ===============================================
-- CONTROL DE SINCRONIZACIÓN Y DISTRIBUCIÓN
-- ===============================================

-- Log de eventos de sincronización entre bases de datos
CREATE TABLE log_sincronizacion (
    id_log SERIAL PRIMARY KEY,
    id_dept_origen INTEGER,
    tabla_origen VARCHAR(50) NOT NULL,
    registro_id INTEGER,
    operacion VARCHAR(20) NOT NULL,
    datos_json JSON,
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_procesado TIMESTAMP,
    error_mensaje TEXT,
    intentos INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_log_departamento FOREIGN KEY (id_dept_origen) 
        REFERENCES departamento_master(id_dept)
);

-- Configuración de replicación entre departamentos
CREATE TABLE configuracion_replicacion (
    id_config SERIAL PRIMARY KEY,
    id_dept_origen INTEGER NOT NULL,
    id_dept_destino INTEGER,
    tabla_nombre VARCHAR(50) NOT NULL,
    tipo_replicacion VARCHAR(20) NOT NULL,
    frecuencia_minutos INTEGER DEFAULT 60,
    filtros_json JSON DEFAULT '{}',
    campos_replicados JSON DEFAULT '[]',
    bidireccional BOOLEAN DEFAULT FALSE,
    activa BOOLEAN DEFAULT TRUE,
    ultima_sincronizacion TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_config_dept_origen FOREIGN KEY (id_dept_origen) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT fk_config_dept_destino FOREIGN KEY (id_dept_destino) 
        REFERENCES departamento_master(id_dept)
);

-- ===============================================
-- VISTAS ÚTILES
-- ===============================================

-- Vista de pacientes con información completa
CREATE VIEW v_pacientes_completo AS
SELECT 
    p.cod_pac,
    p.nom_pac || ' ' || p.apellido_pac AS nombre_completo,
    p.cedula,
    p.tel_pac,
    p.email_pac,
    p.fecha_nac,
    EXTRACT(YEAR FROM AGE(p.fecha_nac)) AS edad,
    p.genero,
    ts.tipo_sangre,
    p.estado_paciente,
    dm.nom_dept AS departamento_principal,
    p.fecha_ultima_atencion,
    CASE 
        WHEN p.fecha_ultima_atencion >= CURRENT_DATE - INTERVAL '30 days' THEN 'RECIENTE'
        WHEN p.fecha_ultima_atencion >= CURRENT_DATE - INTERVAL '6 months' THEN 'MODERADO'
        WHEN p.fecha_ultima_atencion < CURRENT_DATE - INTERVAL '6 months' THEN 'INACTIVO'
        ELSE 'NUEVO'
    END AS frecuencia_atencion
FROM paciente p
LEFT JOIN tipo_sangre ts ON p.id_tipo_sangre = ts.id_tipo_sangre
LEFT JOIN departamento_master dm ON p.id_dept_principal = dm.id_dept;

-- Vista de historias clínicas con control de acceso
CREATE VIEW v_historias_acceso AS
SELECT 
    hc.cod_hist,
    hc.cod_pac,
    p.nom_pac || ' ' || p.apellido_pac AS paciente,
    p.cedula,
    hc.fecha_creacion,
    dm.nom_dept AS departamento_origen,
    hc.confidencial,
    hc.estado_historia,
    hc.departamentos_acceso,
    CASE 
        WHEN hc.confidencial = TRUE THEN 'REQUIERE_AUTORIZACION'
        WHEN hc.departamentos_acceso::text = '[]' THEN 'ACCESO_LIBRE'
        ELSE 'ACCESO_CONTROLADO'
    END AS nivel_acceso
FROM historia_clinica hc
JOIN paciente p ON hc.cod_pac = p.cod_pac
JOIN departamento_master dm ON hc.id_dept_origen = dm.id_dept;

-- Vista de accesos inter-departamentales
CREATE VIEW v_accesos_inter_departamentales AS
SELECT 
    ah.id_acceso,
    ah.fecha_hora_acceso,
    ah.nombre_empleado,
    d1.nom_dept AS departamento_empleado,
    d2.nom_dept AS departamento_historia,
    p.nom_pac || ' ' || p.apellido_pac AS paciente,
    ah.tipo_operacion,
    ah.justificacion_acceso,
    ah.acceso_autorizado
FROM acceso_historia ah
JOIN departamento_master d1 ON ah.id_dept_empleado = d1.id_dept
JOIN historia_clinica hc ON ah.cod_hist = hc.cod_hist
JOIN departamento_master d2 ON hc.id_dept_origen = d2.id_dept
JOIN paciente p ON hc.cod_pac = p.cod_pac
WHERE d1.id_dept != d2.id_dept
ORDER BY ah.fecha_hora_acceso DESC;

-- Vista de departamentos con estadísticas
CREATE VIEW v_departamentos_estadisticas AS
SELECT 
    dm.id_dept,
    dm.nom_dept,
    dm.tipo_especialidad,
    dm.database_name,
    dm.estado_departamento,
    COUNT(DISTINCT p.cod_pac) AS pacientes_atendidos,
    COUNT(DISTINCT hc.cod_hist) AS historias_creadas,
    COUNT(DISTINCT ah.id_acceso) AS accesos_realizados,
    MAX(ah.fecha_hora_acceso) AS ultimo_acceso
FROM departamento_master dm
LEFT JOIN paciente p ON dm.id_dept = p.id_dept_principal
LEFT JOIN historia_clinica hc ON dm.id_dept = hc.id_dept_origen
LEFT JOIN acceso_historia ah ON dm.id_dept = ah.id_dept_empleado
GROUP BY dm.id_dept, dm.nom_dept, dm.tipo_especialidad, dm.database_name, dm.estado_departamento
ORDER BY dm.nom_dept;