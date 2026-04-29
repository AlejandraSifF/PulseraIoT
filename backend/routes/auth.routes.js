const express = require('express');
const router = express.Router();
const authJWT = require('../middleware/authJWT');

const User = require('../models/User');

// ================== RUTAS EXISTENTES ==================

router.get('/private', authJWT, (req, res) => {
  res.json({
    ok: true,
    msg: 'Acceso permitido',
    uid: req.uid,
  });
});

const { register, login, testUser, renew, changePassword, changeEmail } = require('../controllers/auth.controller');

router.post('/register', register);
router.post('/login', login);
router.post('/test-user', testUser);
router.get('/renew', authJWT, renew);
router.put('/change-password', authJWT, changePassword);
router.put('/change-email', authJWT, changeEmail);

// ================== 🔥 CUESTIONARIO ==================

router.post('/cuestionario', authJWT, async (req, res) => {
  try {
    const {
      tipoHome,
      edad,
      sexo,
      viveSolo,
      hipertension,
      diabetes,
      caidas,
      movilidad,
      medicacion,
      contactoNombre,
      contactoTelefono
    } = req.body;

    // 🔥 VALIDACIÓN
    if (!tipoHome) {
      return res.status(400).json({
        ok: false,
        message: "tipoHome es requerido"
      });
    }

    const user = await User.findByIdAndUpdate(
      req.uid,
      {
        tipoHome,
        cuestionario: {
          edad,
          sexo,
          viveSolo,
          hipertension,
          diabetes,
          caidas,
          movilidad,
          medicacion,
          contactoNombre,
          contactoTelefono
        }
      },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({
        ok: false,
        message: "Usuario no encontrado"
      });
    }

    res.json({
      ok: true,
      message: "Cuestionario guardado correctamente",
      user
    });

  } catch (error) {
    console.log(error);

    res.status(500).json({
      ok: false,
      message: "Error guardando cuestionario"
    });
  }
});

module.exports = router;