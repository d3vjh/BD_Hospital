-- ===============================================
-- DML - HOSPITAL CENTRAL (DATOS DE PRUEBA)
-- ===============================================

-- ===============================================
-- CATÁLOGOS MAESTROS
-- ===============================================

-- Insertar tipos de sangre
INSERT INTO tipo_sangre (tipo_sangre, descripcion) VALUES
('O+', 'Tipo O positivo - Donante universal de glóbulos rojos'),
('O-', 'Tipo O negativo - Donante universal'),
('A+', 'Tipo A positivo'),
('A-', 'Tipo A negativo'),
('B+', 'Tipo B positivo'),
('B-', 'Tipo B negativo'),
('AB+', 'Tipo AB positivo - Receptor universal'),
('AB-', 'Tipo AB negativo');

-- Insertar tipos de equipamiento
INSERT INTO tipo_equipamiento (nombre_tipo, descripcion_tipo, vida_util_anos, frecuencia_mantenimiento_dias) VALUES
('ELECTROCARDIOGRAFO', 'Equipo para realizar electrocardiogramas', 8, 180),
('DESFIBRILADOR', 'Equipo de emergencia cardiaca', 10, 90),
('MONITOR_SIGNOS_VITALES', 'Monitor multiparamétrico', 7, 120),
('BOMBA_INFUSION', 'Bomba para administración de medicamentos', 6, 60),
('VENTILADOR_MECANICO', 'Ventilador para soporte respiratorio', 12, 30),
('REFRIGERADOR_FARMACIA', 'Refrigerador especializado para medicamentos', 10, 365),
('BALANZA_PRECISION', 'Balanza de precisión farmacéutica', 15, 180),
('AUTOCLAVE', 'Equipo de esterilización', 15, 90);

-- Insertar proveedores
INSERT INTO proveedor (nombre_proveedor, telefono_prov, email_prov, direccion_prov) VALUES
('MEDTECH COLOMBIA SAS', '601-555-0101', 'ventas@medtech.co', 'Calle 100 #15-20, Bogotá'),
('EQUIPOS MEDICOS ANDINOS', '602-555-0102', 'comercial@ema.co', 'Carrera 50 #25-10, Medellín'),
('FARMEQUIPOS LTDA', '605-555-0103', 'info@farmequipos.co', 'Avenida 6N #20-50, Cali'),
('TECNOLOGIA HOSPITALARIA', '607-555-0104', 'contacto@techosp.co', 'Calle 45 #30-15, Barranquilla'),
('BIOMEDICA NACIONAL', '608-555-0105', 'ventas@biomedica.co', 'Carrera 15 #85-40, Bogotá');

-- Insertar tipos de cita generales
INSERT INTO tipo_cita_general (nombre_tipo, descripcion_tipo, duracion_sugerida_min, categoria) VALUES
('CONSULTA_GENERAL', 'Consulta médica general', 30, 'GENERAL'),
('CONSULTA_ESPECIALIZADA', 'Consulta con médico especialista', 45, 'ESPECIALIZADA'),
('URGENCIA_NIVEL_1', 'Atención de urgencia prioritaria', 15, 'URGENCIA'),
('URGENCIA_NIVEL_2', 'Atención de urgencia moderada', 20, 'URGENCIA'),
('CONTROL_POSOPERATORIO', 'Seguimiento postoperatorio', 20, 'CONTROL'),
('DISPENSACION_MEDICAMENTOS', 'Entrega de medicamentos en farmacia', 15, 'FARMACIA'),
('CONSULTA_FARMACEUTICA', 'Asesoría farmacológica', 30, 'FARMACIA');

-- ===============================================
-- DEPARTAMENTOS DEL HOSPITAL
-- ===============================================

