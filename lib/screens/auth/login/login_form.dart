import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../navigation/main_navigation.dart';
import '../../cuestionario/cuestionario.dart';
import '../../../provider/perfil_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool ocultarPassword = true;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  //================== coneccion ESP32 enviar email=======
    Future<void> enviarCorreoAPython(String email) async {

    try {

      final response = await http.post(

        Uri.parse("http://192.168.1.223:5000/loginUser"),//192.168.1.223:5000

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "email": email
        }),
      );

      //print("Respuesta Python:");
      //print(response.body);

    } catch (e) {

      //print("Error enviando correo:");
      //print(e);
    }
  }

  // ================= GOOGLE =================
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // ================= FORMATEAR FECHA =================
  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return "";

    try {
      final date = DateTime.parse(fecha);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (e) {
      return "";
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,
      appBar: AppBar(
        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,
        title: const Text(
          "Iniciar Sesión",
          style: TextStyle(color: AppColors.colorBotonPrincipal),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.colorBotonPrincipal,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.colorBotonPrincipal,
              ),
            ),

            const SizedBox(height: 25),

            const Text("Correo"),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                hintText: "example@example.com",
                filled: true,
                fillColor: AppColors.inputLogin,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Contraseña"),
            TextField(
              controller: passCtrl,
              obscureText: ocultarPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputLogin,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    ocultarPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      ocultarPassword = !ocultarPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ================= LOGIN =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotonPrincipal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {

                  final response = await AuthService.login(
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text.trim(),
                  );

                  if (response['ok']) {
                    
                    final user = response['user'];
                    
                    await enviarCorreoAPython(
                      user['email'],
                    );

                    final perfilProvider =
                        Provider.of<PerfilProvider>(context, listen: false);

                    //final user = response['user'];
                    final cuestionario = user['cuestionario'];

                    await perfilProvider.guardarDatos(
                      nombre: user['name'] ?? '',
                      //: cuestionario?['edad'] ?? 0,
                      sexo: cuestionario?['sexo'] ?? '',
                      nombreContacto: cuestionario?['contactoEmergenciaNombre'] ?? '',
                      telefonoContacto: cuestionario?['contactoEmergenciaTelefono'] ?? '',
                      telefonoUsuario: user['telefono'] ?? '', // 🔥 FIX
                      fechaNacimiento: _formatearFecha(user?['fechaNacimiento']),
                      correo: user['email'] ?? '',
                    );

                    final tipoHome = user['tipoHome'];

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login exitoso"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    /// SI NO TIENE CUESTIONARIO
                    if (tipoHome == null ||
                        tipoHome.toString().isEmpty ||
                        cuestionario == null) {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Cuestionario(
                            nombre: user['name'] ?? '',
                            correo: emailCtrl.text.trim(),
                            telefono: user['telefono'] ?? '',
                            fecha: '',
                          ),
                        ),
                      );
                      return;
                    }

                    /// REDIRECCIÓN NORMAL
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainNavigation(
                          tipoHome: tipoHome.toString().toLowerCase(),
                          user: user,
                        ),
                      ),
                    );

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message'] ?? "Error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textoClaro,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}