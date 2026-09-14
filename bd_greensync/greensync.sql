CREATE DATABASE greensync;

USE greensync;

CREATE TABLE estados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE, -- Ej: 'Activo', 'Inactivo', 'Pendiente'
    descripcion VARCHAR(255) NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE, -- Ej: 'Administrador', 'Cliente', 'Consultor'
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE tipos_instalacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL, -- Ej: 'Residencial', 'Comercial', 'Industrial'
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rol_id INT NOT NULL,
    estado_id INT NOT NULL DEFAULT 1,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    recordar_token VARCHAR(100) NULL, -- Nativo para 'remember_me'
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    eliminado_en TIMESTAMP NULL, -- Para Soft Deletes en Laravel
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE RESTRICT,
    FOREIGN KEY (estado_id) REFERENCES estados(id) ON DELETE RESTRICT
);

CREATE TABLE instalaciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    tipo_instalacion_id INT NOT NULL,
    estado_id INT NOT NULL DEFAULT 1,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(255) NULL,
    area_metros_cuadrados DECIMAL(8,2) NULL, -- Dato vital para la IA
    cantidad_ocupantes INT NULL,             -- Dato vital para la IA
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    eliminado_en TIMESTAMP NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_instalacion_id) REFERENCES tipos_instalacion(id) ON DELETE RESTRICT,
    FOREIGN KEY (estado_id) REFERENCES estados(id) ON DELETE RESTRICT
);


CREATE TABLE consumos_electricos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    instalacion_id BIGINT NOT NULL,
    kwh_consumido DECIMAL(10, 2) NOT NULL,
    fecha_medicion DATETIME NOT NULL,
    metodo_ingreso ENUM('manual', 'csv', 'api') NOT NULL DEFAULT 'manual',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instalacion_id) REFERENCES instalaciones(id) ON DELETE CASCADE
);


CREATE INDEX idx_fecha_consumo ON consumos_electricos(fecha_medicion);


-- Almacena el consejo generado por la IA para el usuario
CREATE TABLE consejos_ia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    instalacion_id BIGINT NOT NULL,
    contexto_analizado JSON NOT NULL, -- Guarda qué datos vio la IA (ej. consumos del mes)
    consejo_texto TEXT NOT NULL,
    token_uso INT NULL, 
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instalacion_id) REFERENCES instalaciones(id) ON DELETE CASCADE
);


CREATE TABLE retroalimentacion_ia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    consejo_ia_id BIGINT NOT NULL UNIQUE,
    calificacion_estrellas INT NOT NULL CHECK (calificacion_estrellas BETWEEN 1 AND 5),
    aplicado_con_exito BOOLEAN NOT NULL DEFAULT FALSE,
    comentario_usuario TEXT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consejo_ia_id) REFERENCES consejos_ia(id) ON DELETE CASCADE
);
