require('dotenv').config();
require('colors')
const app = require('./app');
const connectDB = require('./config/db');

const PORT = process.env.PORT || 3000;

connectDB();

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`.green);
});