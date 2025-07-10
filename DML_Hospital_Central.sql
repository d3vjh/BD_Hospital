-- ===============================================
-- DML - HOSPITAL CENTRAL (FARMACIA CENTRALIZADA)
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
('TOMOGRAFO', 'Tomógrafo computarizado', 15, 90),
('RESONANCIA_MAGNETICA', 'Equipo de resonancia magnética', 20, 60),
('ULTRASONIDO', 'Equipo de ultrasonido', 10, 120),
('RAYOS_X', 'Equipo de radiografía', 12, 180),
('MICROSCOPIA', 'Microscopio para laboratorio', 15, 365);

-- Insertar proveedores
INSERT INTO proveedor (nombre_proveedor, telefono_prov, email_prov, direccion_prov) VALUES
('MEDTECH COLOMBIA SAS', '601-555-0101', 'ventas@medtech.co', 'Calle 100 #15-20, Bogotá'),
('EQUIPOS MEDICOS ANDINOS', '602-555-0102', 'comercial@ema.co', 'Carrera 50 #25-10, Medellín'),
('SIEMENS HEALTHINEERS', '601-555-0103', 'info@siemens.co', 'Avenida El Dorado #69-76, Bogotá'),
('PHILIPS HEALTHCARE', '604-555-0104', 'contacto@philips.co', 'Calle 45 #30-15, Medellín'),
('GE HEALTHCARE', '601-555-0105', 'ventas@gehealthcare.co', 'Carrera 15 #85-40, Bogotá');

-- Insertar tipos de cita generales
INSERT INTO tipo_cita_general (nombre_tipo, descripcion_tipo, duracion_sugerida_min, categoria) VALUES
('CONSULTA_GENERAL', 'Consulta médica general', 30, 'GENERAL'),
('CONSULTA_ESPECIALIZADA', 'Consulta con médico especialista', 45, 'ESPECIALIZADA'),
('URGENCIA_NIVEL_1', 'Atención de urgencia crítica', 15, 'URGENCIA'),
('URGENCIA_NIVEL_2', 'Atención de urgencia moderada', 20, 'URGENCIA'),
('CONTROL_POSOPERATORIO', 'Seguimiento postoperatorio', 20, 'CONTROL'),
('EXAMEN_DIAGNOSTICO', 'Procedimientos diagnósticos', 60, 'DIAGNOSTICO'),
('INTERCONSULTA', 'Consulta entre especialidades', 30, 'INTERCONSULTA');

-- ===============================================
-- DEPARTAMENTOS MÉDICOS (SIN FARMACIA)
-- ===============================================

-- Insertar departamentos médicos
INSERT INTO departamento_master (nom_dept, tipo_especialidad, ubicacion, telefono_dept, email_dept, database_name) VALUES
('CARDIOLOGIA', 'MEDICINA_INTERNA_CARDIACA', 'Segundo Piso - Ala Norte', '601-555-0201', 'cardiologia@hospital.com', 'hospital_cardiologia'),
('URGENCIAS', 'MEDICINA_URGENCIAS', 'Primer Piso - Entrada Principal', '601-555-0301', 'urgencias@hospital.com', 'hospital_urgencias'),
('NEUROLOGIA', 'MEDICINA_NEUROLOGICA', 'Tercer Piso - Ala Sur', '601-555-0401', 'neurologia@hospital.com', 'hospital_neurologia'),
('PEDIATRIA', 'MEDICINA_PEDIATRICA', 'Segundo Piso - Ala Sur', '601-555-0501', 'pediatria@hospital.com', 'hospital_pediatria'),
('GINECOLOGIA', 'GINECOLOGIA_OBSTETRICIA', 'Cuarto Piso - Ala Norte', '601-555-0601', 'ginecologia@hospital.com', 'hospital_ginecologia'),
('ORTOPEDIA', 'CIRUGIA_ORTOPEDICA', 'Tercer Piso - Ala Norte', '601-555-0701', 'ortopedia@hospital.com', 'hospital_ortopedia'),
('PSIQUIATRIA', 'SALUD_MENTAL', 'Quinto Piso - Ala Este', '601-555-0801', 'psiquiatria@hospital.com', 'hospital_psiquiatria');

-- ===============================================
-- PACIENTES GLOBALES
-- ===============================================

