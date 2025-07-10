-- ===============================================
-- DML - HOSPITAL DEPARTAMENTO (CARDIOLOGÍA)
-- Datos de ejemplo para departamento médico
-- ===============================================

-- ===============================================
-- CONFIGURACIÓN DEL DEPARTAMENTO
-- ===============================================

-- Insertar configuración del departamento de cardiología
INSERT INTO departamento (nom_dept, ubicacion, tipo_especialidad, telefono_dept, email_dept, horario_atencion, configuracion_especial, jefe_departamento, capacidad_atencion) VALUES
('CARDIOLOGIA', 'Segundo Piso - Ala Norte', 'MEDICINA_INTERNA_CARDIACA', '601-555-0201', 'cardiologia@hospital.com', 
'{"lunes": "07:00-17:00", "martes": "07:00-17:00", "miercoles": "07:00-17:00", "jueves": "07:00-17:00", "viernes": "07:00-17:00", "sabado": "08:00-12:00", "domingo": "CERRADO"}',
'{"especialidades": ["Cardiologia Intervencionista", "Electrofisiologia", "Ecocardiografia", "Cardiologia Preventiva"], "certificaciones": ["ACC", "ESC"], "equipos_especializados": ["Cateterismo", "Ecocardiografo", "Holter", "Prueba de Esfuerzo"]}',
'Dr. Luis Fernando Cardiólogo Jefe', 60);

-- ===============================================
-- ROLES ESPECÍFICOS DEL DEPARTAMENTO
-- ===============================================

-- Insertar roles específicos de cardiología
INSERT INTO rol_empleado (nombre_rol, descripcion_rol, permisos_sistema, nivel_acceso, puede_prescribir, puede_ver_historias, puede_modificar_historias, puede_agendar_citas, puede_generar_reportes) VALUES
('CARDIOLOGO_JEFE', 'Jefe del Departamento de Cardiología', '{"administracion": true, "supervision": true, "reportes_completos": true}', 4, TRUE, TRUE, TRUE, TRUE, TRUE),
('CARDIOLOGO_ESPECIALISTA', 'Médico Cardiólogo Especialista', '{"atencion_pacientes": true, "prescripciones": true, "interconsultas": true}', 3, TRUE, TRUE, TRUE, FALSE, FALSE),
('CARDIOLOGO_INTERVENCIONISTA', 'Cardiólogo especialista en procedimientos', '{"cateterismo": true, "angioplastia": true, "prescripciones": true}', 3, TRUE, TRUE, TRUE, FALSE, FALSE),
('ENFERMERA_CARDIOLOGIA', 'Enfermera especializada en cardiología', '{"cuidados_pacientes": true, "monitoreo": true, "apoyo_medico": true}', 2, FALSE, TRUE, FALSE, TRUE, FALSE),
('TECNOLOGO_CARDIOLOGIA', 'Tecnólogo en procedimientos cardiológicos', '{"electrocardiograma": true, "ecocardiografia": true, "pruebas_funcionales": true}', 2, FALSE, TRUE, FALSE, TRUE, FALSE),
('AUXILIAR_ENFERMERIA', 'Auxiliar de enfermería en cardiología', '{"cuidados_basicos": true, "toma_signos": true}', 1, FALSE, FALSE, FALSE, TRUE, FALSE),
('SECRETARIA_CARDIOLOGIA', 'Personal administrativo del departamento', '{"agendamiento": true, "archivo": true, "atencion_telefonica": true}', 1, FALSE, FALSE, FALSE, TRUE, FALSE);

-- ===============================================
-- EMPLEADOS DEL DEPARTAMENTO
-- ===============================================

