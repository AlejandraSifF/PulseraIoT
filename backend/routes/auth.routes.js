const express = require('express');
const User = require('../models/User');

const router = express.Router();

router.post('/test-user', async (req, res) => {
  try {
    const user = await User.create({
      name: 'Prueba',
      email: 'prueba@test.com',
      password: '123456',
    });

    res.json({
      ok: true,
      user,
    });
  } catch (error) {
    res.status(500).json({
      ok: false,
      error: error.message,
    });
  }
});

module.exports = router;