-- Insertar pacientes
INSERT INTO paciente (nom_pac, apellido_pac, dir_pac, tel_pac, email_pac, fecha_nac, genero, cedula, num_seguro, id_tipo_sangre, departamentos_atencion, id_dept_principal) VALUES
('Juan Carlos', 'Rodríguez Pérez', 'Calle 50 #25-30, Bogotá', '3101234567', 'juan.rodriguez@email.com', '1985-03-15', 'M', '1234567890', 'EPS001-12345', 1, '[1, 2]', 1),
('María Elena', 'García López', 'Carrera 20 #40-15, Bogotá', '3109876543', 'maria.garcia@email.com', '1990-07-22', 'F', '9876543210', 'EPS002-67890', 3, '[5]', 5),
('Carlos Andrés', 'Martínez Silva', 'Avenida 68 #15-45, Bogotá', '3156789012', 'carlos.martinez@email.com', '1978-11-08', 'M', '5555666677', 'EPS003-11111', 2, '[1, 2, 3]', 1),
('Ana Sofía', 'Herrera Díaz', 'Calle 127 #7-89, Bogotá', '3201122334', 'ana.herrera@email.com', '1995-02-14', 'F', '1111222233', 'EPS001-22222', 4, '[4]', 4),
('Luis Fernando', 'Ramírez Castro', 'Carrera 15 #85-20, Bogotá', '3134455667', 'luis.ramirez@email.com', '1982-09-30', 'M', '3333444455', 'EPS004-33333', 1, '[2]', 2),
('Isabella', 'Torres Moreno', 'Calle 72 #11-25, Bogotá', '3187788990', 'isabella.torres@email.com', '2010-05-18', 'F', '7777888899', 'EPS002-44444', 6, '[4]', 4),
('Miguel Ángel', 'Vargas Ruiz', 'Avenida Boyacá #45-67, Bogotá', '3145566778', 'miguel.vargas@email.com', '1973-12-03', 'M', '2222333344', 'EPS005-55555', 7, '[3, 6]', 3),
('Laura Cristina', 'Mendoza Jiménez', 'Calle 147 #20-15, Bogotá', '3198899001', 'laura.mendoza@email.com', '1988-08-27', 'F', '4444555566', 'EPS003-66666', 5, '[1, 2]', 1),
('Roberto Antonio', 'Sánchez Morales', 'Carrera 30 #50-80, Bogotá', '3176677889', 'roberto.sanchez@email.com', '1965-01-20', 'M', '6666777788', 'EPS004-77777', 2, '[6]', 6),
('Carmen Teresa', 'López Vásquez', 'Avenida 19 #120-45, Bogotá', '3189900112', 'carmen.lopez@email.com', '2005-09-30', 'F', '8888999900', 'EPS005-88888', 1, '[4]', 4);

-- ===============================================
-- HISTORIAS CLÍNICAS GLOBALES
-- ===============================================

-- Insertar historias clínicas
INSERT INTO historia_clinica (cod_pac, observaciones_generales, peso_kg, altura_cm, alergias_conocidas, antecedentes_familiares, antecedentes_personales, id_dept_origen, departamentos_acceso, confidencial) VALUES
(1, 'Paciente con antecedentes de hipertensión arterial. Controles periódicos en cardiología.', 78.5, 175.0, 'Penicilina', 'Padre con diabetes tipo 2, madre hipertensa', 'Hipertensión arterial diagnosticada en 2020', 1, '[1, 2]', FALSE),

(2, 'Paciente joven con irregularidades menstruales. Primera consulta ginecológica.', 62.0, 165.0, 'Ninguna conocida', 'Sin antecedentes relevantes', 'Sin antecedentes patológicos', 5, '[5]', FALSE),

(3, 'Paciente con antecedentes de infarto agudo de miocardio. Seguimiento cardiológico estricto.', 85.2, 180.0, 'AAS en altas dosis', 'Padre fallecido por IAM a los 55 años', 'IAM en 2021, angioplastia con stent', 1, '[1, 2, 3]', TRUE),

(4, 'Paciente pediátrica con desarrollo normal. Controles de crecimiento y desarrollo.', 25.5, 110.0, 'Ninguna conocida', 'Sin antecedentes familiares relevantes', 'Desarrollo psicomotor normal', 4, '[4]', FALSE),

(5, 'Paciente que ingresó por urgencias con politraumatismo tras accidente de tránsito.', 72.0, 170.0, 'Contraste yodado', 'Sin antecedentes conocidos', 'Trauma craneoencefálico leve en 2019', 2, '[1, 2, 3]', FALSE),

(6, 'Paciente pediátrica con asma bronquial. Requiere seguimiento por pediatría.', 30.2, 125.0, 'Polen, ácaros', 'Madre asmática', 'Asma bronquial desde los 6 años', 4, '[4]', FALSE),

(7, 'Paciente con antecedentes de ACV. Seguimiento neurológico y anticoagulación.', 90.1, 172.0, 'Warfarina (sangrado previo)', 'Hipertensión familiar', 'ACV isquémico 2022, secuelas motoras mínimas', 3, '[3]', TRUE),

