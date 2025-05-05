CREATE TABLE usuario(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL,
    apellido varchar(40) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    celular varchar(100) NOT NULL UNIQUE,
    ciudad VARCHAR(20) NOT NULL DEFAULT 'Chimbote',
    fecha date DEFAULT GETDATE(),
    edad TINYINT NOT NULL CHECK(edad BETWEEN 1 AND 100)
);

CREATE TABLE direcciones(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL,
    usuario_id INT,
    CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE direcciones(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL,
    usuario_id INT,
    CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL
);

CREATE TABLE carreras(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE usuario_carreras(
    id INT PRIMARY KEY IDENTITY(1,1),
    carreras_id INT NOT NULL,
    usuario_id INT NOT NULL,
    FOREIGN KEY (carreras_id) REFERENCES carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);
CREATE INDEX idx_usuario_carreras_1 ON usuario_carreras(usuario_id);
CREATE INDEX idx_usuario_carreras_2 ON usuario_carreras(carreras_id);

CREATE TABLE ciclos(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE cursos(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40) NOT NULL,
    ciclos_id INT NOT NULL,
    FOREIGN KEY (ciclos_id) REFERENCES ciclos(id) ON DELETE CASCADE
);
CREATE INDEX idx_ciclos_cursos ON cursos(ciclos_id);

CREATE TABLE usuario_carreras_cursos(
    id INT PRIMARY KEY IDENTITY(1,1),
    curso_id INT NOT NULL,
    usuario_carreras_id INT NOT NULL,
    FOREIGN KEY (usuario_carreras_id) REFERENCES usuario_carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE CASCADE,
);
CREATE INDEX idx_usuario_carreras_cursos_1 ON usuario_carreras_cursos(usuario_carreras_id);
CREATE INDEX idx_usuario_carreras_cursos_2 ON usuario_carreras_cursos(curso_id);

CREATE TABLE notas(
    id INT PRIMARY KEY IDENTITY(1,1),
    usuario_carreras_cursos_id INT NOT NULL,
    nota1 DECIMAL(5,2) NOT NULL CHECK(nota1 BETWEEN 0 AND 20),
    nota2 DECIMAL(5,2) NOT NULL CHECK(nota2 BETWEEN 0 AND 20),
    nota3 DECIMAL(5,2) NOT NULL CHECK(nota3 BETWEEN 0 AND 20),
    nota4 DECIMAL(5,2) NOT NULL CHECK(nota4 BETWEEN 0 AND 20),
    promedio DECIMAL(5,2) NOT NULL CHECK(promedio BETWEEN 0 AND 20),
    FOREIGN KEY (usuario_carreras_cursos_id) REFERENCES usuario_carreras_cursos(id) ON DELETE CASCADE,
);
CREATE INDEX idx_notas ON notas(usuario_carreras_cursos_id);

SELECT * FROM direcciones;
SELECT * FROM ciclos;
SELECT * FROM carreras;
SELECT * FROM usuario;
SELECT * FROM usuario_carreras;
SELECT * FROM cursos;
SELECT * FROM usuario_carreras_cursos;
SELECT * FROM notas;

INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('ELVIS WILSON', 'ALCANTARA PINEDO', 'ealcantara@jwt.com','930607987', 33);
INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('RAQUEL', 'ALCANTARA PINEDO', 'ealcantara2@jwt.com','930607986', 33);
INSERT INTO usuario(nombre, apellido, email, celular, edad, ciudad) VALUES('RUFINO', 'ALCANTARA', 'ealcantara3@jwt.com','930607985', 33, 'Lima');

INSERT INTO direcciones VALUES('DIR 1', 5);
INSERT INTO direcciones VALUES('DIR 2', 5);
INSERT INTO direcciones VALUES('DIR 1', 7);
INSERT INTO direcciones VALUES('DIR 2', 7);
INSERT INTO direcciones VALUES('DIR 1', 11);
INSERT INTO direcciones VALUES('DIR 2', 11);

DELETE FROM usuario where id = 7;

ALTER TABLE direcciones DROP CONSTRAINT fk_direcciones_usuario;
ALTER TABLE usuario_carreras DROP CONSTRAINT FK__usuario_c__carre__282DF8C2;
ALTER TABLE usuario_carreras DROP CONSTRAINT FK__usuario_c__usuar__29221CFB;

ALTER TABLE usuario_carreras ADD FOREIGN KEY (carreras_id) REFERENCES carreras(id) ON DELETE CASCADE;
ALTER TABLE usuario_carreras ADD FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE;

SELECT * FROM direcciones where usuario_id = 9;

CREATE INDEX idx_direccion_usuario ON direcciones(usuario_id);

INSERT INTO carreras VALUES('INGENIERÍA DE SISTEMAS');
INSERT INTO carreras VALUES('ADMINISTRACIÓN DE EMPRESAS');
INSERT INTO carreras VALUES('MEDICINA');

INSERT INTO usuario_carreras VALUES(1,10);
INSERT INTO usuario_carreras VALUES(2,9);
INSERT INTO usuario_carreras VALUES(3,11);

INSERT INTO ciclos VALUES('I');
INSERT INTO ciclos VALUES('II');
INSERT INTO ciclos VALUES('III');

INSERT INTO cursos VALUES('INT. ING. DE SISTEMAS', 1);
INSERT INTO cursos VALUES('MATEMÁTICA',1);
INSERT INTO cursos VALUES('COMUNICACIÓN',1);
INSERT INTO cursos VALUES('FUNDAMENTOS DE LA PROGRAMACIÓN', 2);
INSERT INTO cursos VALUES('MATEMÁTICA II',2);
INSERT INTO cursos VALUES('FÍSICA I',2);
INSERT INTO cursos VALUES('ESTRUCTURA DE DATOS', 3);

INSERT INTO usuario_carreras_cursos VALUES(1,2);
INSERT INTO usuario_carreras_cursos VALUES(2,2);
INSERT INTO usuario_carreras_cursos VALUES(3,2);
INSERT INTO usuario_carreras_cursos VALUES(4,2);
INSERT INTO usuario_carreras_cursos VALUES(5,2);
INSERT INTO usuario_carreras_cursos VALUES(6,2);
INSERT INTO usuario_carreras_cursos VALUES(14,2);


CREATE TRIGGER trg_insertar_notas_after 
ON usuario_carreras_cursos
AFTER INSERT
AS 
BEGIN 
    SET NOCOUNT ON;
    INSERT INTO notas(nota1, nota2, nota3, nota4, promedio, usuario_carreras_cursos_id)
    SELECT 0,0,0,0,0, i.id FROM inserted i;
END;

CREATE TRIGGER trg_calcular_promedio_after
ON notas
AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
        UPDATE n
        SET promedio = (ISNULL(i.nota1, 0) + ISNULL(i.nota2, 0) + ISNULL(i.nota3, 0) + ISNULL(i.nota4, 0))/ 4
        FROM notas n
        INNER JOIN inserted i ON n.id = i.id;
END;

UPDATE notas SET nota4 = 16 where id = 2;
SELECT * FROM notas;
