const bcrypt = require('bcrypt');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// ================= TEST USER =================
const testUser = async (req, res) => {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('123456', salt);

    const user = await User.create({
      name: 'Prueba33',
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

// ================= GOOGLE REGISTER =================
const registerGoogle = async (req, res) => {
  try {

    const {
      name,
      email,
      telefono,
      fechaNacimiento
    } = req.body;

    // 🔥 Convertir fecha dd/MM/yyyy → Date
    let fechaConvertida = null;

    if (fechaNacimiento) {

      const partes = fechaNacimiento.split('/');

      if (partes.length === 3) {
        fechaConvertida = new Date(
          partes[2], // año
          partes[1] - 1, // mes
          partes[0] // día
        );
      }
    }

    // 🔥 Verificar si ya existe
    const exists = await User.findOne({ email });

    // ❌ SI YA EXISTE → NO REGISTRAR
    /*if (exists) {
      return res.status(400).json({
        ok: false,
        yaRegistrado: true,
        message: 'Esta cuenta ya está registrada'
      });
    }*/
   if (exists) {

  exists.telefono = telefono || exists.telefono;

  exists.fechaNacimiento = fechaConvertida || exists.fechaNacimiento;

  await exists.save();

  const token = jwt.sign(
    { id: exists._id },
    process.env.JWT_SECRET,
    { expiresIn: '2h' }
  );

  return res.status(200).json({
    ok: true,
    user: exists,
    token,
    completado: true
  });
}

    // ✅ Crear usuario nuevo Google
    const user = await User.create({
      name,
      email,
      password: 'GOOGLE_LOGIN',
      telefono: telefono || '',
      fechaNacimiento: fechaConvertida
    });

    // 🔥 Generar token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );

    res.status(201).json({
      ok: true,
      message: 'Usuario creado',
      user,
      token
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false,
      message: 'Error en registro Google'
    });
  }
};

// ================= GOOGLE LOGIN =================
const loginGoogle = async (req, res) => {
  try {

    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({
        ok: false,
        message: 'Usuario no encontrado'
      });
    }

    // Crear token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );

    res.json({
      ok: true,
      user,
      token
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false,
      message: 'Error login Google'
    });
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
    //console.log("UID:", req.uid);
    //console.log("BODY:", req.body);
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
      const partes = fechaNacimiento.split('/');

      if (partes.length === 3) {
        fechaConvertida = new Date(
          partes[2], // año
          partes[1] - 1, // mes
          partes[0] // día
        );
      }
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

// ================= 🔥 SET NEW PASSWORD (SIN CONTRASEÑA ACTUAL) =================
const setPassword = async (req, res) => {
  const { newPassword } = req.body;

  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(newPassword, salt);

  const user = await User.findByIdAndUpdate(
    req.uid,
    { password: hashedPassword },
    { new: true }
  );

  res.json({ ok: true, user });
};

// ================= EXPORT =================
module.exports = {
  testUser,
  register,
  registerGoogle,
  login,
  loginGoogle,
  renew,
  changePassword,
  changeEmail,
  guardarCuestionario,
  actualizarPerfil,
  setPassword
};