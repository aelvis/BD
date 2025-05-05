CREATE TABLE usuario(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(40) NOT NULL,
    apellido varchar2(40) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    celular varchar2(100) NOT NULL UNIQUE,
    ciudad VARCHAR2(20) DEFAULT 'Chimbote',
    fecha date DEFAULT SYSDATE,
    edad NUMBER(3) NOT NULL CHECK(edad BETWEEN 1 AND 100)
);

CREATE TABLE direcciones(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(40) NOT NULL,
    usuario_id NUMBER,
    CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);


CREATE TABLE carreras(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(40) NOT NULL
);

CREATE TABLE usuario_carreras(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    carreras_id NUMBER NOT NULL,
    usuario_id NUMBER NOT NULL,
    FOREIGN KEY (carreras_id) REFERENCES carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE ciclos(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(40) NOT NULL
);

CREATE TABLE cursos(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(40) NOT NULL,
    ciclos_id NUMBER NOT NULL,
    FOREIGN KEY (ciclos_id) REFERENCES ciclos(id) ON DELETE CASCADE
);

CREATE TABLE usuario_carreras_cursos(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    curso_id NUMBER NOT NULL,
    usuario_carreras_id NUMBER NOT NULL,
    FOREIGN KEY (usuario_carreras_id) REFERENCES usuario_carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE CASCADE
);

CREATE TABLE notas(
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    usuario_carreras_cursos_id NUMBER NOT NULL,
    nota1 NUMBER(5,2) NOT NULL CHECK(nota1 BETWEEN 0 AND 20),
    nota2 NUMBER(5,2) NOT NULL CHECK(nota2 BETWEEN 0 AND 20),
    nota3 NUMBER(5,2) NOT NULL CHECK(nota3 BETWEEN 0 AND 20),
    nota4 NUMBER(5,2) NOT NULL CHECK(nota4 BETWEEN 0 AND 20),
    promedio NUMBER(5,2) NOT NULL CHECK(promedio BETWEEN 0 AND 20),
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

INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('RAQUEL', 'ALCANTARA PINEDO', 'ealcantara@jwt.com','930607987', 33);
INSERT INTO usuario(nombre, apellido, email, celular, edad) VALUES('RUFINO', 'ALCANTARA', 'ealcantara2@jwt.com','930607986', 33);
INSERT INTO usuario(nombre, apellido, email, celular, edad, ciudad) VALUES('ELVIS WILSON', 'ALCANTARA PINEDO', 'ealcantara3@jwt.com','930607985', 33, 'Lima');

INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 1', 2);
INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 2', 2);
INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 1', 3);
INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 2', 3);
INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 1', 4);
INSERT INTO direcciones(nombre, usuario_id) VALUES('DIR 2', 4);

DELETE FROM usuario where id = 3;

ALTER TABLE direcciones DROP CONSTRAINT fk_direcciones_usuario;

ALTER TABLE direcciones ADD CONSTRAINT fk_direcciones_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL;

CREATE INDEX idx_direccion_usuario ON direcciones(usuario_id);

SELECT * FROM direcciones where usuario_id = 4;

CREATE INDEX idx_usuario_carreras_1 ON usuario_carreras(usuario_id);
CREATE INDEX idx_usuario_carreras_2 ON usuario_carreras(carreras_id);
CREATE INDEX idx_ciclos_cursos ON cursos(ciclos_id);
CREATE INDEX idx_usuario_carreras_cursos_1 ON usuario_carreras_cursos(usuario_carreras_id);
CREATE INDEX idx_usuario_carreras_cursos_2 ON usuario_carreras_cursos(curso_id);
CREATE INDEX idx_notas ON notas(usuario_carreras_cursos_id);


INSERT INTO carreras(nombre) VALUES('INGENIERÍA DE SISTEMAS');
INSERT INTO carreras(nombre) VALUES('ADMINISTRACIÓN DE EMPRESAS');
INSERT INTO carreras(nombre) VALUES('MEDICINA');

INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(1,4);
INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(2,6);
INSERT INTO usuario_carreras(carreras_id,usuario_id) VALUES(3,5);

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
INSERT INTO usuario_carreras_cursos(curso_id,usuario_carreras_id) VALUES(7,1);


CREATE TRIGGER trg_insertar_promedio_after
AFTER INSERT ON usuario_carreras_cursos
FOR EACH ROW
BEGIN
     INSERT INTO notas(nota1, nota2, nota3, nota4, promedio, usuario_carreras_cursos_id) VALUES(0,0,0,0,0, :NEW.id);
END;

CREATE TRIGGER trg_actualizar_promedio_before
BEFORE UPDATE ON notas
FOR EACH ROW
BEGIN
    IF :NEW.nota1 <> :OLD.nota1 OR :NEW.nota2 <> :OLD.nota2 OR :NEW.nota3 <> :OLD.nota3 OR :NEW.nota4 <> :OLD.nota4 THEN
    :NEW.promedio := (NVL(:NEW.nota1, 0) + NVL(:NEW.nota2, 0) + NVL(:NEW.nota3, 0) + NVL(:NEW.nota4, 0))/4;
    END IF;
END;

UPDATE notas SET nota2=17 where id = 1;

SELECT * FROM cursos;
SELECT * FROM usuario_carreras_cursos;
SELECT * FROM notas;


