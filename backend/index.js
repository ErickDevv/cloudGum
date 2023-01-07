const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const mysql = require('mysql');
const multer = require('multer');

require('dotenv').config()

const db = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
});

db.connect(error => {
    if (error) {
        throw error;
    } else {
        console.log('MySQL Connected');
    }
});

const app = express();
const port = process.env.PORT || 5050;

app.use(express.json());

app.use(cors({ origin: '*' }));

objToArr = (obj) => {
    let arr = [];
    for (let key in obj) {
        arr.push(obj[key]);
    }
    return arr;
}

generateAccessToken = (user) => {
    return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET);
}

const isAuthenticated = (req, res, next) => {
    const token = req.headers['x-access-token'];
    if (token == null) return res.sendStatus(401);
    else {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, function (err, decoded) {
            if (err) {
                res.status(401).send({ auth: false, message: 'Failed to authenticate.' });
            } else {
                req.user = decoded;
                next();
            }
        })
    }
}

app.get('/getFiles', isAuthenticated, (req, res) => {
    const user = req.user;
    db.query(`CALL file_user('${user}');`, (error, results) => {
        if (error) {
            throw error;
        } else {
            let arr = [];
            let arrGen = objToArr(results[0]);
            objToArr(arrGen).forEach(element => {
                arr.push(objToArr(element)[1]);
            });
            res.json(arr);
        }
    });
});

app.post('/download', isAuthenticated, (req, res) => {
    const user = req.user;

    const { fileName } = req.body;

    const path = './uploads/' + user + '/' + fileName;

    res.download(path, fileName, function (err) {
        if (err) {
            res.status(500).send({ message: "Error downloading file." });
        }
    });
});

const upload = (req, res, next) => {
    const user = req.user;

    const storage = multer.diskStorage({

        destination: "./uploads/" + user,

        filename: function (req, file, cb) {
            const extention = file.originalname.split('.')[1];
            cb(null, Date.now() + '.' + extention)
        }
    })

    const upload = multer({ storage: storage }).single('file');
    upload(req, res, function (err) {
        if (err instanceof multer.MulterError) {
            res.status(500).send({ message: "Error uploading file." });
        } else if (err) {
            res.status(500).send({ message: "Error uploading file." });
        } else {
            next();
        }
    });
}


app.post('/upload', isAuthenticated, upload, (req, res) => {
    const user = req.user;

    const fileName = req.file.filename;

    const path = req.file.path;

    const query = `select insert_File('${user}', '${fileName}', '${path}');`;

    db.query(query, (error, results) => {
        if (error) {
            throw error;
        } else {
            res.status(200).send({ message: "File uploaded." });
        }
    }
    );
});

app.post('/login', async (req, res) => {

    const { user, password } = req.body;

    db.query(`CALL validation_User('${user}');`, (error, results) => {
        if (error) {
            throw error;
        } else if (objToArr(results[0]).length === 0) {
            res.status(400).send({ message: "Incorrect user or password." });
        } else {
            const hashedPassword = objToArr(results[0])[0].password;
            bcrypt.compare(password, hashedPassword, (error, result) => {
                if (result) {
                    const accessToken = generateAccessToken(user);
                    res.status(200).json({ message: "User logged in.", accessToken });
                } else {
                    res.status(400).send({ message: "Incorrect user or password." });
                }
            });
        }
    });
});

app.post('/register', async (req, res) => {

    const { user, password } = req.body
    const salt = await bcrypt.genSalt();
    const hashedPassword = await bcrypt.hash(password, salt);

    db.query(`SELECT insert_User('${user}', '${hashedPassword}');`, (error, results) => {
        if (error) {
            throw error;
        } else if (objToArr(results[0])[0] === 1) {
            res.send({ message: "User already exists." });
        }
        else if (objToArr(results[0])[0] === 0) {
            const accessToken = generateAccessToken(user);
            res.status(200).json({ message: "User created", accessToken });
        }
    });
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.use(express.static('./build'));