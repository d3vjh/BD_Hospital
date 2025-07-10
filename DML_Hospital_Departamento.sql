-- ===============================================
-- DML - HOSPITAL DEPARTAMENTO (FARMACIA)
-- ===============================================

-- ===============================================
-- CONFIGURACIÓN DEL DEPARTAMENTO
-- ===============================================

-- Insertar configuración del departamento de farmacia
INSERT INTO departamento (nom_dept, ubicacion, tipo_especialidad, telefono_dept, email_dept, horario_atencion, configuracion_especial) VALUES
('FARMACIA', 'Primer Piso - Ala Este', 'FARMACIA_HOSPITALARIA', '601-555-0199', 'farmacia@hospital.com', 
'{"lunes": "07:00-19:00", "martes": "07:00-19:00", "miercoles": "07:00-19:00", "jueves": "07:00-19:00", "viernes": "07:00-19:00", "sabado": "08:00-14:00", "domingo": "08:00-12:00"}',
'{"capacidad_almacenamiento": 10000, "temperatura_promedio": 22.0, "humedad_promedio": 45.0, "alertas_stock_activas": true, "margen_seguridad_dias": 30}');

-- ===============================================
-- ROLES Y EMPLEADOS DEL DEPARTAMENTO
-- ===============================================

-- Insertar roles específicos de farmacia
INSERT INTO rol_empleado (nombre_rol, descripcion_rol, permisos_sistema, nivel_acceso) VALUES
('FARMACEUTICO_JEFE', 'Químico Farmacéutico Jefe del Departamento', '{"puede_dispensar": true, "puede_gestionar_inventario": true, "puede_autorizar_prescripciones": true, "puede_generar_reportes": true}', 4),
('FARMACEUTICO', 'Químico Farmacéutico', '{"puede_dispensar": true, "puede_gestionar_inventario": true, "puede_autorizar_prescripciones": true, "puede_generar_reportes": false}', 3),
('AUXILIAR_FARMACIA', 'Auxiliar de Farmacia', '{"puede_dispensar": true, "puede_gestionar_inventario": false, "puede_autorizar_prescripciones": false, "puede_generar_reportes": false}', 2),
('REGENTE_FARMACIA', 'Regente de Farmacia', '{"puede_dispensar": true, "puede_gestionar_inventario": true, "puede_autorizar_prescripciones": false, "puede_generar_reportes": true}', 3),
('ADMINISTRATIVO_FARMACIA', 'Personal Administrativo de Farmacia', '{"puede_dispensar": false, "puede_gestionar_inventario": false, "puede_autorizar_prescripciones": false, "puede_generar_reportes": true}', 1);

-- Insertar empleados de farmacia
INSERT INTO empleado (nom_emp, apellido_emp, dir_emp, tel_emp, email_emp, fecha_contratacion, fecha_nacimiento, cedula, id_dept, id_rol, numero_licencia, certificaciones) VALUES
('Ana María', 'González Ruiz', 'Calle 80 #12-45, Bogotá', '3101111111', 'ana.gonzalez@hospital.com', '2020-01-15', '1985-06-20', '11111111', 1, 1, 'QF-2019-001', '["Farmacia Hospitalaria", "Farmacovigilancia"]'),
('Beatriz Elena', 'Martínez López', 'Carrera 25 #30-15, Bogotá', '3102222222', 'beatriz.martinez@hospital.com', '2021-03-01', '1988-09-12', '22222222', 1, 2, 'QF-2020-015', '["Farmacia Clínica"]'),
('Roberto Carlos', 'Herrera Silva', 'Avenida 45 #20-30, Bogotá', '3103333333', 'roberto.herrera@hospital.com', '2019-08-20', '1982-02-28', '33333333', 1, 4, 'RF-2018-008', '["Regencia Farmacia", "Buenas Prácticas"]'),
('Carmen Lucía', 'Vargas Torres', 'Calle 127 #15-60, Bogotá', '3104444444', 'carmen.vargas@hospital.com', '2022-05-10', '1995-11-05', '44444444', 1, 3, NULL, '["Auxiliar Farmacia Certificado"]'),
('Diego Alexander', 'Ramírez Castro', 'Carrera 50 #85-20, Bogotá', '3105555555', 'diego.ramirez@hospital.com', '2020-09-01', '1990-04-15', '55555555', 1, 5, NULL, '["Administración Hospitalaria"]');