(8, 'Paciente con síndrome coronario agudo. Manejo cardiológico ambulatorio.', 68.5, 162.0, 'Ninguna conocida', 'Padre con cardiopatía isquémica', 'Dislipidemia, tabaquismo hasta 2023', 1, '[1, 2]', FALSE),

(9, 'Paciente con fractura de cadera. Manejo ortopédico y rehabilitación.', 75.0, 168.0, 'AINES', 'Osteoporosis familiar', 'Fractura previa de muñeca', 6, '[6]', FALSE),

(10, 'Paciente pediátrica con trastorno del espectro autista. Seguimiento multidisciplinario.', 28.0, 120.0, 'Ninguna conocida', 'Sin antecedentes relevantes', 'TEA diagnosticado a los 3 años', 4, '[4, 7]', FALSE);

-- ===============================================
-- PERSONAL DE FARMACIA CENTRALIZADA
-- ===============================================

-- Insertar empleados de farmacia
INSERT INTO empleado_farmacia (nom_emp, apellido_emp, cedula, email_emp, telefono_emp, fecha_contratacion, fecha_nacimiento, cargo, numero_licencia, certificaciones) VALUES
('Ana María', 'González Ruiz', '11111111', 'ana.gonzalez@hospital.com', '3101111111', '2020-01-15', '1985-06-20', 'FARMACEUTICO_JEFE', 'QF-2019-001', '["Farmacia Hospitalaria", "Farmacovigilancia", "Gestión Farmacéutica"]'),
('Beatriz Elena', 'Martínez López', '22222222', 'beatriz.martinez@hospital.com', '3102222222', '2021-03-01', '1988-09-12', 'FARMACEUTICO', 'QF-2020-015', '["Farmacia Clínica", "Atención Farmacéutica"]'),
('Roberto Carlos', 'Herrera Silva', '33333333', 'roberto.herrera@hospital.com', '3103333333', '2019-08-20', '1982-02-28', 'REGENTE', 'RF-2018-008', '["Regencia Farmacia", "Buenas Prácticas de Manufactura"]'),
('Carmen Lucía', 'Vargas Torres', '44444444', 'carmen.vargas@hospital.com', '3104444444', '2022-05-10', '1995-11-05', 'AUXILIAR', NULL, '["Auxiliar Farmacia Certificado", "Manejo de Medicamentos"]'),
('Diego Alexander', 'Ramírez Castro', '55555555', 'diego.ramirez@hospital.com', '3105555555', '2020-09-01', '1990-04-15', 'FARMACEUTICO', 'QF-2019-025', '["Farmacia Hospitalaria", "Oncología Farmacéutica"]'),
('Patricia Isabel', 'Moreno Delgado', '66666666', 'patricia.moreno@hospital.com', '3106666666', '2023-02-15', '1992-08-18', 'AUXILIAR', NULL, '["Auxiliar Farmacia", "Dispensación de Medicamentos"]');

-- ===============================================
-- LABORATORIOS FARMACÉUTICOS
-- ===============================================

-- Insertar laboratorios
INSERT INTO laboratorio (nombre_laboratorio, telefono_lab, email_lab, direccion_lab, pais_origen, contacto_comercial, telefono_comercial, certificacion_iso, certificacion_fda, certificacion_invima) VALUES
('LABORATORIOS GENFAR', '601-555-0301', 'comercial@genfar.co', 'Autopista Norte Km 15, Bogotá', 'Colombia', 'Juan Pérez Comercial', '3201111111', TRUE, FALSE, TRUE),
('BAYER COLOMBIA', '601-555-0302', 'ventas@bayer.co', 'Calle 100 #8A-49, Bogotá', 'Alemania', 'María González Sales', '3202222222', TRUE, TRUE, TRUE),
('PFIZER COLOMBIA', '601-555-0303', 'info@pfizer.co', 'Carrera 9 #113-52, Bogotá', 'Estados Unidos', 'Carlos Martínez Rep', '3203333333', TRUE, TRUE, TRUE),
('TECNOQUIMICAS', '601-555-0304', 'comercial@tecnoquimicas.co', 'Km 1 Vía Cali-Yumbo, Valle', 'Colombia', 'Ana López Ventas', '3204444444', TRUE, FALSE, TRUE),
('ABBOTT COLOMBIA', '601-555-0305', 'ventas@abbott.co', 'Avenida El Dorado #69-76, Bogotá', 'Estados Unidos', 'Luis Ramírez Dir', '3205555555', TRUE, TRUE, TRUE),
('NOVARTIS COLOMBIA', '601-555-0306', 'contacto@novartis.co', 'Carrera 15 #93-07, Bogotá', 'Suiza', 'Elena Castro Coord', '3206666666', TRUE, TRUE, TRUE),
('ROCHE COLOMBIA', '601-555-0307', 'info@roche.co', 'Calle 113 #7-45, Bogotá', 'Suiza', 'Fernando Gil Rep', '3207777777', TRUE, TRUE, TRUE);

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
('VITAMINAS', 'Suplementos vitamínicos', 'A11', 'Tracto alimentario y metabolismo', FALSE, FALSE, 0),
('HORMONAS', 'Medicamentos hormonales', 'G03', 'Sistema genitourinario y hormonas sexuales', TRUE, FALSE, 0),
('ANTIPIRETICOS', 'Medicamentos para reducir fiebre', 'N02B', 'Sistema Nervioso - Otros analgésicos', FALSE, FALSE, 0);

