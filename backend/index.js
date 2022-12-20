const express = require('express');
const uploadFile = require('./middleware/multer');
const cors = require('cors');

const app = express();
const port = 5050;

app.use(express.json());

app.use(cors({origin: '*'}));

app.post('/upload',uploadFile(), function (req, res) {
    if (!req.file) {
        res.send('No file uploaded');
    }else if (req.file) {
        res.send('File uploaded successfully');
    }
});

app.listen(port, () => {
    console.log(`Servidor funcionando en el puerto: ${port}.`);
});

app.use(express.static('./build'));