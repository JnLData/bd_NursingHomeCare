-- =========================================================================================
-- LIMPIEZA DEL ENTORNO
-- =========================================================================================

DROP TABLE IF EXISTS Historial_Estados;
DROP TABLE IF EXISTS Pago_Virtual;
DROP TABLE IF EXISTS Registro_Evolucion;
DROP TABLE IF EXISTS Cronograma_Turnos;
DROP TABLE IF EXISTS Solicitud_Servicio;
DROP TABLE IF EXISTS Personal_Enfermeria;
DROP TABLE IF EXISTS Catalogo_Servicios;
DROP TABLE IF EXISTS Dim_Responsables;
DROP TABLE IF EXISTS Dim_Pacientes;
GO

-- =========================================================================================
-- FASE 1: CREACIÓN DE TABLAS MAESTRAS O INDEPENDIENTES (DIMENSIONES)
-- =========================================================================================

CREATE TABLE Dim_Pacientes (
    ID_Paciente INT IDENTITY(1,1) NOT NULL,
    Num_Doc_Paciente VARCHAR(15) NOT NULL,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Fec_Nacimiento DATE NOT NULL,
    Direccion_Atencion VARCHAR(255) NOT NULL,
    Alergias_Base VARCHAR(500) NULL,
    CONSTRAINT PK_Pacientes PRIMARY KEY CLUSTERED (ID_Paciente),
    CONSTRAINT UQ_Doc_Paciente UNIQUE (Num_Doc_Paciente)
);
GO

CREATE TABLE Dim_Responsables (
    ID_Responsable INT IDENTITY(1,1) NOT NULL,
    Num_Doc_Responsable VARCHAR(15) NOT NULL,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Celular_WhatsApp VARCHAR(20) NOT NULL,
    Email_Contacto VARCHAR(100) NULL,
    CONSTRAINT PK_Responsables PRIMARY KEY CLUSTERED (ID_Responsable),
    CONSTRAINT UQ_Doc_Responsable UNIQUE (Num_Doc_Responsable)
);
GO

CREATE TABLE Catalogo_Servicios (
    ID_Servicio INT IDENTITY(1,1) NOT NULL,
    Nombre_Servicio VARCHAR(100) NOT NULL,
    Complejidad VARCHAR(20) NOT NULL,
    Tarifa_Base DECIMAL(10,2) NOT NULL,
    Duracion_Est_Horas DECIMAL(4,2) NOT NULL,
    CONSTRAINT PK_Servicios PRIMARY KEY CLUSTERED (ID_Servicio),
    CONSTRAINT UQ_Nombre_Servicio UNIQUE (Nombre_Servicio),
    CONSTRAINT CHK_Tarifa_Positiva CHECK (Tarifa_Base > 0)
);
GO

CREATE TABLE Personal_Enfermeria (
    ID_Personal INT IDENTITY(1,1) NOT NULL,
    Num_Doc_Personal VARCHAR(15) NOT NULL,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Num_Colegiatura VARCHAR(20) NOT NULL,
    Especialidad VARCHAR(50) NOT NULL,
    Celular_Contacto VARCHAR(20) NOT NULL,
    Estado_Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Personal PRIMARY KEY CLUSTERED (ID_Personal),
    CONSTRAINT UQ_Doc_Personal UNIQUE (Num_Doc_Personal),
    CONSTRAINT UQ_Colegiatura UNIQUE (Num_Colegiatura)
);
GO

-- =========================================================================================
-- FASE 2: CREACIÓN DE TRANSACCIONAL CABECERA
-- =========================================================================================

CREATE TABLE Solicitud_Servicio (
    ID_Solicitud INT IDENTITY(1,1) NOT NULL,
    ID_Paciente INT NOT NULL,
    ID_Responsable INT NOT NULL,
    ID_Servicio INT NOT NULL,
    Fecha_Creacion DATETIME NOT NULL DEFAULT GETDATE(),
    Canal_Ingreso VARCHAR(30) NOT NULL,
    Estado_Global VARCHAR(20) NOT NULL DEFAULT 'En Proceso',
    CONSTRAINT PK_Solicitud PRIMARY KEY CLUSTERED (ID_Solicitud),
    CONSTRAINT FK_Solicitud_Paciente FOREIGN KEY (ID_Paciente) REFERENCES Dim_Pacientes(ID_Paciente),
    CONSTRAINT FK_Solicitud_Responsable FOREIGN KEY (ID_Responsable) REFERENCES Dim_Responsables(ID_Responsable),
    CONSTRAINT FK_Solicitud_Servicio FOREIGN KEY (ID_Servicio) REFERENCES Catalogo_Servicios(ID_Servicio)
);
GO

