const express = require('express');
const authRoutes = require('./routes/auth.routes');
const connectDB = require('./config/db');
const Controllers = require('./controllers/auth.controller');

const app = express();

app.use(express.json());
app.use('/api/auth', authRoutes);

module.exports = app;