-- Insertar departamentos maestros
INSERT INTO departamento_master (nom_dept, tipo_especialidad, ubicacion, telefono_dept, email_dept, database_name) VALUES
('FARMACIA', 'FARMACIA_HOSPITALARIA', 'Primer Piso - Ala Este', '601-555-0199', 'farmacia@hospital.com', 'hospital_farmacia'),
('CARDIOLOGIA', 'MEDICINA_INTERNA_CARDIACA', 'Segundo Piso - Ala Norte', '601-555-0201', 'cardiologia@hospital.com', 'hospital_cardiologia'),
('URGENCIAS', 'MEDICINA_URGENCIAS', 'Primer Piso - Entrada Principal', '601-555-0301', 'urgencias@hospital.com', 'hospital_urgencias'),
('NEUROLOGIA', 'MEDICINA_NEUROLOGICA', 'Tercer Piso - Ala Sur', '601-555-0401', 'neurologia@hospital.com', 'hospital_neurologia'),
('PEDIATRIA', 'MEDICINA_PEDIATRICA', 'Segundo Piso - Ala Sur', '601-555-0501', 'pediatria@hospital.com', 'hospital_pediatria');

-- ===============================================
-- PACIENTES GLOBALES
-- ===============================================

-- Insertar pacientes
INSERT INTO paciente (nom_pac, apellido_pac, dir_pac, tel_pac, email_pac, fecha_nac, genero, cedula, num_seguro, id_tipo_sangre, departamentos_atencion, id_dept_principal) VALUES
('Juan Carlos', 'Rodríguez Pérez', 'Calle 50 #25-30, Bogotá', '3101234567', 'juan.rodriguez@email.com', '1985-03-15', 'M', '1234567890', 'EPS001-12345', 1, '[2, 3]', 2),
('María Elena', 'García López', 'Carrera 20 #40-15, Bogotá', '3109876543', 'maria.garcia@email.com', '1990-07-22', 'F', '9876543210', 'EPS002-67890', 3, '[1, 2]', 1),
('Carlos Andrés', 'Martínez Silva', 'Avenida 68 #15-45, Bogotá', '3156789012', 'carlos.martinez@email.com', '1978-11-08', 'M', '5555666677', 'EPS003-11111', 2, '[2, 3, 4]', 2),
('Ana Sofía', 'Herrera Díaz', 'Calle 127 #7-89, Bogotá', '3201122334', 'ana.herrera@email.com', '1995-02-14', 'F', '1111222233', 'EPS001-22222', 4, '[1, 5]', 5),
('Luis Fernando', 'Ramírez Castro', 'Carrera 15 #85-20, Bogotá', '3134455667', 'luis.ramirez@email.com', '1982-09-30', 'M', '3333444455', 'EPS004-33333', 1, '[3]', 3),
('Isabella', 'Torres Moreno', 'Calle 72 #11-25, Bogotá', '3187788990', 'isabella.torres@email.com', '2010-05-18', 'F', '7777888899', 'EPS002-44444', 6, '[5]', 5),
('Miguel Ángel', 'Vargas Ruiz', 'Avenida Boyacá #45-67, Bogotá', '3145566778', 'miguel.vargas@email.com', '1973-12-03', 'M', '2222333344', 'EPS005-55555', 7, '[2, 4]', 4),
('Laura Cristina', 'Mendoza Jiménez', 'Calle 147 #20-15, Bogotá', '3198899001', 'laura.mendoza@email.com', '1988-08-27', 'F', '4444555566', 'EPS003-66666', 5, '[1, 2, 3]', 2);

-- ===============================================
-- HISTORIAS CLÍNICAS GLOBALES
-- ===============================================

-- Insertar historias clínicas
INSERT INTO historia_clinica (cod_pac, observaciones_generales, peso_kg, altura_cm, alergias_conocidas, antecedentes_familiares, antecedentes_personales, id_dept_origen, departamentos_acceso, confidencial) VALUES
(1, 'Paciente con antecedentes de hipertensión arterial. Controles periódicos en cardiología.', 78.5, 175.0, 'Penicilina', 'Padre con diabetes tipo 2, madre hipertensa', 'Hipertensión arterial diagnosticada en 2020', 2, '[1, 2, 3]', FALSE),

