-- ===============================================
-- DDL - HOSPITAL CENTRAL (ARQUITECTURA CORREGIDA)
-- Base de datos central con farmacia única y datos compartidos
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
CREATE TYPE estado_medicamento_enum AS ENUM ('DISPONIBLE', 'AGOTADO', 'VENCIDO', 'RETIRADO');
CREATE TYPE estado_prescripcion_enum AS ENUM ('ACTIVA', 'DISPENSADA', 'CANCELADA', 'VENCIDA');

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

-- Tabla de tipos de cita generales
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

-- Tabla maestra de departamentos médicos (SIN farmacia)
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
-- FARMACIA CENTRALIZADA ÚNICA
-- ===============================================

-- Tabla de laboratorios farmacéuticos
CREATE TABLE laboratorio (
    id_laboratorio SERIAL PRIMARY KEY,
    nombre_laboratorio VARCHAR(100) NOT NULL,
    telefono_lab VARCHAR(20),
    email_lab VARCHAR(100),
    direccion_lab VARCHAR(200),
    pais_origen VARCHAR(50),
    contacto_comercial VARCHAR(100),
    telefono_comercial VARCHAR(20),
    condiciones_pago VARCHAR(100),
    tiempo_entrega_dias INTEGER DEFAULT 7,
    certificacion_iso BOOLEAN DEFAULT FALSE,
    certificacion_fda BOOLEAN DEFAULT FALSE,
    certificacion_invima BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_laboratorio_nombre UNIQUE (nombre_laboratorio),
    CONSTRAINT ck_laboratorio_email CHECK (email_lab ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Tabla de categorías de medicamentos
CREATE TABLE categoria_medicamento (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion_categoria TEXT,
    codigo_atc VARCHAR(10),
    grupo_terapeutico VARCHAR(100),
    requiere_receta BOOLEAN DEFAULT TRUE,
    medicamento_controlado BOOLEAN DEFAULT FALSE,
    nivel_control INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_categoria_nombre UNIQUE (nombre_categoria),
    CONSTRAINT ck_nivel_control CHECK (nivel_control BETWEEN 0 AND 4)
);

-- Tabla central de medicamentos (inventario único del hospital)
CREATE TABLE medicamento (
    cod_med SERIAL PRIMARY KEY,
    nom_med VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(200) NOT NULL,
    descripcion_med TEXT,
    concentracion VARCHAR(50),
    forma_farmaceutica VARCHAR(50),
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 10,
    stock_maximo INTEGER DEFAULT 1000,
    precio_unitario DECIMAL(10,2) DEFAULT 0.00,
    precio_compra DECIMAL(10,2),
    margen_ganancia DECIMAL(5,2) DEFAULT 20.00,
    lote VARCHAR(50),
    fecha_vencimiento DATE,
    fecha_fabricacion DATE,
    id_laboratorio INTEGER,
    id_categoria INTEGER,
    estado_medicamento estado_medicamento_enum DEFAULT 'DISPONIBLE',
    temperatura_almacenamiento VARCHAR(50) DEFAULT 'AMBIENTE',
    condiciones_especiales TEXT,
    registro_sanitario VARCHAR(50),
    codigo_barras VARCHAR(50),
    codigo_cum VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_medicamento_laboratorio FOREIGN KEY (id_laboratorio) 
        REFERENCES laboratorio(id_laboratorio),
    CONSTRAINT fk_medicamento_categoria FOREIGN KEY (id_categoria) 
        REFERENCES categoria_medicamento(id_categoria),
    CONSTRAINT ck_stock_no_negativo CHECK (stock_actual >= 0),
    CONSTRAINT ck_stock_minimo_positivo CHECK (stock_minimo >= 0),
    CONSTRAINT ck_stock_maximo CHECK (stock_maximo >= stock_minimo),
    CONSTRAINT ck_precio_positivo CHECK (precio_unitario >= 0),
    CONSTRAINT ck_fecha_vencimiento CHECK (fecha_vencimiento IS NULL OR fecha_fabricacion IS NULL OR fecha_vencimiento > fecha_fabricacion),
    CONSTRAINT uk_medicamento_codigo_barras UNIQUE (codigo_barras),
    CONSTRAINT uk_medicamento_cum UNIQUE (codigo_cum)
);

-- Tabla de prescripciones (centralizadas en farmacia)
CREATE TABLE prescripcion (
    cod_prescripcion SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp_prescriptor INTEGER NOT NULL, -- ID del empleado en su BD departamental
    id_dept_prescriptor INTEGER NOT NULL, -- Departamento que prescribe
    nombre_prescriptor VARCHAR(100) NOT NULL, -- Nombre para registro
    cedula_prescriptor VARCHAR(20) NOT NULL, -- Cédula para auditoría
    fecha_prescripcion DATE DEFAULT CURRENT_DATE,
    observaciones_prescripcion TEXT,
    diagnostico_asociado VARCHAR(200),
    estado_prescripcion estado_prescripcion_enum DEFAULT 'ACTIVA',
    fecha_dispensacion DATE,
    id_farmaceutico_dispensador INTEGER, -- ID empleado farmacia
    nombre_dispensador VARCHAR(100), -- Nombre farmacéutico
    validada_farmaceutico BOOLEAN DEFAULT FALSE,
    id_farmaceutico_validador INTEGER,
    nombre_validador VARCHAR(100),
    observaciones_farmaceuticas TEXT,
    fecha_validacion TIMESTAMP,
    vigencia_dias INTEGER DEFAULT 30,
    fecha_vencimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prescripcion_historia FOREIGN KEY (cod_hist) 
        REFERENCES historia_clinica(cod_hist),
    CONSTRAINT fk_prescripcion_departamento FOREIGN KEY (id_dept_prescriptor) 
        REFERENCES departamento_master(id_dept),
    CONSTRAINT ck_vigencia_positiva CHECK (vigencia_dias > 0),
    CONSTRAINT ck_fecha_vencimiento_prescripcion CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_prescripcion)
);

-- Tabla de detalles de prescripción
CREATE TABLE detalle_prescripcion (
    id_detalle SERIAL PRIMARY KEY,
    cod_prescripcion INTEGER NOT NULL,
    cod_med INTEGER NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(100) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    instrucciones_especiales TEXT,
    cantidad_total INTEGER NOT NULL,
    cantidad_dispensada INTEGER DEFAULT 0,
    cantidad_pendiente INTEGER,
    via_administracion VARCHAR(50),
    momento_administracion VARCHAR(100),
    efectos_secundarios TEXT,
    contraindicaciones TEXT,
    interacciones_medicamentosas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_detalle_prescripcion FOREIGN KEY (cod_prescripcion) 
        REFERENCES prescripcion(cod_prescripcion),
    CONSTRAINT fk_detalle_medicamento FOREIGN KEY (cod_med) 
        REFERENCES medicamento(cod_med),
    CONSTRAINT ck_cantidad_positiva CHECK (cantidad_total > 0),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_dias > 0),
    CONSTRAINT ck_cantidad_dispensada CHECK (cantidad_dispensada >= 0 AND cantidad_dispensada <= cantidad_total)
);

