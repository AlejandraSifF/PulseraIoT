//MODIFIQUE 07/05/25
const express = require('express');

const router = express.Router();

const {
  createReport,
  getReports,
  updateReport
} = require('../controllers/reporte.controller');


// CREAR REPORTE
router.post('/report', createReport);

// OBTENER REPORTES
router.get('/report', getReports);

// ACTUALIZAR REPORTE
router.put('/report/:id', updateReport);

module.exports = router;