CREATE DATABASE cloudGum;

USE `cloudGum`;
CREATE TABLE `cloudGum`.`User`  (
	idUser int UNSIGNED AUTO_INCREMENT NOT NULL,
	`user` char(16) NOT NULL,
    `password` char(16) NOT NULL UNIQUE,
    PRIMARY KEY (idUser)
);
USE `cloudGum`;
CREATE TABLE `cloudGum`.`File`(
	idFile int UNSIGNED AUTO_INCREMENT NOT NULL,
    `name` char(32) UNIQUE NOT NULL,
    url TEXT(2048) NOT NULL,
    PRIMARY KEY (idFile)
);
USE `cloudGum`;
CREATE TABLE `cloudGum`.`User_Has_File`(
	idUser INT UNSIGNED,
    idFile INT UNSIGNED UNIQUE,
    FOREIGN KEY (idUser) REFERENCES `User` (idUser),
    FOREIGN KEY (idFile) REFERENCES `File` (idFile)
);
USE `cloudGum`;
CREATE TABLE `cloudGum`.`Relation`(
	`name` CHAR(16),
	idNew INT
);

USE `cloudGum`;
DROP function IF EXISTS `insert_User`;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insert_User` (newUser char(16), newPassword char(16))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT `user` FROM `User` AS U WHERE U.`user` = newuser)
		THEN
			BEGIN
				IF NOT EXISTS(SELECT `password` FROM `User` AS U WHERE U.`password` = newPassword)
					THEN
						BEGIN
							INSERT INTO `User` (`user`, `password`) VALUES (newUser, newPassword);
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

USE `cloudGum`;
DROP function IF EXISTS `insert_File`;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insert_File` (`owner` CHAR(16), nameFile CHAR(32), newUrl TEXT(2048))
RETURNS INTEGER
BEGIN
	IF NOT EXISTS(SELECT idFile FROM `File` as F WHERE F.`name` = nameFile AND F.url = newUrl)
		THEN
			BEGIN
                IF NOT EXISTS(SELECT idFile FROM `File` AS F WHERE F.`name` = namefile)
					THEN
						BEGIN
							INSERT INTO `File` (`name`, url) VALUES (nameFile, newUrl);
                
							INSERT INTO Relation (`name`, idNew) VALUES (`owner`, LAST_INSERT_ID());
                
							INSERT INTO User_Has_File (idUser, idFile) 
							SELECT U.idUser, R.idNew FROM `User` AS U
							INNER JOIN Relation AS R
							ON R.`name` = U.`user`
							WHERE R.`name` = `owner` AND R.idNew = LAST_INSERT_ID();
                
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

USE `cloudGum`;
DROP function IF EXISTS `validation_User`;

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

USE `cloudGum`;
DROP function IF EXISTS `file_User`;

DELIMITER $$
USE `cloudGum`$$
CREATE PROCEDURE `file_User` (in inUser CHAR(16))
BEGIN
	SELECT U.`user` AS Usuario, F.`name` AS Nombre, F.url AS URL FROM `User` AS U
	INNER JOIN User_Has_File AS UHF
	ON UHF.idUser = U.idUser
	INNER JOIN `File` AS F
	ON F.idFile = UHF.idFile
	WHERE U.`user` = inUser;
END$$
DELIMITER ;

/*
USE `cloudGum`;
SET GLOBAL event_scheduler = 1;

CREATE EVENT clear_Trmporal_Records
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO TRUNCATE TABLE Relation;

https://stackoverflow.com/questions/26767899/mysql-event-scheduler-grant-super-privileges-not-working
*/