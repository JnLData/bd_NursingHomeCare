# bd_NursingHomeCare
Modelo de datos para proyecto de Atencion de Enfermeria Particular en casa
### 📄 Caso de Estudio Definitivo: Proyecto "Nursing HomeCare"

**Nombre del Proyecto:** Arquitectura de Datos Transaccional para Atenciones de Enfermería Particular "Nursing HomeCare"

**Contexto del Negocio**
"Nursing HomeCare" es una agencia privada de salud a domicilio. La agencia gestiona una operativa dinámica mediante múltiples canales (WhatsApp, llamadas, correo), conectando pacientes con una red de profesionales de enfermería. El proceso abarca desde la solicitud de servicios (ej. inyectables, monitoreo UCI) hasta la asignación de turnos, ejecución del servicio, documentación clínica (SOAPIE) y calificación final. La misión es diseñar un modelo relacional (OLTP) que automatice la trazabilidad operativa, garantice la integridad de las asignaciones y permita la posterior toma de decisiones basada en datos.

**Reglas de Negocio Estrictas**
El modelo Entidad-Relación (ER) deberá soportar la siguiente lógica:

1. **Registro Multicanal y Desglose de Solicitudes:** Un paciente puede solicitar múltiples servicios a lo largo del tiempo. Una solicitud inicial ("Cabecera") que ingresa por un canal específico (ej. WhatsApp) puede implicar múltiples visitas físicas ("Detalles"). El sistema debe desagregar una petición general (ej. "5 días de curaciones") en turnos individuales.
2. **Catálogo y Complejidad Tarifaria:** Cada servicio posee una tarifa base ligada a su nivel de complejidad y duración estimada.
3. **Gestión de Disponibilidad (Zero-Overlapping):** El ciclo de vida de un turno pasa por distintos estados (Pendiente, Asignado, En Curso, Completado, Cancelado). Un profesional solo puede ser asignado si la validación matemática de su agenda garantiza que no existen cruces de horarios.
4. **Control de Tiempos Reales (Time Tracking):** Además de la hora programada, el sistema debe registrar obligatoriamente la fecha y hora real de llegada y salida del profesional en el domicilio para medir desviaciones y calcular la duración real de la atención.
5. **Obligatoriedad Documental (SOAPIE):** Para que un turno complejo pase a estado "Completado", el sistema debe validar la existencia de una nota de evolución clínica estructurada (Subjetivo, Objetivo, Análisis, Plan, Intervención, Evaluación).
6. **Calidad Bidireccional:** Al finalizar el servicio, se debe permitir el registro de una calificación (1 a 5 estrellas) del paciente hacia el enfermero, y viceversa.

**Entidades Clave Esperadas (Diccionario de Datos Base)**
Se requiere identificar, normalizar (hasta la 3NF) y conectar las siguientes entidades, definiendo llaves primarias (PK) y foráneas (FK):

* **Pacientes / Responsables:** Datos maestros y ubicación geográfica base.
* **Personal de Enfermería:** Directorio de profesionales, especialidades y credenciales.
* **Catálogo de Servicios:** Entidad paramétrica de procedimientos y tarifas.
* **Solicitudes de Servicio (Cabecera):** Registro de la intención de compra y canal de origen.
* **Cronograma de Turnos (Detalle):** Entidad transaccional resolutiva. Controla las fechas/horas programadas, fechas/horas reales de llegada y salida, estado actual y las calificaciones bidireccionales.
* **Historial de Estados (Auditoría):** Tabla dependiente para registrar el *timestamp* exacto de cada cambio de estado de un turno.
* **Registros de Evolución:** Entidad de almacenamiento de las notas clínicas (SOAPIE).

**Reto Analítico SQL (SLA y Eficiencia)**
El modelo diseñado deberá ser capaz de resolver las siguientes métricas mediante T-SQL:

* **Embudos de Conversión Operativa:** Porcentaje de solicitudes UCI que pasaron de "Pendiente" a "Canceladas" por falta de disponibilidad.
* **Productividad y SLA Clínico:** Profesionales con más de 15 turnos completados en el mes actual que poseen un 100% de cumplimiento en la redacción de sus notas SOAPIE.
* **Tiempos de Respuesta (Lead Time):** Tiempo promedio en horas transcurrido desde la creación de la solicitud hasta el registro de asignación en el historial de estados, segmentado por canal de atención.

---

### 🚧 Delimitaciones del Proyecto (Qué NO modelar)

Para mantener la integridad conceptual y evitar que la complejidad del modelo sobrepase los objetivos de un nivel intermedio de bases de datos transaccionales, **queda estrictamente excluido** el desarrollo de los siguientes módulos:

| Módulo Excluido | Razón Técnica y Pedagógica |
| --- | --- |
| **Facturación y Tributación** | Generar comprobantes de pago electrónicos, calcular impuestos (IGV/IVA), notas de crédito o retenciones contables requiere un submodelo financiero completo que desvía el foco del ciclo central (Operaciones/Clínico). |
| **Logística e Inventario de Insumos** | Controlar el stock unitario de gasas, jeringas o medicamentos consumidos por visita añade una capa de complejidad logística (Kardex) innecesaria. Se asume tarifariamente que el servicio es un "paquete cerrado" o los insumos los provee el paciente. |
| **Geolocalización Dinámica (GIS)** | El cálculo de rutas en tiempo real, distancias exactas de traslado o uso de coordenadas espaciales dinámicas requeriría tipos de datos espaciales (ej. `geography` en SQL Server) y APIs externas, lo cual excede el alcance de SQL relacional estándar. |
| **Historias Clínicas Previas (Anamnesis Completa)** | El diseño se centra en la evolución *actual* del cuidado (SOAPIE). Modelar antecedentes patológicos familiares, alergias crónicas o cirugías de hace 10 años convierte el sistema en un EMR (Electronic Medical Record) completo, sobrepasando el alcance operativo de una agencia de turnos. |
| **Subastas / Sustituciones Complejas** | El flujo automatizado donde un turno cancelado entra en "subasta" a varios enfermeros con temporizadores de aceptación involucra lógicas de aplicaciones en tiempo real (colas de mensajes), no manejables puramente a nivel de base de datos relacional. |