-- =========================================================================================
-- FASE 3: CREACIÓN DE TRANSACCIONAL DETALLE Y ENTIDADES DÉBILES
-- =========================================================================================

CREATE TABLE Cronograma_Turnos (
    ID_Turno INT IDENTITY(1,1) NOT NULL,
    ID_Solicitud INT NOT NULL,
    ID_Personal INT NULL,
    FecHora_Prog_Inicio DATETIME NOT NULL,
    FecHora_Prog_Fin DATETIME NOT NULL,
    FecHora_Real_Llegada DATETIME NULL,
    FecHora_Real_Salida DATETIME NULL,
    Estado_Turno VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT PK_Turno PRIMARY KEY CLUSTERED (ID_Turno),
    CONSTRAINT FK_Turno_Solicitud FOREIGN KEY (ID_Solicitud) REFERENCES Solicitud_Servicio(ID_Solicitud) ON DELETE CASCADE,
    CONSTRAINT FK_Turno_Personal FOREIGN KEY (ID_Personal) REFERENCES Personal_Enfermeria(ID_Personal),
    CONSTRAINT CHK_Fechas_Programadas CHECK (FecHora_Prog_Inicio < FecHora_Prog_Fin)
);
GO

CREATE TABLE Registro_Evolucion (
    ID_Evolucion INT IDENTITY(1,1) NOT NULL,
    ID_Turno INT NOT NULL,
    Nota_Subjetivo VARCHAR(MAX) NOT NULL,
    Nota_Objetivo VARCHAR(MAX) NOT NULL,
    Nota_Analisis VARCHAR(MAX) NOT NULL,
    Nota_Plan VARCHAR(MAX) NOT NULL,
    Nota_Intervencion VARCHAR(MAX) NOT NULL,
    Nota_Evaluacion VARCHAR(MAX) NOT NULL,
    FecHora_Registro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Evolucion PRIMARY KEY CLUSTERED (ID_Evolucion),
    CONSTRAINT FK_Evolucion_Turno FOREIGN KEY (ID_Turno) REFERENCES Cronograma_Turnos(ID_Turno) ON DELETE CASCADE,
    CONSTRAINT UQ_Evolucion_Turno UNIQUE (ID_Turno) 
);
GO

CREATE TABLE Pago_Virtual (
    ID_Pago INT IDENTITY(1,1) NOT NULL,
    ID_Turno INT NOT NULL,
    Monto_Abonado DECIMAL(10,2) NOT NULL,
    Plataforma_Pago VARCHAR(30) NOT NULL,
    Num_Operacion VARCHAR(50) NOT NULL,
    FecHora_Pago DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Pago PRIMARY KEY CLUSTERED (ID_Pago),
    CONSTRAINT FK_Pago_Turno FOREIGN KEY (ID_Turno) REFERENCES Cronograma_Turnos(ID_Turno) ON DELETE CASCADE,
    CONSTRAINT UQ_Pago_Turno UNIQUE (ID_Turno), 
    CONSTRAINT UQ_Num_Operacion UNIQUE (Num_Operacion, Plataforma_Pago), 
    CONSTRAINT CHK_Monto_Abonado CHECK (Monto_Abonado > 0)
);
GO

CREATE TABLE Historial_Estados (
    ID_Historial INT IDENTITY(1,1) NOT NULL,
    ID_Turno INT NOT NULL,
    Estado_Anterior VARCHAR(20) NULL,
    Estado_Nuevo VARCHAR(20) NOT NULL,
    FecHora_Cambio DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Historial PRIMARY KEY CLUSTERED (ID_Historial),
    CONSTRAINT FK_Historial_Turno FOREIGN KEY (ID_Turno) REFERENCES Cronograma_Turnos(ID_Turno) ON DELETE CASCADE
);
GO