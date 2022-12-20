CREATE DATABASE cloudGum;
USE cloudGum;
CREATE TABLE Usuario (
	idUsuario int UNSIGNED AUTO_INCREMENT NOT NULL,
	usuario char(8) NOT NULL,
    contrasena char(8) NOT NULL,
    PRIMARY KEY (idUsuario, usuario)
);
CREATE TABLE Archivo(
	idArchivo int UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre char(32) NOT NULL,
    url TEXT(2048) NOT NULL,
    PRIMARY KEY (idArchivo, nombre)
);
CREATE TABLE Usuario_Has_Archivo(
	idUsuario INT UNSIGNED NOT NULL,
    idArchivo INT UNSIGNED NOT NULL,
    PRIMARY KEY(idUsuario, idArchivo),
    FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario),
    FOREIGN KEY (idArchivo) REFERENCES Archivo (idArchivo)
);
DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION insertar_Usuario (usuarioNuevo char(8), contrasenaNueva char(8))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT (usuario) FROM Usuario WHERE Usuario.Usuario = usuarioNuevo)
		THEN
			BEGIN
				INSERT INTO Usuario (usuario, contrasena) VALUES (usuarioNuevo, contrasenaNueva);
                RETURN 1;
            END;
		ELSE
			BEGIN
				RETURN 0;
            END;
		END IF;
END$$
DELIMITER ;
DELIMITER $$
USE `cloudGum`$$
CREATE PROCEDURE `archivos_Usuario` (in idUsuarioEntrante int)
BEGIN
	IF EXISTS(SELECT (idUsuario) FROM Usuario as U WHERE U.idUsuario = idUsuarioEntrante)
		THEN
			BEGIN
				SELECT U.idUsuario AS ID, U.usuario AS Usuario, A.nombre AS Nombre, A.url AS URL FROM Usuario AS U
                INNER JOIN Usuario_has_Archivo AS UHA
                ON UHA.idUsuario = U.idUsuario
                INNER JOIN Archivo AS A
                ON A.idArchivo = UHA.idArchivo
                WHERE U.idUsuario = idUsuarioEntrante;
            END;
		ELSE
			BEGIN
            
            END;
	END IF;
END$$
DELIMITER ;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insertar_Archivos` (nomArchivo char(32), urlEnt TEXT(2048))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT (nombre) FROM Archivo AS A WHERE A.nombre = nomArchivo)
    THEN
		BEGIN
			INSERT INTO Archivo (nombre, url) VALUES (nomArchivo, urlEnt);
            RETURN 1;
        END;
	ELSE
		BEGIN
			RETURN 0;
        END;
	END IF;
END$$
DELIMITER ;

