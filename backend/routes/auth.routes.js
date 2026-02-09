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

const { register, login, testUser } = require('../controllers/auth.controller');

router.post('/register', register);
router.post('/login', login);
router.post('/test-user', testUser);

module.exports = router;