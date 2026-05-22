//MODIFIQUE 07/05/25
const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
  usuarioId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },

  tipoProblema: {
    type: String,
    required: true
  },

  descripcion: {
    type: String,
    required: true
  },

  estado: {
    type: String,
    enum: ['pendiente', 'en revision', 'resuelto'],
    default: 'pendiente'
  }

}, {
  timestamps: true
});

module.exports = mongoose.model('Report', reportSchema);