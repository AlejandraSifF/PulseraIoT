const express = require('express');
const router = express.Router();
const authJWT = require('../middleware/authJWT');

const {
  register,
  registerGoogle,
  login,
  loginGoogle,
  testUser,
  renew,
  changePassword,
  changeEmail,
  guardarCuestionario,
  actualizarPerfil,
  setPassword,

  // 🔥 NUEVO
  //forgotPassword,
  //verifyResetCode,
  //resetPassword

} = require('../controllers/auth.controller');

// ================== RUTAS ==================

router.get('/private', authJWT, (req, res) => {
  res.json({
    ok: true,
    msg: 'Acceso permitido',
    uid: req.uid,
  });
});

// ================= AUTH =================

router.post('/register', register);
router.post('/login', login);
router.post('/test-user', testUser);
router.get('/renew', authJWT, renew);
router.post('/login-google', loginGoogle);
router.post('/register-google', registerGoogle);

// ================= PASSWORD =================

router.put(
  '/change-password',
  authJWT,
  changePassword
);

router.post(
  '/set-password',
  authJWT,
  setPassword
);

// 🔥 RECUPERAR CONTRASEÑA
/*
router.post(
  '/forgot-password',
  //forgotPassword
);

router.post(
  '/verify-reset-code',
  verifyResetCode
);

router.post(
  '/reset-password',
  resetPassword
);*/

// ================= EMAIL =================

router.put(
  '/change-email',
  authJWT,
  changeEmail
);

// ================= CUESTIONARIO =================

router.post(
  '/cuestionario',
  authJWT,
  guardarCuestionario
);

// ================= PERFIL =================

router.put(
  '/update-profile',
  authJWT,
  actualizarPerfil
);

module.exports = router;