-- Insertar empleados de cardiología
INSERT INTO empleado (nom_emp, apellido_emp, dir_emp, tel_emp, email_emp, fecha_contratacion, fecha_nacimiento, cedula, id_dept, id_rol, numero_licencia, especialidad_medica, universidad_titulo, ano_graduacion, certificaciones, turno_preferido) VALUES
('Luis Fernando', 'Cardiólogo Jefe', 'Calle 85 #15-30, Bogotá', '3101111111', 'luis.cardiologo@hospital.com', '2018-01-15', '1975-03-10', '30111111', 1, 1, 'MP-15789', 'Cardiología Clínica e Intervencionista', 'Universidad Nacional de Colombia', 2005, '["Cardiología Intervencionista", "Fellow AHA", "Certificación ACC"]', 'DIURNO'),

('Fernando José', 'Especialista Coronario', 'Carrera 20 #45-80, Bogotá', '3102222222', 'fernando.especialista@hospital.com', '2019-06-01', '1980-08-22', '30222222', 1, 2, 'MP-18934', 'Cardiología Clínica', 'Universidad del Rosario', 2008, '["Cardiología Clínica", "Ecocardiografía Avanzada"]', 'DIURNO'),

('Sandra Milena', 'Cardióloga Preventiva', 'Avenida 68 #25-40, Bogotá', '3103333333', 'sandra.cardiologa@hospital.com', '2020-02-15', '1985-12-05', '30333333', 1, 2, 'MP-20156', 'Cardiología Preventiva', 'Universidad Javeriana', 2012, '["Cardiología Preventiva", "Rehabilitación Cardíaca"]', 'DIURNO'),

('Miguel Ángel', 'Intervencionista Senior', 'Calle 127 #10-50, Bogotá', '3104444444', 'miguel.intervencionista@hospital.com', '2017-09-10', '1978-06-18', '30444444', 1, 3, 'MP-14567', 'Cardiología Intervencionista', 'Universidad El Bosque', 2006, '["Cardiología Intervencionista", "Implante de Marcapasos", "TAVI"]', 'MIXTO'),

('Patricia Elena', 'Enfermera Especialista', 'Carrera 50 #30-25, Bogotá', '3105555555', 'patricia.enfermera@hospital.com', '2019-03-20', '1988-01-30', '30555555', 1, 4, 'LE-5678', 'Enfermería en Cuidados Críticos Cardiovasculares', 'Universidad Nacional de Colombia', 2014, '["Cuidados Críticos", "Monitoreo Cardiológico", "RCP Avanzado"]', 'DIURNO'),

('Carlos Alberto', 'Tecnólogo Cardiovascular', 'Avenida Boyacá #80-15, Bogotá', '3106666666', 'carlos.tecnologo@hospital.com', '2021-08-05', '1992-11-12', '30666666', 1, 5, 'TL-3456', 'Tecnología en Instrumentación Quirúrgica', 'Fundación Universitaria San Martín', 2018, '["EKG Avanzado", "Ecocardiografía", "Ergometría"]', 'DIURNO'),

('María Fernanda', 'Enfermera Jefe', 'Calle 72 #12-80, Bogotá', '3107777777', 'maria.enfermera@hospital.com', '2016-11-10', '1983-04-25', '30777777', 1, 4, 'LE-2345', 'Enfermería', 'Universidad Nacional de Colombia', 2010, '["Administración en Enfermería", "Cuidados Coronarios", "Docencia"]', 'DIURNO'),

('Ana Lucía', 'Auxiliar de Enfermería', 'Carrera 15 #95-30, Bogotá', '3108888888', 'ana.auxiliar@hospital.com', '2022-01-20', '1995-07-08', '30888888', 1, 6, 'AE-1234', 'Auxiliar de Enfermería', 'SENA', 2020, '["Auxiliar de Enfermería", "Primeros Auxilios"]', 'DIURNO'),

('Roberto Carlos', 'Secretario Médico', 'Avenida 19 #120-45, Bogotá', '3109999999', 'roberto.secretario@hospital.com', '2020-05-15', '1990-09-15', '30999999', 1, 7, NULL, 'Administración en Salud', 'Universidad Minuto de Dios', 2015, '["Administración Hospitalaria", "Sistemas de Información"]', 'DIURNO');

