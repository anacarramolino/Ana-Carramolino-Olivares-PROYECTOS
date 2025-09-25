/* ===========================================================
   PROYECTO: Plataforma de Streaming Musical (MySQL)
   Autor: Tú
   Contenido:
     1) Creación de esquema
     2) Tablas (9)
     3) Inserts de datos (coherentes)
     4) 50 consultas con explicación
   =========================================================== */

-- 1) Creación de la BD
DROP DATABASE IF EXISTS music_streaming;
CREATE DATABASE music_streaming CHARACTER SET utf8mb4;
USE music_streaming;

-- 2) Tablas
-- Nota: claves, FK y tipos pensados para consultas analíticas.

CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  pais VARCHAR(60) NOT NULL,
  fecha_registro DATE NOT NULL
);

CREATE TABLE planes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(60) NOT NULL,
  precio DECIMAL(8,2) NOT NULL,
  descripcion VARCHAR(200) NULL
);

CREATE TABLE suscripciones (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  plan_id INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NULL,
  estado ENUM('activa','vencida','cancelada') NOT NULL DEFAULT 'activa',
  CONSTRAINT fk_sus_usu FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CONSTRAINT fk_sus_plan FOREIGN KEY (plan_id) REFERENCES planes(id)
);

CREATE TABLE artistas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(120) NOT NULL,
  pais VARCHAR(60) NOT NULL,
  genero_principal VARCHAR(40) NOT NULL
);

CREATE TABLE albumes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  artista_id INT NOT NULL,
  titulo VARCHAR(120) NOT NULL,
  fecha_lanzamiento DATE NOT NULL,
  genero VARCHAR(40) NOT NULL,
  CONSTRAINT fk_alb_art FOREIGN KEY (artista_id) REFERENCES artistas(id)
);

CREATE TABLE canciones (
  id INT PRIMARY KEY AUTO_INCREMENT,
  album_id INT NOT NULL,
  titulo VARCHAR(160) NOT NULL,
  duracion_seg INT NOT NULL,
  reproducciones INT NOT NULL DEFAULT 0,
  genero VARCHAR(40) NOT NULL,
  CONSTRAINT fk_can_alb FOREIGN KEY (album_id) REFERENCES albumes(id)
);

CREATE TABLE playlists (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  fecha_creacion DATE NOT NULL,
  CONSTRAINT fk_pl_usu FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla puente N:M
CREATE TABLE playlist_cancion (
  playlist_id INT NOT NULL,
  cancion_id INT NOT NULL,
  fecha_agregado DATE NOT NULL,
  PRIMARY KEY (playlist_id, cancion_id),
  CONSTRAINT fk_pc_pl FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,
  CONSTRAINT fk_pc_can FOREIGN KEY (cancion_id) REFERENCES canciones(id) ON DELETE CASCADE
);

CREATE TABLE historial_reproduccion (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  cancion_id INT NOT NULL,
  fecha_rep DATETIME NOT NULL,
  CONSTRAINT fk_hist_usu FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CONSTRAINT fk_hist_can FOREIGN KEY (cancion_id) REFERENCES canciones(id)
);

CREATE TABLE likes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario_id INT NOT NULL,
  cancion_id INT NOT NULL,
  fecha_like DATE NOT NULL,
  CONSTRAINT fk_like_usu FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CONSTRAINT fk_like_can FOREIGN KEY (cancion_id) REFERENCES canciones(id),
  UNIQUE KEY uq_like (usuario_id, cancion_id) -- evita likes duplicados
);

-- 3) Datos de ejemplo
-- 3.1 Usuarios (15)
INSERT INTO usuarios (nombre,email,pais,fecha_registro) VALUES
('Ana','ana@correo.com','España','2024-01-10'),
('Luis','luis@correo.com','México','2024-01-18'),
('María','maria@correo.com','España','2024-02-05'),
('Pedro','pedro@correo.com','Argentina','2024-02-20'),
('Lucía','lucia@correo.com','Chile','2024-03-01'),
('Jorge','jorge@correo.com','Colombia','2024-03-03'),
('Elena','elena@correo.com','Perú','2024-03-12'),
('Raúl','raul@correo.com','México','2024-03-18'),
('Sofía','sofia@correo.com','España','2024-03-25'),
('Diego','diego@correo.com','México','2024-04-02'),
('Carmen','carmen@correo.com','Colombia','2024-04-11'),
('Iván','ivan@correo.com','Argentina','2024-04-17'),
('Nuria','nuria@correo.com','España','2024-05-01'),
('Pablo','pablo@correo.com','Chile','2024-05-06'),
('Valeria','valeria@correo.com','Perú','2024-05-10');

