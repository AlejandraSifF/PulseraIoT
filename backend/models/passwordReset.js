// models/PasswordReset.js

const mongoose = require('mongoose');

const passwordResetSchema =
  new mongoose.Schema({

    // Usuario relacionado
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    // Código de recuperación (HASH)
    resetCode: {
      type: String,
      default: null,
    },

    // Expiración del código
    resetCodeExpires: {
      type: Date,
      default: null,
    },

    // Sesión temporal recuperación
    recoverySession: {
      type: String,
      default: null,
    },

    // Token final seguro (HASH)
    resetToken: {
      type: String,
      default: null,
    },

    // Saber si ya fue usado
    used: {
      type: Boolean,
      default: false,
    },

    // Fecha creación
    createdAt: {
      type: Date,
      default: Date.now,
    },

  });

module.exports = mongoose.model(
  'PasswordReset',
  passwordResetSchema
);