-- ===============================================
-- USUARIOS DEL SISTEMA
-- ===============================================

-- Insertar usuarios del sistema
INSERT INTO usuario_sistema (id_emp, username, password_hash, salt, configuracion_usuario, preferencias_interfaz) VALUES
(1, 'luis.jefe', 'hash_password_jefe_1', 'salt_jefe_1', '{"notificaciones": true, "reportes_automaticos": true}', '{"tema": "profesional", "idioma": "es", "dashboard": "completo"}'),
(2, 'fernando.especialista', 'hash_password_esp_2', 'salt_esp_2', '{"notificaciones": true, "alertas_criticas": true}', '{"tema": "claro", "idioma": "es", "dashboard": "clinico"}'),
(3, 'sandra.preventiva', 'hash_password_prev_3', 'salt_prev_3', '{"notificaciones": true, "seguimientos": true}', '{"tema": "claro", "idioma": "es", "dashboard": "preventivo"}'),
(4, 'miguel.intervencionista', 'hash_password_int_4', 'salt_int_4', '{"notificaciones": true, "procedimientos": true}', '{"tema": "oscuro", "idioma": "es", "dashboard": "procedimientos"}'),
(5, 'patricia.enfermera', 'hash_password_enf_5', 'salt_enf_5', '{"notificaciones": true, "monitores": true}', '{"tema": "claro", "idioma": "es", "dashboard": "enfermeria"}'),
(6, 'carlos.tecnologo', 'hash_password_tec_6', 'salt_tec_6', '{"notificaciones": false, "equipos": true}', '{"tema": "claro", "idioma": "es", "dashboard": "tecnico"}'),
(7, 'maria.enfermera', 'hash_password_enf_7', 'salt_enf_7', '{"notificaciones": true, "supervision": true}', '{"tema": "profesional", "idioma": "es", "dashboard": "supervision"}'),
(8, 'ana.auxiliar', 'hash_password_aux_8', 'salt_aux_8', '{"notificaciones": false, "turnos": true}', '{"tema": "claro", "idioma": "es", "dashboard": "basico"}'),
(9, 'roberto.secretario', 'hash_password_sec_9', 'salt_sec_9', '{"notificaciones": true, "citas": true}', '{"tema": "claro", "idioma": "es", "dashboard": "administrativo"}');

-- ===============================================
-- TIPOS DE CITA ESPECÍFICOS DE CARDIOLOGÍA
-- ===============================================

-- Insertar tipos de cita específicos de cardiología
INSERT INTO tipo_cita (nombre_tipo, duracion_default_min, costo_base, descripcion_tipo, requiere_preparacion, permite_urgencia, requiere_interconsulta, configuracion_especial) VALUES
('CONSULTA_CARDIOLOGIA_GENERAL', 45, 85000.00, 'Consulta cardiológica de primera vez o control', FALSE, TRUE, FALSE, '{"incluye": ["EKG", "Evaluación clínica"], "preparacion": "ayuno no requerido"}'),
('ECOCARDIOGRAMA', 30, 120000.00, 'Ecocardiografía transtorácica', TRUE, FALSE, FALSE, '{"preparacion": "ropa cómoda", "ayuno": false, "medicamentos": "suspender betabloqueadores 24h antes"}'),
('ELECTROCARDIOGRAMA', 15, 25000.00, 'EKG de 12 derivaciones', FALSE, TRUE, FALSE, '{"preparacion": "ninguna especial", "urgente": true}'),
('PRUEBA_ESFUERZO', 60, 180000.00, 'Ergometría o test de esfuerzo', TRUE, FALSE, FALSE, '{"preparacion": "ayuno 4h", "suspension_medicamentos": "beta bloqueadores 48h", "ropa_deportiva": true}'),
('HOLTER_24H', 20, 150000.00, 'Monitoreo Holter de 24 horas', TRUE, FALSE, FALSE, '{"preparacion": "baño previo", "evitar": "resonancia magnética", "actividad_normal": true}'),
('CONSULTA_INTERVENCIONISTA', 60, 120000.00, 'Evaluación pre-procedimiento intervencionista', TRUE, FALSE, TRUE, '{"incluye": ["Evaluación", "Consentimiento"], "laboratorios": "requeridos"}'),
('CONTROL_POSOPERATORIO', 30, 65000.00, 'Control post-procedimiento cardiológico', FALSE, TRUE, FALSE, '{"evaluacion": "herida quirúrgica", "medicamentos": "anticoagulación"}'),
('URGENCIA_CARDIOLOGICA', 20, 95000.00, 'Atención cardiológica urgente', FALSE, TRUE, FALSE, '{"prioridad": "alta", "evaluacion_inmediata": true}');