-- 3.2 Planes (15 sencillos)
INSERT INTO planes (nombre,precio,descripcion) VALUES
('Free',0.00,'Con anuncios'),
('Básico',4.99,'Audio estándar'),
('Premium',9.99,'Alta calidad'),
('Familiar',14.99,'Hasta 6 cuentas'),
('Estudiante',5.99,'Descuento estudiante'),
('HiFi',12.99,'Calidad lossless'),
('Pro',11.99,'Más dispositivos'),
('Duo',12.49,'Para dos personas'),
('Plus',7.99,'Más saltos'),
('Lite',2.99,'Limitado'),
('Gold',15.99,'Beneficios exclusivos'),
('Platinum',19.99,'Todo incluido'),
('Anual',99.99,'Pago anual'),
('Empresas',29.99,'Uso comercial'),
('Promo',3.99,'Oferta temporal');

-- 3.3 Suscripciones (20 mezcladas y con estados)
INSERT INTO suscripciones (usuario_id,plan_id,fecha_inicio,fecha_fin,estado) VALUES
(1,3,'2024-01-10',NULL,'activa'),
(2,2,'2024-01-18','2025-01-18','activa'),
(3,1,'2024-02-05',NULL,'activa'),
(4,4,'2024-02-20',NULL,'activa'),
(5,5,'2024-03-01','2024-09-01','vencida'),
(6,6,'2024-03-03',NULL,'activa'),
(7,7,'2024-03-12',NULL,'cancelada'),
(8,8,'2024-03-18',NULL,'activa'),
(9,9,'2024-03-25','2024-09-25','vencida'),
(10,10,'2024-04-02',NULL,'activa'),
(11,11,'2024-04-11',NULL,'activa'),
(12,12,'2024-04-17',NULL,'activa'),
(13,13,'2024-05-01',NULL,'activa'),
(14,14,'2024-05-06',NULL,'activa'),
(15,15,'2024-05-10','2024-08-10','vencida'),
(1,4,'2025-01-15',NULL,'activa'),
(2,5,'2025-01-18',NULL,'activa'),
(3,3,'2025-02-05',NULL,'activa'),
(4,2,'2025-02-20',NULL,'activa'),
(5,1,'2025-03-01',NULL,'activa');

-- 3.4 Artistas (15)
INSERT INTO artistas (nombre,pais,genero_principal) VALUES
('Luna Nova','España','Pop'),
('Ritmo Urbano','México','HipHop'),
('Cordillera','Chile','Rock'),
('Pacífico Beats','Perú','EDM'),
('Café Andino','Colombia','Latin'),
('El Viajero','Argentina','Rock'),
('Blue Coast','EEUU','Pop'),
('Solaris','España','EDM'),
('Tierra Firme','México','Latin'),
('Nébula','España','Pop'),
('Vector3','EEUU','EDM'),
('La Ruta','Argentina','Rock'),
('Aire Libre','Chile','Pop'),
('Selva Sonora','Colombia','Latin'),
('Nocturna','España','Pop');

-- 3.5 Álbumes (15; 1 por artista, variados)
INSERT INTO albumes (artista_id,titulo,fecha_lanzamiento,genero) VALUES
(1,'Ecos de Luna','2021-05-10','Pop'),
(2,'Barrio Norte','2020-10-01','HipHop'),
(3,'Cumbres','2019-08-15','Rock'),
(4,'Marea','2022-03-03','EDM'),
(5,'Aromas','2020-12-12','Latin'),
(6,'Kilómetros','2018-09-09','Rock'),
(7,'Coastline','2023-01-20','Pop'),
(8,'Photon','2021-11-11','EDM'),
(9,'Raíces','2019-06-06','Latin'),
(10,'Vértigo','2024-04-04','Pop'),
(11,'Vectorial','2023-06-30','EDM'),
(12,'Carretera','2017-07-07','Rock'),
(13,'Brisa','2022-09-09','Pop'),
(14,'Amazonas','2018-01-15','Latin'),
(15,'Insomnio','2024-02-02','Pop');

