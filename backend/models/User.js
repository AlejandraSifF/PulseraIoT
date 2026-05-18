const mongoose = require('mongoose');
//const { testUser } = require('../controllers/auth.controller');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, default: '' },
  telefono: { type: String, default: '' },

  // 🔥 NUEVO
  tipoHome: { type: String, default: null },
  fechaNacimiento: { type: Date, default: null },// 🔥 NUEVO

  cuestionario: {
    edad: Number,
    sexo: String,
    viveSolo: String,
    hipertension: Boolean,
    diabetes: Boolean,
    caidas: String,
    movilidad: String,
    medicacion: String,
    contactoEmergenciaNombre: String,
    contactoEmergenciaTelefono: String,
    //fechaNacimiento: Date
  }
});

module.exports = mongoose.model('User', userSchema);