-- ===============================================
-- MEDICAMENTOS (INVENTARIO CENTRALIZADO)
-- ===============================================

-- Insertar medicamentos
INSERT INTO medicamento (nom_med, principio_activo, descripcion_med, concentracion, forma_farmaceutica, stock_actual, stock_minimo, stock_maximo, precio_unitario, precio_compra, lote, fecha_vencimiento, fecha_fabricacion, id_laboratorio, id_categoria, registro_sanitario, codigo_barras, codigo_cum) VALUES

-- Antihipertensivos (Cardiología)
('LOSARTAN', 'Losartan Potásico', 'Antihipertensivo inhibidor de receptores de angiotensina II', '50mg', 'Tableta', 150, 20, 300, 850.00, 500.00, 'LOS2024001', '2026-08-15', '2024-02-15', 1, 3, 'INVIMA2020M-001234', '7701234567890', 'CUM001-2024'),
('AMLODIPINO', 'Amlodipino Besilato', 'Bloqueador de canales de calcio', '5mg', 'Tableta', 200, 30, 400, 650.00, 380.00, 'AML2024002', '2026-10-20', '2024-04-20', 2, 3, 'INVIMA2021M-002345', '7701234567891', 'CUM002-2024'),
('ENALAPRIL', 'Enalapril Maleato', 'Inhibidor de la enzima convertidora de angiotensina', '10mg', 'Tableta', 100, 25, 250, 720.00, 420.00, 'ENA2024003', '2025-12-30', '2023-12-30', 1, 3, 'INVIMA2019M-003456', '7701234567892', 'CUM003-2024'),

-- Analgésicos (Múltiples departamentos)
('ACETAMINOFEN', 'Paracetamol', 'Analgésico y antipirético', '500mg', 'Tableta', 500, 50, 800, 320.00, 180.00, 'ACE2024004', '2027-03-15', '2024-09-15', 1, 1, 'INVIMA2020M-004567', '7701234567893', 'CUM004-2024'),
('IBUPROFENO', 'Ibuprofeno', 'Antiinflamatorio no esteroideo', '400mg', 'Tableta', 300, 40, 500, 480.00, 280.00, 'IBU2024005', '2026-07-10', '2024-01-10', 2, 1, 'INVIMA2021M-005678', '7701234567894', 'CUM005-2024'),
('DICLOFENACO', 'Diclofenaco Sódico', 'Antiinflamatorio no esteroideo', '50mg', 'Tableta', 180, 30, 350, 590.00, 340.00, 'DIC2024006', '2026-11-25', '2024-05-25', 3, 1, 'INVIMA2020M-006789', '7701234567895', 'CUM006-2024'),

-- Antibióticos (Múltiples departamentos)
('AMOXICILINA', 'Amoxicilina', 'Antibiótico betalactámico', '500mg', 'Cápsula', 80, 20, 200, 1250.00, 720.00, 'AMO2024007', '2025-09-30', '2023-09-30', 3, 2, 'INVIMA2019M-007890', '7701234567896', 'CUM007-2024'),
('AZITROMICINA', 'Azitromicina', 'Antibiótico macrólido', '500mg', 'Tableta', 60, 15, 150, 2890.00, 1650.00, 'AZI2024008', '2026-04-12', '2024-10-12', 3, 2, 'INVIMA2021M-008901', '7701234567897', 'CUM008-2024'),
('CIPROFLOXACINA', 'Ciprofloxacina', 'Antibiótico quinolona', '500mg', 'Tableta', 40, 10, 120, 3200.00, 1850.00, 'CIP2024009', '2025-11-18', '2023-11-18', 4, 2, 'INVIMA2020M-009012', '7701234567898', 'CUM009-2024'),