(2, 'Paciente joven, sana, acude por primera vez a farmacia para asesoría anticonceptiva.', 62.0, 165.0, 'Ninguna conocida', 'Sin antecedentes relevantes', 'Sin antecedentes patológicos', 1, '[1, 2]', FALSE),

(3, 'Paciente con antecedentes de infarto agudo de miocardio. Seguimiento cardiológico estricto.', 85.2, 180.0, 'AAS en altas dosis', 'Padre fallecido por IAM a los 55 años', 'IAM en 2021, angioplastia con stent', 2, '[1, 2, 3]', TRUE),

(4, 'Paciente pediátrica con desarrollo normal. Controles de crecimiento y desarrollo.', 25.5, 110.0, 'Ninguna conocida', 'Sin antecedentes familiares relevantes', 'Desarrollo psicomotor normal', 5, '[1, 5]', FALSE),

(5, 'Paciente que ingresó por urgencias con politraumatismo tras accidente de tránsito.', 72.0, 170.0, 'Contraste yodado', 'Sin antecedentes conocidos', 'Trauma craneoencefálico leve en 2019', 3, '[1, 2, 3, 4]', FALSE),

(6, 'Paciente pediátrica con asma bronquial. Requiere seguimiento por pediatría y farmacia.', 30.2, 125.0, 'Polen, ácaros', 'Madre asmática', 'Asma bronquial desde los 6 años', 5, '[1, 5]', FALSE),

(7, 'Paciente con antecedentes de ACV. Seguimiento neurológico y control anticoagulación.', 90.1, 172.0, 'Warfarina (sangrado previo)', 'Hipertensión familiar', 'ACV isquémico 2022, secuelas motoras mínimas', 4, '[1, 2, 4]', TRUE),

(8, 'Paciente con síndrome coronario agudo. Manejo conjunto cardiología-farmacia.', 68.5, 162.0, 'Ninguna conocida', 'Padre con cardiopatía isquémica', 'Dislipidemia, tabaquismo hasta 2023', 2, '[1, 2, 3]', FALSE);

-- ===============================================
-- AUDITORÍA DE ACCESOS INTER-DEPARTAMENTALES
-- ===============================================

-- Insertar registros de acceso entre departamentos
INSERT INTO acceso_historia (cod_hist, id_emp_externo, id_dept_empleado, nombre_empleado, cedula_empleado, tipo_operacion, justificacion_acceso, ip_acceso) VALUES
(1, 101, 1, 'Ana María Farmacéutica', '11111111', 'LECTURA', 'Revisión de medicamentos antihipertensivos para ajuste de dosis', '192.168.1.10'),
(3, 201, 3, 'Carlos Urgenciólogo', '22222222', 'LECTURA', 'Paciente llega a urgencias con dolor torácico, requiere revisar antecedentes cardiológicos', '192.168.1.20'),
(2, 301, 2, 'Luis Cardiólogo', '33333333', 'ESCRITURA', 'Interconsulta solicitada desde farmacia por efectos adversos cardiovasculares', '192.168.1.15'),
(7, 102, 1, 'Beatriz Farmacéutica', '44444444', 'LECTURA', 'Validación de anticoagulante prescrito por neurología', '192.168.1.12'),
(5, 401, 4, 'Diana Neuróloga', '55555555', 'LECTURA', 'Evaluación neurológica post-trauma, revisión de historia desde urgencias', '192.168.1.25'),
(8, 103, 1, 'Roberto Regente', '66666666', 'LECTURA', 'Dispensación de medicamentos post-hospitalización cardiológica', '192.168.1.11');

-- ===============================================
-- PERMISOS INTER-DEPARTAMENTALES
-- ===============================================

