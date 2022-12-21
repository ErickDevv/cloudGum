CREATE DATABASE cloudGum;

USE cloudGum;

CREATE TABLE `User` (
	idUser int UNSIGNED AUTO_INCREMENT NOT NULL,
	`user` char(16) NOT NULL,
    `password` char(16) NOT NULL,
    PRIMARY KEY (idUser, `password`)
);
CREATE TABLE `File`(
	idFile int UNSIGNED AUTO_INCREMENT NOT NULL,
    `name` char(32) NOT NULL,
    url TEXT(2048) NOT NULL,
    PRIMARY KEY (idFile, `name`)
);
CREATE TABLE User_Has_File(
	idUser INT UNSIGNED NOT NULL,
    idFile INT UNSIGNED NOT NULL,
    PRIMARY KEY(idUser, idFile),
    FOREIGN KEY (idUser) REFERENCES `User` (idUser),
    FOREIGN KEY (idFile) REFERENCES `File` (idFile)
);

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insert_User` (newUser char(16), newPassword char(16))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT (`user`) FROM `User` AS U WHERE U.`user` = newUser)
		THEN
			BEGIN
				INSERT INTO `User` (`user`, `password`) VALUES (newUser, newPassword);
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
CREATE FUNCTION `insert_File` (newFile char(32), newUrl TEXT(2048))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT (`name`) FROM `File` AS F WHERE F.`name` = newFile and F.url = newUrl)
    THEN
		BEGIN
			INSERT INTO Archivo (`name`, url) VALUES (newFile, newUrl);
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
CREATE FUNCTION `validation_User` (`user` CHAR(16), `password` CHAR(16))
RETURNS INTEGER
BEGIN
	IF EXISTS(SELECT * FROM `User` AS U WHERE U.`user` = `user` AND U.`password` = `password`)
		THEN
			BEGIN
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
CREATE FUNCTION `assig_File` (idUser int, idFile int)
RETURNS INTEGER
BEGIN
	IF (EXISTS(SELECT idUser FROM `User` AS U WHERE U.idUser = idUser) 
		AND EXISTS(SELECT idFile FROM `File` AS F WHERE F.idFile = idFile))
		THEN
			BEGIN
				IF NOT EXISTS(SELECT idUser FROM User_Has_File as UHF WHERE UHF.idUser = idUser AND UHF.idFile = idFile)
					THEN
						BEGIN
							INSERT INTO User_Has_File (idUser, idFile) VALUES (idUser, idFile);
                            RETURN 1;
                        END;
					ELSE
						BEGIN
							RETURN 2;
                        END;
					END IF;
            END;
		ELSE
			BEGIN
				RETURN 3;
            END;
		END IF;
END$$
DELIMITER ;

DELIMITER $$
USE `cloudGum`$$
CREATE PROCEDURE `file_User` (in inUser CHAR(16))
BEGIN
	IF EXISTS(SELECT (`user`) FROM `User` as U WHERE U.`user` = inUser)
		THEN
			BEGIN
				SELECT U.idUser AS ID, U.`user` AS Usuario, F.`name` AS Nombre, F.url AS URL FROM `User` AS U
                INNER JOIN User_Has_File AS UHF
                ON UHF.idUser = U.idUser
                INNER JOIN `File` AS F
                ON F.idFile = UHF.idFile
                WHERE U.`user` = inUser;
            END;
		ELSE
			BEGIN
            
            END;
	END IF;
END$$
DELIMITER ;