-- Anticoagulantes (Neurología/Cardiología)
('WARFARINA', 'Warfarina Sódica', 'Anticoagulante oral', '5mg', 'Tableta', 120, 20, 200, 1850.00, 1100.00, 'WAR2024010', '2027-01-08', '2024-07-08', 2, 4, 'INVIMA2021M-010123', '7701234567899', 'CUM010-2024'),
('RIVAROXABAN', 'Rivaroxaban', 'Anticoagulante oral directo', '20mg', 'Tableta', 50, 10, 100, 12500.00, 8500.00, 'RIV2024011', '2026-06-22', '2024-12-22', 2, 4, 'INVIMA2022M-011234', '7701234567800', 'CUM011-2024'),

-- Broncodilatadores (Pediatría)
('SALBUTAMOL', 'Salbutamol', 'Broncodilatador beta-2 agonista', '100mcg/puff', 'Inhalador', 25, 5, 60, 18500.00, 12000.00, 'SAL2024012', '2026-09-15', '2024-03-15', 4, 5, 'INVIMA2021M-012345', '7701234567801', 'CUM012-2024'),
('BUDESONIDA', 'Budesonida', 'Corticoesteroide inhalado', '200mcg/puff', 'Inhalador', 15, 3, 40, 35000.00, 24000.00, 'BUD2024013', '2025-12-03', '2023-12-03', 5, 5, 'INVIMA2020M-013456', '7701234567802', 'CUM013-2024'),

-- Anticonvulsivantes (Neurología)
('FENITOINA', 'Fenitoína Sódica', 'Anticonvulsivante', '100mg', 'Cápsula', 90, 15, 180, 980.00, 580.00, 'FEN2024014', '2026-05-30', '2024-11-30', 3, 8, 'INVIMA2020M-014567', '7701234567803', 'CUM014-2024'),
('CARBAMAZEPINA', 'Carbamazepina', 'Anticonvulsivante', '200mg', 'Tableta', 75, 20, 150, 1200.00, 750.00, 'CAR2024015', '2026-08-20', '2024-02-20', 1, 8, 'INVIMA2021M-015678', '7701234567804', 'CUM015-2024'),

-- Hormonas (Ginecología)
('ETINILESTRADIOL_LEVONORGESTREL', 'Etinilestradiol + Levonorgestrel', 'Anticonceptivo oral combinado', '0.03mg+0.15mg', 'Tableta', 200, 30, 400, 2500.00, 1500.00, 'ETI2024016', '2026-12-15', '2024-06-15', 2, 11, 'INVIMA2021M-016789', '7701234567805', 'CUM016-2024'),

-- Psicofármacos (Psiquiatría)
('HALOPERIDOL', 'Haloperidol', 'Antipsicótico típico', '5mg', 'Tableta', 60, 10, 120, 1850.00, 1100.00, 'HAL2024017', '2026-03-10', '2024-09-10', 3, 6, 'INVIMA2020M-017890', '7701234567806', 'CUM017-2024'),
('SERTRALINA', 'Sertralina', 'Antidepresivo ISRS', '50mg', 'Tableta', 100, 15, 200, 2200.00, 1300.00, 'SER2024018', '2026-07-25', '2024-01-25', 6, 6, 'INVIMA2021M-018901', '7701234567807', 'CUM018-2024'),

-- Medicamentos de stock crítico y próximos a vencer
('MORFINA', 'Sulfato de Morfina', 'Analgésico opioide', '10mg', 'Ampolla', 8, 10, 50, 8500.00, 5500.00, 'MOR2024019', '2025-08-10', '2023-08-10', 3, 7, 'INVIMA2019M-019012', '7701234567808', 'CUM019-2024'),
('OMEPRAZOL', 'Omeprazol', 'Inhibidor de bomba de protones', '20mg', 'Cápsula', 5, 25, 200, 1250.00, 750.00, 'OME2024020', '2025-08-25', '2023-08-25', 1, 9, 'INVIMA2020M-020123', '7701234567809', 'CUM020-2024');

-- ===============================================
-- PRESCRIPCIONES CENTRALIZADAS
-- ===============================================

-- Insertar prescripciones desde diferentes departamentos
INSERT INTO prescripcion (cod_hist, id_emp_prescriptor, id_dept_prescriptor, nombre_prescriptor, cedula_prescriptor, fecha_prescripcion, observaciones_prescripcion, diagnostico_asociado, estado_prescripcion, fecha_dispensacion, id_farmaceutico_dispensador, nombre_dispensador, validada_farmaceutico, id_farmaceutico_validador, nombre_validador, fecha_validacion, fecha_vencimiento) VALUES

