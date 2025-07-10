-- ===============================================
-- DDL - HOSPITAL DEPARTAMENTO (BD LOCAL)
-- Base de datos local para cualquier departamento del hospital
-- ===============================================

-- Crear base de datos
-- CREATE DATABASE hospital_departamento;
-- \c hospital_departamento;

-- ===============================================
-- TIPOS ENUMERADOS (ENUMS)
-- ===============================================
CREATE TYPE estado_empleado_enum AS ENUM ('ACTIVO', 'INACTIVO', 'VACACIONES', 'LICENCIA');
CREATE TYPE estado_cita_enum AS ENUM ('PROGRAMADA', 'CONFIRMADA', 'EN_CURSO', 'COMPLETADA', 'CANCELADA', 'NO_ASISTIO');
CREATE TYPE estado_equipo_enum AS ENUM ('OPERATIVO', 'MANTENIMIENTO', 'FUERA_SERVICIO', 'REPARACION');
CREATE TYPE estado_medicamento_enum AS ENUM ('DISPONIBLE', 'AGOTADO', 'VENCIDO', 'RETIRADO');
CREATE TYPE estado_prescripcion_enum AS ENUM ('ACTIVA', 'DISPENSADA', 'CANCELADA', 'VENCIDA');
CREATE TYPE estado_sesion_enum AS ENUM ('ACTIVA', 'CERRADA', 'EXPIRADA');

-- ===============================================
-- CONFIGURACIÓN DEL DEPARTAMENTO
-- ===============================================