-- 3.6 Canciones (30; 2 por álbum, duraciones y reproducciones varias)
INSERT INTO canciones (album_id,titulo,duracion_seg,reproducciones,genero) VALUES
(1,'Luz de Noche',210,12000,'Pop'),
(1,'Reflejos',195,8000,'Pop'),
(2,'Calle 13',180,15000,'HipHop'),
(2,'Asfalto',205,7000,'HipHop'),
(3,'Roca y Viento',240,6000,'Rock'),
(3,'Horizonte',230,4000,'Rock'),
(4,'Oleaje',200,22000,'EDM'),
(4,'Marea Alta',215,18000,'EDM'),
(5,'Cumbia del Café',190,9000,'Latin'),
(5,'Sabor Andino',185,5000,'Latin'),
(6,'Kilómetro 0',260,3000,'Rock'),
(6,'Ruta Sur',245,3500,'Rock'),
(7,'Blue Hour',200,26000,'Pop'),
(7,'Seagulls',198,12000,'Pop'),
(8,'Neón',210,14000,'EDM'),
(8,'Fotón',205,16000,'EDM'),
(9,'Raíz y Flor',220,10000,'Latin'),
(9,'Son del Valle',200,6000,'Latin'),
(10,'Vértigo',190,28000,'Pop'),
(10,'Gravedad',205,15000,'Pop'),
(11,'Matriz',210,9000,'EDM'),
(11,'Transform',230,11000,'EDM'),
(12,'Kilómetro Final',240,4500,'Rock'),
(12,'Ruta 40',235,5000,'Rock'),
(13,'Brisa de Mar',205,8000,'Pop'),
(13,'Verano Eterno',210,9500,'Pop'),
(14,'Selva',215,7000,'Latin'),
(14,'Río Amazonas',225,5600,'Latin'),
(15,'Insomnio',200,30000,'Pop'),
(15,'Medianoche',215,17000,'Pop');

-- 3.7 Playlists (15)
INSERT INTO playlists (usuario_id,nombre,fecha_creacion) VALUES
(1,'Favoritas Ana','2024-05-11'),
(2,'Gym Luis','2024-05-12'),
(3,'Pop María','2024-05-12'),
(4,'Rock Pedro','2024-05-13'),
(5,'Latinas Lucía','2024-05-13'),
(6,'EDM Jorge','2024-05-13'),
(7,'Focus Elena','2024-05-14'),
(8,'Roadtrip Raúl','2024-05-15'),
(9,'Relax Sofía','2024-05-16'),
(10,'Novedades Diego','2024-05-17'),
(11,'Café Carmen','2024-05-18'),
(12,'Clásicos Iván','2024-05-18'),
(13,'Descubrir Nuria','2024-05-19'),
(14,'Mañanas Pablo','2024-05-20'),
(15,'Noche Valeria','2024-05-20');

-- 3.8 Playlist_cancion (≥45; variedad de géneros por playlist)
INSERT INTO playlist_cancion (playlist_id,cancion_id,fecha_agregado) VALUES
(1,1,'2024-05-11'),(1,2,'2024-05-11'),(1,19,'2024-05-11'),(1,29,'2024-05-11'),
(2,3,'2024-05-12'),(2,4,'2024-05-12'),(2,20,'2024-05-12'),(2,30,'2024-05-12'),
(3,1,'2024-05-12'),(3,13,'2024-05-12'),(3,19,'2024-05-12'),(3,27,'2024-05-12'),
(4,5,'2024-05-13'),(4,6,'2024-05-13'),(4,23,'2024-05-13'),(4,24,'2024-05-13'),
(5,9,'2024-05-13'),(5,10,'2024-05-13'),(5,17,'2024-05-13'),(5,28,'2024-05-13'),
(6,7,'2024-05-13'),(6,8,'2024-05-13'),(6,16,'2024-05-13'),(6,22,'2024-05-13'),
(7,11,'2024-05-14'),(7,12,'2024-05-14'),(7,6,'2024-05-14'),(7,26,'2024-05-14'),
(8,14,'2024-05-15'),(8,15,'2024-05-15'),(8,25,'2024-05-15'),(8,3,'2024-05-15'),
(9,18,'2024-05-16'),(9,10,'2024-05-16'),(9,2,'2024-05-16'),(9,7,'2024-05-16'),
(10,20,'2024-05-17'),(10,21,'2024-05-17'),(10,29,'2024-05-17'),(10,4,'2024-05-17'),
(11,9,'2024-05-18'),(11,1,'2024-05-18'),(11,7,'2024-05-18'),
(12,5,'2024-05-18'),(12,23,'2024-05-18'),(12,12,'2024-05-18'),
(13,13,'2024-05-19'),(13,27,'2024-05-19'),(13,15,'2024-05-19'),
(14,19,'2024-05-20'),(14,29,'2024-05-20'),(14,8,'2024-05-20'),
(15,30,'2024-05-20'),(15,28,'2024-05-20'),(15,24,'2024-05-20');

