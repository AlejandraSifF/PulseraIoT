const bcrypt = require('bcrypt');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// ================= TEST USER =================
const testUser = async (req, res) => {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('123456', salt);

    const user = await User.create({
      name: 'Prueba',
      email: 'test@test.com',
      password: hashedPassword,
    });

    res.json({ ok: true, user });
  } catch (error) {
    res.status(500).json({ ok: false });
  }
};

// ================= REGISTER =================
const register = async (req, res) => {
  try {
    const { name, email, password, telefono } = req.body;

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
      telefono : telefono || '' // Aseguramos que siempre tenga un valor, aunque sea vacío
    });

    res.json({ ok: true, user });

  } catch (error) {
    console.log(error);
    res.status(500).json({ ok: false });
  }
};

// ================= LOGIN =================
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({
        ok: false,
        message: 'Usuario no existe',
      });
    }

    const valid = await bcrypt.compare(password, user.password);

    if (!valid) {
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

    res.json({
      ok: true,
      token,
      user
    });

  } catch (error) {
    res.status(500).json({ ok: false });
  }
};

// ================= RENEW =================
const renew = async (req, res) => {
  const user = await User.findById(req.uid);

  const token = jwt.sign(
    { id: req.uid },
    process.env.JWT_SECRET,
    { expiresIn: '2h' }
  );

  res.json({ ok: true, user, token });
};

// ================= CHANGE PASSWORD =================
const changePassword = async (req, res) => {
  const user = await User.findById(req.uid);

  const valid = await bcrypt.compare(
    req.body.currentPassword,
    user.password
  );

  if (!valid) {
    return res.status(400).json({ ok: false });
  }

  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(req.body.newPassword, salt);

  await user.save();

  res.json({ ok: true });
};

// ================= CHANGE EMAIL =================
const changeEmail = async (req, res) => {
  const user = await User.findByIdAndUpdate(
    req.uid,
    { email: req.body.newEmail },
    { new: true }
  );

  res.json({ ok: true, user });
};

// ================= 🔥 CUESTIONARIO =================
const guardarCuestionario = async (req, res) => {
  try {
    //console.log("BODY:", req.body);// 🔥 DEBUG
    const {
      tipoHome,
      //edad,
      sexo,
      viveSolo,
      hipertension,
      diabetes,
      caidas,
      movilidad,
      medicacion,
      contactoEmergenciaNombre,
      contactoEmergenciaTelefono,
      fechaNacimiento
    } = req.body;

    let fechaConvertida = null;

    if (fechaNacimiento) {
      fechaConvertida = new Date(fechaNacimiento);
    }

    const user = await User.findByIdAndUpdate(
      req.uid,
      {
        tipoHome,
        fechaNacimiento: fechaConvertida,
        cuestionario: {
          //edad,
          sexo,
          viveSolo,
          hipertension,
          diabetes,
          caidas,
          movilidad,
          medicacion,
          contactoEmergenciaNombre,
          contactoEmergenciaTelefono,
          fechaNacimiento: fechaConvertida
        }
      },
      { new: true }
    );

    res.json({ ok: true, user });

  } catch (error) {
    res.status(500).json({ ok: false });
  }
};

// ================= 🔥 UPDATE PROFILE =================
const actualizarPerfil = async (req, res) => {
  try {
    const {
      name,
      telefono,
      contactoNombre,
      contactoTelefono,
      fechaNacimiento
    } = req.body;

    let fechaConvertida = null;

    if (fechaNacimiento) {
      fechaConvertida = new Date(fechaNacimiento);
    }

    const user = await User.findByIdAndUpdate(
      req.uid,
      {
        name,
        telefono,
        fechaNacimiento: fechaConvertida,
        'cuestionario.contactoEmergenciaNombre': contactoNombre,
        'cuestionario.contactoEmergenciaTelefono': contactoTelefono,
        'cuestionario.fechaNacimiento': fechaConvertida
      },
      { new: true }
    );

    res.json({ ok: true, user });

  } catch (error) {
    res.status(500).json({ ok: false });
  }
};

// ================= EXPORT =================
module.exports = {
  testUser,
  register,
  login,
  renew,
  changePassword,
  changeEmail,
  guardarCuestionario,
  actualizarPerfil
};