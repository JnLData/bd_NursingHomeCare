-- =========================================================================================
-- PROYECTO: NURSING HOMECARE - POBLADO DE DATOS (DML - INSERT)
-- FASE 1: TABLAS MAESTRAS
-- =========================================================================================

-- 1. Dim_Pacientes
INSERT INTO Dim_Pacientes (Num_Doc_Paciente, Nombre_Completo, Fec_Nacimiento, Direccion_Atencion, Alergias_Base)
VALUES 
('08123456', 'María Rosa Pérez Gonzales', '1945-05-12', 'Av. Larco 123, Miraflores', 'Penicilina'),
('09234567', 'José Luis Torres Vargas', '1950-08-22', 'Calle Los Pinos 456, Surco', NULL),
('10345678', 'Carmen Julia López Neyra', '1938-11-05', 'Av. Arequipa 789, Lince', 'Polvo, Ácaros'),
('11456789', 'Héctor Manuel Ruiz Díaz', '1942-02-14', 'Jirón de la Unión 101, Lima', 'Ibuprofeno'),
('12567890', 'Teresa Amanda Castro Silva', '1955-09-30', 'Av. Javier Prado 202, San Borja', NULL);
GO

-- 2. Dim_Responsables
INSERT INTO Dim_Responsables (Num_Doc_Responsable, Nombre_Completo, Celular_WhatsApp, Email_Contacto)
VALUES 
('40123456', 'Carlos Pérez Pérez', '987654321', 'cperez@gmail.com'),
('41234567', 'Ana Torres Vargas', '987654322', 'atorres@hotmail.com'),
('42345678', 'Luis López Neyra', '987654323', 'llopez@empresa.pe'),
('43456789', 'Marta Ruiz Díaz', '987654324', NULL),
('44567890', 'Jorge Castro Silva', '987654325', 'jcastro@gmail.com');
GO

-- 3. Catalogo_Servicios
INSERT INTO Catalogo_Servicios (Nombre_Servicio, Complejidad, Tarifa_Base, Duracion_Est_Horas)
VALUES 
('Aplicación de Inyectables', 'Baja', 30.00, 0.50),
('Curación de Heridas Ambulatoria', 'Media', 60.00, 1.00),
('Monitoreo UCI Domiciliario', 'Alta', 250.00, 12.00),
('Cuidados Postoperatorios', 'Alta', 150.00, 8.00),
('Acompañamiento Adulto Mayor', 'Baja', 80.00, 6.00);
GO

-- 4. Personal_Enfermeria
INSERT INTO Personal_Enfermeria (Num_Doc_Personal, Nombre_Completo, Num_Colegiatura, Especialidad, Celular_Contacto, Estado_Activo)
VALUES 
('45123456', 'Luigui Alfredo Arroyo Bruno', 'CEP-10112', 'Cuidados Intensivos', '912345671', 1),
('46234567', 'Caren Dalia Díaz Antonio', 'CEP-20223', 'Geriatría', '912345672', 1),
('47345678', 'Liliana Flor de María Montenegro', 'CEP-30334', 'General', '912345673', 1),
('48456789', 'Sugei Amada Ochante Arroyo', 'CEP-40445', 'Pediatría', '912345674', 1),
('49567890', 'Juan Carlos Mendoza', 'CEP-50556', 'Cuidados Intensivos', '912345675', 1);
GO

-- =========================================================================================
-- FASE 2: TABLAS TRANSACCIONALES - CABECERA (20 Registros)
-- =========================================================================================

-- Asumiremos IDs secuenciales del 1 al 5 generados en las tablas maestras.
INSERT INTO Solicitud_Servicio (ID_Paciente, ID_Responsable, ID_Servicio, Fecha_Creacion, Canal_Ingreso, Estado_Global)
VALUES 
(1, 1, 1, '2026-05-01 08:00:00', 'WhatsApp', 'Completado'),
(2, 2, 2, '2026-05-02 09:15:00', 'Llamada', 'Completado'),
(3, 3, 3, '2026-05-03 10:30:00', 'Correo', 'Completado'),
(4, 4, 4, '2026-05-04 11:45:00', 'WhatsApp', 'Completado'),
(5, 5, 5, '2026-05-05 14:00:00', 'Llamada', 'Completado'),
(1, 1, 2, '2026-05-06 08:30:00', 'WhatsApp', 'Completado'),
(2, 2, 3, '2026-05-07 09:45:00', 'WhatsApp', 'Completado'),
(3, 3, 4, '2026-05-08 10:00:00', 'Llamada', 'Completado'),
(4, 4, 5, '2026-05-09 11:20:00', 'WhatsApp', 'Completado'),
(5, 5, 1, '2026-05-10 13:15:00', 'Correo', 'Completado'),
(1, 1, 3, '2026-05-11 08:10:00', 'WhatsApp', 'Completado'),
(2, 2, 4, '2026-05-12 09:20:00', 'WhatsApp', 'Completado'),
(3, 3, 5, '2026-05-13 10:40:00', 'Llamada', 'Completado'),
(4, 4, 1, '2026-05-14 11:50:00', 'WhatsApp', 'Completado'),
(5, 5, 2, '2026-05-15 14:10:00', 'Llamada', 'Completado'),
(1, 1, 4, '2026-05-16 08:05:00', 'WhatsApp', 'Completado'),
(2, 2, 5, '2026-05-17 09:35:00', 'Correo', 'Completado'),
(3, 3, 1, '2026-05-18 10:55:00', 'WhatsApp', 'Completado'),
(4, 4, 2, '2026-05-19 11:10:00', 'Llamada', 'Completado'),
(5, 5, 3, '2026-05-20 14:25:00', 'WhatsApp', 'Completado');
GO

