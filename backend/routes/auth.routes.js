const express = require('express');
const router = express.Router();
const authJWT = require('../middleware/authJWT');

const {
  register,
  login,
  testUser,
  renew,
  changePassword,
  changeEmail,
  guardarCuestionario,
  actualizarPerfil
} = require('../controllers/auth.controller');

// ================== RUTAS ==================

router.get('/private', authJWT, (req, res) => {
  res.json({
    ok: true,
    msg: 'Acceso permitido',
    uid: req.uid,
  });
});

router.post('/register', register);
router.post('/login', login);
router.post('/test-user', testUser);
router.get('/renew', authJWT, renew);
router.put('/change-password', authJWT, changePassword);
router.put('/change-email', authJWT, changeEmail);

// 🔥 YA NO HAY LÓGICA AQUÍ
router.post('/cuestionario', authJWT, guardarCuestionario);
router.put('/update-profile', authJWT, actualizarPerfil);

module.exports = router;