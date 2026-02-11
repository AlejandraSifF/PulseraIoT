const bcrypt = require('bcrypt');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Usuario de prueba
const testUser = async (req, res) => {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('123456', salt);

    const user = await User.create({
      name: 'Prueba2',
      email: 'prueba@test2.com',
      password: hashedPassword,
    });

    res.json({ ok: true, user });
  } catch (error) {
    res.status(500).json({ ok: false, error: error.message });
  }
};

// Registro
const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        ok: false,
        msg: 'Todos los campos son obligatorios',
      });
    }

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(400).json({
        ok: false,
        msg: 'El usuario ya existe',
      });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      name,
      email,
      password: hashedPassword,
    });

    res.status(201).json({
      ok: true,
      msg: 'Usuario creado correctamente',
      user,
    });
  } catch (error) {
    res.status(500).json({ ok: false, error: error.message });
  }
};

// Login
const login = async (req, res) => {
  console.log('METHOD:', req.method);
console.log('BODY:', req.body);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        ok: false,
        msg: 'Email y contraseña obligatorios',
      });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        ok: false,
        msg: 'Usuario no existe',
      });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({
        ok: false,
        msg: 'Contraseña incorrecta',
      });
    }
    // TOKEN
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );

    res.json({
      ok: true,
      msg: 'Login exitoso',
      token,
      // user,
    });
  } catch (error) {
    res.status(500).json({ ok: false, error: error.message });
  }
};

    const renew = async (req, res) => {
      try {
        const uid = req.uid;

        const user = await User.findById(uid).select('-password');

        if (!user) {
          return res.status(404).json({
            ok: false,
            msg: 'Usuario no existe',
          });
        }

        const token = jwt.sign(
          { id: uid },
          process.env.JWT_SECRET,
          { expiresIn: '2h' }
        );

        res.json({
          ok: true,
          user,
          token,
        });

      } catch (error) {
        res.status(500).json({
          ok: false,
          error: error.message
        });
      }
    };

module.exports = {
  testUser,
  register,
  login,
  renew,
};