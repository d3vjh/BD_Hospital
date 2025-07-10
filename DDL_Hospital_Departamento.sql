-- ===============================================
-- DDL - HOSPITAL DEPARTAMENTO (BD LOCAL)
-- Base de datos local para departamentos médicos (SIN farmacia)
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
    jefe_departamento VARCHAR(100),
    capacidad_atencion INTEGER DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT ck_departamento_email CHECK (email_dept ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- ===============================================
-- GESTIÓN DE PERSONAL DEL DEPARTAMENTO
-- ===============================================

-- Tabla de roles específicos del departamento médico
CREATE TABLE rol_empleado (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion_rol TEXT,
    permisos_sistema JSON DEFAULT '{}',
    nivel_acceso INTEGER DEFAULT 1,
    puede_prescribir BOOLEAN DEFAULT FALSE,
    puede_ver_historias BOOLEAN DEFAULT FALSE,
    puede_modificar_historias BOOLEAN DEFAULT FALSE,
    puede_agendar_citas BOOLEAN DEFAULT FALSE,
    puede_generar_reportes BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_rol_nombre UNIQUE (nombre_rol),
    CONSTRAINT ck_nivel_acceso CHECK (nivel_acceso BETWEEN 1 AND 4)
);

-- Tabla de empleados del departamento médico
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
    especialidad_medica VARCHAR(100),
    universidad_titulo VARCHAR(150),
    ano_graduacion INTEGER,
    certificaciones JSON DEFAULT '[]',
    turno_preferido VARCHAR(20) DEFAULT 'DIURNO',
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
    CONSTRAINT ck_fecha_contratacion CHECK (fecha_contratacion <= CURRENT_DATE),
    CONSTRAINT ck_ano_graduacion CHECK (ano_graduacion IS NULL OR ano_graduacion BETWEEN 1950 AND EXTRACT(YEAR FROM CURRENT_DATE))
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
    preferencias_interfaz JSON DEFAULT '{}',
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
    acciones_realizadas INTEGER DEFAULT 0,
    ultima_actividad TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_sesion_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario_sistema(id_usuario),
    CONSTRAINT ck_fechas_sesion CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- ===============================================
-- GESTIÓN DE CITAS DEL DEPARTAMENTO
-- ===============================================

-- Tabla de tipos de cita específicos del departamento
CREATE TABLE tipo_cita (
    id_tipo_cita SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
    duracion_default_min INTEGER DEFAULT 30,
    costo_base DECIMAL(10,2) DEFAULT 0.00,
    descripcion_tipo TEXT,
    requiere_preparacion BOOLEAN DEFAULT FALSE,
    permite_urgencia BOOLEAN DEFAULT TRUE,
    requiere_interconsulta BOOLEAN DEFAULT FALSE,
    configuracion_especial JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_tipo_cita_nombre UNIQUE (nombre_tipo),
    CONSTRAINT ck_duracion_positiva CHECK (duracion_default_min > 0),
    CONSTRAINT ck_costo_no_negativo CHECK (costo_base >= 0)
);

-- Tabla de citas del departamento (cod_pac referencia a hospital_central.paciente)
CREATE TABLE cita (
    id_cita SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL, -- FK a hospital_central.paciente
    id_emp INTEGER NOT NULL,
    id_tipo_cita INTEGER NOT NULL,
    id_dept INTEGER NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME,
    duracion_real_min INTEGER,
    motivo_consulta TEXT,
    sintomas_principales TEXT,
    diagnostico_preliminar TEXT,
    diagnostico_final TEXT,
    observaciones_cita TEXT,
    recomendaciones TEXT,
    requiere_seguimiento BOOLEAN DEFAULT FALSE,
    fecha_seguimiento DATE,
    prioridad VARCHAR(20) DEFAULT 'NORMAL', -- 'BAJA', 'NORMAL', 'ALTA', 'URGENTE'
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
    CONSTRAINT ck_duracion_real CHECK (duracion_real_min IS NULL OR duracion_real_min > 0),
    CONSTRAINT ck_horas_cita CHECK (hora_fin IS NULL OR hora_fin >= hora_inicio)
);

-- Tabla de interconsultas (solicitudes a otros departamentos)
CREATE TABLE interconsulta (
    id_interconsulta SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL, -- FK a hospital_central.paciente
    id_cita_origen INTEGER, -- Cita que originó la interconsulta
    id_emp_solicitante INTEGER NOT NULL,
    id_dept_solicitante INTEGER NOT NULL,
    dept_destino_nombre VARCHAR(100) NOT NULL, -- Nombre del departamento destino
    id_dept_destino INTEGER, -- Si se conoce el ID del departamento destino
    motivo_interconsulta TEXT NOT NULL,
    hallazgos_relevantes TEXT,
    pregunta_especifica TEXT,
    urgente BOOLEAN DEFAULT FALSE,
    fecha_solicitud DATE DEFAULT CURRENT_DATE,
    fecha_respuesta_esperada DATE,
    fecha_respuesta_recibida DATE,
    respuesta_interconsulta TEXT,
    id_emp_respondente INTEGER, -- Empleado que responde (del otro departamento)
    nombre_respondente VARCHAR(100),
    estado_interconsulta VARCHAR(20) DEFAULT 'PENDIENTE', -- 'PENDIENTE', 'EN_PROCESO', 'RESPONDIDA', 'CANCELADA'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_interconsulta_cita FOREIGN KEY (id_cita_origen) 
        REFERENCES cita(id_cita),
    CONSTRAINT fk_interconsulta_empleado FOREIGN KEY (id_emp_solicitante) 
        REFERENCES empleado(id_emp),
    CONSTRAINT fk_interconsulta_departamento FOREIGN KEY (id_dept_solicitante) 
        REFERENCES departamento(id_dept),
    CONSTRAINT ck_fechas_interconsulta CHECK (fecha_respuesta_recibida IS NULL OR fecha_respuesta_recibida >= fecha_solicitud)
);

-- ===============================================
-- GESTIÓN DE EQUIPAMIENTO DEL DEPARTAMENTO
-- ===============================================

-- Tabla de equipamiento del departamento (referencias a catálogos centrales)
CREATE TABLE equipamiento (
    cod_eq SERIAL PRIMARY KEY,
    nom_eq VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    numero_serie VARCHAR(100) UNIQUE,
    descripcion_eq TEXT,
    id_dept INTEGER NOT NULL,
    id_tipo_equipo INTEGER NOT NULL, -- FK a hospital_central.tipo_equipamiento
    id_proveedor INTEGER, -- FK a hospital_central.proveedor
    estado_equipo estado_equipo_enum DEFAULT 'OPERATIVO',
    ubicacion_especifica VARCHAR(100),
    responsable_equipo INTEGER, -- Empleado responsable
    fecha_adquisicion DATE,
    costo_adquisicion DECIMAL(12,2),
    garantia_meses INTEGER,
    fecha_fin_garantia DATE,
    proxima_calibracion DATE,
    frecuencia_calibracion_dias INTEGER DEFAULT 365,
    ultimo_mantenimiento DATE,
    observaciones_equipo TEXT,
    manual_usuario VARCHAR(200), -- Ruta del manual
    configuracion_tecnica JSON DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_equipamiento_departamento FOREIGN KEY (id_dept) 
        REFERENCES departamento(id_dept),
    CONSTRAINT fk_equipamiento_responsable FOREIGN KEY (responsable_equipo) 
        REFERENCES empleado(id_emp),
    CONSTRAINT ck_fechas_garantia CHECK (fecha_fin_garantia IS NULL OR fecha_fin_garantia >= fecha_adquisicion),
    CONSTRAINT ck_costo_no_negativo CHECK (costo_adquisicion IS NULL OR costo_adquisicion >= 0)
);

-- Tabla de mantenimiento de equipos
CREATE TABLE mantenimiento_equipo (
    id_mantenimiento SERIAL PRIMARY KEY,
    cod_eq INTEGER NOT NULL,
    fecha_mantenimiento DATE DEFAULT CURRENT_DATE,
    tipo_mantenimiento VARCHAR(50) NOT NULL, -- 'PREVENTIVO', 'CORRECTIVO', 'CALIBRACION', 'LIMPIEZA'
    descripcion_trabajo TEXT NOT NULL,
    costo_mantenimiento DECIMAL(10,2) DEFAULT 0.00,
    tiempo_fuera_servicio_horas INTEGER,
    id_emp_responsable INTEGER,
    empresa_externa VARCHAR(100),
    tecnico_externo VARCHAR(100),
    telefono_tecnico VARCHAR(20),
    estado_posterior VARCHAR(20) DEFAULT 'OPERATIVO',
    observaciones_tecnicas TEXT,
    piezas_reemplazadas TEXT,
    requiere_seguimiento BOOLEAN DEFAULT FALSE,
    proxima_revision DATE,
    garantia_trabajo_dias INTEGER DEFAULT 30,
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
-- COMUNICACIÓN CON FARMACIA CENTRAL
-- ===============================================

-- Tabla de solicitudes de prescripción a farmacia central
CREATE TABLE solicitud_prescripcion (
    id_solicitud SERIAL PRIMARY KEY,
    cod_pac INTEGER NOT NULL, -- FK a hospital_central.paciente
    cod_hist INTEGER NOT NULL, -- FK a hospital_central.historia_clinica
    id_cita INTEGER, -- Cita asociada
    id_emp_prescriptor INTEGER NOT NULL,
    diagnostico VARCHAR(200) NOT NULL,
    observaciones_medicas TEXT,
    urgente BOOLEAN DEFAULT FALSE,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_solicitud VARCHAR(20) DEFAULT 'ENVIADA', -- 'ENVIADA', 'RECIBIDA_FARMACIA', 'PROCESADA', 'DISPENSADA'
    id_prescripcion_central INTEGER, -- ID de la prescripción en hospital_central
    fecha_respuesta_farmacia TIMESTAMP,
    observaciones_farmacia TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_solicitud_cita FOREIGN KEY (id_cita) 
        REFERENCES cita(id_cita),
    CONSTRAINT fk_solicitud_empleado FOREIGN KEY (id_emp_prescriptor) 
        REFERENCES empleado(id_emp)
);

-- Tabla de detalles de medicamentos solicitados
CREATE TABLE detalle_solicitud_medicamento (
    id_detalle_solicitud SERIAL PRIMARY KEY,
    id_solicitud INTEGER NOT NULL,
    nombre_medicamento VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(200),
    concentracion VARCHAR(50),
    forma_farmaceutica VARCHAR(50),
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(100) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    cantidad_solicitada INTEGER NOT NULL,
    instrucciones_especiales TEXT,
    via_administracion VARCHAR(50),
    justificacion_medica TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_detalle_solicitud FOREIGN KEY (id_solicitud) 
        REFERENCES solicitud_prescripcion(id_solicitud),
    CONSTRAINT ck_duracion_positiva_solicitud CHECK (duracion_dias > 0),
    CONSTRAINT ck_cantidad_positiva_solicitud CHECK (cantidad_solicitada > 0)
);

-- ===============================================
-- VISTAS ÚTILES DEL DEPARTAMENTO
-- ===============================================

-- Vista de empleados del departamento con roles
CREATE VIEW v_empleados_departamento AS
SELECT 
    e.id_emp,
    e.nom_emp || ' ' || e.apellido_emp AS nombre_completo,
    e.cedula,
    e.especialidad_medica,
    r.nombre_rol,
    r.nivel_acceso,
    r.puede_prescribir,
    r.puede_ver_historias,
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
    c.cod_pac,
    c.fecha_cita,
    c.hora_inicio,
    c.hora_fin,
    e.nom_emp || ' ' || e.apellido_emp AS medico,
    e.especialidad_medica,
    tc.nombre_tipo AS tipo_cita,
    c.motivo_consulta,
    c.prioridad,
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
    emp.nom_emp || ' ' || emp.apellido_emp AS responsable,
    eq.proxima_calibracion,
    CASE 
        WHEN eq.proxima_calibracion <= CURRENT_DATE THEN 'CALIBRACION_VENCIDA'
        WHEN eq.proxima_calibracion <= CURRENT_DATE + INTERVAL '30 days' THEN 'CALIBRACION_PROXIMA'
        ELSE 'CALIBRACION_VIGENTE'
    END AS estado_calibracion,
    (eq.proxima_calibracion - CURRENT_DATE) AS dias_proxima_calibracion
FROM equipamiento eq
LEFT JOIN empleado emp ON eq.responsable_equipo = emp.id_emp
ORDER BY eq.proxima_calibracion;

-- Vista de interconsultas pendientes
CREATE VIEW v_interconsultas_pendientes AS
SELECT 
    i.id_interconsulta,
    i.cod_pac,
    i.dept_destino_nombre,
    i.motivo_interconsulta,
    i.urgente,
    i.fecha_solicitud,
    i.fecha_respuesta_esperada,
    emp.nom_emp || ' ' || emp.apellido_emp AS medico_solicitante,
    (CURRENT_DATE - i.fecha_solicitud) AS dias_pendiente,
    i.estado_interconsulta
FROM interconsulta i
JOIN empleado emp ON i.id_emp_solicitante = emp.id_emp
WHERE i.estado_interconsulta IN ('PENDIENTE', 'EN_PROCESO')
ORDER BY i.urgente DESC, i.fecha_solicitud;

-- Vista de solicitudes de prescripción a farmacia
CREATE VIEW v_solicitudes_farmacia AS
SELECT 
    sp.id_solicitud,
    sp.cod_pac,
    sp.diagnostico,
    sp.urgente,
    sp.fecha_solicitud,
    sp.estado_solicitud,
    emp.nom_emp || ' ' || emp.apellido_emp AS medico_prescriptor,
    COUNT(dsm.id_detalle_solicitud) AS total_medicamentos,
    STRING_AGG(dsm.nombre_medicamento, ', ') AS medicamentos_solicitados
FROM solicitud_prescripcion sp
JOIN empleado emp ON sp.id_emp_prescriptor = emp.id_emp
LEFT JOIN detalle_solicitud_medicamento dsm ON sp.id_solicitud = dsm.id_solicitud
GROUP BY sp.id_solicitud, sp.cod_pac, sp.diagnostico, sp.urgente, 
         sp.fecha_solicitud, sp.estado_solicitud, emp.nom_emp, emp.apellido_emp
ORDER BY sp.fecha_solicitud DESC;