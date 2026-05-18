# bd_NursingHomeCare

### 📄 Caso de Estudio Definitivo: Proyecto "Nursing HomeCare"

**Nombre del Proyecto:** Arquitectura de Datos Transaccional (OLTP) para Atenciones de Enfermería Particular "Nursing HomeCare"

**Contexto del Negocio**
"Nursing HomeCare" es una agencia privada de salud a domicilio con una operativa altamente dinámica. Actualmente, las solicitudes de servicio (desde curaciones hasta monitoreo en UCI) ingresan de forma manual a través de canales como WhatsApp o llamadas. El equipo directivo recibe estas solicitudes y coordina con su red de profesionales de enfermería para confirmar disponibilidad.
La misión de este proyecto es diseñar e implementar un modelo de datos relacional normalizado que permita automatizar la trazabilidad operativa, garantizar la integridad matemática en la asignación de horarios (evitando solapamientos), controlar el ciclo de vida documental y registrar la liquidación financiera de las atenciones completadas, sentando las bases para un futuro análisis en la nube.

**Reglas de Negocio Estrictas**
El modelo Entidad-Relación soportará la siguiente lógica operativa:

1. **Desacoplamiento Clínico-Comercial:** Se debe diferenciar estrictamente al "Paciente" (quien recibe el cuidado físico) del "Responsable" (el familiar o cliente que solicita el servicio y asume el pago). Un mismo responsable puede solicitar atenciones para distintos pacientes en el tiempo.
2. **Desglose de Cabecera-Detalle:** Una solicitud inicial ("Cabecera") que ingresa por un canal específico puede requerir múltiples visitas físicas ("Detalle"). El sistema debe desagregar una petición general (ej. "5 días de tratamiento") en turnos individuales.
3. **Catálogo Paramétrico:** Cada servicio ofrecido posee una tarifa base y una duración estimada, definidas en un catálogo central para evitar redundancias y facilitar actualizaciones de precios.
4. **Gestión de Disponibilidad (Zero-Overlapping):** El ciclo de vida de un turno pasa por distintos estados auditables. Un profesional solo puede ser asignado a un turno si la base de datos garantiza que no existen cruces (intersecciones) con otros horarios previamente aceptados.
5. **Control de Tiempos Reales (Time Tracking):** Además del horario programado, es obligatorio registrar la fecha y hora real de llegada y salida del profesional para medir desviaciones operativas.
6. **Obligatoriedad Documental (SOAPIE):** Todo turno completado exige obligatoriamente un, y solo un, registro de evolución clínica estructurado (Subjetivo, Objetivo, Análisis, Plan, Intervención, Evaluación).
7. **Liquidación Financiera Posterior:** El pago es un evento estrictamente posterior y dependiente. Un turno finalizado genera máximo un solo registro de pago virtual (Yape, Plin, Transferencia) asociado a un número de operación bancaria único para evitar fraudes y duplicidades.

**Diccionario de Entidades Clave (Arquitectura Lógica)**
El diseño se compone de 9 entidades estructuradas hasta la Tercera Forma Normal (3NF):

* **Maestras (Dimensiones):**
* `Dim_Pacientes`: Sujetos de atención (Datos clínicos base y dirección).
* `Dim_Responsables`: Clientes comerciales (Datos de contacto y facturación).
* `Personal_Enfermeria`: Directorio de profesionales, credenciales y especialidades.
* `Catalogo_Servicios`: Tarifario paramétrico y duraciones estándar.


* **Transaccionales (Núcleo):**
* `Solicitud_Servicio` (Cabecera): Punto de convergencia que registra la intención de compra, el canal y vincula al Paciente, Responsable y Servicio.
* `Cronograma_Turnos` (Detalle): Entidad resolutiva. Materializa la visita física, asocia al enfermero, controla los tiempos reales y el estado actual.


* **Dependientes (Entidades Débiles):**
* `Historial_Estados` (1:N): Bitácora de auditoría que registra el *timestamp* exacto de cada cambio de estado de un turno.
* `Registro_Evolucion` (1:0..1): Entidad documental que almacena los textos clínicos SOAPIE.
* `Pago_Virtual` (1:0..1): Registro de la transacción económica y el voucher de conciliación.



**Reto Analítico SQL**
El esquema transaccional debe permitir a la directiva responder, mediante sentencias T-SQL, preguntas estratégicas como:

* **Embudos de Conversión:** ¿Qué porcentaje de solicitudes de alta complejidad pasaron a estado "Cancelado" por falta de profesionales disponibles?
* **SLA Clínico:** ¿Qué enfermeros han completado más de 15 turnos en el mes manteniendo un 100% de cumplimiento en la redacción de sus notas SOAPIE?
* **Lead Time Operativo:** Utilizando el historial de estados, ¿cuál es el tiempo promedio transcurrido desde que un turno nace como "Pendiente" hasta que un profesional es "Asignado"?

---

### 🚧 Delimitaciones del Proyecto (Qué NO modelar y Por qué)

Para garantizar el éxito del proyecto en un nivel intermedio de bases de datos y evitar el "Scope Creep" (corrupción del alcance), **quedan estrictamente excluidos** los siguientes módulos:

| Módulo Excluido | Razón Técnica y de Negocio |
| --- | --- |
| **Facturación Fiscal y Tributación** | Generar comprobantes electrónicos (XML), calcular impuestos (IGV/IVA) o retenciones requiere un diseño contable complejo. Hemos modelado el *Ingreso de Dinero* (Pago Virtual), pero la *Declaración Fiscal* se maneja en un sistema ERP aparte. |
| **Logística e Inventario de Insumos** | Controlar el stock unitario de jeringas, gasas o medicamentos consumidos por turno añade una capa de "Kardex" innecesaria. Se asume que el servicio es un paquete cerrado o que el paciente provee los insumos físicos. |
| **Geolocalización Dinámica (GIS)** | Calcular el tiempo de traslado en tiempo real o mapear rutas requeriría tipos de datos espaciales (`geography`) y consumo de APIs de Google Maps, lo cual desvía el foco del SQL relacional estándar. |
| **Historia Clínica Electrónica (EMR Completo)** | El modelo se centra en el episodio de cuidado actual (SOAPIE). Añadir antecedentes patológicos familiares, alergias detalladas, vacunas o cirugías de hace 10 años convierte el proyecto en un EMR médico completo, excediendo el alcance de una agencia operativa. |
| **Subastas Automatizadas de Turnos** | Flujos donde un turno cancelado lanza una alerta a 5 enfermeros y el primero que acepta se lo queda. Esto requiere manejo de colas de mensajes (ej. RabbitMQ/Kafka) y lógica de aplicación en tiempo real, no manejable puramente desde restricciones de base de datos relacional. |