-- Prescripción de Cardiología
(1, 101, 1, 'Dr. Luis Cardiólogo', '30111111', CURRENT_DATE - INTERVAL '2 days', 'Control de hipertensión arterial, ajuste de dosis según respuesta', 'Hipertensión arterial estadio 2', 'DISPENSADA', CURRENT_DATE - INTERVAL '1 day', 1, 'Ana María González', TRUE, 1, 'Ana María González', CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_DATE + INTERVAL '28 days'),

-- Prescripción de Cardiología (Carlos - post-infarto)
(3, 102, 1, 'Dr. Fernando Especialista', '30222222', CURRENT_DATE - INTERVAL '1 day', 'Medicación post-infarto, seguimiento estricto anticoagulación', 'Síndrome coronario agudo post-IAM', 'ACTIVA', NULL, 2, 'Beatriz Elena Martínez', TRUE, 1, 'Ana María González', CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_DATE + INTERVAL '29 days'),

-- Prescripción de Urgencias
(5, 201, 2, 'Dr. Carlos Urgenciólogo', '30333333', CURRENT_DATE, 'Analgesia post-trauma, antiinflamatorio para dolor moderado', 'Politraumatismo, dolor moderado-severo', 'DISPENSADA', CURRENT_DATE, 2, 'Beatriz Elena Martínez', TRUE, 1, 'Ana María González', CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_DATE + INTERVAL '30 days'),

-- Prescripción de Pediatría
(6, 401, 4, 'Dra. Elena Pediatra', '30444444', CURRENT_DATE - INTERVAL '3 days', 'Tratamiento asma bronquial, educar sobre técnica inhalatoria', 'Asma bronquial persistente moderada', 'DISPENSADA', CURRENT_DATE - INTERVAL '2 days', 5, 'Diego Alexander Ramírez', TRUE, 1, 'Ana María González', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_DATE + INTERVAL '27 days'),

-- Prescripción de Neurología
(7, 301, 3, 'Dr. Miguel Neurólogo', '30555555', CURRENT_DATE - INTERVAL '5 days', 'Anticoagulación post-ACV, control estricto INR', 'ACV isquémico, prevención secundaria', 'ACTIVA', NULL, 1, 'Ana María González', TRUE, 1, 'Ana María González', CURRENT_TIMESTAMP - INTERVAL '4 days', CURRENT_DATE + INTERVAL '25 days'),

-- Prescripción de Ginecología
(2, 501, 5, 'Dra. Patricia Ginecóloga', '30666666', CURRENT_DATE - INTERVAL '1 day', 'Anticonceptivo oral, seguimiento a los 3 meses', 'Planificación familiar', 'DISPENSADA', CURRENT_DATE, 3, 'Roberto Carlos Herrera', TRUE, 2, 'Beatriz Elena Martínez', CURRENT_TIMESTAMP - INTERVAL '30 minutes', CURRENT_DATE + INTERVAL '30 days'),

-- Prescripción de Psiquiatría
(10, 701, 7, 'Dr. Andrés Psiquiatra', '30777777', CURRENT_DATE - INTERVAL '7 days', 'Inicio de tratamiento antipsicótico, vigilar efectos adversos', 'Trastorno del espectro autista con agitación', 'ACTIVA', NULL, NULL, NULL, FALSE, NULL, NULL, NULL, CURRENT_DATE + INTERVAL '23 days'),

-- Prescripción de Cardiología (Laura)
(8, 103, 1, 'Dra. Sandra Cardióloga', '30888888', CURRENT_DATE, 'Medicación cardiológica ambulatoria post-hospitalización', 'Síndrome coronario agudo, seguimiento', 'ACTIVA', NULL, NULL, NULL, FALSE, NULL, NULL, NULL, CURRENT_DATE + INTERVAL '30 days'),

-- Prescripción de Ortopedia
(9, 601, 6, 'Dr. Roberto Ortopedista', '30999999', CURRENT_DATE - INTERVAL '4 days', 'Analgesia post-quirúrgica, evitar AINES por edad', 'Fractura de cadera post-quirúrgica', 'DISPENSADA', CURRENT_DATE - INTERVAL '3 days', 4, 'Carmen Lucía Vargas', TRUE, 2, 'Beatriz Elena Martínez', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_DATE + INTERVAL '26 days');

-- ===============================================
-- DETALLES DE PRESCRIPCIÓN
-- ===============================================

-- Insertar detalles de prescripciones
INSERT INTO detalle_prescripcion (cod_prescripcion, cod_med, dosis, frecuencia, duracion_dias, instrucciones_especiales, cantidad_total, cantidad_dispensada, via_administracion, momento_administracion) VALUES