-- =========================================================================================
-- FASE 3: TABLAS TRANSACCIONALES - DETALLE Y DÉBILES (20 Registros)
-- =========================================================================================

-- 1. Cronograma_Turnos (20 Turnos Completados)
-- ID_Solicitud va del 1 al 20, ID_Personal va del 1 al 5
INSERT INTO Cronograma_Turnos (ID_Solicitud, ID_Personal, FecHora_Prog_Inicio, FecHora_Prog_Fin, FecHora_Real_Llegada, FecHora_Real_Salida, Estado_Turno)
VALUES 
(1, 1, '2026-05-02 08:00:00', '2026-05-02 08:30:00', '2026-05-02 07:55:00', '2026-05-02 08:35:00', 'Completado'),
(2, 2, '2026-05-03 09:00:00', '2026-05-03 10:00:00', '2026-05-03 08:50:00', '2026-05-03 10:10:00', 'Completado'),
(3, 5, '2026-05-04 20:00:00', '2026-05-05 08:00:00', '2026-05-04 19:55:00', '2026-05-05 08:05:00', 'Completado'),
(4, 3, '2026-05-05 08:00:00', '2026-05-05 16:00:00', '2026-05-05 08:00:00', '2026-05-05 16:00:00', 'Completado'),
(5, 4, '2026-05-06 10:00:00', '2026-05-06 16:00:00', '2026-05-06 10:15:00', '2026-05-06 16:15:00', 'Completado'),
(6, 2, '2026-05-07 09:00:00', '2026-05-07 10:00:00', '2026-05-07 08:58:00', '2026-05-07 10:02:00', 'Completado'),
(7, 1, '2026-05-08 20:00:00', '2026-05-09 08:00:00', '2026-05-08 19:50:00', '2026-05-09 08:10:00', 'Completado'),
(8, 3, '2026-05-09 08:00:00', '2026-05-09 16:00:00', '2026-05-09 08:05:00', '2026-05-09 16:00:00', 'Completado'),
(9, 4, '2026-05-10 10:00:00', '2026-05-10 16:00:00', '2026-05-10 09:55:00', '2026-05-10 16:05:00', 'Completado'),
(10, 1, '2026-05-11 08:00:00', '2026-05-11 08:30:00', '2026-05-11 08:00:00', '2026-05-11 08:35:00', 'Completado'),
(11, 5, '2026-05-12 20:00:00', '2026-05-13 08:00:00', '2026-05-12 19:45:00', '2026-05-13 08:00:00', 'Completado'),
(12, 3, '2026-05-13 08:00:00', '2026-05-13 16:00:00', '2026-05-13 08:10:00', '2026-05-13 16:10:00', 'Completado'),
(13, 2, '2026-05-14 10:00:00', '2026-05-14 16:00:00', '2026-05-14 09:50:00', '2026-05-14 15:50:00', 'Completado'),
(14, 4, '2026-05-15 08:00:00', '2026-05-15 08:30:00', '2026-05-15 08:00:00', '2026-05-15 08:30:00', 'Completado'),
(15, 1, '2026-05-16 09:00:00', '2026-05-16 10:00:00', '2026-05-16 09:05:00', '2026-05-16 10:00:00', 'Completado'),
(16, 3, '2026-05-17 08:00:00', '2026-05-17 16:00:00', '2026-05-17 07:55:00', '2026-05-17 16:05:00', 'Completado'),
(17, 2, '2026-05-18 10:00:00', '2026-05-18 16:00:00', '2026-05-18 09:45:00', '2026-05-18 16:15:00', 'Completado'),
(18, 4, '2026-05-19 08:00:00', '2026-05-19 08:30:00', '2026-05-19 08:00:00', '2026-05-19 08:35:00', 'Completado'),
(19, 1, '2026-05-20 09:00:00', '2026-05-20 10:00:00', '2026-05-20 09:00:00', '2026-05-20 10:00:00', 'Completado'),
(20, 5, '2026-05-21 20:00:00', '2026-05-22 08:00:00', '2026-05-21 19:55:00', '2026-05-22 08:05:00', 'Completado');
GO

