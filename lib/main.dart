import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* =========================
   APP PRINCIPAL
========================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoSE',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8FB9A8),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/* =========================
   SPLASH SCREEN
========================= */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FB9A8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite, size: 90, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'NoSE',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Texto lindo',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   LOGIN
========================= */
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            _inputCampo('Usuario'),
            const SizedBox(height: 20),
            _inputCampo('Contraseña', oculto: true),
            const SizedBox(height: 30),

            _boton(
              texto: 'Acceder',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            const SizedBox(height: 15),

            TextButton(
              onPressed: () {},
              child: const Text(
                'Crear cuenta',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCampo(String texto, {bool oculto = false}) {
    return TextField(
      obscureText: oculto,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: texto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/* =========================
   HOME
========================= */
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoSE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hola 👋',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '¿Qué deseas revisar hoy?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            _boton(
              texto: 'Signos vitales',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignosScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            _boton(texto: 'Historial', onTap: () {}),
            const SizedBox(height: 20),

            _boton(texto: 'Alertas', onTap: () {}),
            const SizedBox(height: 20),

            _boton(texto: 'Configuración', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

/* =========================
   SIGNOS VITALES
========================= */
class SignosScreen extends StatelessWidget {
  const SignosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signos vitales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _cardSigno('Frecuencia cardíaca', '72 bpm', Icons.favorite),
            const SizedBox(height: 20),
            _cardSigno('Temperatura corporal', '36.5 °C', Icons.thermostat),
            const SizedBox(height: 20),
            _cardSigno('Oxigenación', '98%', Icons.water_drop),
          ],
        ),
      ),
    );
  }

  Widget _cardSigno(String titulo, String valor, IconData icono) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icono, size: 40, color: const Color(0xFF8FB9A8)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   BOTÓN REUTILIZABLE
========================= */
Widget _boton({required String texto, required VoidCallback onTap}) {
  return SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8FB9A8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onTap,
      child: Text(
        texto,
        style: const TextStyle(fontSize: 22),
      ),
    ),
  );
}