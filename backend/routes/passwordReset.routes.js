// routes/passwordReset.routes.js

const { Router } = require('express');

const {
  forgotPassword,
  verifyResetCode,
  resetPassword,
} = require(
  '../controllers/passwordReset.controller'
);

const router = Router();


// ================= FORGOT PASSWORD =================
router.post(
  '/forgot-password',
  forgotPassword
);


// ================= VERIFY RESET CODE =================
router.post(
  '/verify-reset-code',
  verifyResetCode
);


// ================= RESET PASSWORD =================
router.post(
  '/reset-password',
  resetPassword
);


module.exports = router;