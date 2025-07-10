-- ===============================================
-- DDL - ESTRUCTURA DEL SISTEMA HOSPITALARIO DISTRIBUIDO
-- Bases de Datos 1 - PostgreSQL 13+
-- ===============================================

-- Crear base de datos (ejecutar como superusuario)
-- CREATE DATABASE hospital_sistema;
-- \c hospital_sistema;

-- ===============================================
-- TIPOS ENUMERADOS (ENUMS)
-- ===============================================

-- Estados generales
CREATE TYPE estado_general AS ENUM ('ACTIVO', 'INACTIVO', 'SUSPENDIDO', 'ELIMINADO');

-- Estados específicos por entidad
CREATE TYPE estado_empleado_enum AS ENUM ('ACTIVO', 'INACTIVO', 'VACACIONES', 'LICENCIA', 'SUSPENDIDO');
CREATE TYPE estado_paciente_enum AS ENUM ('ACTIVO', 'INACTIVO', 'FALLECIDO', 'TRANSFERIDO');
CREATE TYPE estado_cita_enum AS ENUM ('PROGRAMADA', 'CONFIRMADA', 'REALIZADA', 'CANCELADA', 'NO_ASISTIO', 'REPROGRAMADA');
CREATE TYPE estado_prescripcion_enum AS ENUM ('ACTIVA', 'COMPLETADA', 'CANCELADA', 'SUSPENDIDA', 'VENCIDA');
CREATE TYPE estado_medicamento_enum AS ENUM ('DISPONIBLE', 'AGOTADO', 'VENCIDO', 'RETIRADO', 'CUARENTENA');
CREATE TYPE estado_equipo_enum AS ENUM ('OPERATIVO', 'MANTENIMIENTO', 'FUERA_SERVICIO', 'RETIRADO', 'CALIBRACION');
CREATE TYPE estado_historia_enum AS ENUM ('ACTIVA', 'CERRADA', 'ARCHIVADA');
CREATE TYPE estado_sesion_enum AS ENUM ('ACTIVA', 'CERRADA', 'EXPIRADA');
CREATE TYPE tipo_operacion_enum AS ENUM ('LECTURA', 'ESCRITURA', 'MODIFICACION', 'ELIMINACION');
CREATE TYPE tipo_mantenimiento_enum AS ENUM ('PREVENTIVO', 'CORRECTIVO', 'CALIBRACION');
CREATE TYPE genero_enum AS ENUM ('M', 'F', 'OTRO');

-- ===============================================
-- TABLAS CENTRALIZADAS (Catálogos y Recursos Compartidos)
-- ===============================================