-- ===============================================
-- USUARIOS DEL SISTEMA
-- ===============================================

-- Insertar usuarios del sistema (passwords son ejemplos - en producción usar hashing real)
INSERT INTO usuario_sistema (id_emp, username, password_hash, salt, configuracion_usuario) VALUES
(1, 'ana.gonzalez', 'hash_password_1', 'salt_1', '{"tema_interfaz": "CLARO", "idioma": "es", "notificaciones": true}'),
(2, 'beatriz.martinez', 'hash_password_2', 'salt_2', '{"tema_interfaz": "OSCURO", "idioma": "es", "notificaciones": true}'),
(3, 'roberto.herrera', 'hash_password_3', 'salt_3', '{"tema_interfaz": "CLARO", "idioma": "es", "notificaciones": false}'),
(4, 'carmen.vargas', 'hash_password_4', 'salt_4', '{"tema_interfaz": "CLARO", "idioma": "es", "notificaciones": true}'),
(5, 'diego.ramirez', 'hash_password_5', 'salt_5', '{"tema_interfaz": "OSCURO", "idioma": "es", "notificaciones": true}');

-- ===============================================
-- TIPOS DE CITA ESPECÍFICOS DE FARMACIA
-- ===============================================

-- Insertar tipos de cita específicos de farmacia
INSERT INTO tipo_cita (nombre_tipo, duracion_default_min, costo_base, descripcion_tipo, configuracion_especial) VALUES
('DISPENSACION_MEDICAMENTOS', 15, 0.00, 'Entrega de medicamentos con prescripción médica', '{"requiere_prescripcion": true, "tipo_consulta": "DISPENSACION", "permite_urgencia": true}'),
('CONSULTA_FARMACEUTICA', 30, 25000.00, 'Asesoría farmacológica especializada', '{"requiere_prescripcion": false, "tipo_consulta": "CONSULTA_FARMACEUTICA", "permite_urgencia": false}'),
('SEGUIMIENTO_FARMACOTERAPEUTICO', 45, 35000.00, 'Seguimiento de tratamientos farmacológicos', '{"requiere_prescripcion": false, "tipo_consulta": "SEGUIMIENTO", "permite_urgencia": false}'),
('URGENCIA_FARMACIA', 10, 0.00, 'Atención farmacéutica de urgencia', '{"requiere_prescripcion": false, "tipo_consulta": "DISPENSACION", "permite_urgencia": true}'),
('VALIDACION_PRESCRIPCION', 20, 15000.00, 'Validación y reconciliación de prescripciones', '{"requiere_prescripcion": true, "tipo_consulta": "VALIDACION", "permite_urgencia": false}');

-- ===============================================
-- CITAS DE FARMACIA
-- ===============================================

-- Insertar citas programadas en farmacia (cod_pac referencia a hospital_central.paciente)
INSERT INTO cita (cod_pac, id_emp, id_tipo_cita, id_dept, fecha_cita, hora_inicio, motivo_consulta, observaciones_cita, estado_cita) VALUES
(1, 1, 1, 1, CURRENT_DATE + INTERVAL '1 day', '09:00:00', 'Dispensación de antihipertensivos', 'Paciente requiere ajuste de Losartan', 'PROGRAMADA'),
(2, 2, 2, 1, CURRENT_DATE + INTERVAL '2 days', '10:30:00', 'Asesoría anticonceptiva', 'Primera consulta farmacéutica', 'PROGRAMADA'),
(3, 1, 5, 1, CURRENT_DATE, '14:00:00', 'Validación prescripción cardiológica', 'Prescripción post-hospitalización', 'COMPLETADA'),
(4, 3, 1, 1, CURRENT_DATE + INTERVAL '3 days', '11:00:00', 'Dispensación medicamentos pediátricos', 'Medicamentos para asma bronquial', 'CONFIRMADA'),
(5, 2, 4, 1, CURRENT_DATE, '16:30:00', 'Urgencia - Analgésicos post-trauma', 'Paciente politraumatizado requiere analgesia', 'COMPLETADA'),
(7, 1, 3, 1, CURRENT_DATE + INTERVAL '5 days', '15:00:00', 'Seguimiento anticoagulación', 'Control de warfarina por neurología', 'PROGRAMADA'),
(8, 2, 1, 1, CURRENT_DATE + INTERVAL '1 day', '16:00:00', 'Dispensación medicamentos cardiológicos', 'Medicamentos post-síndrome coronario', 'PROGRAMADA');

