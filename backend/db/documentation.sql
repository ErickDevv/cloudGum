DROP DATABASE cloudGum;

SELECT insert_User('admin2232', '42wmin1');
SELECT insert_User('admin1', '42mi1231');
SELECT insert_User('admin2', '42m1231');
SELECT insert_User('admin3', '42mi41');
SELECT insert_User('admin4', '42mi2');

/*
	The first parameter is the name of the user.
    The second parameter is the password
    Note: Username and password cannot be repeated.
    Possible results:
		0 = Everything was successful
        1 = The user already exists
*/

SELECT insert_file('admin2232', 'FotoHalo2', 'urlEjemplo2');
SELECT insert_file('admin1', 'FotoHalo4', 'urlEjemplo2');
SELECT insert_file('admin2232', 'FotoHalo9', 'urlEjemplo6');
SELECT insert_file('admin2232', 'FotoHalo5', 'urlEjemplo2');
SELECT insert_file('admin2232', 'FotoHalo6', 'urlEjemplo2');

/*
	The first parameter is the owner of the file to be inserted. The user
    The second parameter is the name of the file. Which cannot be repeated.
    The third parameter is the link to the file. Which can be repeated
    Possible results:
		0 = Successful
        1 = The file name already exists
*/

CALL validation_User('admin11');

/*
	The only parameter received is the name of the user.
    you get the user's password, if you get null it means that the user does not exist.
*/

CALL file_User('admin2232');
CALL file_User('admin1');

/*
	The only parameter received is the name of the user.
    You get the files that belong to that user.
*/

SELECT * FROM `User`;
SELECT * FROM `File`;
SELECT * FROM User_Has_File;
SELECT * FROM Relation;

/*
    Everything works correctly, in case of an error when creating the functions you can take a look at:
    https://stackoverflow.com/questions/26015160/deterministic-no-sql-or-reads-sql-data-in-its-declaration-and-binary-logging-i
*/