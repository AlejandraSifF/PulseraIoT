//MODIFIQUE 07/05/25
const Report = require('../models/Reporte');


// CREAR REPORTE
const createReport = async (req, res) => {

  try {

    const {
      usuarioId,
      tipoProblema,
      descripcion
    } = req.body;

    const report = new Report({
      usuarioId,
      tipoProblema,
      descripcion
    });

    await report.save();

    res.status(201).json({
      success: true,
      message: 'Reporte enviado correctamente',
      report
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: 'Error al crear reporte',
      error: error.message
    });

  }
};


// OBTENER REPORTES
const getReports = async (req, res) => {

  try {

    const reports = await Report.find()
      .populate('usuarioId', 'name email');

    res.status(200).json(reports);

  } catch (error) {

    res.status(500).json({
      message: 'Error al obtener reportes'
    });

  }

};


// ACTUALIZAR ESTADO
const updateReport = async (req, res) => {

  try {

    const { estado } = req.body;

    const report = await Report.findByIdAndUpdate(
      req.params.id,
      { estado },
      {
        returnDocument: 'after'
      }
    );

    res.status(200).json(report);

  } catch (error) {

    res.status(500).json({
      message: 'Error al actualizar reporte'
    });

  }

};


module.exports = {
  createReport,
  getReports,
  updateReport
};