-- 3.9 Historial de reproducción (40+)
INSERT INTO historial_reproduccion (usuario_id,cancion_id,fecha_rep) VALUES
(1,1,'2024-06-01 09:00:00'),(1,19,'2024-06-01 09:05:00'),(1,29,'2024-06-02 10:00:00'),
(2,3,'2024-06-01 07:30:00'),(2,4,'2024-06-01 07:34:00'),(2,20,'2024-06-02 08:00:00'),
(3,13,'2024-06-03 11:00:00'),(3,19,'2024-06-03 11:05:00'),(3,27,'2024-06-04 12:00:00'),
(4,5,'2024-06-01 18:00:00'),(4,6,'2024-06-01 18:05:00'),(4,23,'2024-06-02 19:00:00'),
(5,9,'2024-06-02 08:00:00'),(5,10,'2024-06-02 08:04:00'),(5,17,'2024-06-03 08:05:00'),
(6,7,'2024-06-01 22:00:00'),(6,8,'2024-06-01 22:03:00'),(6,16,'2024-06-02 22:00:00'),
(7,11,'2024-06-05 10:00:00'),(7,12,'2024-06-05 10:04:00'),(7,26,'2024-06-06 10:04:00'),
(8,14,'2024-06-01 13:00:00'),(8,15,'2024-06-01 13:03:00'),(8,25,'2024-06-01 13:06:00'),
(9,18,'2024-06-07 16:00:00'),(9,10,'2024-06-07 16:03:00'),(9,7,'2024-06-07 16:06:00'),
(10,20,'2024-06-02 21:00:00'),(10,29,'2024-06-02 21:03:00'),(10,4,'2024-06-03 21:05:00'),
(11,9,'2024-06-02 09:30:00'),(11,1,'2024-06-03 09:31:00'),(11,7,'2024-06-04 09:32:00'),
(12,5,'2024-06-01 06:15:00'),(12,23,'2024-06-01 06:19:00'),(12,12,'2024-06-02 06:20:00'),
(13,13,'2024-06-03 14:00:00'),(13,15,'2024-06-03 14:03:00'),(13,27,'2024-06-04 14:05:00'),
(14,19,'2024-06-05 07:00:00'),(14,29,'2024-06-05 07:03:00'),(14,8,'2024-06-06 07:05:00'),
(15,30,'2024-06-02 23:00:00'),(15,28,'2024-06-02 23:03:00'),(15,24,'2024-06-03 23:05:00');

-- 3.10 Likes (30)
INSERT INTO likes (usuario_id,cancion_id,fecha_like) VALUES
(1,1,'2024-06-01'),(1,19,'2024-06-01'),(1,29,'2024-06-02'),
(2,3,'2024-06-01'),(2,20,'2024-06-02'),(2,30,'2024-06-02'),
(3,13,'2024-06-03'),(3,27,'2024-06-04'),
(4,5,'2024-06-01'),(4,23,'2024-06-02'),
(5,9,'2024-06-02'),(5,10,'2024-06-02'),
(6,7,'2024-06-01'),(6,8,'2024-06-01'),(6,16,'2024-06-02'),
(7,11,'2024-06-05'),
(8,14,'2024-06-01'),(8,15,'2024-06-01'),
(9,18,'2024-06-07'),(9,7,'2024-06-07'),
(10,20,'2024-06-02'),(10,29,'2024-06-02'),
(11,1,'2024-06-03'),
(12,5,'2024-06-01'),(12,12,'2024-06-02'),
(13,15,'2024-06-03'),
(14,8,'2024-06-05'),(14,19,'2024-06-05'),
(15,24,'2024-06-02');



/* ===========================================================
   4) 50 CONSULTAS
   =========================================================== */

-- 1. Canciones con su álbum y artista (INNER JOIN)
SELECT c.id, c.titulo AS cancion, a.titulo AS album, ar.nombre AS artista
FROM canciones c
JOIN albumes a ON c.album_id = a.id
JOIN artistas ar ON a.artista_id = ar.id;
-- Explica: Unimos canción→álbum→artista para ver el contexto completo.