-- ===============================================
-- CITAS DEL DEPARTAMENTO
-- ===============================================

-- Insertar citas de cardiología (cod_pac referencia a hospital_central.paciente)
INSERT INTO cita (cod_pac, id_emp, id_tipo_cita, id_dept, fecha_cita, hora_inicio, hora_fin, motivo_consulta, sintomas_principales, diagnostico_preliminar, observaciones_cita, requiere_seguimiento, fecha_seguimiento, prioridad, estado_cita) VALUES

-- Citas programadas
(1, 1, 1, 1, CURRENT_DATE + INTERVAL '2 days', '08:00:00', '08:45:00', 'Control de hipertensión arterial y ajuste de medicación', 'Cefalea matutina, mareos ocasionales', 'Hipertensión arterial no controlada', 'Paciente con adherencia irregular al tratamiento. Educación sobre importancia de medicación.', TRUE, CURRENT_DATE + INTERVAL '30 days', 'NORMAL', 'PROGRAMADA'),

(3, 2, 6, 1, CURRENT_DATE + INTERVAL '1 day', '10:00:00', '11:00:00', 'Evaluación pre-angioplastia coronaria', 'Dolor torácico de esfuerzo', 'Enfermedad coronaria severa', 'Paciente candidato a angioplastia. Revisar laboratorios y consentimiento informado.', TRUE, CURRENT_DATE + INTERVAL '7 days', 'ALTA', 'CONFIRMADA'),

(8, 3, 1, 1, CURRENT_DATE + INTERVAL '3 days', '14:30:00', '15:15:00', 'Primera consulta por síndrome coronario agudo', 'Dolor torácico, disnea de esfuerzo', 'Síndrome coronario agudo estabilizado', 'Paciente post-hospitalización. Iniciar rehabilitación cardíaca.', TRUE, CURRENT_DATE + INTERVAL '15 days', 'ALTA', 'PROGRAMADA'),

-- Citas completadas
(1, 2, 2, 1, CURRENT_DATE - INTERVAL '5 days', '09:00:00', '09:30:00', 'Ecocardiograma de control', 'Seguimiento de función ventricular', 'Hipertrofia ventricular izquierda leve', 'Ecocardiograma muestra mejoría. Continuar tratamiento antihipertensivo.', FALSE, NULL, 'NORMAL', 'COMPLETADA'),

(3, 1, 7, 1, CURRENT_DATE - INTERVAL '2 days', '11:00:00', '11:30:00', 'Control post-cateterismo cardíaco', 'Sitio de punción sin complicaciones', 'Post-angioplastia exitosa', 'Evolución satisfactoria. Continuar antiagregación dual.', TRUE, CURRENT_DATE + INTERVAL '30 days', 'NORMAL', 'COMPLETADA'),

-- Citas de urgencia
(1, 4, 8, 1, CURRENT_DATE, '16:30:00', '16:50:00', 'Urgencia por dolor torácico', 'Dolor torácico súbito, disnea', 'Descartar síndrome coronario agudo', 'EKG sin cambios agudos. Enzimas cardíacas normales. Alta con seguimiento.', TRUE, CURRENT_DATE + INTERVAL '3 days', 'URGENTE', 'COMPLETADA'),

