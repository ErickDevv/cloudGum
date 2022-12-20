const multer = require('multer');

const uploadFile = () => {
    const storage = multer.diskStorage({
        destination: "./uploads",
        filename: function (req, file, cb) {
            const extention = file.originalname.split('.')[1];
            cb(null, Date.now() + '.' + extention)
        }
    })

    const upload = multer({ storage: storage }).single('file');
    
    return upload
}

module.exports = uploadFile;