-- 2. Registro_Evolucion (20 Notas Clínicas)
INSERT INTO Registro_Evolucion (ID_Turno, Nota_Subjetivo, Nota_Objetivo, Nota_Analisis, Nota_Plan, Nota_Intervencion, Nota_Evaluacion)
VALUES 
(1, 'Paciente refiere dolor leve', 'SV estables', 'Dolor controlado', 'Administrar medicación', 'Inyectable aplicado IM', 'Paciente sin reacciones adversas'),
(2, 'Refiere picor en herida', 'Herida con bordes limpios', 'Herida en proceso de cicatrización', 'Limpieza y nuevo apósito', 'Curación plana', 'Acepta procedimiento, herida limpia'),
(3, 'Familiar indica noche tranquila', 'Saturación 98%, FC 75', 'Estabilidad hemodinámica', 'Mantener monitoreo continuo', 'Control de SV cada hora', 'Turno sin incidencias'),
(4, 'Paciente con molestia abdominal', 'Abdomen blando depresible', 'Dolor postoperatorio esperado', 'Dar analgesia SOS', 'Administración de Ketorolaco', 'Disminución del dolor a 2/10'),
(5, 'Paciente se siente solo', 'Aparente buen estado general', 'Riesgo de caídas', 'Acompañamiento y caminata', 'Asistencia en deambulación', 'Paciente animado al finalizar turno'),
(6, 'Familiar indica buena evolución', 'Cicatriz sin secreción', 'Cicatrización óptima', 'Retiro de puntos programado', 'Curación con suero fisiológico', 'Procedimiento exitoso'),
(7, 'Paciente somnoliento', 'PA 110/70, FC 80', 'Manejo UCI estable', 'Continuar infusión', 'Ajuste de goteo de bomba', 'Infusión pasando correctamente'),
(8, 'Refiere náuseas', 'Mucosas orales secas', 'Leve deshidratación', 'Aumentar ingesta hídrica', 'Asistencia en dieta y vía oral', 'Tolerancia oral adecuada'),
(9, 'Paciente colaborador', 'Marcha lenta pero segura', 'Movilidad reducida', 'Ejercicios pasivos', 'Masajes en miembros inferiores', 'Relajación muscular lograda'),
(10, 'Paciente solicita inyectable rápido', 'Zona glútea sin eritemas', 'Requerimiento de antibiótico', 'Aplicar según receta', 'Inyectable IM de Ceftriaxona', 'Sin alergias observadas'),
(11, 'Familiar refiere pico de fiebre', 'T 38.5C a las 22h', 'Síndrome febril', 'Medios físicos y antipirético', 'Aplicación de paracetamol IV', 'Temperatura desciende a 37.1C'),
(12, 'Paciente refiere molestia en drenaje', 'Drenaje serohemático escaso', 'Evolución favorable', 'Cuantificar drenaje', 'Vaciado de drenovac', 'Volumen registrado 20cc'),
(13, 'Paciente tranquilo', 'Piel íntegra', 'Autocuidado deficiente', 'Baño de esponja', 'Higiene corporal en cama', 'Paciente limpio y confortable'),
(14, 'Paciente ansioso', 'SV dentro de parámetros', 'Ansiedad leve', 'Terapia de escucha', 'Aplicación de Neurobion IM', 'Paciente refiere alivio'),
(15, 'Paciente refiere dolor 4/10', 'Zona operatoria sin rubor', 'Dolor moderado', 'Curación y analgesia', 'Cambio de gasas y esparadrapo', 'Curación sellada correctamente'),
(16, 'Familia solicita revisión de sonda', 'Sonda permeable', 'Buen flujo urinario', 'Manejo de diuresis', 'Fijación de sonda vesical', 'Sonda fijada sin tensión'),
(17, 'Paciente refiere fatiga', 'Saturación 95%', 'Fatiga propia de la edad', 'Descanso activo', 'Lectura guiada y compañía', 'Paciente concilia sueño'),
(18, 'Paciente apurado', 'SV estables', 'Administración rápida', 'Aplicar medicamento diario', 'Inyectable subcutáneo', 'Aplicación en zona periumbilical'),
(19, 'Refiere comezón', 'Ligero eritema peri-herida', 'Posible reacción al esparadrapo', 'Cambiar tipo de adhesivo', 'Uso de cinta microporosa', 'Disminución de eritema'),
(20, 'Familiar reporta tos', 'Murmullo vesicular pasa bien', 'Secreciones leves', 'Fisioterapia respiratoria', 'Nebulización y palmoteo', 'Paciente expectora con facilidad');
GO

