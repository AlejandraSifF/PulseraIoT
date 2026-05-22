//MODIFIQUE 07/05/25
//08/05/2025
require('dotenv').config();
const express = require('express');
const authRoutes = require('./routes/auth.routes');
const connectDB = require('./config/db');
const Controllers = require('./controllers/auth.controller');
//const authJWT = require('./middlewares/authJWT');

//AGREGUE 1
const reportRoutes = require('./routes/reporte.routes');

const cors = require('cors');
const app = express();



app.use(express.json());
app.use(cors());

app.use('/api/auth', authRoutes);
app.use('/api', reportRoutes);//nuevo

module.exports = app;