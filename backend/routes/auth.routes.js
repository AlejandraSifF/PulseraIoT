const express = require('express');
const router = express.Router();
const authJWT = require('../middleware/authJWT');

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


module.exports = router;