-- Prescripción 1 (Hipertensión - Juan Carlos)
(1, 1, '50mg', 'Una vez al día', 30, 'Tomar en la mañana, controlar presión arterial semanalmente', 30, 30, 'Oral', 'En ayunas'),
(1, 2, '5mg', 'Una vez al día', 30, 'Puede tomarse con alimentos, vigilar edemas', 30, 30, 'Oral', 'En la noche'),

-- Prescripción 2 (Post-infarto - Carlos Andrés)
(2, 3, '10mg', 'Dos veces al día', 30, 'Controlar función renal y potasio cada 15 días', 60, 0, 'Oral', 'Con alimentos'),
(2, 10, '5mg', 'Una vez al día', 30, 'Control estricto de INR, riesgo de sangrado', 30, 0, 'Oral', 'Siempre a la misma hora'),

-- Prescripción 3 (Post-trauma - Luis Fernando)
(3, 4, '500mg', 'Cada 8 horas', 7, 'Máximo 3 gramos al día, vigilar función hepática', 21, 21, 'Oral', 'Con alimentos'),
(3, 5, '400mg', 'Cada 12 horas', 5, 'Tomar con alimentos, vigilar función renal y gástrica', 10, 10, 'Oral', 'Con alimentos'),

-- Prescripción 4 (Asma pediátrica - Isabella)
(4, 13, '200mcg', '2 puff cada 12 horas', 30, 'Enjuagar boca después de usar, técnica correcta de inhalación', 1, 1, 'Inhalatoria', 'Independiente de alimentos'),
(4, 12, '100mcg', '2 puff según necesidad', 30, 'Máximo 8 puff al día, para crisis broncoespásticas', 1, 1, 'Inhalatoria', 'Según necesidad'),

-- Prescripción 5 (Anticoagulación neurológica - Miguel Ángel)
(5, 11, '20mg', 'Una vez al día', 90, 'Control de función renal mensual, evitar AINES', 90, 0, 'Oral', 'Con alimentos'),

-- Prescripción 6 (Anticonceptivo - María Elena)
(6, 16, '1 tableta', 'Una vez al día', 21, 'Tomar siempre a la misma hora, descanso de 7 días', 21, 21, 'Oral', 'Preferiblemente en la noche'),

-- Prescripción 7 (Psiquiatría - Carmen Teresa)
(7, 17, '5mg', 'Una vez al día', 30, 'Iniciar con dosis baja, vigilar síntomas extrapiramidales', 30, 0, 'Oral', 'Con alimentos'),

-- Prescripción 8 (Cardiológica ambulatoria - Laura Cristina)
(8, 1, '50mg', 'Una vez al día', 30, 'Control de presión arterial semanal, seguimiento médico', 30, 0, 'Oral', 'En ayunas'),
(8, 4, '500mg', 'Según necesidad', 10, 'Máximo 3 gramos al día, para dolor torácico leve', 20, 0, 'Oral', 'Con alimentos'),

-- Prescripción 9 (Post-quirúrgica ortopedia - Roberto)
(9, 4, '500mg', 'Cada 6 horas', 7, 'Analgesia post-quirúrgica, vigilar función hepática', 28, 28, 'Oral', 'Con alimentos');

-- ===============================================
-- AUDITORÍA DE ACCESOS INTER-DEPARTAMENTALES
-- ===============================================

-- Insertar registros de acceso entre departamentos
INSERT INTO acceso_historia (cod_hist, id_emp_externo, id_dept_empleado, nombre_empleado, cedula_empleado, tipo_operacion, justificacion_acceso, ip_acceso) VALUES
(1, 201, 2, 'Dr. Carlos Urgenciólogo', '30333333', 'LECTURA', 'Paciente llega a urgencias con dolor torácico, requiere revisar antecedentes cardiológicos', '192.168.1.20'),
(3, 301, 3, 'Dr. Miguel Neurólogo', '30555555', 'LECTURA', 'Interconsulta neurológica por cefalea post-infarto, revisar medicación actual', '192.168.1.25'),
(2, 401, 4, 'Dra. Elena Pediatra', '30444444', 'LECTURA', 'Paciente joven requiere evaluación para medicación anticonceptiva', '192.168.1.30'),
(7, 101, 1, 'Dr. Luis Cardiólogo', '30111111', 'LECTURA', 'Evaluación cardiológica de paciente neurológico con anticoagulación', '192.168.1.15'),
(9, 201, 2, 'Dr. Carlos Urgenciólogo', '30333333', 'LECTURA', 'Paciente con fractura llega a urgencias, revisar alergias medicamentosas', '192.168.1.21'),
(5, 601, 6, 'Dr. Roberto Ortopedista', '30999999', 'LECTURA', 'Paciente politraumatizado requiere evaluación ortopédica', '192.168.1.35');

