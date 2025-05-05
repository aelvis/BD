use prueba;

CREATE TABLE usuario(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL,
    apellido varchar(40) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    celular varchar(100) NOT NULL UNIQUE,
    ciudad VARCHAR(20) NOT NULL DEFAULT 'Chimbote',
    fecha date DEFAULT (CURRENT_DATE),
    edad TINYINT NOT NULL CHECK(edad BETWEEN 1 AND 100)
);

CREATE TABLE direcciones(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL,
    usuario_id INT,
    CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE carreras(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE usuario_carreras(
    id INT PRIMARY KEY AUTO_INCREMENT,
    carreras_id INT NOT NULL,
    usuario_id INT NOT NULL,
    FOREIGN KEY (carreras_id) REFERENCES carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE ciclos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE cursos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(40) NOT NULL,
    ciclos_id INT NOT NULL,
    FOREIGN KEY (ciclos_id) REFERENCES ciclos(id) ON DELETE CASCADE
);

CREATE TABLE usuario_carreras_cursos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    curso_id INT NOT NULL,
    usuario_carreras_id INT NOT NULL,
    FOREIGN KEY (usuario_carreras_id) REFERENCES usuario_carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE CASCADE
);

CREATE TABLE notas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_carreras_cursos_id INT NOT NULL,
    nota1 DECIMAL(5,2) NOT NULL CHECK(nota1 BETWEEN 0 AND 20),
    nota2 DECIMAL(5,2) NOT NULL CHECK(nota2 BETWEEN 0 AND 20),
    nota3 DECIMAL(5,2) NOT NULL CHECK(nota3 BETWEEN 0 AND 20),
    nota4 DECIMAL(5,2) NOT NULL CHECK(nota4 BETWEEN 0 AND 20),
    promedio DECIMAL(5,2) NOT NULL CHECK(promedio BETWEEN 0 AND 20),
    FOREIGN KEY (usuario_carreras_cursos_id) REFERENCES usuario_carreras_cursos(id) ON DELETE CASCADE
);


SELECT * FROM direcciones;
SELECT * FROM ciclos;
SELECT * FROM usuario;
SELECT * FROM carreras;
SELECT * FROM usuario_carreras;
SELECT * FROM cursos;
SELECT * FROM usuario_carreras_cursos;
SELECT * FROM notas;

INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('ELVIS WILSON', 'ALCANTARA PINEDO', 'ealcantara@jwt.com','930607987', 99);
INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('ELVIS WILSON', 'ALCANTARA PINEDO', 'ealcantara2@jwt.com','930607986', 33);
INSERT INTO usuario(nombre, apellido, email, celular, edad, ciudad) VALUES('ELVIS WILSON', 'ALCANTARA PINEDO', 'ealcantara3@jwt.com','930607985', 33, 'Lima');

INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 1', 1);
INSERT INTO direcciones(nombre, usuario_id)  VALUES('DIR 2', 1);
INSERT INTO direcciones(nombre, usuario_id)  VALUES('DIR 1', 3);
INSERT INTO direcciones(nombre, usuario_id)  VALUES('DIR 2', 3);
INSERT INTO direcciones(nombre, usuario_id)  VALUES('DIR 1', 4);
INSERT INTO direcciones(nombre, usuario_id)  VALUES('DIR 2', 4);

DELETE FROM usuario where id = 3;

ALTER TABLE direcciones DROP CONSTRAINT fk_direcciones_usuario;

ALTER TABLE direcciones ADD CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL;

INSERT INTO carreras(nombre) VALUES('INGENIERÍA DE SISTEMAS');
INSERT INTO carreras(nombre) VALUES('ADMINISTRACIÓN DE EMPRESAS');
INSERT INTO carreras(nombre) VALUES('MEDICINA');

INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(1,4);
INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(2,5);
INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(3,6);

INSERT INTO ciclos(nombre) VALUES('I');
INSERT INTO ciclos(nombre) VALUES('II');
INSERT INTO ciclos(nombre) VALUES('III');

INSERT INTO cursos(nombre,ciclos_id) VALUES('INT. ING. DE SISTEMAS', 1);
INSERT INTO cursos(nombre,ciclos_id) VALUES('MATEMÁTICA',1);
INSERT INTO cursos(nombre,ciclos_id) VALUES('COMUNICACIÓN',1);
INSERT INTO cursos(nombre,ciclos_id) VALUES('FUNDAMENTOS DE LA PROGRAMACIÓN', 2);
INSERT INTO cursos(nombre,ciclos_id) VALUES('MATEMÁTICA II',2);
INSERT INTO cursos(nombre,ciclos_id) VALUES('FÍSICA I',2);
INSERT INTO cursos(nombre,ciclos_id) VALUES('ESTRUCTURA DE DATOS',3);

INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(1,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(2,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(3,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(4,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(5,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(6,1);
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(7,1);

DELIMITER $$
CREATE TRIGGER trg_insertar_notas_after 
AFTER INSERT ON usuario_carreras_cursos
FOR EACH ROW
BEGIN
	INSERT INTO notas(nota1, nota2, nota3, nota4, promedio, usuario_carreras_cursos_id) VALUES(0,0,0,0,0, NEW.id);
END $$

DELIMITER $$
CREATE EVENT actualizarPromedio
ON SCHEDULE EVERY 5 SECOND
DO 
BEGIN
	UPDATE notas Set promedio = (IFNULL(nota1, 0) + IFNULL(nota2, 0)+IFNULL(nota3, 0) +IFNULL(nota4, 0))/4;
END $$

UPDATE notas SET nota4= 20 where id = 6;
SELECT * FROM notas;
