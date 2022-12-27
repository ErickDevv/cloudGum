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

app.get('/login', async (req, res) => {

    const { user, password } = req.body;

    db.query(`SELECT validation_User('${user}', '${password}');`, (error, results) => {
        if (error) {
            throw error;
        } else if (objToArr(results[0])[0] === 0) {
            res.status(400).send('Wrong username or password.');
        } else if (objToArr(results[0])[0] === 1) {
            const accessToken = generateAccessToken({ user: user });
            res.json({ accessToken });
        } else {
            res.status(400).send('Error at login.');
        }
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.use(express.static('./build'));