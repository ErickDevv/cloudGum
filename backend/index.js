const express = require('express');
const uploadFile = require('./middleware/multer');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const mysql = require('mysql');

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
    return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET
    );
}

app.post('/login', async (req, res) => {

    const { user, password } = req.body;

    db.query(`CALL validation_User('${user}');`, (error, results) => {
        if (error) {
            throw error;
        } else if (objToArr(results[0]).length === 0) {
            res.status(400).send('Incorrect user or password.');
        } else {
            const hashedPassword = objToArr(results[0])[0].password;
            bcrypt.compare(password, hashedPassword, (error, result) => {
                if (result) {
                    const accessToken = generateAccessToken({ user: user });
                    res.status(200).json({ message: "User logged in.", accessToken });
                } else {
                    res.status(400).send('Incorrect user or password.');
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
            const accessToken = generateAccessToken({ user: user });
            res.status(200).json({ message: "User created", accessToken });
        }
    });
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.use(express.static('./build'));