-- Tabla de personal de farmacia
CREATE TABLE empleado_farmacia (
    id_emp_farmacia SERIAL PRIMARY KEY,
    nom_emp VARCHAR(50) NOT NULL,
    apellido_emp VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    email_emp VARCHAR(100),
    telefono_emp VARCHAR(20),
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    fecha_nacimiento DATE NOT NULL,
    cargo VARCHAR(50) NOT NULL, -- 'FARMACEUTICO_JEFE', 'FARMACEUTICO', 'AUXILIAR', 'REGENTE'
    numero_licencia VARCHAR(50),
    certificaciones JSON DEFAULT '[]',
    estado_empleado VARCHAR(20) DEFAULT 'ACTIVO',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT ck_farmacia_email CHECK (email_emp ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento_farmacia CHECK (fecha_nacimiento <= CURRENT_DATE - INTERVAL '18 years')
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

-- Tabla de auditoría de farmacia
CREATE TABLE auditoria_farmacia (
    id_auditoria SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INTEGER NOT NULL,
    operacion VARCHAR(20) NOT NULL, -- 'DISPENSACION', 'AJUSTE_INVENTARIO', 'PRESCRIPCION'
    id_empleado_farmacia INTEGER,
    nombre_empleado VARCHAR(100),
    id_dept_solicitante INTEGER,
    datos_anteriores JSON,
    datos_nuevos JSON,
    observaciones TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_acceso INET,
    
    CONSTRAINT fk_auditoria_empleado_farmacia FOREIGN KEY (id_empleado_farmacia) 
        REFERENCES empleado_farmacia(id_emp_farmacia),
    CONSTRAINT fk_auditoria_departamento FOREIGN KEY (id_dept_solicitante) 
        REFERENCES departamento_master(id_dept)
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

-- Vista de inventario crítico de farmacia
CREATE VIEW v_inventario_critico AS
SELECT 
    m.cod_med,
    m.nom_med,
    m.principio_activo,
    m.stock_actual,
    m.stock_minimo,
    l.nombre_laboratorio,
    c.nombre_categoria,
    m.fecha_vencimiento,
    CASE 
        WHEN m.stock_actual = 0 THEN 'AGOTADO'
        WHEN m.stock_actual <= m.stock_minimo THEN 'CRITICO'
        WHEN m.fecha_vencimiento <= CURRENT_DATE + INTERVAL '30 days' THEN 'PROXIMO_VENCER'
        ELSE 'NORMAL'
    END AS nivel_alerta,
    CASE 
        WHEN m.fecha_vencimiento IS NOT NULL THEN 
            (m.fecha_vencimiento - CURRENT_DATE)
        ELSE NULL
    END AS dias_vencimiento
FROM medicamento m
LEFT JOIN laboratorio l ON m.id_laboratorio = l.id_laboratorio
LEFT JOIN categoria_medicamento c ON m.id_categoria = c.id_categoria
WHERE m.estado_medicamento = 'DISPONIBLE'
    AND (m.stock_actual <= m.stock_minimo 
         OR m.fecha_vencimiento <= CURRENT_DATE + INTERVAL '60 days')
ORDER BY nivel_alerta, m.fecha_vencimiento;

-- Vista de prescripciones por departamento
CREATE VIEW v_prescripciones_por_departamento AS
SELECT 
    dm.nom_dept AS departamento,
    COUNT(p.cod_prescripcion) AS total_prescripciones,
    COUNT(CASE WHEN p.estado_prescripcion = 'ACTIVA' THEN 1 END) AS activas,
    COUNT(CASE WHEN p.estado_prescripcion = 'DISPENSADA' THEN 1 END) AS dispensadas,
    SUM(CASE WHEN dp.cantidad_total IS NOT NULL THEN dp.cantidad_total * m.precio_unitario ELSE 0 END) AS valor_total,
    AVG(p.vigencia_dias) AS promedio_vigencia_dias
FROM departamento_master dm
LEFT JOIN prescripcion p ON dm.id_dept = p.id_dept_prescriptor
LEFT JOIN detalle_prescripcion dp ON p.cod_prescripcion = dp.cod_prescripcion
LEFT JOIN medicamento m ON dp.cod_med = m.cod_med
WHERE p.fecha_prescripcion >= CURRENT_DATE - INTERVAL '30 days' OR p.fecha_prescripcion IS NULL
GROUP BY dm.id_dept, dm.nom_dept
ORDER BY total_prescripciones DESC;

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