-- 3. Pago_Virtual (20 Pagos)
-- Para cumplir con la restricción UQ_Num_Operacion, cada voucher es único.
INSERT INTO Pago_Virtual (ID_Turno, Monto_Abonado, Plataforma_Pago, Num_Operacion, FecHora_Pago)
VALUES 
(1, 30.00, 'Yape', 'OPE-0001-Y', '2026-05-02 08:40:00'),
(2, 60.00, 'Plin', 'OPE-0002-P', '2026-05-03 10:15:00'),
(3, 250.00, 'Transferencia BCP', 'OPE-0003-B', '2026-05-05 08:30:00'),
(4, 150.00, 'Yape', 'OPE-0004-Y', '2026-05-05 16:05:00'),
(5, 80.00, 'Plin', 'OPE-0005-P', '2026-05-06 16:20:00'),
(6, 60.00, 'Transferencia BBVA', 'OPE-0006-V', '2026-05-07 10:05:00'),
(7, 250.00, 'Yape', 'OPE-0007-Y', '2026-05-09 08:15:00'),
(8, 150.00, 'Plin', 'OPE-0008-P', '2026-05-09 16:10:00'),
(9, 80.00, 'Transferencia BCP', 'OPE-0009-B', '2026-05-10 16:15:00'),
(10, 30.00, 'Yape', 'OPE-0010-Y', '2026-05-11 08:40:00'),
(11, 250.00, 'Plin', 'OPE-0011-P', '2026-05-13 08:20:00'),
(12, 150.00, 'Transferencia BCP', 'OPE-0012-B', '2026-05-13 16:15:00'),
(13, 80.00, 'Yape', 'OPE-0013-Y', '2026-05-14 15:55:00'),
(14, 30.00, 'Plin', 'OPE-0014-P', '2026-05-15 08:35:00'),
(15, 60.00, 'Transferencia BBVA', 'OPE-0015-V', '2026-05-16 10:10:00'),
(16, 150.00, 'Yape', 'OPE-0016-Y', '2026-05-17 16:10:00'),
(17, 80.00, 'Plin', 'OPE-0017-P', '2026-05-18 16:20:00'),
(18, 30.00, 'Transferencia BCP', 'OPE-0018-B', '2026-05-19 08:40:00'),
(19, 60.00, 'Yape', 'OPE-0019-Y', '2026-05-20 10:15:00'),
(20, 250.00, 'Plin', 'OPE-0020-P', '2026-05-22 08:20:00');
GO

-- 4. Historial_Estados (Mínimo 20 registros auditables)
-- Para simplificar la prueba lógica, simulamos la transición del Turno 1 y 2 completos
INSERT INTO Historial_Estados (ID_Turno, Estado_Anterior, Estado_Nuevo, FecHora_Cambio)
VALUES 
(1, NULL, 'Pendiente', '2026-05-01 08:05:00'),
(1, 'Pendiente', 'Asignado', '2026-05-01 09:00:00'),
(1, 'Asignado', 'En Curso', '2026-05-02 07:55:00'),
(1, 'En Curso', 'Completado', '2026-05-02 08:35:00'),

(2, NULL, 'Pendiente', '2026-05-02 09:20:00'),
(2, 'Pendiente', 'Asignado', '2026-05-02 10:00:00'),
(2, 'Asignado', 'En Curso', '2026-05-03 08:50:00'),
(2, 'En Curso', 'Completado', '2026-05-03 10:10:00'),

(3, NULL, 'Pendiente', '2026-05-03 10:35:00'),
(3, 'Pendiente', 'Asignado', '2026-05-03 11:00:00'),
(3, 'Asignado', 'En Curso', '2026-05-04 19:55:00'),
(3, 'En Curso', 'Completado', '2026-05-05 08:05:00'),

(4, NULL, 'Pendiente', '2026-05-04 11:50:00'),
(4, 'Pendiente', 'Asignado', '2026-05-04 12:30:00'),
(4, 'Asignado', 'En Curso', '2026-05-05 08:00:00'),
(4, 'En Curso', 'Completado', '2026-05-05 16:00:00'),

(5, NULL, 'Pendiente', '2026-05-05 14:05:00'),
(5, 'Pendiente', 'Asignado', '2026-05-05 15:00:00'),
(5, 'Asignado', 'En Curso', '2026-05-06 10:15:00'),
(5, 'En Curso', 'Completado', '2026-05-06 16:15:00');
GO