-- 2. Usuarios y el plan actual (LEFT JOIN a suscripciones activas más recientes)
SELECT u.id, u.nombre, p.nombre AS plan
FROM usuarios u
LEFT JOIN (
  SELECT s1.*
  FROM suscripciones s1
  JOIN (
    SELECT usuario_id, MAX(fecha_inicio) AS max_ini
    FROM suscripciones
    WHERE estado='activa'
    GROUP BY usuario_id
  ) x ON x.usuario_id=s1.usuario_id AND x.max_ini=s1.fecha_inicio
) s ON s.usuario_id=u.id
LEFT JOIN planes p ON p.id=s.plan_id;
-- Explica: Tomamos la suscripción activa más reciente por usuario.

-- 3. Playlists por usuario con nº de canciones
SELECT u.nombre, pl.nombre AS playlist, COUNT(pc.cancion_id) AS n_canciones
FROM playlists pl
JOIN usuarios u ON u.id=pl.usuario_id
LEFT JOIN playlist_cancion pc ON pc.playlist_id=pl.id
GROUP BY pl.id;
-- Explica: Contamos entradas en la tabla puente por playlist.

-- 4. Historial con nombre de usuario y canción
SELECT h.id, u.nombre AS usuario, c.titulo AS cancion, h.fecha_rep
FROM historial_reproduccion h
JOIN usuarios u ON u.id=h.usuario_id
JOIN canciones c ON c.id=h.cancion_id
ORDER BY h.fecha_rep DESC
LIMIT 50;
-- Explica: Trazabilidad de reproducciones human-readable.

-- 5. Canciones y si tienen likes + quién dio like
SELECT c.titulo, u.nombre AS usuario_like
FROM canciones c
LEFT JOIN likes l ON l.cancion_id=c.id
LEFT JOIN usuarios u ON u.id=l.usuario_id
ORDER BY c.titulo;
-- Explica: LEFT para mostrar canciones aunque no tengan likes.

-- 6. Usuarios con más de 1 playlist
SELECT u.nombre, COUNT(pl.id) AS playlists
FROM usuarios u
JOIN playlists pl ON pl.usuario_id=u.id
GROUP BY u.id
HAVING COUNT(pl.id) > 1;
-- Explica: Agregación + HAVING.

-- 7. Canciones con más reproducciones que el promedio global
SELECT c.titulo, c.reproducciones
FROM canciones c
WHERE c.reproducciones > (SELECT AVG(reproducciones) FROM canciones)
ORDER BY c.reproducciones DESC;
-- Explica: Comparación contra subquery de promedio.

-- 8. Artistas con al menos un álbum con >3 canciones
SELECT ar.nombre
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
GROUP BY ar.id, a.id
HAVING COUNT(c.id) > 3;
-- Explica: Conteo por álbum; devuelve artista si un álbum supera 3 temas.

-- 9. Usuarios que dieron like a la canción más popular (por reproducciones)
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN likes l ON l.usuario_id=u.id
JOIN canciones c ON c.id=l.cancion_id
WHERE c.id = (SELECT id FROM canciones ORDER BY reproducciones DESC LIMIT 1);
-- Explica: Subquery selecciona la canción top.

-- 10. Canciones reproducidas por >2 usuarios distintos
SELECT c.titulo, COUNT(DISTINCT h.usuario_id) oyentes_unicos
FROM historial_reproduccion h
JOIN canciones c ON c.id=h.cancion_id
GROUP BY c.id
HAVING COUNT(DISTINCT h.usuario_id) > 2;
-- Explica: Distintos usuarios por canción.

-- 11. Top 5 canciones más reproducidas (campo reproducciones)
SELECT titulo, reproducciones
FROM canciones
ORDER BY reproducciones DESC
LIMIT 5;
-- Explica: Ranking por métrica almacenada.

-- 12. Total de likes por artista
SELECT ar.nombre AS artista, COUNT(l.id) AS likes_totales
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
LEFT JOIN likes l ON l.cancion_id=c.id
GROUP BY ar.id
ORDER BY likes_totales DESC;
-- Explica: Agregamos likes a nivel de artista.

-- 13. Promedio de duración por género
SELECT genero, AVG(duracion_seg) AS duracion_media
FROM canciones
GROUP BY genero;
-- Explica: Media de duración por género.