-- ===============================================
-- LABORATORIOS FARMACÉUTICOS
-- ===============================================

-- Insertar laboratorios
INSERT INTO laboratorio (nombre_laboratorio, telefono_lab, email_lab, direccion_lab, pais_origen, contacto_comercial, telefono_comercial, certificacion_iso, certificacion_fda, certificacion_invima) VALUES
('LABORATORIOS GENFAR', '601-555-0301', 'comercial@genfar.co', 'Autopista Norte Km 15, Bogotá', 'Colombia', 'Juan Pérez', '3201111111', TRUE, FALSE, TRUE),
('BAYER COLOMBIA', '601-555-0302', 'ventas@bayer.co', 'Calle 100 #8A-49, Bogotá', 'Alemania', 'María González', '3202222222', TRUE, TRUE, TRUE),
('PFIZER COLOMBIA', '601-555-0303', 'info@pfizer.co', 'Carrera 9 #113-52, Bogotá', 'Estados Unidos', 'Carlos Martínez', '3203333333', TRUE, TRUE, TRUE),
('TECNOQUIMICAS', '601-555-0304', 'comercial@tecnoquimicas.co', 'Km 1 Vía Cali-Yumbo, Valle', 'Colombia', 'Ana López', '3204444444', TRUE, FALSE, TRUE),
('ABBOTT COLOMBIA', '601-555-0305', 'ventas@abbott.co', 'Avenida El Dorado #69-76, Bogotá', 'Estados Unidos', 'Luis Ramírez', '3205555555', TRUE, TRUE, TRUE);

-- ===============================================
-- CATEGORÍAS DE MEDICAMENTOS
-- ===============================================

-- Insertar categorías de medicamentos
INSERT INTO categoria_medicamento (nombre_categoria, descripcion_categoria, codigo_atc, grupo_terapeutico, requiere_receta, medicamento_controlado, nivel_control) VALUES
('ANALGESICOS', 'Medicamentos para el alivio del dolor', 'N02', 'Sistema Nervioso - Analgésicos', TRUE, FALSE, 0),
('ANTIBIOTICOS', 'Medicamentos antimicrobianos', 'J01', 'Antiinfecciosos para uso sistémico', TRUE, FALSE, 0),
('ANTIHIPERTENSIVOS', 'Medicamentos para control de presión arterial', 'C09', 'Sistema Cardiovascular', TRUE, FALSE, 0),
('ANTICOAGULANTES', 'Medicamentos para prevenir coagulación', 'B01', 'Sangre y órganos hematopoyéticos', TRUE, FALSE, 0),
('BRONCODILATADORES', 'Medicamentos para asma y EPOC', 'R03', 'Sistema Respiratorio', TRUE, FALSE, 0),
('PSICOFARMACOS', 'Medicamentos para trastornos mentales', 'N05', 'Sistema Nervioso - Psicolépticos', TRUE, TRUE, 2),
('NARCOTICOS', 'Medicamentos opioides controlados', 'N02A', 'Sistema Nervioso - Opioides', TRUE, TRUE, 4),
('ANTICONVULSIVANTES', 'Medicamentos para epilepsia', 'N03', 'Sistema Nervioso - Antiepilépticos', TRUE, FALSE, 0),
('ANTIACIDOS', 'Medicamentos para acidez estomacal', 'A02', 'Tracto alimentario y metabolismo', FALSE, FALSE, 0),
('VITAMINAS', 'Suplementos vitamínicos', 'A11', 'Tracto alimentario y metabolismo', FALSE, FALSE, 0);

