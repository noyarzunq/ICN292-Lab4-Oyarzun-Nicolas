DROP DATABASE IF EXISTS  austral;
CREATE DATABASE austral;
USE austral;
CREATE TABLE autores(
    id_autor INT AUTO_INCREMENT,
    nombre  VARCHAR(80) NOT NULL,
    país    VARCHAR(60),
    género  ENUM('Cómic','Ensayo','Infantil','Novela','Poesía') NOT NULL,
    PRIMARY KEY(id_autor)
);

CREATE TABLE colecciones(
    id_colección    INT AUTO_INCREMENT,
    título    VARCHAR(120) NOT NULL,
    fecha_publicación   DATE,
    PRIMARY KEY (id_colección)
);

CREATE TABLE libros (
    id_libro     INT AUTO_INCREMENT,
    id_autor    INT,
    id_colección    INT,
    título  VARCHAR(120) NOT NULL,
    páginas INT,
    ejemplares_vendidos INT,
    anio    INT,
    PRIMARY KEY(id_libro),
    FOREIGN KEY(id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY(id_colección) REFERENCES colecciones(id_colección)
);

CREATE TABLE pagos(
    id_pago     INT AUTO_INCREMENT,
    id_autor INT,
    fecha_pago   DATE,
    monto DECIMAL(10,2),
    pago_total DECIMAL(10,2),
    PRIMARY KEY (id_pago),
    FOREIGN KEY(id_autor) REFERENCES autores(id_autor)
);

INSERT INTO autores(nombre,país,género) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

INSERT INTO colecciones(título,fecha_publicación) VALUES
('Vocal Final','2016-09-16'),
('Consonante Final','2017-06-07');

INSERT INTO libros(id_autor,id_colección,título,páginas,ejemplares_vendidos,anio) VALUES
(1,1,'Cielo de Enero',210,1500,2024),
(1,1,'Marea Baja',185,800,2023),
(1,1,'El Norte',200,2200,2024),
(2,2,'Estrellas que Caen',240,3000,2022),
(2,2,'Máquinas',215,450,2024),
(3,2,'Luz Artificial',300,1200,2024),
(3,1,'Ruido Blanco',280,600,2023),
(4,1,'El Barrio de Lila',190,5000,2024),
(4,2,'Antes del Amanecer',205,2700,2024),
(4,1,'La Calle 8',175,900,2023),
(5,1,'Flor de Hierro',195,4100,2024),
(5,1,'Hora Dorada',220,1800,2022);

INSERT INTO pagos(id_autor,fecha_pago,monto) VALUES
(1,'2024-01-01',1500),
(1,'2023-01-01',800),
(1,'2024-01-01',2200),
(2,'2022-01-01',3000),
(2,'2024-01-01',450),
(3,'2024-01-01',1200),
(3,'2023-01-01',600),
(4,'2024-01-01',5000),
(4,'2024-01-01',2700),
(4,'2023-01-01',900),
(5,'2024-01-01',4100),
(5,'2022-01-01',1800)
;

#Consultas
#Consulta 1
SELECT nombre, género FROM autores
WHERE país <> 'Chile' OR país IS NULL;
#Consulta 2
SELECT título, páginas FROM libros
WHERE páginas >= 190 AND páginas <=220
ORDER BY páginas;
#Consulta 3
SELECT count(título) AS n_libros,
    SUM(ejemplares_vendidos) AS total_vendidos,
    AVG(páginas) AS promedio_páginas,
    MIN(anio) AS más_antiguo,
    MAX(ejemplares_vendidos) AS mayor_ejemplares_vendidos
FROM libros;
#Consulta 4
SELECT DISTINCT género
FROM autores
ORDER BY género;
#Consulta 5
SELECT a.nombre, COUNT(*) AS libros_2024
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;
#Consulta 6
SELECT título, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;
#Consulta 7
INSERT INTO libros(id_autor,id_colección,título,páginas,ejemplares_vendidos,anio) VALUES
(3,1,'Papel Mojado',260,50,2024);
SELECT *
FROM libros
WHERE título = 'Papel Mojado';
DELETE FROM libros
WHERE título = 'Papel Mojado';
SELECT *
FROM libros
WHERE título = 'Papel Mojado';
#Consulta 8
SELECT *
FROM libros
WHERE título = 'Cielo de Enero';
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE título = 'Cielo de Enero';
SELECT *
FROM libros
WHERE título = 'Cielo de Enero';
#Consulta 9
SELECT l.título AS título_libro,
       c.título AS título_coleccion, c.fecha_publicación
FROM libros l
JOIN colecciones c ON l.id_colección = c.id_colección
ORDER BY l.id_libro;
#Consulta 10/ Sentencia 1
SELECT a.nombre AS autor, p.fecha_pago, p.monto
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
ORDER BY a.nombre, p.fecha_pago;
#Consulta 10/ Sentencia 2
SELECT a.nombre AS autor,
       SUM(p.monto) AS total_pagado
FROM autores a
LEFT JOIN pagos p ON a.id_autor = p.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;