-- 14. Nº de usuarios suscritos por plan (estado activo)
SELECT p.nombre, COUNT(s.id) AS suscriptores_activos
FROM planes p
LEFT JOIN suscripciones s ON s.plan_id=p.id AND s.estado='activa'
GROUP BY p.id
ORDER BY suscriptores_activos DESC;
-- Explica: Conteo de activas por plan.

-- 15. Usuario con más reproducciones en historial
SELECT u.nombre, COUNT(h.id) AS total_reps
FROM usuarios u
JOIN historial_reproduccion h ON h.usuario_id=u.id
GROUP BY u.id
ORDER BY total_reps DESC
LIMIT 1;
-- Explica: Mayor uso efectivo.

-- 16. Las 10 canciones más reproducidas (campo reproducciones)
SELECT titulo, reproducciones
FROM canciones
ORDER BY reproducciones DESC
LIMIT 10;
-- Explica: Ranking extendido.

-- 17. Usuarios con plan ACTIVO (cualquier estado='activa')
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN suscripciones s ON s.usuario_id=u.id
WHERE s.estado='activa';
-- Explica: Detección simple de activos.

-- 18. Playlists con cantidad de canciones
SELECT pl.nombre, COUNT(pc.cancion_id) AS n_canciones
FROM playlists pl
LEFT JOIN playlist_cancion pc ON pc.playlist_id=pl.id
GROUP BY pl.id
ORDER BY n_canciones DESC;
-- Explica: Similar a #3 pero sin usuario.

-- 19. Canciones reproducidas el último mes (ajusta NOW() según pruebas)
SELECT DISTINCT c.titulo
FROM historial_reproduccion h
JOIN canciones c ON c.id=h.cancion_id
WHERE h.fecha_rep >= DATE_SUB(NOW(), INTERVAL 1 MONTH);
-- Explica: Ventana temporal móvil.

-- 20. Usuarios que escucharon un mismo artista >2 veces
SELECT u.nombre, ar.nombre AS artista, COUNT(*) AS veces
FROM historial_reproduccion h
JOIN canciones c ON c.id=h.cancion_id
JOIN albumes a ON a.id=c.album_id
JOIN artistas ar ON ar.id=a.artista_id
JOIN usuarios u ON u.id=h.usuario_id
GROUP BY u.id, ar.id
HAVING COUNT(*) > 2;
-- Explica: Frecuencia por usuario-artista.

-- 21. Canciones con duración mayor al promedio
SELECT titulo, duracion_seg
FROM canciones
WHERE duracion_seg > (SELECT AVG(duracion_seg) FROM canciones);
-- Explica: Comparación con media de duración.

-- 22. Álbum con más reproducciones totales (suma de sus canciones)
SELECT a.titulo, SUM(c.reproducciones) AS total_rep
FROM albumes a
JOIN canciones c ON c.album_id=a.id
GROUP BY a.id
ORDER BY total_rep DESC
LIMIT 1;
-- Explica: Agregación por álbum.

-- 23. Género más popular por reproducciones
SELECT genero, SUM(reproducciones) AS rep
FROM canciones
GROUP BY genero
ORDER BY rep DESC
LIMIT 1;
-- Explica: Suma por género.

-- 24. Usuario con más likes dados
SELECT u.nombre, COUNT(l.id) AS likes_dados
FROM usuarios u
JOIN likes l ON l.usuario_id=u.id
GROUP BY u.id
ORDER BY likes_dados DESC
LIMIT 1;
-- Explica: Actividad social.

-- 25. Canciones nunca reproducidas
SELECT c.titulo
FROM canciones c
LEFT JOIN historial_reproduccion h ON h.cancion_id=c.id
WHERE h.id IS NULL;
-- Explica: Antijoin para detectar 0 uso.

-- 26. Playlists con canciones de >2 géneros diferentes
SELECT pl.nombre, COUNT(DISTINCT c.genero) AS generos
FROM playlists pl
JOIN playlist_cancion pc ON pc.playlist_id=pl.id
JOIN canciones c ON c.id=pc.cancion_id
GROUP BY pl.id
HAVING COUNT(DISTINCT c.genero) > 2;
-- Explica: Diversidad por playlist.

-- 27. Usuarios que escucharon canciones de ≥3 artistas distintos
SELECT u.nombre, COUNT(DISTINCT ar.id) AS artistas_distintos
FROM historial_reproduccion h
JOIN canciones c ON c.id=h.cancion_id
JOIN albumes a ON a.id=c.album_id
JOIN artistas ar ON ar.id=a.artista_id
JOIN usuarios u ON u.id=h.usuario_id
GROUP BY u.id
HAVING COUNT(DISTINCT ar.id) >= 3;
-- Explica: Variedad de escucha.

