//08/05/25
//11-05-25
//12-05-25
//18-05-2025

const mongoose = require('mongoose');
//const { testUser } = require('../controllers/auth.controller');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  telefono: { type: String, default: '' },


  //NUEVO B
  resetCode: {
    type: String,
    default: null
  },
  //NUEVO B
  resetCodeExpires: {
  type: Date,
  default: null
},
//nuevo B
recoverySession: {
  type: String,
  default: null,
},

//nUEVO B
resetToken: {
  type: String,
  default: null,
},


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