const jwt = require('jsonwebtoken'); // librería de cifrado de token
const validator = require("email-validator"); // librería para validar direcciones de emails
const mail = require('../utils/mail_util'); // importación de la función de envío de mails
// importación del servicio de acceso a la base de datos
const userBd = require('../services/userService');

// función de registro de usuarios nuevos
const register = async (req, res) => {

    // Datos del body de la petición 
    const { name, username, email, password, role } = req.body.user;

    // comprobación del paso de parámetros requeridos
    if (!name || !username || !email || !password || !role) {
        res.status(400).json({ error: 'Rellene todos los campos' });
        return;
    }

    // comprobación de dirección de correo válida
    const checkEmail = validator.validate(email);

    if (!checkEmail) {
        res.status(200).json({invalidMail: 'invalidMail'});
        return;
    }
    // comprobación de dirección de correo existente
    if (await userBd.emailExist(email) > 0) {
        res.status(200).json({mailExist: 'mailExist'})
        return
    }

    if (await userBd.usernameExist(username) > 0) {
        res.status(200).json({ usernameExist: 'usernameExist' })
        return
    }

    // Llamada a la función de registro en la BBDD
    const result = await userBd.saveUser(req.body.user)
    // Si hay un error de servidor
    if (result.code === 500) {
        res.status(500).json({ error: 'No se ha podido registrar el usuario' });
        return;
    }
    // Se construye la respuesta y se envía
    const response = {
        description: 'Registro correcto',
        username,
        role
    }

    res.status(201).json(response);

    // envío del correo de confirmación al usuario
    const message = 'Registro realizado correctamente';
    mail.sendMail(email, message);
}

// función de logueo de usuarios
const login = async (req, res) => {
    const { username, password } = req.body;

    // comprobación del paso de parámetros requeridos
    if (!username || !password) {
        res.status(400).json({ error: 'Rellene todos los campos' });
        // devolución de error por falta de parámetros
        return;
    }

    const result = await userBd.loginUser(username, password);

    if (!result) {
        res.status(401).json({ error: 'Email o contraseña incorrectos' });
        return;
    }

    const { id, role } = result;

    // objeto que almacena el id y el rol de usuario
    const tokenPayload = { userId: id, role: role };

    // creación del token cifrado a partir del objeto anterior y una clave almacenada en el fichero de variables de entorno '.env'
    const token = jwt.sign(tokenPayload, process.env.SECRET, {
        expiresIn: '1d'
    });

    // envío al usruario del token y su id
    res.status(201).json({ token, username, role, id })
}

// exportación de las funciones
module.exports = {
    login,
    register
}
