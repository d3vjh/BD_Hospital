-- DDL para la Base de Datos: Farmacia
-- Incluye MEDICAMENTO, LABORATORIO, CATEGORIA_MEDICAMENTO

CREATE TYPE estado_medicamento_enum AS ENUM ('DISPONIBLE', 'AGOTADO', 'VENCIDO', 'RETIRADO', 'CUARENTENA');

-- Tabla de laboratorios farmacéuticos
CREATE TABLE laboratorio (
    id_laboratorio SERIAL PRIMARY KEY,
    nombre_laboratorio VARCHAR(100) NOT NULL,
    telefono_lab VARCHAR(20),
    email_lab VARCHAR(100),
    direccion_lab VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_laboratorio_nombre UNIQUE (nombre_laboratorio),
    CONSTRAINT ck_laboratorio_email CHECK (email_lab ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Tabla de categorías de medicamentos
CREATE TABLE categoria_medicamento (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE,
    descripcion_categoria TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de medicamentos (CENTRALIZADA - Farmacia)
CREATE TABLE medicamento (
    cod_med SERIAL PRIMARY KEY,
    nom_med VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(100),
    descripcion_med TEXT,
    concentracion VARCHAR(50),
    forma_farmaceutica VARCHAR(50),
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 10,
    stock_maximo INTEGER DEFAULT 1000,
    precio_unitario DECIMAL(10,2),
    fecha_vencimiento DATE,
    lote VARCHAR(50),
    id_laboratorio INTEGER,
    id_categoria INTEGER,
    estado_medicamento estado_medicamento_enum DEFAULT 'DISPONIBLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_medicamento_laboratorio FOREIGN KEY (id_laboratorio)
        REFERENCES laboratorio(id_laboratorio),
    CONSTRAINT fk_medicamento_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria_medicamento(id_categoria),
    CONSTRAINT ck_stock_actual_positivo CHECK (stock_actual >= 0),
    CONSTRAINT ck_stock_minimo_positivo CHECK (stock_minimo >= 0),
    CONSTRAINT ck_stock_maximo_mayor CHECK (stock_maximo >= stock_minimo),
    CONSTRAINT ck_precio_positivo CHECK (precio_unitario >= 0),
    CONSTRAINT ck_fecha_vencimiento CHECK (fecha_vencimiento > CURRENT_DATE)
);

-- Vista de medicamentos con información completa
CREATE VIEW v_medicamentos_completo AS
SELECT
    m.cod_med,
    m.nom_med,
    m.principio_activo,
    m.concentracion,
    m.forma_farmaceutica,
    m.stock_actual,
    m.stock_minimo,
    m.precio_unitario,
    l.nombre_laboratorio,
    cm.nombre_categoria,
    m.fecha_vencimiento,
    m.estado_medicamento,
    CASE
        WHEN m.stock_actual <= m.stock_minimo THEN 'STOCK_BAJO'
        WHEN m.fecha_vencimiento <= CURRENT_DATE + INTERVAL '3 months' THEN 'PROXIMO_VENCIMIENTO'
        ELSE 'NORMAL'
    END AS alerta_stock
FROM medicamento m
JOIN laboratorio l ON m.id_laboratorio = l.id_laboratorio
JOIN categoria_medicamento cm ON m.id_categoria = cm.id_categoria;


DML:
-- Insertar categorías de medicamentos
INSERT INTO categoria_medicamento (nombre_categoria, descripcion_categoria) VALUES
('Antibióticos', 'Medicamentos para combatir infecciones'),
('Analgésicos', 'Medicamentos para aliviar el dolor'),
('Antihipertensivos', 'Medicamentos para controlar la presión arterial'),
('Antidiabéticos', 'Medicamentos para controlar la diabetes');

-- Insertar laboratorios
INSERT INTO laboratorio (nombre_laboratorio, telefono_lab, email_lab, direccion_lab) VALUES
('Laboratorios Genfar', '+57-1-4567890', 'info@genfar.com', 'Bogotá, Colombia'),
('Tecnoquímicas', '+57-4-3456789', 'contacto@tecnoquimicas.com', 'Cali, Colombia');

TOCA AGREGAR INFO A LA COLUMNA DE DESC MED

INSERT INTO medicamento (nom_med, principio_activo, concentracion, forma_farmaceutica, stock_actual, stock_minimo, precio_unitario, fecha_vencimiento, lote, id_laboratorio, id_categoria, estado_medicamento) VALUES
('Acetaminofén', 'Paracetamol', '500mg', 'Tableta', 500, 50, 150.00, '2025-12-31', 'LOT001', 1, 2, 'DISPONIBLE'),
('Amoxicilina', 'Amoxicilina', '500mg', 'Cápsula', 300, 30, 800.00, '2025-10-15', 'LOT002', 2, 1, 'DISPONIBLE'),
('Losartán', 'Losartán Potásico', '50mg', 'Tableta', 250, 25, 450.00, '2025-09-20', 'LOT003', 1, 3, 'DISPONIBLE'),
('Metformina', 'Metformina HCl', '850mg', 'Tableta', 200, 20, 320.00, '2025-08-15', 'LOT004', 2, 4, 'DISPONIBLE');