-- Procedimientos diagnósticos
(8, 6, 4, 1, CURRENT_DATE + INTERVAL '5 days', '07:30:00', '08:30:00', 'Prueba de esfuerzo', 'Evaluación de capacidad funcional post-infarto', 'Capacidad funcional por determinar', 'Prueba de esfuerzo para estratificación de riesgo cardiovascular.', TRUE, CURRENT_DATE + INTERVAL '10 days', 'NORMAL', 'PROGRAMADA'),

(3, 6, 5, 1, CURRENT_DATE + INTERVAL '4 days', '10:00:00', '10:20:00', 'Instalación Holter 24h', 'Palpitaciones intermitentes', 'Arritmia por documentar', 'Holter para documentar arritmias. Retirar en 24 horas.', TRUE, CURRENT_DATE + INTERVAL '6 days', 'NORMAL', 'CONFIRMADA'),

-- Cita cancelada
(1, 3, 1, 1, CURRENT_DATE - INTERVAL '1 day', '15:00:00', NULL, 'Control cardiológico programado', 'Control de rutina', NULL, 'Paciente canceló por motivos personales. Reagendar.', FALSE, NULL, 'NORMAL', 'CANCELADA');

-- ===============================================
-- INTERCONSULTAS
-- ===============================================

-- Insertar interconsultas a otros departamentos
INSERT INTO interconsulta (cod_pac, id_cita_origen, id_emp_solicitante, id_dept_solicitante, dept_destino_nombre, id_dept_destino, motivo_interconsulta, hallazgos_relevantes, pregunta_especifica, urgente, fecha_solicitud, fecha_respuesta_esperada, estado_interconsulta) VALUES

(3, 2, 2, 1, 'NEUROLOGIA', 3, 'Paciente con antecedente de ACV e IAM. Requiere evaluación neurológica antes de procedimiento intervencionista', 'Paciente con antecedente de ACV isquémico en 2022, actualmente estable. Programado para angioplastia coronaria.', '¿Es seguro suspender anticoagulación para procedimiento? ¿Riesgo tromboembólico?', TRUE, CURRENT_DATE - INTERVAL '1 day', CURRENT_DATE + INTERVAL '1 day', 'PENDIENTE'),

(1, 1, 1, 1, 'PSIQUIATRIA', 7, 'Paciente hipertenso con síntomas de ansiedad que pueden estar afectando control de presión arterial', 'Hipertensión de difícil control, paciente refiere ansiedad y estrés laboral significativo.', '¿Requiere manejo farmacológico de ansiedad? ¿Puede ser causa de hipertensión secundaria?', FALSE, CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE + INTERVAL '7 days', 'PENDIENTE'),

(8, 3, 3, 1, 'MEDICINA_INTERNA', NULL, 'Paciente joven con IAM. Descartar causas secundarias', 'Paciente femenina de 37 años con IAM sin factores de riesgo cardiovascular tradicionales.', '¿Descartar trombofilias, vasculitis, enfermedades autoinmunes?', FALSE, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '5 days', 'EN_PROCESO');

-- ===============================================
-- EQUIPAMIENTO DEL DEPARTAMENTO
-- ===============================================

-- Insertar equipamiento específico de cardiología
INSERT INTO equipamiento (nom_eq, modelo, numero_serie, descripcion_eq, id_dept, id_tipo_equipo, id_proveedor, ubicacion_especifica, responsable_equipo, fecha_adquisicion, costo_adquisicion, garantia_meses, fecha_fin_garantia, proxima_calibracion, configuracion_tecnica) VALUES