-- ===============================================
-- MEDICAMENTOS
-- ===============================================

-- Insertar medicamentos
INSERT INTO medicamento (nom_med, principio_activo, descripcion_med, concentracion, forma_farmaceutica, stock_actual, stock_minimo, stock_maximo, precio_unitario, precio_compra, lote, fecha_vencimiento, fecha_fabricacion, id_laboratorio, id_categoria, registro_sanitario, codigo_barras, codigo_cum) VALUES

-- Antihipertensivos
('LOSARTAN', 'Losartan Potásico', 'Antihipertensivo inhibidor de receptores de angiotensina II', '50mg', 'Tableta', 150, 20, 300, 850.00, 500.00, 'LOS2024001', '2026-08-15', '2024-02-15', 1, 3, 'INVIMA2020M-001234', '7701234567890', 'CUM001-2024'),

('AMLODIPINO', 'Amlodipino Besilato', 'Bloqueador de canales de calcio', '5mg', 'Tableta', 200, 30, 400, 650.00, 380.00, 'AML2024002', '2026-10-20', '2024-04-20', 2, 3, 'INVIMA2021M-002345', '7701234567891', 'CUM002-2024'),

('ENALAPRIL', 'Enalapril Maleato', 'Inhibidor de la enzima convertidora de angiotensina', '10mg', 'Tableta', 100, 25, 250, 720.00, 420.00, 'ENA2024003', '2025-12-30', '2023-12-30', 1, 3, 'INVIMA2019M-003456', '7701234567892', 'CUM003-2024'),

-- Analgésicos
('ACETAMINOFEN', 'Paracetamol', 'Analgésico y antipirético', '500mg', 'Tableta', 500, 50, 800, 320.00, 180.00, 'ACE2024004', '2027-03-15', '2024-09-15', 1, 1, 'INVIMA2020M-004567', '7701234567893', 'CUM004-2024'),

('IBUPROFENO', 'Ibuprofeno', 'Antiinflamatorio no esteroideo', '400mg', 'Tableta', 300, 40, 500, 480.00, 280.00, 'IBU2024005', '2026-07-10', '2024-01-10', 2, 1, 'INVIMA2021M-005678', '7701234567894', 'CUM005-2024'),

('DICLOFENACO', 'Diclofenaco Sódico', 'Antiinflamatorio no esteroideo', '50mg', 'Tableta', 180, 30, 350, 590.00, 340.00, 'DIC2024006', '2026-11-25', '2024-05-25', 3, 1, 'INVIMA2020M-006789', '7701234567895', 'CUM006-2024'),

-- Antibióticos
('AMOXICILINA', 'Amoxicilina', 'Antibiótico betalactámico', '500mg', 'Cápsula', 80, 20, 200, 1250.00, 720.00, 'AMO2024007', '2025-09-30', '2023-09-30', 3, 2, 'INVIMA2019M-007890', '7701234567896', 'CUM007-2024'),

('AZITROMICINA', 'Azitromicina', 'Antibiótico macrólido', '500mg', 'Tableta', 60, 15, 150, 2890.00, 1650.00, 'AZI2024008', '2026-04-12', '2024-10-12', 3, 2, 'INVIMA2021M-008901', '7701234567897', 'CUM008-2024'),

('CIPROFLOXACINA', 'Ciprofloxacina', 'Antibiótico quinolona', '500mg', 'Tableta', 40, 10, 120, 3200.00, 1850.00, 'CIP2024009', '2025-11-18', '2023-11-18', 4, 2, 'INVIMA2020M-009012', '7701234567898', 'CUM009-2024'),