-- Tabla de configuración local del departamento
CREATE TABLE departamento (
    id_dept SERIAL PRIMARY KEY,
    nom_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200),
    tipo_especialidad VARCHAR(100),
    telefono_dept VARCHAR(20),
    email_dept VARCHAR(100),
    horario_atencion JSON DEFAULT '{}',
    configuracion_especial JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT ck_departamento_email CHECK (email_dept ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- ===============================================
-- GESTIÓN DE PERSONAL DEL DEPARTAMENTO
-- ===============================================

-- Tabla de roles específicos del departamento
CREATE TABLE rol_empleado (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion_rol TEXT,
    permisos_sistema JSON DEFAULT '{}',
    nivel_acceso INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_rol_nombre UNIQUE (nombre_rol),
    CONSTRAINT ck_nivel_acceso CHECK (nivel_acceso BETWEEN 1 AND 4)
);

-- Tabla de empleados del departamento
CREATE TABLE empleado (
    id_emp SERIAL PRIMARY KEY,
    nom_emp VARCHAR(50) NOT NULL,
    apellido_emp VARCHAR(50) NOT NULL,
    dir_emp VARCHAR(200),
    tel_emp VARCHAR(20),
    email_emp VARCHAR(100),
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    fecha_nacimiento DATE NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    estado_empleado estado_empleado_enum DEFAULT 'ACTIVO',
    id_dept INTEGER NOT NULL,
    id_rol INTEGER NOT NULL,
    numero_licencia VARCHAR(50),
    certificaciones JSON DEFAULT '[]',
    ultimo_acceso TIMESTAMP,
    intentos_acceso_fallidos INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT fk_empleado_rol FOREIGN KEY (id_rol) 
        REFERENCES rol_empleado(id_rol),
    CONSTRAINT ck_empleado_email CHECK (email_emp ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT ck_fecha_nacimiento_empleado CHECK (fecha_nacimiento <= CURRENT_DATE - INTERVAL '18 years'),
    CONSTRAINT ck_fecha_contratacion CHECK (fecha_contratacion <= CURRENT_DATE)
);

-- ===============================================
-- SISTEMA DE USUARIOS Y SEGURIDAD
-- ===============================================

-- Tabla de usuarios del sistema local
CREATE TABLE usuario_sistema (
    id_usuario SERIAL PRIMARY KEY,
    id_emp INTEGER NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP,
    intentos_fallidos INTEGER DEFAULT 0,
    cuenta_activa BOOLEAN DEFAULT TRUE,
    token_recuperacion VARCHAR(255),
    token_expiracion TIMESTAMP,
    configuracion_usuario JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_usuario_empleado FOREIGN KEY (id_emp) 
        REFERENCES empleado(id_emp),
    CONSTRAINT ck_username_length CHECK (LENGTH(username) >= 4),
    CONSTRAINT ck_intentos_fallidos CHECK (intentos_fallidos >= 0 AND intentos_fallidos <= 10)
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
    ubicacion_geografica VARCHAR(100),
    dispositivo VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario_sistema(id_usuario),
    CONSTRAINT ck_fechas_sesion CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- ===============================================
-- GESTIÓN DE CITAS
-- ===============================================

-- Tabla de tipos de cita específicos del departamento
CREATE TABLE tipo_cita (
    id_tipo_cita SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
    duracion_default_min INTEGER DEFAULT 30,
    costo_base DECIMAL(10,2) DEFAULT 0.00,
    descripcion_tipo TEXT,
    configuracion_especial JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_tipo_cita_nombre UNIQUE (nombre_tipo),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_default_min > 0),
    CONSTRAINT ck_costo_no_negativo CHECK (costo_base >= 0)
);

-- Tabla de citas del departamento
CREATE TABLE cita (
    id_cita SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL,
    id_emp INTEGER NOT NULL,
    id_tipo_cita INTEGER NOT NULL,
    id_dept INTEGER NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    duracion_real_min INTEGER,
    motivo_consulta TEXT,
    diagnostico_preliminar TEXT,
    observaciones_cita TEXT,
    estado_cita estado_cita_enum DEFAULT 'PROGRAMADA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_cita_empleado FOREIGN KEY (id_emp) 
        REFERENCES empleado(id_emp),
    CONSTRAINT fk_cita_tipo FOREIGN KEY (id_tipo_cita) 
        REFERENCES tipo_cita(id_tipo_cita),
    CONSTRAINT fk_cita_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT ck_fecha_cita CHECK (fecha_cita >= CURRENT_DATE - INTERVAL '1 year'),
    CONSTRAINT ck_duracion_real CHECK (duracion_real_min IS NULL OR duracion_real_min > 0)
);

-- ===============================================
-- GESTIÓN DE EQUIPAMIENTO
-- ===============================================

-- Tabla de equipamiento del departamento
CREATE TABLE equipamiento (
    cod_eq SERIAL PRIMARY KEY,
    nom_eq VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    numero_serie VARCHAR(100) UNIQUE,
    descripcion_eq TEXT,
    id_dept INTEGER NOT NULL,
    id_tipo_equipo INTEGER NOT NULL,
    id_proveedor INTEGER,
    estado_equipo estado_equipo_enum DEFAULT 'OPERATIVO',
    ubicacion_especifica VARCHAR(100),
    fecha_adquisicion DATE,
    costo_adquisicion DECIMAL(12,2),
    garantia_meses INTEGER,
    fecha_fin_garantia DATE,
    proxima_calibracion DATE,
    frecuencia_calibracion_dias INTEGER DEFAULT 365,
    ultimo_mantenimiento DATE,
    configuracion_tecnica JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_equipamiento_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT ck_fechas_garantia CHECK (fecha_fin_garantia IS NULL OR fecha_fin_garantia >= fecha_adquisicion),
    CONSTRAINT ck_costo_no_negativo CHECK (costo_adquisicion IS NULL OR costo_adquisicion >= 0)
);

-- Tabla de mantenimiento de equipos
CREATE TABLE mantenimiento_equipo (
    id_mantenimiento SERIAL PRIMARY KEY,
    cod_eq INTEGER NOT NULL,
    fecha_mantenimiento DATE DEFAULT CURRENT_DATE,
    tipo_mantenimiento VARCHAR(50) NOT NULL,
    descripcion_trabajo TEXT NOT NULL,
    costo_mantenimiento DECIMAL(10,2) DEFAULT 0.00,
    tiempo_fuera_servicio_horas INTEGER,
    id_emp_responsable INTEGER,
    empresa_externa VARCHAR(100),
    tecnico_externo VARCHAR(100),
    estado_posterior VARCHAR(20) DEFAULT 'OPERATIVO',
    observaciones_tecnicas TEXT,
    requiere_seguimiento BOOLEAN DEFAULT FALSE,
    proxima_revision DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_mantenimiento_equipo FOREIGN KEY (cod_eq) 
        REFERENCES equipamiento(cod_eq),
    CONSTRAINT fk_mantenimiento_empleado FOREIGN KEY (id_emp_responsable) 
        REFERENCES empleado(id_emp),
    CONSTRAINT ck_costo_mantenimiento CHECK (costo_mantenimiento >= 0),
    CONSTRAINT ck_tiempo_fuera_servicio CHECK (tiempo_fuera_servicio_horas IS NULL OR tiempo_fuera_servicio_horas >= 0)
);

-- ===============================================
-- MÓDULO DE FARMACIA (SOLO SI EL DEPARTAMENTO ES FARMACIA)
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

-- Tabla de medicamentos
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

-- Tabla de prescripciones
CREATE TABLE prescripcion (
    cod_prescripcion SERIAL PRIMARY KEY,
    cod_hist INTEGER NOT NULL,
    id_emp_prescriptor INTEGER NOT NULL,
    id_dept_prescriptor INTEGER,
    fecha_prescripcion DATE DEFAULT CURRENT_DATE,
    observaciones_prescripcion TEXT,
    diagnostico_asociado VARCHAR(200),
    estado_prescripcion estado_prescripcion_enum DEFAULT 'ACTIVA',
    fecha_dispensacion DATE,
    id_emp_dispensador INTEGER,
    validada_farmaceutico BOOLEAN DEFAULT FALSE,
    id_emp_validador INTEGER,
    observaciones_farmaceuticas TEXT,
    fecha_validacion TIMESTAMP,
    vigencia_dias INTEGER DEFAULT 30,
    fecha_vencimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prescripcion_dispensador FOREIGN KEY (id_emp_dispensador) 
        REFERENCES empleado(id_emp),
    CONSTRAINT fk_prescripcion_validador FOREIGN KEY (id_emp_validador) 
        REFERENCES empleado(id_emp),
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

-- ===============================================
-- VISTAS ÚTILES
-- ===============================================

-- Vista de inventario crítico (solo para departamentos con farmacia)
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

-- Vista de prescripciones pendientes
CREATE VIEW v_prescripciones_pendientes AS
SELECT 
    p.cod_prescripcion,
    p.fecha_prescripcion,
    p.diagnostico_asociado,
    p.validada_farmaceutico,
    emp_disp.nom_emp || ' ' || emp_disp.apellido_emp AS farmaceutico_asignado,
    COUNT(dp.id_detalle) AS total_medicamentos,
    SUM(CASE WHEN dp.cantidad_dispensada < dp.cantidad_total THEN 1 ELSE 0 END) AS medicamentos_pendientes,
    (CURRENT_DATE - p.fecha_prescripcion) AS dias_transcurridos
FROM prescripcion p
LEFT JOIN detalle_prescripcion dp ON p.cod_prescripcion = dp.cod_prescripcion
LEFT JOIN empleado emp_disp ON p.id_emp_dispensador = emp_disp.id_emp
WHERE p.estado_prescripcion = 'ACTIVA'
    AND (p.fecha_vencimiento IS NULL OR p.fecha_vencimiento >= CURRENT_DATE)
GROUP BY p.cod_prescripcion, p.fecha_prescripcion, p.diagnostico_asociado, 
         p.validada_farmaceutico, emp_disp.nom_emp, emp_disp.apellido_emp
HAVING SUM(CASE WHEN dp.cantidad_dispensada < dp.cantidad_total THEN 1 ELSE 0 END) > 0
ORDER BY p.fecha_prescripcion;

-- Vista de empleados del departamento
CREATE VIEW v_empleados_departamento AS
SELECT 
    e.id_emp,
    e.nom_emp || ' ' || e.apellido_emp AS nombre_completo,
    e.cedula,
    r.nombre_rol,
    r.nivel_acceso,
    e.numero_licencia,
    e.estado_empleado,
    us.cuenta_activa,
    us.ultimo_acceso,
    d.nom_dept AS departamento
FROM empleado e
JOIN rol_empleado r ON e.id_rol = r.id_rol
LEFT JOIN usuario_sistema us ON e.id_emp = us.id_emp
JOIN departamento d ON e.id_dept = d.id_dept
ORDER BY r.nivel_acceso DESC, e.nom_emp;

-- Vista de citas programadas
CREATE VIEW v_citas_programadas AS
SELECT 
    c.id_cita,
    c.fecha_cita,
    c.hora_inicio,
    e.nom_emp || ' ' || e.apellido_emp AS medico,
    tc.nombre_tipo AS tipo_cita,
    c.motivo_consulta,
    c.estado_cita,
    (c.fecha_cita - CURRENT_DATE) AS dias_hasta_cita
FROM cita c
JOIN empleado e ON c.id_emp = e.id_emp
JOIN tipo_cita tc ON c.id_tipo_cita = tc.id_tipo_cita
WHERE c.estado_cita IN ('PROGRAMADA', 'CONFIRMADA')
    AND c.fecha_cita >= CURRENT_DATE
ORDER BY c.fecha_cita, c.hora_inicio;

-- Vista de equipamiento del departamento
CREATE VIEW v_equipamiento_departamento AS
SELECT 
    eq.cod_eq,
    eq.nom_eq,
    eq.modelo,
    eq.numero_serie,
    eq.estado_equipo,
    eq.ubicacion_especifica,
    eq.proxima_calibracion,
    CASE 
        WHEN eq.proxima_calibracion <= CURRENT_DATE THEN 'CALIBRACION_VENCIDA'
        WHEN eq.proxima_calibracion <= CURRENT_DATE + INTERVAL '30 days' THEN 'CALIBRACION_PROXIMA'
        ELSE 'CALIBRACION_VIGENTE'
    END AS estado_calibracion,
    (eq.proxima_calibracion - CURRENT_DATE) AS dias_proxima_calibracion
FROM equipamiento eq
ORDER BY eq.proxima_calibracion;