('ECOCARDIÓGRAFO PRINCIPAL', 'Philips EPIQ 7C', 'ECO-001-2022', 'Ecocardiógrafo con doppler color y contraste', 1, 8, 4, 'Consultorio 1 - Ecocardiografía', 6, '2022-03-15', 85000000.00, 36, '2025-03-15', '2025-09-15', '{"frecuencias": ["2-5MHz", "1-5MHz"], "modos": ["2D", "M", "Doppler", "Contraste"], "sondas": 4}'),

('ELECTROCARDIÓGRAFO DIGITAL', 'GE MAC 2000', 'EKG-002-2021', 'EKG digital de 12 derivaciones con interpretación automática', 1, 1, 5, 'Sala de Procedimientos', 6, '2021-08-10', 12000000.00, 24, '2023-08-10', '2025-08-10', '{"derivaciones": 12, "interpretacion_automatica": true, "conectividad": "WiFi", "almacenamiento": "cloud"}'),

('MONITOR HOLTER DIGITAL', 'Mortara H12+', 'HOL-003-2023', 'Sistema de monitoreo Holter de 12 canales', 1, 3, 1, 'Área de Monitoreo', 5, '2023-01-20', 18000000.00, 24, '2025-01-20', '2025-07-20', '{"canales": 12, "duracion_maxima": "7_dias", "analisis_automatico": true, "bluetooth": true}'),

('ERGÓMETRO COMPUTARIZADO', 'GE T2100', 'ERG-004-2020', 'Banda sin fin para pruebas de esfuerzo con monitoreo cardíaco', 1, 3, 5, 'Laboratorio de Ergometría', 6, '2020-11-05', 35000000.00, 60, '2025-11-05', '2025-11-05', '{"velocidad_maxima": "25km/h", "inclinacion_maxima": "25%", "protocolos": ["Bruce", "Naughton", "Ramp"], "seguridad": "stop_automatico"}'),

('DESFIBRILADOR BIFÁSICO', 'Philips HeartStart MRx', 'DEF-005-2019', 'Desfibrilador/Monitor con capacidad de marcapaso externo', 1, 2, 4, 'Sala de Urgencias Cardiológicas', 5, '2019-06-30', 28000000.00, 60, '2024-06-30', '2025-06-30', '{"energia_maxima": "200J", "modo_bifasico": true, "marcapaso_externo": true, "monitoreo": "12_derivaciones"}'),

('BOMBA DE INFUSIÓN CARDÍACA', 'B.Braun Perfusor Space', 'BIC-006-2021', 'Bomba de infusión para medicamentos cardiológicos', 1, 4, 2, 'UCI Coronaria', 7, '2021-04-12', 8500000.00, 36, '2024-04-12', '2025-04-12', '{"precision": "0.1ml/h", "alarmas": "multiples", "bateria": "8_horas", "biblioteca_medicamentos": true}');

-- ===============================================
-- MANTENIMIENTO DE EQUIPOS
-- ===============================================

-- Insertar registros de mantenimiento
INSERT INTO mantenimiento_equipo (cod_eq, fecha_mantenimiento, tipo_mantenimiento, descripcion_trabajo, costo_mantenimiento, id_emp_responsable, estado_posterior, observaciones_tecnicas, proxima_revision) VALUES

(1, '2024-11-15', 'PREVENTIVO', 'Calibración de sondas y limpieza profunda del sistema', 2500000.00, 6, 'OPERATIVO', 'Todas las sondas calibradas correctamente. Sistema funcionando óptimamente.', '2025-05-15'),

(2, '2024-10-20', 'CALIBRACION', 'Calibración anual y actualización de software', 800000.00, 6, 'OPERATIVO', 'Calibración exitosa. Software actualizado a versión más reciente.', '2025-10-20'),

(3, '2024-12-01', 'PREVENTIVO', 'Revisión de electrodos y cables, limpieza de sensores', 450000.00, 5, 'OPERATIVO', 'Equipo en excelente estado. Todos los canales funcionando correctamente.', '2025-06-01'),

