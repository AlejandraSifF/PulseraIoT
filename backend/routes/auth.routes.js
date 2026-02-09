const express = require('express');
const router = express.Router();

const { register, login, testUser } = require('../controllers/auth.controller');

router.post('/register', register);
router.post('/login', login);
router.post('/test-user', testUser);

module.exports = router;