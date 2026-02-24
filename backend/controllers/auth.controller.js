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

    const userResponse = {
      id: user._id,
      name: user.name,
      email: user.email
    };

    res.json({ ok: true, user: userResponse });
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Error interno del servidor'
    });
  }
};

// Registro
const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        ok: false,
        message: 'Todos los campos son obligatorios',
      });
    }

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(400).json({
        ok: false,
        message: 'El usuario ya existe',
      });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      name,
      email,
      password: hashedPassword,
    });

    const userResponse = {
      id: user._id,
      name: user.name,
      email: user.email
    };

    res.status(201).json({
      ok: true,
      message: 'Usuario creado correctamente',
      user: userResponse,
    });

  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Error interno del servidor'
    });
  }
};

// Login
const login = async (req, res) => {
//console.log('METHOD:', req.method);
//console.log('BODY:', req.body);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        ok: false,
        message: 'Email y contraseña obligatorios',
      });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        ok: false,
        message: 'Usuario no existe',
      });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({
        ok: false,
        message: 'Contraseña incorrecta',
      });
    }

    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );

    const userResponse = {
      id: user._id,
      name: user.name,
      email: user.email
    };

    res.json({
      ok: true,
      message: 'Login exitoso',
      user: userResponse,
      token,
    });

  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Error interno del servidor'
    });
  }
};

// Renew token
    const renew = async (req, res) => {
      try {
        const uid = req.uid;

        const user = await User.findById(uid).select('-password');

        if (!user) {
           return res.status(404).json({
            ok: false,
            message: 'Usuario no existe',
        });
    }

      const token = jwt.sign(
        { id: uid },
        process.env.JWT_SECRET,
        { expiresIn: '2h' }
     );

      const userResponse = {
        id: user._id,
        name: user.name,
        email: user.email
     };

      res.json({
        ok: true,
         message: 'Token renovado correctamente',
         user: userResponse,
         token,
     });

    } catch (error) {
      res.status(500).json({
        ok: false,
        message: 'Error interno del servidor'
     });
    }
  };

  // Cambiar contraseña
const changePassword = async (req, res) => {
  try {
    const uid = req.uid; // viene del token
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        ok: false,
        message: 'Faltan datos',
      });
    }

    const user = await User.findById(uid);
    if (!user) {
      return res.status(404).json({
        ok: false,
        message: 'Usuario no existe',
      });
    }

    // Verificar contraseña actual
    const validPassword = await bcrypt.compare(currentPassword, user.password);
    if (!validPassword) {
      return res.status(400).json({
        ok: false,
        message: 'Contraseña actual incorrecta',
      });
    }

    // Encriptar nueva contraseña
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    user.password = hashedPassword;
    await user.save();

    res.json({
      ok: true,
      message: 'Contraseña actualizada correctamente',
    });

  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Error interno del servidor',
    });
  }
};

const changeEmail = async (req, res) => {
  try {
    const uid = req.uid;
    const { newEmail } = req.body;

    if (!newEmail) {
      return res.status(400).json({
        ok: false,
        message: 'Correo requerido'
      });
    }

    const existing = await User.findOne({ email: newEmail });

    if (existing) {
      return res.status(400).json({
        ok: false,
        message: 'El correo ya está en uso'
      });
    }

    const user = await User.findByIdAndUpdate(
      uid,
      { email: newEmail },
      { new: true }
    );

    res.json({
      ok: true,
      message: 'Correo actualizado',
      user
    });

  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Error interno'
    });
  }
};



module.exports = {
  testUser,
  register,
  login,
  renew,
  changePassword,
  changeEmail,
};