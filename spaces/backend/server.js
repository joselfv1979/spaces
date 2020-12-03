require('dotenv').config(); // librería para configurar las variables de entorno guardadas en el archivo .env

const path = require('path'); // librería para trabajar con rutas de archivos y directorios
const bodyParser = require('body-parser'); // librería de parseo de datos a json
const cors = require('cors'); // librería para configurar CORS
const express = require('express'); // librería para crear el entorno de servidor express
const fs = require('fs'); // librería para trabajar con ficheros
const morgan = require('morgan'); // librería para crear el middleware de loggs 
const multer = require('multer')

const uuid = require('uuid')

const userRouter = require('./routes/users'); // variables que almacenan los módulos de los endpoint enrutados
const profileRouter = require('./routes/profiles');
const spaceRouter = require('./routes/spaces');
const bookRouter = require('./routes/books');

// CONFIGURACIÓN DEL ALMACENAMIENTO DE IMÁGENES
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './../frontend/public/images/')
    },
    filename(req, file, cb) {
        cb(null, uuid.v4() + path.extname(file.originalname));
    }
})

const upload = multer({
    storage: storage,
    fileFilter: function (req, file, callback) {
        var ext = path.extname(file.originalname);
        if (ext !== '.png' && ext !== '.jpg' && ext !== '.gif' && ext !== '.jpeg') {
            return callback(new Error('Only images are allowed'))
        }
        callback(null, true)
    }
})

const port = process.env.PORT; // puerto de la aplicación

const app = express(); // creación del servidor

const accessLogStream = fs.createWriteStream(path.join(__dirname, './logs/access.log'), { flags: 'a' });
// middleware de registro de logs en un archivo creado en el directorio 'logs' y por consola
app.use(morgan('combined', { stream: accessLogStream }))
app.use(morgan('dev'));
app.use(bodyParser.json()); // middleware de parseo
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors()); // middleware de habilitación de CORS

app.use('/users', userRouter);  // middlewares de enrutamiento
app.use('/profiles', profileRouter);
app.use('/spaces', spaceRouter);
app.use('/books', bookRouter);

// Endpoint para subir imágenes al servidor
app.post('/upload', upload.single('images'), (req, res) => {
    const { path, filename } = req.file
    const file = req.file
    console.log(filename);
    console.log(path);
    if (!file) {
        const error = new Error('Please upload a file')
        error.httpStatusCode = 400
        return next(error)
    }
    res.send(filename)
})

// middleware que gestiona los errores generados
app.use((error, req, res, next) => {
    res
        .status(error.status || 500)
        .send({ status: 'error', message: error.message })
})

// inicialización del servidor
app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});
