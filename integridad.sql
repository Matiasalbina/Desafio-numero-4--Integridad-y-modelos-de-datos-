-- Active: 1721019939146@@127.0.0.1@5432@desafio4_matias_albina_151@public
CREATE DATABASE desafio4_matias_albina_151;

-- Crear la tabla de películas
CREATE TABLE peliculas (
    peli_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INT
);

-- Crear la tabla de etiquetas
CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    tag_nombre VARCHAR(32) NOT NULL
);

-- Crear la tabla intermedia para la relación muchos a muchos
CREATE TABLE peli_tags (
    peli_id INT REFERENCES peliculas(peli_id) ON DELETE CASCADE,
    tag_id INT REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (peli_id, tag_id)
);

-- Requerimiento N°2 (Insertar datos)----------------

INSERT INTO peliculas (nombre, anno) VALUES
('El Conjuro', 2013),
('Top Gun', 2022),
('El viaje de Chihiro', 2001),
('Mi maestro Pulpo', 2020),
('La momia', 2017);

-- Insertar etiquetas
INSERT INTO tags (tag_nombre) VALUES
('Terror'),
('Accion'),
('Anime'),
('Documental'),
('Fantasia');

SELECT * FROM peliculas;
SELECT * FROM tags;

-- REQUERIMIENTO N°2
-- La primera película (El Conjuro) tiene 3 etiquetas
INSERT INTO peli_tags (peli_id, tag_id) VALUES
(1, 1), -- Terror
(1, 2), -- Accion
(1, 5); -- Fantasia

-- La segunda película (Top Gun) tiene 2 etiquetas
INSERT INTO peli_tags (peli_id, tag_id) VALUES
(2, 2), -- Accion
(2, 5); -- fantasia

SELECT * FROM peli_tags; -- verificacion

-- REQUERIMIENTO N°3: Contar la cantidad de tags por película
--La pelicula (El Conjuro) tiene 3 tags.
--La segunda (Top Gun) tiene 2 tags asociados.
--Las que no tienen tag muestran cero.
SELECT 
    m.nombre,
    COUNT(mt.tag_id) AS tag_count
FROM 
    peliculas m
LEFT JOIN 
    peli_tags mt ON m.peli_id = mt.peli_id
GROUP BY 
    m.peli_id;

--REQUERIMIENTO N°4

CREATE TABLE usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombreusuario VARCHAR(255) NOT NULL,
    edad INT CHECK (edad >= 18) -- Restricción de edad mínima de 18 años
);

CREATE TABLE preguntas (
    pregunta_id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

CREATE TABLE respuestas (
    respuesta_id SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INT REFERENCES usuarios(usuario_id) ON DELETE CASCADE,
    pregunta_id INT REFERENCES preguntas(pregunta_id) ON DELETE CASCADE,
    is_correct BOOLEAN NOT NULL
);

--REQUERIMIENTO N° 5: Agregar usuarios y preguntas

 -- Insertar usuarios con nombreusuario, edad
INSERT INTO usuarios (nombreusuario, edad) VALUES
('User1', 35),
('User2', 23),
('User3', 56),
('User4', 19),
('User5', 28);
SELECT * FROM usuarios;

-- In sertar preguntas
INSERT INTO preguntas (pregunta) VALUES
('Cual es la capital de Francia?'),
('Cuanto es 77 + 33?'),
('En que planeta vivimos?'),
('Cual es el pais mas grande del mundo?'),
('Cual es el lugar mas frio de la tierra?');
SELECT * FROM preguntas;

-- La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id, is_correct) VALUES
('París', 1, 1, TRUE),
('París', 2, 1, TRUE);
 
-- La segunda pregunta debe estar contestada correctamente solo por un usuario.
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id, is_correct) VALUES
('110', 3, 2, TRUE);

-- Las otras tres preguntas deben tener respuestas incorrectas.
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id, is_correct) VALUES
('Marte', 4, 3, FALSE), -- Respuesta incorrecta a 'En que planeta vivimos?'
('Australia', 5, 4, FALSE), -- Respuesta incorrecta a 'Cual es el pais mas grande del mundo?'
('Sahara', 1, 5, FALSE); -- Respuesta incorrecta a 'Cual es el lugar mas frio de la tierra?'

--REQUERIMIENTO N° 6 Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT usuario_id, COUNT(*) AS respuestas_correctas
FROM respuestas
WHERE is_correct = TRUE
GROUP BY usuario_id;

--REQUERIMIENTO N° 7 Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente. 
SELECT pregunta_id, COUNT(*) AS usuarios_correctos
FROM respuestas
WHERE is_correct = TRUE
GROUP BY pregunta_id;

--REQUERIMIENTO N° 8: Borrado en cascada
-- Paso 3: Verificar datos antes del borrado
SELECT * FROM usuarios;
SELECT * FROM respuestas;
-- Paso 4: Borrar un usuario y verificar el borrado en cascada
DELETE FROM usuarios WHERE usuario_id = 1;
-- Verificar que las respuestas asociadas también se hayan borrado
SELECT * FROM respuestas;

--REQUERIMIENTO N° 9 (esta en la tabla usuarios)
-- Cuando insertamos un usuario menor de 18 años
INSERT INTO usuarios (nombreusuario, edad) VALUES ('usuario_invalido', 17);

--REQUERIMIENTO N° 10  Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

SELECT * FROM usuarios;