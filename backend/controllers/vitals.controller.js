const Vitals = require('../models/Vitals');

const guardarVitales = async (req, res) => {
  try {
    const {
      fechaLocal,
      fechaHora,
      frecuenciaCardiaca,
      oxigenacion,
      temperatura,
      movimiento
    } = req.body;

    // ============================================================
    // VALIDAR FECHA LOCAL
    // ============================================================

    if (!fechaLocal) {
      return res.status(400).json({
        ok: false,
        msg: 'La fecha local es obligatoria'
      });
    }

    // ============================================================
    // FECHA Y HORA DE LA MEDICIÓN
    // ============================================================

    const ahora = fechaHora
      ? new Date(fechaHora)
      : new Date();

    // ============================================================
    // NUEVA MEDICIÓN
    // ============================================================

    const nuevaMedicion = {
      fechaHora: ahora,

      frecuenciaCardiaca:
        frecuenciaCardiaca !== undefined
          ? frecuenciaCardiaca
          : null,

      oxigenacion:
        oxigenacion !== undefined
          ? oxigenacion
          : null,

      temperatura:
        temperatura !== undefined
          ? temperatura
          : null,

      movimiento:
        movimiento !== undefined
          ? movimiento
          : null
    };

    // ============================================================
    // GUARDAR EN EL DOCUMENTO DEL DÍA
    // ============================================================

    const vitals = await Vitals.findOneAndUpdate(
      {
        usuarioId: req.uid,
        fecha: fechaLocal
      },
      {
        $push: {
          mediciones: nuevaMedicion
        }
      },
      {
        new: 'after',
        upsert: true,
        setDefaultsOnInsert: true
      }
    );

    res.status(201).json({
      ok: true,
      msg: 'Medición guardada correctamente',
      vitales: vitals
    });

  } catch (error) {
    console.error('Error al guardar vitales:', error);

    res.status(500).json({
      ok: false,
      msg: 'Error al guardar la medición'
    });
  }
};


const obtenerHistorial = async (req, res) => {
  try {
    const documentos = await Vitals.find({
      usuarioId: req.uid
    }).sort({
      fecha: -1
    });

    const historial = [];

    documentos.forEach((documento) => {
      documento.mediciones.forEach((medicion) => {
        historial.push({
          fechaHora: medicion.fechaHora,
          frecuenciaCardiaca: medicion.frecuenciaCardiaca,
          oxigenacion: medicion.oxigenacion,
          temperatura: medicion.temperatura,
          movimiento: medicion.movimiento
        });
      });
    });

    historial.sort((a, b) => {
      return new Date(b.fechaHora) - new Date(a.fechaHora);
    });

    res.status(200).json({
      ok: true,
      historial
    });

  } catch (error) {
    console.error('Error al obtener historial:', error);

    res.status(500).json({
      ok: false,
      msg: 'Error al obtener el historial'
    });
  }
};


module.exports = {
  guardarVitales,
  obtenerHistorial
};