-- 28. Ranking de artistas por oyentes únicos
SELECT ar.nombre, COUNT(DISTINCT h.usuario_id) AS oyentes_unicos
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
JOIN historial_reproduccion h ON h.cancion_id=c.id
GROUP BY ar.id
ORDER BY oyentes_unicos DESC;
-- Explica: Popularidad por alcance.

-- 29. Plan con mayor ingreso (precio * nº suscriptores activos)
SELECT p.nombre, p.precio * COUNT(s.id) AS ingreso_estimado
FROM planes p
JOIN suscripciones s ON s.plan_id=p.id AND s.estado='activa'
GROUP BY p.id
ORDER BY ingreso_estimado DESC
LIMIT 1;
-- Explica: Métrica económica simple.

-- 30. Canciones agregadas a playlists en los últimos 7 días
SELECT DISTINCT c.titulo
FROM playlist_cancion pc
JOIN canciones c ON c.id=pc.cancion_id
WHERE pc.fecha_agregado >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
-- Explica: Nuevos añadidos.

-- 31. Top 5 artistas por nº de canciones
SELECT ar.nombre, COUNT(c.id) AS n_canciones
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
GROUP BY ar.id
ORDER BY n_canciones DESC
LIMIT 5;
-- Explica: Productividad artística.

-- 32. Álbumes lanzados después de 2020 con su artista
SELECT a.titulo AS album, a.fecha_lanzamiento, ar.nombre AS artista
FROM albumes a
JOIN artistas ar ON ar.id=a.artista_id
WHERE a.fecha_lanzamiento > '2020-12-31'
ORDER BY a.fecha_lanzamiento;
-- Explica: Filtro por fecha de lanzamiento.

-- 33. Usuarios que nunca crearon playlist
SELECT u.nombre
FROM usuarios u
LEFT JOIN playlists pl ON pl.usuario_id=u.id
WHERE pl.id IS NULL;
-- Explica: Antijoin para ausencia de playlists.

-- 34. Canciones que aparecen en >2 playlists
SELECT c.titulo, COUNT(pc.playlist_id) AS en_playlists
FROM canciones c
JOIN playlist_cancion pc ON pc.cancion_id=c.id
GROUP BY c.id
HAVING COUNT(pc.playlist_id) > 2;
-- Explica: Popularidad en curación.

-- 35. Artistas con canciones de >1000 reproducciones
SELECT DISTINCT ar.nombre
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
WHERE c.reproducciones > 1000;
-- Explica: Umbral sencillo (todos cumplen en dataset).

-- 36. Top 3 usuarios con más canciones reproducidas (historial)
SELECT u.nombre, COUNT(h.id) AS total
FROM usuarios u
JOIN historial_reproduccion h ON h.usuario_id=u.id
GROUP BY u.id
ORDER BY total DESC
LIMIT 3;
-- Explica: Engagement de escucha.

-- 37. Playlists con al menos una canción de cada género existente en la BBDD
WITH gen AS (SELECT DISTINCT genero FROM canciones)
SELECT pl.nombre
FROM playlists pl
JOIN playlist_cancion pc ON pc.playlist_id=pl.id
JOIN canciones c ON c.id=pc.cancion_id
GROUP BY pl.id
HAVING COUNT(DISTINCT c.genero) = (SELECT COUNT(*) FROM gen);
-- Explica: Cobertura total de géneros.

-- 38. Usuarios con suscripción vencida
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN suscripciones s ON s.usuario_id=u.id
WHERE s.estado='vencida';
-- Explica: Filtro por estado.

-- 39. Canciones con likes de >3 usuarios diferentes
SELECT c.titulo, COUNT(DISTINCT l.usuario_id) AS usuarios_like
FROM canciones c
JOIN likes l ON l.cancion_id=c.id
GROUP BY c.id
HAVING COUNT(DISTINCT l.usuario_id) > 3;
-- Explica: Popularidad social.

-- 40. Álbumes con duración promedio de sus canciones
SELECT a.titulo AS album, AVG(c.duracion_seg) AS dur_media
FROM albumes a
JOIN canciones c ON c.album_id=a.id
GROUP BY a.id
ORDER BY dur_media DESC;
-- Explica: Caracterización por álbum.

