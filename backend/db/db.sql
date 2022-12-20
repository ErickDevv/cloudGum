CREATE DATABASE cloudGum;
USE cloudGum;
CREATE TABLE User (
	idUser int UNSIGNED AUTO_INCREMENT NOT NULL,
	User char(8) NOT NULL,
    contrasena char(8) NOT NULL,
    PRIMARY KEY (idUser, User)
);
CREATE TABLE _File(
	idFile int UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre char(32) NOT NULL,
    url TEXT(2048) NOT NULL,
    PRIMARY KEY (idFile, nombre)
);
CREATE TABLE Usuario_Has_Archivo(
	idUser INT UNSIGNED NOT NULL,
    idFile INT UNSIGNED NOT NULL,
    PRIMARY KEY(idUser, idFile),
    FOREIGN KEY (idUser) REFERENCES User (idUser),
    FOREIGN KEY (idFile) REFERENCES _File (idFile)
);
DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION insertar_Usuario (newUser char(8), contrasenaNueva char(8))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT (User) FROM User WHERE User.User = newUser)
		THEN
			BEGIN
				INSERT INTO User (User, contrasena) VALUES (newUser, contrasenaNueva);
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
	IF EXISTS(SELECT (idUser) FROM User as U WHERE U.idUser = idUsuarioEntrante)
		THEN
			BEGIN
				SELECT U.idUser AS ID, U.User AS User, A.nombre AS Nombre, A.url AS URL FROM User AS U
                INNER JOIN Usuario_has_Archivo AS UHA
                ON UHA.idUser = U.idUser
                INNER JOIN _File AS A
                ON A.idFile = UHA.idFile
                WHERE U.idUser = idUsuarioEntrante;
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
	IF NOT EXISTS(SELECT (nombre) FROM _File AS A WHERE A.nombre = nomArchivo)
    THEN
		BEGIN
			INSERT INTO _File (nombre, url) VALUES (nomArchivo, urlEnt);
            RETURN 1;
        END;
	ELSE
		BEGIN
			RETURN 0;
        END;
	END IF;
END$$
DELIMITER ;