-- Insertar permisos entre departamentos
INSERT INTO permisos_inter_departamental (id_emp_externo, id_dept_origen, nombre_empleado, id_dept_destino, tipo_acceso, recursos_permitidos, fecha_fin, justificacion) VALUES
(201, 3, 'Carlos Urgenciólogo', 2, 'LECTURA', '["historia_clinica", "prescripciones"]', '2025-12-31', 'Acceso a historias cardiológicas para manejo de urgencias cardiovasculares'),
(301, 2, 'Luis Cardiólogo', 1, 'ESCRITURA', '["prescripciones", "interconsultas"]', '2025-12-31', 'Prescripción de medicamentos cardiológicos y solicitud de seguimiento farmacéutico'),
(401, 4, 'Diana Neuróloga', 1, 'LECTURA', '["medicamentos", "prescripciones"]', '2025-12-31', 'Consulta de medicamentos neurológicos y validación de interacciones'),
(101, 1, 'Ana María Farmacéutica', 2, 'LECTURA', '["historia_clinica"]', '2025-12-31', 'Revisión de historias cardiológicas para optimización farmacoterapéutica'),
(501, 5, 'Pediatra Principal', 1, 'LECTURA', '["medicamentos", "dosis_pediatricas"]', '2025-12-31', 'Consulta de medicamentos pediátricos y cálculo de dosis'),
(102, 1, 'Beatriz Farmacéutica', 4, 'LECTURA', '["prescripciones_neurologicas"]', '2025-12-31', 'Validación de prescripciones neurológicas complejas');

-- ===============================================
-- LOG DE SINCRONIZACIÓN
-- ===============================================

-- Insertar eventos de sincronización
INSERT INTO log_sincronizacion (id_dept_origen, tabla_origen, registro_id, operacion, datos_json, estado, fecha_procesado) VALUES
(1, 'prescripcion', 1001, 'INSERT', '{"cod_prescripcion": 1001, "cod_hist": 1, "medicamento": "Losartan 50mg"}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
(2, 'cita', 2001, 'UPDATE', '{"id_cita": 2001, "estado": "COMPLETADA", "cod_pac": 1}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
(3, 'historia_acceso', 3001, 'INSERT', '{"acceso_urgencias": "paciente_trauma", "cod_pac": 5}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
(1, 'inventario', 1002, 'UPDATE', '{"cod_med": 150, "stock_anterior": 100, "stock_nuevo": 85}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
(4, 'interconsulta', 4001, 'INSERT', '{"solicitud_farmacia": "revision_anticoagulantes", "cod_pac": 7}', 'PENDIENTE', NULL);

-- ===============================================
-- CONFIGURACIÓN DE REPLICACIÓN
-- ===============================================

-- Insertar configuraciones de replicación
INSERT INTO configuracion_replicacion (id_dept_origen, id_dept_destino, tabla_nombre, tipo_replicacion, frecuencia_minutos, filtros_json, bidireccional) VALUES
(1, NULL, 'medicamento', 'TIEMPO_REAL', 5, '{"stock_critico": true}', FALSE),
(2, 1, 'prescripcion', 'PROGRAMADA', 15, '{"tipo": "cardiologicas"}', TRUE),
(3, 1, 'prescripcion', 'PROGRAMADA', 10, '{"urgente": true}', TRUE),
(4, 1, 'prescripcion', 'PROGRAMADA', 30, '{"tipo": "neurologicas"}', TRUE),
(5, 1, 'prescripcion', 'PROGRAMADA', 60, '{"tipo": "pediatricas"}', TRUE);

-- ===============================================
-- ACTUALIZACIONES DE TIMESTAMP
-- ===============================================

-- Actualizar fechas de última atención de pacientes
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '5 days' WHERE cod_pac = 1;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '2 days' WHERE cod_pac = 2;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '1 day' WHERE cod_pac = 3;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '7 days' WHERE cod_pac = 4;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE WHERE cod_pac = 5;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '10 days' WHERE cod_pac = 6;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '3 days' WHERE cod_pac = 7;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '1 day' WHERE cod_pac = 8;