-- 41. Artistas sin ningún álbum
SELECT ar.nombre
FROM artistas ar
LEFT JOIN albumes a ON a.artista_id=ar.id
WHERE a.id IS NULL;
-- Explica: Antijoin (en este dataset no habrá resultados).

-- 42. Usuarios que nunca han dado like
SELECT u.nombre
FROM usuarios u
LEFT JOIN likes l ON l.usuario_id=u.id
WHERE l.id IS NULL;
-- Explica: Inactivos socialmente.

-- 43. Canción más reproducida por cada usuario (en historial)
SELECT t.usuario, t.cancion, t.veces
FROM (
  SELECT u.nombre AS usuario, c.titulo AS cancion,
         COUNT(*) AS veces,
         ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY COUNT(*) DESC) AS rn
  FROM historial_reproduccion h
  JOIN usuarios u ON u.id=h.usuario_id
  JOIN canciones c ON c.id=h.cancion_id
  GROUP BY u.id, c.id
) t
WHERE t.rn=1;
-- Explica: Window function para elegir la top por usuario.

-- 44. Top 5 canciones más agregadas a playlists
SELECT c.titulo, COUNT(pc.playlist_id) AS veces
FROM canciones c
JOIN playlist_cancion pc ON pc.cancion_id=c.id
GROUP BY c.id
ORDER BY veces DESC, c.titulo
LIMIT 5;
-- Explica: Popularidad en playlists.

-- 45. Plan con menor nº de usuarios suscritos (activos)
SELECT p.nombre, COUNT(s.id) AS suscriptores
FROM planes p
LEFT JOIN suscripciones s ON s.plan_id=p.id AND s.estado='activa'
GROUP BY p.id
ORDER BY suscriptores ASC, p.nombre
LIMIT 1;
-- Explica: Extremo inferior del ranking de planes.

-- 46. Canciones reproducidas por usuarios de un país (ej. México)
SELECT DISTINCT c.titulo
FROM historial_reproduccion h
JOIN usuarios u ON u.id=h.usuario_id
JOIN canciones c ON c.id=h.cancion_id
WHERE u.pais='México';
-- Explica: Filtro por origen del usuario.

-- 47. Artistas cuyo género principal coincide con el género más popular (por reproducciones)
WITH top_gen AS (
  SELECT genero
  FROM canciones
  GROUP BY genero
  ORDER BY SUM(reproducciones) DESC
  LIMIT 1
)
SELECT ar.nombre, ar.genero_principal
FROM artistas ar
JOIN top_gen tg ON tg.genero = ar.genero_principal;
-- Explica: Matching contra el género top.

-- 48. Usuarios con al menos una playlist con >5 canciones
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN playlists pl ON pl.usuario_id=u.id
JOIN playlist_cancion pc ON pc.playlist_id=pl.id
GROUP BY u.id, pl.id
HAVING COUNT(pc.cancion_id) > 5;
-- Explica: Umbral por playlist.

-- 49. Usuarios que comparten canciones en común en sus playlists
SELECT u1.nombre AS usuario_a, u2.nombre AS usuario_b, COUNT(*) AS canciones_en_comun
FROM playlist_cancion pc1
JOIN playlists pl1 ON pl1.id=pc1.playlist_id
JOIN playlist_cancion pc2 ON pc2.cancion_id=pc1.cancion_id
JOIN playlists pl2 ON pl2.id=pc2.playlist_id
JOIN usuarios u1 ON u1.id=pl1.usuario_id
JOIN usuarios u2 ON u2.id=pl2.usuario_id
WHERE u1.id < u2.id
GROUP BY u1.id, u2.id
HAVING COUNT(*) > 0
ORDER BY canciones_en_comun DESC;
-- Explica: Autounión sobre la tabla puente para detectar intersecciones.

-- 50. Artistas con canciones en playlists de >5 usuarios distintos
SELECT ar.nombre, COUNT(DISTINCT pl.usuario_id) AS usuarios_distintos
FROM artistas ar
JOIN albumes a ON a.artista_id=ar.id
JOIN canciones c ON c.album_id=a.id
JOIN playlist_cancion pc ON pc.cancion_id=c.id
JOIN playlists pl ON pl.id=pc.playlist_id
GROUP BY ar.id
HAVING COUNT(DISTINCT pl.usuario_id) > 5
ORDER BY usuarios_distintos DESC;
-- Explica: Alcance del artista a través de playlists de muchos usuarios.

/* ===========================
   FIN DEL SCRIPT
   =========================== */