-- Anticoagulantes
('WARFARINA', 'Warfarina Sódica', 'Anticoagulante oral', '5mg', 'Tableta', 120, 20, 200, 1850.00, 1100.00, 'WAR2024010', '2027-01-08', '2024-07-08', 2, 4, 'INVIMA2021M-010123', '7701234567899', 'CUM010-2024'),

('RIVAROXABAN', 'Rivaroxaban', 'Anticoagulante oral directo', '20mg', 'Tableta', 50, 10, 100, 12500.00, 8500.00, 'RIV2024011', '2026-06-22', '2024-12-22', 2, 4, 'INVIMA2022M-011234', '7701234567800', 'CUM011-2024'),

-- Broncodilatadores
('SALBUTAMOL', 'Salbutamol', 'Broncodilatador beta-2 agonista', '100mcg/puff', 'Inhalador', 25, 5, 60, 18500.00, 12000.00, 'SAL2024012', '2026-09-15', '2024-03-15', 4, 5, 'INVIMA2021M-012345', '7701234567801', 'CUM012-2024'),

('BUDESONIDA', 'Budesonida', 'Corticoesteroide inhalado', '200mcg/puff', 'Inhalador', 15, 3, 40, 35000.00, 24000.00, 'BUD2024013', '2025-12-03', '2023-12-03', 5, 5, 'INVIMA2020M-013456', '7701234567802', 'CUM013-2024'),

-- Medicamentos de stock crítico y próximos a vencer
('MORFINA', 'Sulfato de Morfina', 'Analgésico opioide', '10mg', 'Ampolla', 8, 10, 50, 8500.00, 5500.00, 'MOR2024014', '2025-08-10', '2023-08-10', 3, 7, 'INVIMA2019M-014567', '7701234567803', 'CUM014-2024'),

('OMEPRAZOL', 'Omeprazol', 'Inhibidor de bomba de protones', '20mg', 'Cápsula', 5, 25, 200, 1250.00, 750.00, 'OME2024015', '2025-08-25', '2023-08-25', 1, 9, 'INVIMA2020M-015678', '7701234567804', 'CUM015-2024');

-- ===============================================
-- EQUIPAMIENTO DE FARMACIA
-- ===============================================

-- Insertar equipamiento específico de farmacia
INSERT INTO equipamiento (nom_eq, modelo, numero_serie, descripcion_eq, id_dept, id_tipo_equipo, id_proveedor, ubicacion_especifica, fecha_adquisicion, costo_adquisicion, garantia_meses, fecha_fin_garantia, proxima_calibracion, configuracion_tecnica) VALUES

('REFRIGERADOR FARMACIA PRINCIPAL', 'PharmaCool-500', 'REF-001-2023', 'Refrigerador especializado para medicamentos termolábiles', 1, 6, 3, 'Área de Almacenamiento - Sección A', '2023-01-15', 8500000.00, 24, '2025-01-15', '2025-08-15', '{"temperatura_min": 2, "temperatura_max": 8, "alarma_temperatura": true}'),

('BALANZA PRECISION MAGISTRAL', 'PharmaScale-200', 'BAL-002-2022', 'Balanza analítica para preparaciones magistrales', 1, 7, 1, 'Laboratorio Magistral', '2022-06-10', 3200000.00, 36, '2025-06-10', '2025-09-10', '{"precision": "0.1mg", "capacidad_maxima": "200g"}'),

('REFRIGERADOR BACKUP', 'MediFridge-300', 'REF-003-2024', 'Refrigerador de respaldo para emergencias', 1, 6, 3, 'Área de Almacenamiento - Sección B', '2024-03-20', 6800000.00, 24, '2026-03-20', '2025-09-20', '{"temperatura_min": 2, "temperatura_max": 8, "alarma_temperatura": true}'),

('AUTOCLAVE ESTERILIZACION', 'SterilMax-150', 'AUT-004-2021', 'Autoclave para esterilización de material', 1, 8, 2, 'Área de Preparaciones', '2021-09-05', 12500000.00, 60, '2026-09-05', '2025-12-05', '{"temperatura_esterilizacion": 121, "presion_vapor": "15psi", "ciclo_estandar": "15min"}');