-- Tabla de tipos de sangre
CREATE TABLE tipo_sangre (
    id_tipo_sangre SERIAL PRIMARY KEY,
    tipo_sangre VARCHAR(5) NOT NULL UNIQUE,
    descripcion VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de laboratorios farmacéuticos
CREATE TABLE laboratorio (
    id_laboratorio SERIAL PRIMARY KEY,
    nombre_laboratorio VARCHAR(100) NOT NULL,
    telefono_lab VARCHAR(20),
    email_lab VARCHAR(100),
    direccion_lab VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_laboratorio_nombre UNIQUE (nombre_laboratorio),
    CONSTRAINT ck_laboratorio_email CHECK (email_lab ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Tabla de categorías de medicamentos
CREATE TABLE categoria_medicamento (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE,
    descripcion_categoria TEXT,
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

-- Tabla de medicamentos (CENTRALIZADA - Farmacia)
CREATE TABLE medicamento (
    cod_med SERIAL PRIMARY KEY,
    nom_med VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(100),
    descripcion_med TEXT,
    concentracion VARCHAR(50),
    forma_farmaceutica VARCHAR(50),
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 10,
    stock_maximo INTEGER DEFAULT 1000,
    precio_unitario DECIMAL(10,2),
    fecha_vencimiento DATE,
    lote VARCHAR(50),
    id_laboratorio INTEGER,
    id_categoria INTEGER,
    estado_medicamento estado_medicamento_enum DEFAULT 'DISPONIBLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_medicamento_laboratorio FOREIGN KEY (id_laboratorio) 
        REFERENCES laboratorio(id_laboratorio),
    CONSTRAINT fk_medicamento_categoria FOREIGN KEY (id_categoria) 
        REFERENCES categoria_medicamento(id_categoria),
    CONSTRAINT ck_stock_actual_positivo CHECK (stock_actual >= 0),
    CONSTRAINT ck_stock_minimo_positivo CHECK (stock_minimo >= 0),
    CONSTRAINT ck_stock_maximo_mayor CHECK (stock_maximo >= stock_minimo),
    CONSTRAINT ck_precio_positivo CHECK (precio_unitario >= 0),
    CONSTRAINT ck_fecha_vencimiento CHECK (fecha_vencimiento > CURRENT_DATE)
);

-- ===============================================
-- TABLAS DEPARTAMENTALES (Distribuidas por Departamento)
-- ===============================================

-- Tabla de departamentos
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

-- Tabla de roles de empleados
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
    
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT fk_empleado_rol FOREIGN KEY (id_rol) 
        REFERENCES rol_empleado(id_rol),
    CONSTRAINT ck_empleado_email CHECK (email_emp ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE),
    CONSTRAINT ck_fecha_contratacion CHECK (fecha_contratacion >= fecha_nacimiento + INTERVAL '18 years')
);

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
    
    CONSTRAINT fk_paciente_tipo_sangre FOREIGN KEY (id_tipo_sangre) 
        REFERENCES tipo_sangre(id_tipo_sangre),
    CONSTRAINT ck_paciente_email CHECK (email_pac ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento_paciente CHECK (fecha_nac <= CURRENT_DATE)
);

-- Tabla de historias clínicas
CREATE TABLE historia_clinica (
    cod_hist SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    observaciones_generales TEXT,
    peso_kg DECIMAL(5,2),
    altura_cm DECIMAL(5,2),
    alergias_conocidas TEXT,
    id_dept_origen INTEGER NOT NULL,
    estado_historia estado_historia_enum DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_historia_paciente FOREIGN KEY (cod_pac) 
        REFERENCES paciente(cod_pac),
    CONSTRAINT fk_historia_departamento FOREIGN KEY (id_dept_origen) 
        REFERENCES departamento(id_dept),
    CONSTRAINT uk_historia_paciente UNIQUE (cod_pac),
    CONSTRAINT ck_peso_positivo CHECK (peso_kg > 0 AND peso_kg <= 500),
    CONSTRAINT ck_altura_positiva CHECK (altura_cm > 0 AND altura_cm <= 300)
);

-- Tabla de tipos de cita
CREATE TABLE tipo_cita (
    id_tipo_cita SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
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
    cod_pac INTEGER NOT NULL,
    id_emp INTEGER NOT NULL,
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
    
    CONSTRAINT fk_cita_paciente FOREIGN KEY (cod_pac) 
        REFERENCES paciente(cod_pac),
    CONSTRAINT fk_cita_empleado FOREIGN KEY (id_emp) 
        REFERENCES empleado(id_emp),
    CONSTRAINT fk_cita_tipo FOREIGN KEY (id_tipo_cita) 
        REFERENCES tipo_cita(id_tipo_cita),
    CONSTRAINT fk_cita_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT ck_fecha_cita CHECK (fecha_cita >= CURRENT_DATE),
    CONSTRAINT ck_duracion_real_positiva CHECK (duracion_real_min > 0)
);

-- Tabla de prescripciones
CREATE TABLE prescripcion (
    cod_prescripcion SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp_prescriptor INTEGER NOT NULL,
    fecha_prescripcion DATE DEFAULT CURRENT_DATE,
    observaciones_prescripcion TEXT,
    estado_prescripcion estado_prescripcion_enum DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prescripcion_historia FOREIGN KEY (cod_hist) 
        REFERENCES historia_clinica(cod_hist),
    CONSTRAINT fk_prescripcion_empleado FOREIGN KEY (id_emp_prescriptor) 
        REFERENCES empleado(id_emp)
);

-- Tabla de detalles de prescripción
CREATE TABLE detalle_prescripcion (
    id_detalle SERIAL PRIMARY KEY,
    cod_prescripcion INTEGER NOT NULL,
    cod_med INTEGER NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    instrucciones_especiales TEXT,
    cantidad_total INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_detalle_prescripcion FOREIGN KEY (cod_prescripcion) 
        REFERENCES prescripcion(cod_prescripcion) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_medicamento FOREIGN KEY (cod_med) 
        REFERENCES medicamento(cod_med),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_dias > 0),
    CONSTRAINT ck_cantidad_positiva CHECK (cantidad_total > 0)
);

-- Tabla de equipamiento
CREATE TABLE equipamiento (
    cod_eq SERIAL PRIMARY KEY,
    nom_eq VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    numero_serie VARCHAR(50) UNIQUE,
    descripcion_eq TEXT,
    id_dept INTEGER NOT NULL,
    id_tipo_equipo INTEGER NOT NULL,
    id_proveedor INTEGER,
    estado_equipo estado_equipo_enum DEFAULT 'OPERATIVO',
    fecha_adquisicion DATE DEFAULT CURRENT_DATE,
    costo_adquisicion DECIMAL(12,2),
    proxima_calibracion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_equipamiento_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT fk_equipamiento_tipo FOREIGN KEY (id_tipo_equipo) 
        REFERENCES tipo_equipamiento(id_tipo_equipo),
    CONSTRAINT fk_equipamiento_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES proveedor(id_proveedor),
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
    id_emp_responsable INTEGER,
    empresa_externa VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_mantenimiento_equipo FOREIGN KEY (cod_eq) 
        REFERENCES equipamiento(cod_eq),
    CONSTRAINT fk_mantenimiento_empleado FOREIGN KEY (id_emp_responsable) 
        REFERENCES empleado(id_emp),
    CONSTRAINT ck_costo_mantenimiento_positivo CHECK (costo_mantenimiento >= 0),
    CONSTRAINT ck_fecha_mantenimiento CHECK (fecha_mantenimiento <= CURRENT_DATE)
);

-- ===============================================
-- TABLAS DE SEGURIDAD Y AUDITORÍA
-- ===============================================

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

-- Tabla de acceso a historias clínicas (Auditoría)
CREATE TABLE acceso_historia (
    id_acceso SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp INTEGER NOT NULL,
    fecha_hora_acceso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion tipo_operacion_enum NOT NULL,
    justificacion_acceso TEXT,
    ip_acceso INET,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_acceso_historia FOREIGN KEY (cod_hist) 
        REFERENCES historia_clinica(cod_hist),
    CONSTRAINT fk_acceso_empleado FOREIGN KEY (id_emp) 
        REFERENCES empleado(id_emp)
);

-- ===============================================
-- VISTAS ÚTILES PARA CONSULTAS
-- ===============================================

-- Vista de empleados con información completa
CREATE VIEW v_empleados_completo AS
SELECT 
    e.id_emp,
    e.nom_emp || ' ' || e.apellido_emp AS nombre_completo,
    e.cedula,
    e.tel_emp,
    e.email_emp,
    d.nom_dept,
    d.tipo_especialidad,
    r.nombre_rol,
    e.estado_empleado,
    e.fecha_contratacion
FROM empleado e
JOIN departamento d ON e.id_dept = d.id_dept
JOIN rol_empleado r ON e.id_rol = r.id_rol;

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
    p.estado_paciente
FROM paciente p
LEFT JOIN tipo_sangre ts ON p.id_tipo_sangre = ts.id_tipo_sangre;

-- Vista de citas con información detallada
CREATE VIEW v_citas_detalle AS
SELECT 
    c.id_cita,
    c.fecha_cita,
    c.hora_inicio,
    p.nom_pac || ' ' || p.apellido_pac AS paciente,
    p.cedula AS cedula_paciente,
    e.nom_emp || ' ' || e.apellido_emp AS medico,
    d.nom_dept AS departamento,
    tc.nombre_tipo AS tipo_cita,
    c.estado_cita,
    c.motivo_consulta,
    c.diagnostico_preliminar
FROM cita c
JOIN paciente p ON c.cod_pac = p.cod_pac
JOIN empleado e ON c.id_emp = e.id_emp
JOIN departamento d ON c.id_dept = d.id_dept
JOIN tipo_cita tc ON c.id_tipo_cita = tc.id_tipo_cita;

-- Vista de prescripciones con detalles
CREATE VIEW v_prescripciones_detalle AS
SELECT 
    pr.cod_prescripcion,
    pr.fecha_prescripcion,
    p.nom_pac || ' ' || p.apellido_pac AS paciente,
    e.nom_emp || ' ' || e.apellido_emp AS medico_prescriptor,
    d.nom_dept AS departamento,
    pr.estado_prescripcion,
    COUNT(dp.id_detalle) AS cantidad_medicamentos,
    pr.observaciones_prescripcion
FROM prescripcion pr
JOIN historia_clinica hc ON pr.cod_hist = hc.cod_hist
JOIN paciente p ON hc.cod_pac = p.cod_pac
JOIN empleado e ON pr.id_emp_prescriptor = e.id_emp
JOIN departamento d ON e.id_dept = d.id_dept
LEFT JOIN detalle_prescripcion dp ON pr.cod_prescripcion = dp.cod_prescripcion
GROUP BY pr.cod_prescripcion, pr.fecha_prescripcion, p.nom_pac, p.apellido_pac, 
         e.nom_emp, e.apellido_emp, d.nom_dept, pr.estado_prescripcion, pr.observaciones_prescripcion;

-- Vista de medicamentos con información completa
CREATE VIEW v_medicamentos_completo AS
SELECT 
    m.cod_med,
    m.nom_med,
    m.principio_activo,
    m.concentracion,
    m.forma_farmaceutica,
    m.stock_actual,
    m.stock_minimo,
    m.precio_unitario,
    l.nombre_laboratorio,
    cm.nombre_categoria,
    m.fecha_vencimiento,
    m.estado_medicamento,
    CASE 
        WHEN m.stock_actual <= m.stock_minimo THEN 'STOCK_BAJO'
        WHEN m.fecha_vencimiento <= CURRENT_DATE + INTERVAL '3 months' THEN 'PROXIMO_VENCIMIENTO'
        ELSE 'NORMAL'
    END AS alerta_stock
FROM medicamento m
JOIN laboratorio l ON m.id_laboratorio = l.id_laboratorio
JOIN categoria_medicamento cm ON m.id_categoria = cm.id_categoria;

-- Vista de equipamiento con información completa
CREATE VIEW v_equipamiento_completo AS
SELECT 
    eq.cod_eq,
    eq.nom_eq,
    eq.modelo,
    eq.numero_serie,
    d.nom_dept AS departamento,
    te.nombre_tipo AS tipo_equipo,
    pr.nombre_proveedor,
    eq.estado_equipo,
    eq.fecha_adquisicion,
    eq.proxima_calibracion,
    CASE 
        WHEN eq.proxima_calibracion <= CURRENT_DATE THEN 'CALIBRACION_VENCIDA'
        WHEN eq.proxima_calibracion <= CURRENT_DATE + INTERVAL '1 month' THEN 'CALIBRACION_PROXIMA'
        ELSE 'CALIBRACION_OK'
    END AS estado_calibracion
FROM equipamiento eq
JOIN departamento d ON eq.id_dept = d.id_dept
JOIN tipo_equipamiento te ON eq.id_tipo_equipo = te.id_tipo_equipo
LEFT JOIN proveedor pr ON eq.id_proveedor = pr.id_proveedor;