const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();

app.use(function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', '*');
    next();
});

app.use(bodyParser.json());

const PUERTO = 8080;

const conexion = mysql.createConnection(
    {
        host: 'localhost',
        database: 'services',
        user: 'root',
        password: ''
    }
);

app.listen(PUERTO, () => {
    console.log(`Servidor corriendo en el puerto ${PUERTO}`);
});

conexion.connect(error => {
    if (error) throw error;
    console.log('Conexión exitosa a la base de datos');
});

app.get('/', (req, res) => {
    res.send('API');
});

// Ruta para obtener todos los usuarios
app.get('/users', (req, res) => {
    const query = 'SELECT * FROM users;';
    conexion.query(query, (error, resultado) => {
        if (error) return console.error(error.message);

        if (resultado.length > 0) {
            res.json(resultado); // Solo envía la lista de usuarios
        } else {
            res.json([]); // Envía un array vacío si no hay registros
        }
    });
});

// Ruta para obtener un usuario por ID
app.get('/users/:id', (req, res) => {
    const { id } = req.params;
    const query = `SELECT * FROM users WHERE id_user=${id};`;
    conexion.query(query, (error, resultado) => {
        if (error) return console.error(error.message);

        if (resultado.length > 0) {
            res.json(resultado); // Solo envía la lista de usuarios
        } else {
            res.json([]); // Envía un array vacío si no hay registro
        }
    });
});

// Ruta para agregar un usuario
app.post('/users', (req, res) => {
    const usuario = {
        username: req.body.username,
        lastname: req.body.lastname,
        email: req.body.email,
        password: req.body.password,
        rol: req.body.rol
    };

    const query = 'INSERT INTO users SET ?';
    conexion.query(query, usuario, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al agregar el usuario" });
        } else {
            res.status(200).json({ mensaje: "Se insertó correctamente el usuario" });
        }
    });
});

// Ruta para actualizar un usuario por ID
app.put('/users/:id', (req, res) => {
    const { id } = req.params;
    const {
        username,
        lastname,
        email,
        password,
        rol
    } = req.body;

    const query = `UPDATE users SET
        username='${username}',
        lastname='${lastname}',
        email='${email}',
        password='${password}',
        rol='${rol}'
        WHERE id_user=${id};`;

    conexion.query(query, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al actualizar el usuario" });
        } else {
            res.status(200).json({ mensaje: "Se actualizó correctamente el usuario" });
        }
    });
});

// Ruta para eliminar un usuario por ID
app.delete('/users/:id', (req, res) => {
    const { id } = req.params;

    const query = `DELETE FROM users WHERE id_user=${id};`;
    conexion.query(query, (error) => {
        if (error) {
            console.error(error.message);
            res.status(500).json({ mensaje: "Error al eliminar el usuario" });
        } else {
            res.status(200).json({ mensaje: "Se eliminó correctamente el usuario" });
        }
    });
});