-- ===============================================
-- MANTENIMIENTO DE EQUIPOS
-- ===============================================

-- Insertar registros de mantenimiento
INSERT INTO mantenimiento_equipo (cod_eq, fecha_mantenimiento, tipo_mantenimiento, descripcion_trabajo, costo_mantenimiento, id_emp_responsable, estado_posterior, observaciones_tecnicas, proxima_revision) VALUES

(1, '2024-11-15', 'PREVENTIVO', 'Calibración de temperatura y limpieza de condensador', 450000.00, 3, 'OPERATIVO', 'Equipo en excelente estado, temperatura estable entre 2-8°C', '2025-02-15'),

(2, '2024-10-20', 'CALIBRACION', 'Calibración con pesas patrón certificadas', 280000.00, 1, 'OPERATIVO', 'Calibración exitosa, precisión dentro de especificaciones', '2025-01-20'),

(3, '2024-12-01', 'PREVENTIVO', 'Revisión general y calibración de sensores', 380000.00, 3, 'OPERATIVO', 'Equipo funcionando correctamente, alarmas operativas', '2025-03-01'),

(4, '2024-09-30', 'CORRECTIVO', 'Reparación de válvula de vapor y recalibración', 850000.00, 3, 'OPERATIVO', 'Válvula reemplazada, equipo esterilizando correctamente', '2025-03-30');

-- ===============================================
-- PRESCRIPCIONES
-- ===============================================

-- Insertar prescripciones (cod_hist referencia a hospital_central.historia_clinica)
INSERT INTO prescripcion (cod_hist, id_emp_prescriptor, id_dept_prescriptor, fecha_prescripcion, observaciones_prescripcion, diagnostico_asociado, estado_prescripcion, fecha_dispensacion, id_emp_dispensador, validada_farmaceutico, id_emp_validador, fecha_validacion, fecha_vencimiento) VALUES

(1, 301, 2, CURRENT_DATE - INTERVAL '2 days', 'Control de hipertensión arterial', 'Hipertensión arterial estadio 2', 'DISPENSADA', CURRENT_DATE - INTERVAL '1 day', 1, TRUE, 1, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_DATE + INTERVAL '28 days'),

(3, 301, 2, CURRENT_DATE - INTERVAL '1 day', 'Medicación post-infarto, anticoagulación', 'Síndrome coronario agudo post-IAM', 'ACTIVA', NULL, 2, TRUE, 1, CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_DATE + INTERVAL '29 days'),

(5, 201, 3, CURRENT_DATE, 'Analgesia post-trauma, antiinflamatorio', 'Politraumatismo, dolor moderado-severo', 'DISPENSADA', CURRENT_DATE, 2, TRUE, 1, CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_DATE + INTERVAL '30 days'),

(6, 501, 5, CURRENT_DATE - INTERVAL '3 days', 'Tratamiento asma bronquial pediátrica', 'Asma bronquial persistente moderada', 'DISPENSADA', CURRENT_DATE - INTERVAL '2 days', 3, TRUE, 1, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_DATE + INTERVAL '27 days'),

(7, 401, 4, CURRENT_DATE - INTERVAL '5 days', 'Anticoagulación post-ACV', 'ACV isquémico, prevención secundaria', 'ACTIVA', NULL, 1, TRUE, 1, CURRENT_TIMESTAMP - INTERVAL '4 days', CURRENT_DATE + INTERVAL '25 days'),

(8, 301, 2, CURRENT_DATE, 'Medicación cardiológica ambulatoria', 'Síndrome coronario agudo, seguimiento', 'ACTIVA', NULL, NULL, FALSE, NULL, NULL, CURRENT_DATE + INTERVAL '30 days');

-- ===============================================
-- DETALLES DE PRESCRIPCIÓN
-- ===============================================

-- Insertar detalles de prescripciones
INSERT INTO detalle_prescripcion (cod_prescripcion, cod_med, dosis, frecuencia, duracion_dias, instrucciones_especiales, cantidad_total, cantidad_dispensada, via_administracion, momento_administracion) VALUES

