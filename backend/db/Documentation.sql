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
		1 = Everything was successful
        2 = Password already exists
        3 = The user already exists
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
		1 = Successful
        2 = The file name already exists
        3 = The record already exists
*/

SELECT validation_User('admin1', '42mi1231');

/*
	The first parameter is the user
    As a second parameter the password is received
    Possible results:
		1 = You have access!
        0 = Incorrect user or password!
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