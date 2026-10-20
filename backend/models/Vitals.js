const mongoose = require('mongoose');

const medicionSchema = new mongoose.Schema({

    fechaHora: {
        type: Date,
        default: Date.now
    },

    frecuenciaCardiaca: {
        type: Number,
        default: null
    },

    oxigenacion: {
        type: Number,
        default: null
    },

    temperatura: {
        type: Number,
        default: null
    },

    movimiento: {
        type: String,
        default: null
    }

}, { _id: false });


const vitalsSchema = new mongoose.Schema({

    usuarioId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },

    fecha: {
        type: String,
        required: true
    },

    mediciones: {
        type: [medicionSchema],
        default: []
    }

}, {
    timestamps: true
});


vitalsSchema.index({
    usuarioId: 1,
    fecha: 1
}, {
    unique: true
});


module.exports = mongoose.model('Vitals', vitalsSchema);