-- Prescripción 1 (Hipertensión - Juan Carlos)
(1, 1, '50mg', 'Una vez al día', 30, 'Tomar en la mañana, controlar presión arterial', 30, 30, 'Oral', 'En ayunas'),
(1, 2, '5mg', 'Una vez al día', 30, 'Puede tomarse con alimentos', 30, 30, 'Oral', 'En la noche'),

-- Prescripción 2 (Post-infarto - Carlos Andrés)
(2, 3, '10mg', 'Dos veces al día', 30, 'Controlar función renal y potasio', 60, 0, 'Oral', 'Con alimentos'),
(2, 10, '5mg', 'Una vez al día', 30, 'Control estricto de INR, riesgo de sangrado', 30, 0, 'Oral', 'Siempre a la misma hora'),

-- Prescripción 3 (Post-trauma - Luis Fernando)
(3, 4, '500mg', 'Cada 8 horas', 7, 'Máximo 3 gramos al día', 21, 21, 'Oral', 'Con alimentos'),
(3, 5, '400mg', 'Cada 12 horas', 5, 'Tomar con alimentos, vigilar función renal', 10, 10, 'Oral', 'Con alimentos'),

-- Prescripción 4 (Asma pediátrica - Isabella)
(4, 12, '200mcg', '2 puff cada 12 horas', 30, 'Enjuagar boca después de usar, técnica de inhalación', 1, 1, 'Inhalatoria', 'Independiente de alimentos'),
(4, 11, '100mcg', '2 puff según necesidad', 30, 'Máximo 8 puff al día, para crisis broncoespásticas', 1, 1, 'Inhalatoria', 'Según necesidad'),

-- Prescripción 5 (Anticoagulación neurológica - Miguel Ángel)
(5, 11, '20mg', 'Una vez al día', 90, 'Control de función renal, evitar AINES', 90, 0, 'Oral', 'Con alimentos'),

-- Prescripción 6 (Cardiológica ambulatoria - Laura Cristina)
(6, 1, '50mg', 'Una vez al día', 30, 'Control de presión arterial semanal', 30, 0, 'Oral', 'En ayunas'),
(6, 4, '500mg', 'Según necesidad', 10, 'Máximo 3 gramos al día, para dolor torácico leve', 20, 0, 'Oral', 'Con alimentos');

-- ===============================================
-- SESIONES DE USUARIO
-- ===============================================

-- Insertar algunas sesiones de usuario
INSERT INTO sesion_usuario (id_usuario, fecha_inicio, fecha_fin, ip_acceso, user_agent, estado_sesion, ubicacion_geografica, dispositivo) VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '30 minutes', '192.168.1.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Farmacia - Estación 1', 'PC-FARMACIA-01'),
(2, CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP - INTERVAL '1 hour', '192.168.1.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Farmacia - Estación 2', 'PC-FARMACIA-02'),
(3, CURRENT_TIMESTAMP - INTERVAL '1 hour', NULL, '192.168.1.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'ACTIVA', 'Farmacia - Estación 3', 'PC-FARMACIA-03'),
(1, CURRENT_TIMESTAMP - INTERVAL '30 minutes', NULL, '192.168.1.13', 'Mozilla/5.0 (Android 12; Mobile)', 'ACTIVA', 'Farmacia - Móvil', 'TABLET-FARMACIA-01');

-- ===============================================
-- ACTUALIZAR CANTIDADES PENDIENTES
-- ===============================================

-- Actualizar cantidades pendientes en detalles de prescripción
UPDATE detalle_prescripcion SET cantidad_pendiente = cantidad_total - cantidad_dispensada;

-- ===============================================
-- ACTUALIZAR TIMESTAMPS
-- ===============================================

-- Actualizar último acceso de usuarios
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '30 minutes' WHERE id_usuario = 1;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '1 hour' WHERE id_usuario = 2;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '2 hours' WHERE id_usuario = 3;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '3 hours' WHERE id_usuario = 4;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '4 hours' WHERE id_usuario = 5;