const express = require('express');
const fileUpload = require('express-fileupload')
const app = express();
const ip = ''
const port = 5050;

var path = require('path');


app.use(fileUpload())

app.use(express.static(path.join(__dirname, 'build')));

app.listen(port, ip, () => {
    console.log(`Servidor funcionando en el puerto: ${port}.`);
});

app.post('/upload', function (req, res) {

    if (req.files && Object.keys(req.files).length !== 0) {

        const uploadedFile = req.files.sampleFile;

        const uploadPath = __dirname
            + "/uploads/" + uploadedFile.name;

        uploadedFile.mv(uploadPath, function (err) {
            if (err) {
                console.log(err);
                res.send("Error.");
            } else res.send("Subida exitosa.");
        });
    } else res.send("Error.");

});


