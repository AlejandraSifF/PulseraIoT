// controllers/passwordReset.controller.js

const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const nodemailer = require('nodemailer');

const User = require('../models/User');
//const PasswordReset = require('../models/passwordReset');
const PasswordReset = require('../models/passwordReset');


// ================= TRANSPORTER =================
const transporter = nodemailer.createTransport({
  service: 'gmail',

  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});


// ================= FORGOT PASSWORD =================
const forgotPassword = async (req, res) => {

  try {

    const email =
      req.body.email
        .trim()
        .toLowerCase();

    const user =
      await User.findOne({ email });

    if (!user) {

      return res.status(404).json({
        ok: false,
        message: 'Usuario no encontrado',
      });
    }

    // Generar código
    const code = Math.floor(
      100000 + Math.random() * 900000
    ).toString();

    // HASH del código
    const salt =
      await bcrypt.genSalt(10);

    const hashedCode =
      await bcrypt.hash(code, salt);
    
      
    //BRI
    //modifique esto, para encriptar session
    // Crear recovery session
    const rawRecoverySession =
    crypto.randomBytes(32)
        .toString('hex');

    const sessionSalt =
    await bcrypt.genSalt(10);

    const recoverySession =
    await bcrypt.hash(
        rawRecoverySession,
        sessionSalt
    );




    // Eliminar recuperaciones anteriores
    await PasswordReset.deleteMany({
      userId: user._id,
    });

    // Guardar nueva recuperación
    const passwordReset =
      new PasswordReset({

        userId: user._id,

        resetCode: hashedCode,

        resetCodeExpires:
          new Date(
            Date.now() + 10 * 60 * 1000
          ),

        recoverySession,

        resetToken: null,

        used: false,
      });

    await passwordReset.save();

        // Hora expiración
    const expirationTime =
    new Date(
        Date.now() + 10 * 60 * 1000
    ).toLocaleTimeString('es-MX', {

        hour: '2-digit',
        minute: '2-digit',
    });

    // Enviar correo
    await transporter.sendMail({

    from: process.env.EMAIL_USER,

    to: email,

    subject:
        'Recuperación de contraseña',

    // Hace que Gmail no agrupe igual
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
      ok: false,
      message: 'Error del servidor',
    });
  }
};


// ================= VERIFY RESET CODE =================
const verifyResetCode = async (req, res) => {

  try {

    const {
      email,
      code,
    } = req.body;

    const user =
      await User.findOne({
        email: email
          .trim()
          .toLowerCase(),
      });

    if (!user) {

      return res.status(404).json({
        ok: false,
        message: 'Usuario no encontrado',
      });
    }

    // Buscar recuperación activa
    const passwordReset =
      await PasswordReset.findOne({

        userId: user._id,

        used: false,
      });

    if (!passwordReset) {

      return res.status(400).json({
        ok: false,
        message:
          'No hay recuperación activa',
      });
    }

    // Verificar expiración
    if (
      !passwordReset.resetCodeExpires ||

      passwordReset.resetCodeExpires <
        new Date()
    ) {

      return res.status(400).json({
        ok: false,
        message:
          'Código expirado',
      });
    }

    // Comparar código HASH
    const validCode =
      await bcrypt.compare(
        code,
        passwordReset.resetCode
      );

    if (!validCode) {

      return res.status(400).json({
        ok: false,
        message:
          'Código incorrecto',
      });
    }

    // Generar token seguro
    const resetToken =
      crypto.randomBytes(32)
        .toString('hex');

    // HASH token
    const salt =
      await bcrypt.genSalt(10);

    const hashedToken =
      await bcrypt.hash(
        resetToken,
        salt
      );

    // Limpiar código
    passwordReset.resetCode = null;

    passwordReset.resetCodeExpires =
      null;

    // Guardar token HASH
    passwordReset.resetToken =
      hashedToken;

    await passwordReset.save();

    res.json({

      ok: true,

      resetToken,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false,
      message: 'Error del servidor',
    });
  }
};


// ================= RESET PASSWORD =================
const resetPassword = async (req, res) => {

  try {

    const {
      email,
      resetToken,
      newPassword,
    } = req.body;

    const user =
      await User.findOne({

        email: email
          .trim()
          .toLowerCase(),
      });

    if (!user) {

      return res.status(404).json({
        ok: false,
        message: 'Usuario no encontrado',
      });
    }

    // Buscar recuperación activa
    const passwordReset =
      await PasswordReset.findOne({

        userId: user._id,

        used: false,
      });

    if (!passwordReset) {

      return res.status(400).json({
        ok: false,
        message:
          'Recuperación inválida',
      });
    }

    // Comparar token HASH
    const validToken =
      await bcrypt.compare(
        resetToken,
        passwordReset.resetToken
      );

    if (!validToken) {

      return res.status(400).json({
        ok: false,
        message:
          'Token inválido',
      });
    }

    // HASH nueva contraseña
    const salt =
      await bcrypt.genSalt(10);

    user.password =
      await bcrypt.hash(
        newPassword,
        salt
      );

    await user.save();

    // Marcar recuperación usada
    passwordReset.used = true;

    // Limpiar token
    passwordReset.resetToken = null;

    await passwordReset.save();

    res.json({

      ok: true,

      message:
        'Contraseña actualizada',
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      ok: false,
      message: 'Error del servidor',
    });
  }
};


module.exports = {

  forgotPassword,

  verifyResetCode,

  resetPassword,
};