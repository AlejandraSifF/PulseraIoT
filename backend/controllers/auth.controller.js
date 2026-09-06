const bcrypt = require('bcrypt');
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const crypto = require('crypto');

/*//Nuevo
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});*/

// ================= TEST USER =================
const testUser = async (req, res) => {
  try {
    const salt = await bcrypt.genSalt(10);

    const hashedPassword = await bcrypt.hash(
      '123456',
      salt
    );

    const user = await User.create({
      name: 'Prueba33',
      email: 'test@test.com',
      password: hashedPassword,
    });

    res.json({
      ok: true,
      user
    });

  } catch (error) {

    res.status(500).json({
      ok: false
    });

  }
};

// ================= REGISTER =================
const register = async (req, res) => {
  try {
    const { name, email, password, telefono } = req.body;

    const cleanEmail = email.trim().toLowerCase();

    const exists = await User.findOne({ email: cleanEmail });

    if (exists) {
      return res.status(400).json({
        ok: false,
        message: "Ya existe una cuenta con este correo, inicia sesión",
      });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      name,
      email: cleanEmail,
      password: hashedPassword,
      telefono: telefono || "",
    });

    return res.status(201).json({
      ok: true,
      user,
    });

  } catch (error) {
    return res.status(500).json({
      ok: false,
      message: "Error en registro",
    });
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

    const cleanEmail =
      email.trim().toLowerCase();

    // ==========================
    // VERIFICAR SI YA EXISTE
    // ==========================
    const existe =
      await User.findOne({
        email: cleanEmail
      });

    if (existe) {

      return res.status(400).json({
        ok: false,
        yaRegistrado: true,
        message:
          'Ya existe una cuenta con este correo, inicia sesión'
      });
    }

    // ==========================
    // CONVERTIR FECHA
    // ==========================
    let fechaConvertida = null;

    if (fechaNacimiento) {

      const partes =
        fechaNacimiento.split('/');

      if (partes.length === 3) {

        fechaConvertida =
          new Date(
            partes[2],
            partes[1] - 1,
            partes[0]
          );
      }
    }

    // ==========================
    // CREAR USUARIO
    // ==========================
    const user =
      await User.create({

        name,
        email: cleanEmail,
        password:
          'GOOGLE_LOGIN',

        telefono:
          telefono || "",

        fechaNacimiento:
          fechaConvertida,
      });

    // ==========================
    // TOKEN
    // ==========================
    const token =
      jwt.sign(

        { id: user._id },

        process.env.JWT_SECRET,

        {
          expiresIn: '2h'
        }
      );

    return res.status(201).json({

      ok: true,
      user,
      token,
    });

  } catch (error) {

    console.log(error);

    return res.status(500).json({

      ok: false,

      message:
        'Error en Google register',
    });
  }
};

// ================= GOOGLE LOGIN =================
const loginGoogle = async (req, res) => {

  try {

    const { email } = req.body;

    const user =
      await User.findOne({ 
        email: email.toLowerCase()});

    if (!user) {

      return res.status(404).json({
        ok: false,
        message:
          'Usuario no encontrado'
      });

    }

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
      message:
        'Error login Google'
    });

  }
};

