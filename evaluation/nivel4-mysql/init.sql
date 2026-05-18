-- init.sql — script SQL ejecutado en la primera inicialización
-- Crea tabla de ejemplo para verificar que la BD funciona

USE mi_db;

CREATE TABLE IF NOT EXISTS docker_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(255) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO docker_test (mensaje) VALUES
    ('Hola desde Docker Nivel 4!'),
    ('MySQL inicializado correctamente'),
    ('Volumen persistente funcionando');
