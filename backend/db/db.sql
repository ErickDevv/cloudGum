CREATE DATABASE cloudGum;

/*
SET GLOBAL log_bin_trust_function_creators = 1;
*/

USE `cloudGum`;
CREATE TABLE `cloudGum`.`User`  (
	idUser int UNSIGNED AUTO_INCREMENT NOT NULL,
	`user` char(32) NOT NULL UNIQUE,
    `password` char(128) NOT NULL,
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
	`name` CHAR(32),
	idNew INT
);

USE `cloudGum`;
DROP function IF EXISTS `insert_User`;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insert_User` (newUser char(32), newPassword char(128))
RETURNS INTEGER
READS SQL DATA
DETERMINISTIC
BEGIN
	IF NOT EXISTS(SELECT `user` FROM `User` AS U WHERE U.`user` = newuser)
		THEN
			BEGIN
				INSERT INTO `User` (`user`, `password`) VALUES (newUser, newPassword);
				RETURN 0;
            END;
		ELSE
			BEGIN
				RETURN 1;
            END;
		END IF;
END$$
DELIMITER ;

USE `cloudGum`;
DROP function IF EXISTS `insert_File`;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `insert_File` (`owner` CHAR(32), nameFile CHAR(32), newUrl TEXT(2048))
RETURNS INTEGER
READS SQL DATA
DETERMINISTIC
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
                
							DELETE FROM Relation AS R WHERE R.`name` = `owner`;
                
							RETURN 0;
                        END;
					ELSE
						BEGIN
							RETURN 1;
                        END;
					END IF;
END$$
DELIMITER ;

USE `cloudGum`;
DROP function IF EXISTS `validation_User`;

DELIMITER $$
USE `cloudGum`$$
CREATE FUNCTION `validation_User` (`user` CHAR(32), `password` CHAR(128))
RETURNS INTEGER
READS SQL DATA
DETERMINISTIC
BEGIN
	IF EXISTS(SELECT * FROM `User` AS U WHERE U.`user` = `user` AND U.`password` = `password`)
		THEN
			BEGIN
				RETURN 0;
            END;
		ELSE
			BEGIN
				RETURN 1;
            END;
		END IF;
END$$
DELIMITER ;

USE `cloudGum`;
DROP function IF EXISTS `file_User`;

DELIMITER $$
USE `cloudGum`$$
CREATE PROCEDURE `file_User` (in inUser CHAR(32))
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
SET GLOBAL event_scheduler = ON;

CREATE EVENT clear_Trmporal_Records
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO TRUNCATE TABLE Relation;

https://stackoverflow.com/questions/26767899/mysql-event-scheduler-grant-super-privileges-not-working
*/


/*
    Everything works correctly, in case of an error when creating the functions you can take a look at:
    https://stackoverflow.com/questions/26015160/deterministic-no-sql-or-reads-sql-data-in-its-declaration-and-binary-logging-i
*/