// ================= LOGIN =================
const login = async (req, res) => {

  try {

    const {
      email,
      password
    } = req.body;

    const user =
      await User.findOne({ 
        email: email.toLowerCase()});

    if (!user) {

      return res.status(400).json({
        ok: false,
        message:
          'Usuario no existe',
      });

    }

    const valid =
      await bcrypt.compare(
        password,
        user.password
      );

    if (!valid) {

      return res.status(400).json({
        ok: false,
        message:
          'Contraseña incorrecta',
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

    res.status(500).json({
      ok: false
    });

  }
};

// ================= RENEW =================
const renew = async (req, res) => {

  const user =
    await User.findById(req.uid);

  const token = jwt.sign(
    { id: req.uid },
    process.env.JWT_SECRET,
    { expiresIn: '2h' }
  );

  res.json({
    ok: true,
    user,
    token
  });
};

// ================= CHANGE PASSWORD =================
const changePassword = async (req, res) => {

  const user =
    await User.findById(req.uid);

  const valid =
    await bcrypt.compare(
      req.body.currentPassword,
      user.password
    );

  if (!valid) {

    return res.status(400).json({
      ok: false
    });

  }

  const salt =
    await bcrypt.genSalt(10);

  user.password =
    await bcrypt.hash(
      req.body.newPassword,
      salt
    );

  await user.save();

  res.json({
    ok: true
  });
};

// ================= CHANGE EMAIL =================
const changeEmail = async (req, res) => {

  try {

    const {
      newEmail,
      currentPassword
    } = req.body;

    if (
      !newEmail ||
      !currentPassword
    ) {

      return res.status(400).json({
        ok: false,
        message:
          'Todos los campos son obligatorios'
      });

    }

    const user =
      await User.findById(req.uid);

    if (!user) {

      return res.status(404).json({
        ok: false,
        message:
          'Usuario no encontrado'
      });

    }

    if (
      user.password ===
      'GOOGLE_LOGIN'
    ) {

      return res.status(400).json({
        ok: false,
        message:
          'Las cuentas de Google no pueden cambiar correo aquí'
      });

    }

    const valid =
      await bcrypt.compare(
        currentPassword,
        user.password
      );

    if (!valid) {

      return res.status(400).json({
        ok: false,
        message:
          'Contraseña incorrecta'
      });

    }

    if (
      user.email.toLowerCase() ===
      newEmail.toLowerCase()
    ) {

      return res.status(400).json({
        ok: false,
        message:
          'Ese ya es tu correo actual'
      });

    }

    const existe =
      await User.findOne({
        email: newEmail.toLowerCase()
      });

    if (existe) {

      return res.status(400).json({
        ok: false,
        message:
          'Ese correo ya está registrado'
      });

    }

    if (user.lastEmailChange) {

      const horas =
        (
          new Date() -
          new Date(
            user.lastEmailChange
          )
        ) /
        (1000 * 60 * 60);

      if (horas < 24) {

        return res.status(400).json({
          ok: false,
          message:
            'Solo puedes cambiar el correo una vez cada 24 horas'
        });

      }
    }

    user.email = newEmail.toLowerCase();

    user.lastEmailChange =
      new Date();

    await user.save();

    res.json({
      ok: true,
      user
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false,
      message:
        'Error actualizando correo'
    });

  }
};

// ================= 🔥 CUESTIONARIO =================
const guardarCuestionario = async (req, res) => {

  try {

    const {
      tipoHome,
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

      const partes =
        fechaNacimiento.split('/');

      if (partes.length === 3) {

        fechaConvertida = new Date(
          partes[2],
          partes[1] - 1,
          partes[0]
        );

      }
    }

    const user =
      await User.findByIdAndUpdate(
        req.uid,
        {
          tipoHome,
          fechaNacimiento:
            fechaConvertida,

          cuestionario: {
            sexo,
            viveSolo,
            hipertension,
            diabetes,
            caidas,
            movilidad,
            medicacion,
            contactoEmergenciaNombre,
            contactoEmergenciaTelefono,
            fechaNacimiento:
              fechaConvertida
          }
        },
        {
          returnDocument: 'after'
        }
      );

    res.json({
      ok: true,
      user
    });

  } catch (error) {

    res.status(500).json({
      ok: false
    });

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

  const partes =
    fechaNacimiento.split('/');

  if (partes.length === 3) {

    fechaConvertida = new Date(
      partes[2], // año
      partes[1] - 1, // mes
      partes[0] // día
    );
  }
}

    const user =
      await User.findByIdAndUpdate(
        req.uid,
        {
          name,
          telefono,
          fechaNacimiento:
            fechaConvertida,

          'cuestionario.contactoEmergenciaNombre':
            contactoNombre,

          'cuestionario.contactoEmergenciaTelefono':
            contactoTelefono,

          'cuestionario.fechaNacimiento':
            fechaConvertida
        },
        {
          returnDocument: 'after'
        }
      );

    res.json({
      ok: true,
      user
    });

  } catch (error) {

    res.status(500).json({
      ok: false
    });

  }
};
/*
// ================= FORGOT PASSWORD =================
const forgotPassword = async (req, res) => {
  try {

    const { email } = req.body;

    const user = await User.findOne({ 
      email: email.toLowerCase()});

    if (!user) {
      return res.status(404).json({
        ok: false,
        message: 'Usuario no encontrado',
      });
    }

    // 🔥 Bloquear cuentas Google
    if (user.password === 'GOOGLE_LOGIN') {
      return res.status(400).json({
        ok: false,
        message: 'Las cuentas Google usan inicio de sesión con Google'
      });
    }

    const code = Math.floor(
      100000 + Math.random() * 900000
    ).toString();

    if (!user.recoverySession) {
      user.recoverySession =
        Date.now().toString();
    }

    user.resetCode = code;

    user.resetCodeExpires = new Date(
      Date.now() + 10 * 60 * 1000
    );

    await user.save();

    const expirationTime = new Date(
      Date.now() + 10 * 60 * 1000
    ).toLocaleTimeString('es-MX', {
      hour: '2-digit',
      minute: '2-digit',
    });

    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Recuperación de contraseña',

      headers: {
        'X-Entity-Ref-ID':
          Date.now().toString(),
      },

      text: `Hola, ${user.name}:

Tu código de 6 dígitos es: ${code}

Usa este código para recuperar tu contraseña.

Este código es válido hasta las ${expirationTime}.

Hora: ${new Date().toLocaleString('es-MX')}

Ingresa este código únicamente en la aplicación oficial.`,
    });

    res.json({
      ok: true,
      message: 'Código enviado',
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false
    });
  }
};

// ================= VERIFY RESET CODE =================
const verifyResetCode = async (req, res) => {
  try {

    const { email, code } = req.body;

    const user = await User.findOne({ 
      email: email.toLowerCase()});

    if (
      !user ||
      user.resetCode !== code ||
      !user.resetCodeExpires ||
      user.resetCodeExpires < new Date()
    ) {
      return res.status(400).json({
        ok: false,
        message: 'Código incorrecto o expirado',
      });
    }

    user.resetCode = null;
    user.resetCodeExpires = null;

    const token = crypto
      .randomBytes(32)
      .toString('hex');

    user.resetToken = token;

    await user.save();

    res.json({
      ok: true,
      resetToken: token,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false
    });
  }
};

// ================= RESET PASSWORD =================
const resetPassword = async (req, res) => {
  try {

    const {
      email,
      resetToken,
      newPassword
    } = req.body;

    const user = await User.findOne({ 
      email: email.toLowerCase()});

    if (
      !user ||
      user.resetToken !== resetToken
    ) {
      return res.status(400).json({
        ok: false,
        message: 'Token inválido',
      });
    }

    const salt = await bcrypt.genSalt(10);

    user.password = await bcrypt.hash(
      newPassword,
      salt
    );

    user.resetToken = null;
    user.recoverySession = null;

    await user.save();

    res.json({
      ok: true,
      message: 'Contraseña actualizada',
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false
    });
  }
};
*/
// ================= 🔥 SET NEW PASSWORD =================
const setPassword = async (req, res) => {

  const { newPassword } = req.body;

  const salt =
    await bcrypt.genSalt(10);

  const hashedPassword =
    await bcrypt.hash(
      newPassword,
      salt
    );

  const user =
    await User.findByIdAndUpdate(
      req.uid,
      {
        password:
          hashedPassword
      },
      {
        returnDocument: 'after'
      }
    );

  res.json({
    ok: true,
    user
  });
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
  setPassword, 
  //forgotPassword,
  //verifyResetCode,
  //resetPassword
};