(4, '2024-09-30', 'CORRECTIVO', 'Reparación de motor de inclinación y recalibración', 3200000.00, 6, 'OPERATIVO', 'Motor reemplazado. Ergómetro funcionando correctamente en todos los protocolos.', '2025-03-30'),

(5, '2024-11-10', 'PREVENTIVO', 'Verificación de energía de descarga y prueba de baterías', 1200000.00, 5, 'OPERATIVO', 'Desfibrilador entrega energía correcta. Baterías en buen estado.', '2025-05-10');

-- ===============================================
-- SOLICITUDES DE PRESCRIPCIÓN A FARMACIA CENTRAL
-- ===============================================

-- Insertar solicitudes de prescripción a farmacia central
INSERT INTO solicitud_prescripcion (cod_pac, cod_hist, id_cita, id_emp_prescriptor, diagnostico, observaciones_medicas, urgente, estado_solicitud, id_prescripcion_central, fecha_respuesta_farmacia, observaciones_farmacia) VALUES

(1, 1, 1, 1, 'Hipertensión arterial no controlada', 'Paciente requiere ajuste de medicación antihipertensiva. Considerar combinación de IECA y calcioantagonista.', FALSE, 'DISPENSADA', 1, CURRENT_TIMESTAMP - INTERVAL '1 day', 'Medicación dispensada según prescripción. Paciente educado sobre adherencia.'),

(3, 3, 2, 2, 'Enfermedad coronaria severa - Pre-angioplastia', 'Paciente requiere medicación pre-procedimiento y antiagregación dual post-intervención.', TRUE, 'PROCESADA', 2, CURRENT_TIMESTAMP - INTERVAL '2 hours', 'Medicación pre-procedimiento lista. Antiagregación dual preparada para post-intervención.'),

(8, 8, 3, 3, 'Síndrome coronario agudo estabilizado', 'Paciente post-hospitalización requiere medicación ambulatoria para prevención secundaria.', FALSE, 'ENVIADA', NULL, NULL, NULL),

(1, 1, 6, 4, 'Síndrome coronario agudo - Urgencia', 'Paciente en urgencias requiere medicación inmediata para manejo de dolor torácico.', TRUE, 'DISPENSADA', NULL, CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'Medicación de urgencia dispensada inmediatamente. Paciente estabilizado.');

-- ===============================================
-- DETALLES DE MEDICAMENTOS SOLICITADOS
-- ===============================================

-- Insertar detalles de medicamentos solicitados a farmacia
INSERT INTO detalle_solicitud_medicamento (id_solicitud, nombre_medicamento, principio_activo, concentracion, forma_farmaceutica, dosis, frecuencia, duracion_dias, cantidad_solicitada, instrucciones_especiales, via_administracion, justificacion_medica) VALUES

-- Solicitud 1: Hipertensión (Juan Carlos)
(1, 'LOSARTAN', 'Losartan Potásico', '50mg', 'Tableta', '50mg', 'Una vez al día', 30, 30, 'Tomar en la mañana, controlar presión arterial', 'Oral', 'IECA para control de hipertensión arterial'),
(1, 'AMLODIPINO', 'Amlodipino Besilato', '5mg', 'Tableta', '5mg', 'Una vez al día', 30, 30, 'Puede tomarse con alimentos', 'Oral', 'Calcioantagonista para sinergia antihipertensiva'),

-- Solicitud 2: Pre-angioplastia (Carlos Andrés)
(2, 'ENALAPRIL', 'Enalapril Maleato', '10mg', 'Tableta', '10mg', 'Dos veces al día', 30, 60, 'Controlar función renal y potasio', 'Oral', 'Cardioprotección post-IAM'),
(2, 'WARFARINA', 'Warfarina Sódica', '5mg', 'Tableta', '5mg', 'Una vez al día', 30, 30, 'Control INR estricto', 'Oral', 'Anticoagulación para prevención tromboembólica'),

