const express = require('express');
const uploadFile = require('./middleware/multer');

const app = express();
const port = 5050;


app.post('/upload',uploadFile(), function (req, res) {
    res.send('File uploaded successfully');
});

app.listen(port, () => {
    console.log(`Servidor funcionando en el puerto: ${port}.`);
});

app.use(express.static('./build'));