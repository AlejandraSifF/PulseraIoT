const express = require('express');
const router = express.Router();

const authJWT = require('../middleware/authJWT');

const {
  guardarVitales,
  obtenerHistorial
} = require('../controllers/vitals.controller');


// GUARDAR UNA MEDICIÓN: 

router.post('/', authJWT, guardarVitales);


// OBTENER HISTORIAL DEL USUARIO:

router.get('/', authJWT, obtenerHistorial);


module.exports = router;