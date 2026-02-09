const jwt = require('jsonwebtoken');

const authJWT = (req, res, next) => {
  const token = req.header('x-token');

  if (!token) {
    return res.status(401).json({
      ok: false,
      msg: 'No hay token',
    });
  }

  try {
    const { id } = jwt.verify(token, process.env.JWT_SECRET);
    req.uid = id;
    next();
  } catch (error) {
    return res.status(401).json({
      ok: false,
      msg: 'Token no válido',
    });
  }
};

module.exports = authJWT;