-- Solicitud 3: Post-IAM (Laura Cristina)
(3, 'LOSARTAN', 'Losartan Potásico', '50mg', 'Tableta', '50mg', 'Una vez al día', 30, 30, 'Control de presión arterial semanal', 'Oral', 'Cardioprotección post-síndrome coronario'),
(3, 'ACETAMINOFEN', 'Paracetamol', '500mg', 'Tableta', '500mg', 'Según necesidad', 10, 20, 'Máximo 3 gramos al día', 'Oral', 'Analgesia para dolor torácico residual'),

-- Solicitud 4: Urgencia (Juan Carlos)
(4, 'ACETAMINOFEN', 'Paracetamol', '500mg', 'Tableta', '500mg', 'Cada 6 horas', 3, 12, 'Para manejo de dolor inicial', 'Oral', 'Analgesia inicial en urgencias cardiológicas');

-- ===============================================
-- SESIONES DE USUARIO
-- ===============================================

-- Insertar sesiones de usuario
INSERT INTO sesion_usuario (id_usuario, fecha_inicio, fecha_fin, ip_acceso, user_agent, estado_sesion, ubicacion_geografica, dispositivo, acciones_realizadas) VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP - INTERVAL '30 minutes', '192.168.1.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Consultorio Jefe Cardiología', 'PC-CARDIO-JEFE', 15),
(2, CURRENT_TIMESTAMP - INTERVAL '4 hours', CURRENT_TIMESTAMP - INTERVAL '1 hour', '192.168.1.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Consultorio 2 Cardiología', 'PC-CARDIO-02', 8),
(3, CURRENT_TIMESTAMP - INTERVAL '2 hours', NULL, '192.168.1.17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'ACTIVA', 'Consultorio 3 Cardiología', 'PC-CARDIO-03', 5),
(4, CURRENT_TIMESTAMP - INTERVAL '6 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours', '192.168.1.18', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Sala Cateterismo', 'PC-CATETERISMO', 12),
(5, CURRENT_TIMESTAMP - INTERVAL '1 hour', NULL, '192.168.1.19', 'Mozilla/5.0 (Android 12; Mobile)', 'ACTIVA', 'UCI Coronaria', 'TABLET-CARDIO-01', 3),
(6, CURRENT_TIMESTAMP - INTERVAL '5 hours', CURRENT_TIMESTAMP - INTERVAL '1 hour', '192.168.1.20', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Laboratorio Procedimientos', 'PC-LAB-CARDIO', 10),
(9, CURRENT_TIMESTAMP - INTERVAL '8 hours', CURRENT_TIMESTAMP - INTERVAL '10 minutes', '192.168.1.21', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'CERRADA', 'Recepción Cardiología', 'PC-RECEPCION', 25);

-- ===============================================
-- ACTUALIZAR TIMESTAMPS
-- ===============================================

-- Actualizar último acceso de usuarios
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '30 minutes' WHERE id_usuario = 1;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '1 hour' WHERE id_usuario = 2;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '10 minutes' WHERE id_usuario = 3;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '2 hours' WHERE id_usuario = 4;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '5 minutes' WHERE id_usuario = 5;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '1 hour' WHERE id_usuario = 6;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '30 minutes' WHERE id_usuario = 7;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '4 hours' WHERE id_usuario = 8;
UPDATE usuario_sistema SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '10 minutes' WHERE id_usuario = 9;

-- Actualizar última actividad de empleados
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '30 minutes' WHERE id_emp = 1;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '1 hour' WHERE id_emp = 2;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '10 minutes' WHERE id_emp = 3;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '2 hours' WHERE id_emp = 4;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '5 minutes' WHERE id_emp = 5;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '1 hour' WHERE id_emp = 6;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '30 minutes' WHERE id_emp = 7;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '4 hours' WHERE id_emp = 8;
UPDATE empleado SET ultimo_acceso = CURRENT_TIMESTAMP - INTERVAL '10 minutes' WHERE id_emp = 9;