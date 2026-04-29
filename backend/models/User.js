const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  // 🔥 NUEVO
  tipoHome: { type: String, default: null },

  cuestionario: {
    edad: Number,
    sexo: String,
    viveSolo: String,
    hipertension: Boolean,
    diabetes: Boolean,
    caidas: String,
    movilidad: String,
    medicacion: String,
    contactoNombre: String,
    contactoTelefono: String,
  }
});

module.exports = mongoose.model('User', userSchema);