-- ===============================================
-- AUDITORÍA DE FARMACIA
-- ===============================================

-- Insertar registros de auditoría farmacéutica
INSERT INTO auditoria_farmacia (tabla_afectada, registro_id, operacion, id_empleado_farmacia, nombre_empleado, id_dept_solicitante, datos_anteriores, datos_nuevos, observaciones, ip_acceso) VALUES
('prescripcion', 1, 'DISPENSACION', 1, 'Ana María González', 1, '{"estado": "ACTIVA"}', '{"estado": "DISPENSADA", "fecha_dispensacion": "2025-01-07"}', 'Dispensación completa de antihipertensivos para paciente cardiológico', '192.168.1.50'),
('medicamento', 1, 'AJUSTE_INVENTARIO', 1, 'Ana María González', 1, '{"stock_actual": 180}', '{"stock_actual": 150}', 'Dispensación de 30 tabletas de Losartan', '192.168.1.50'),
('prescripcion', 3, 'DISPENSACION', 2, 'Beatriz Elena Martínez', 2, '{"estado": "ACTIVA"}', '{"estado": "DISPENSADA", "fecha_dispensacion": "2025-01-08"}', 'Dispensación analgésicos para paciente de urgencias', '192.168.1.51'),
('medicamento', 4, 'AJUSTE_INVENTARIO', 2, 'Beatriz Elena Martínez', 2, '{"stock_actual": 521}', '{"stock_actual": 500}', 'Dispensación de 21 tabletas de Acetaminofén', '192.168.1.51'),
('prescripcion', 4, 'DISPENSACION', 5, 'Diego Alexander Ramírez', 4, '{"estado": "ACTIVA"}', '{"estado": "DISPENSADA", "fecha_dispensacion": "2025-01-06"}', 'Dispensación inhaladores para paciente pediátrico', '192.168.1.52'),
('medicamento', 12, 'AJUSTE_INVENTARIO', 5, 'Diego Alexander Ramírez', 4, '{"stock_actual": 26}', '{"stock_actual": 25}', 'Dispensación de 1 inhalador de Salbutamol', '192.168.1.52');

-- ===============================================
-- LOG DE SINCRONIZACIÓN
-- ===============================================

-- Insertar eventos de sincronización
INSERT INTO log_sincronizacion (id_dept_origen, tabla_origen, registro_id, operacion, datos_json, estado, fecha_procesado) VALUES
(1, 'prescripcion', 1, 'UPDATE', '{"cod_prescripcion": 1, "estado": "DISPENSADA", "medicamentos": ["Losartan", "Amlodipino"]}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
(2, 'prescripcion', 3, 'UPDATE', '{"cod_prescripcion": 3, "estado": "DISPENSADA", "paciente": "Luis Fernando"}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
(4, 'prescripcion', 4, 'UPDATE', '{"cod_prescripcion": 4, "estado": "DISPENSADA", "tipo": "pediatrica"}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
(1, 'interconsulta', 1001, 'INSERT', '{"destino": "neurologia", "motivo": "cefalea_post_infarto"}', 'COMPLETADO', CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
(3, 'prescripcion', 5, 'INSERT', '{"cod_prescripcion": 5, "medicamento": "rivaroxaban", "paciente": "Miguel Angel"}', 'PENDIENTE', NULL),
(7, 'prescripcion', 7, 'INSERT', '{"cod_prescripcion": 7, "medicamento": "haloperidol", "paciente": "Carmen Teresa"}', 'PENDIENTE', NULL);

-- ===============================================
-- ACTUALIZAR CANTIDADES PENDIENTES
-- ===============================================

-- Actualizar cantidades pendientes en detalles de prescripción
UPDATE detalle_prescripcion SET cantidad_pendiente = cantidad_total - cantidad_dispensada;

-- ===============================================
-- ACTUALIZAR TIMESTAMPS
-- ===============================================

-- Actualizar fechas de última atención de pacientes
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '5 days' WHERE cod_pac = 1;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '1 day' WHERE cod_pac = 2;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '1 day' WHERE cod_pac = 3;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '3 days' WHERE cod_pac = 4;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE WHERE cod_pac = 5;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '3 days' WHERE cod_pac = 6;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '5 days' WHERE cod_pac = 7;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE WHERE cod_pac = 8;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '4 days' WHERE cod_pac = 9;
UPDATE paciente SET fecha_ultima_atencion = CURRENT_DATE - INTERVAL '7 days' WHERE cod_pac = 10;
