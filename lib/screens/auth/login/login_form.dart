import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ================= GOOGLE SIGN IN =================
  Future<UserCredential?> signInWithGoogle() async {

    try {

      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth =
          await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(credential);

    } catch (e) {

      debugPrint(
        "Error Google Sign In: $e",
      );

      return null;
    }
  }

  // ================= LOGIN NORMAL =================
  Future<void> loginNormal() async {

    final response = await AuthService.login(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    if (!response['ok']) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? "Error",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    await procesarLogin(
      response['user'],
    );
  }

  // ================= LOGIN GOOGLE =================
Future<void> loginGoogle() async {

  try {

    final userCredential =
        await signInWithGoogle();

    if (userCredential == null) return;

    final firebaseUser =
        userCredential.user;

    if (firebaseUser == null) return;

    // 🔥 HACER LOGIN, NO REGISTER
    final response =
        await AuthService.loginGoogle(
      email: firebaseUser.email ?? '',
    );

    if (!response['ok']) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ??
                'Error Google',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // 🔥 OBTENER USER CORRECTAMENTE
    final user = response['user'];

    await procesarLogin(user);

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'Error Google: $e',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  // ================= PROCESAR LOGIN =================
  Future<void> procesarLogin(
    dynamic user,
  ) async {

    final perfilProvider =
        Provider.of<PerfilProvider>(
      context,
      listen: false,
    );

    final cuestionario =
        user['cuestionario'];

    // ================= FECHA FORMATEADA =================
    String fechaFormateada = "";

    if (user['fechaNacimiento'] != null &&
        user['fechaNacimiento']
            .toString()
            .isNotEmpty) {

      try {

        final date = DateTime.parse(
          user['fechaNacimiento']
              .toString(),
        );

        fechaFormateada =
            "${date.day.toString().padLeft(2, '0')}/"
            "${date.month.toString().padLeft(2, '0')}/"
            "${date.year}";

      } catch (e) {

        debugPrint(
          "Error fecha: $e",
        );
      }
    }

    // ================= GUARDAR FECHA =================
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "fecha",
      fechaFormateada,
    );

    // ================= GUARDAR DATOS =================
    await perfilProvider.guardarDatos(
      nombre: user['name'] ?? '',
      sexo: cuestionario?['sexo'] ?? '',
      nombreContacto:
          cuestionario?[
                  'contactoEmergenciaNombre'] ??
              '',
      telefonoContacto:
          cuestionario?[
                  'contactoEmergenciaTelefono'] ??
              '',
      telefonoUsuario:
          user['telefono'] ?? '',
      fechaNacimiento:
          fechaFormateada,
      correo:
          user['email'] ?? '',
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Login exitoso",
        ),
        backgroundColor: Colors.green,
      ),
    );

    final tipoHome =
        user['tipoHome'];

    // ================= SI NO TIENE DATOS =================
    if (tipoHome == null ||
        tipoHome
            .toString()
            .isEmpty ||
        cuestionario == null ||
        user['fechaNacimiento'] == null ||
        user['fechaNacimiento']
            .toString()
            .isEmpty) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Cuestionario(
            nombre:
                user['name'] ?? '',
            correo:
                user['email'] ?? '',
            telefono:
                user['telefono'] ?? '',
            fecha:
                fechaFormateada,
          ),
        ),
      );

      return;
    }

    // ================= HOME =================
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(
          tipoHome: tipoHome
              .toString()
              .toLowerCase(),
          user: user,
        ),
      ),
    );
  }

  @override
  void dispose() {

    emailCtrl.dispose();
    passCtrl.dispose();

    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.fondoBlanco,

      appBar: AppBar(

        backgroundColor:
            AppColors.fondoBlanco,

        elevation: 0,

        title: const Text(
          "Iniciar Sesión",
          style: TextStyle(
            color:
                AppColors.colorBotonPrincipal,
          ),
        ),

        iconTheme: const IconThemeData(
          color:
              AppColors.colorBotonPrincipal,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.colorBotonPrincipal,
              ),
            ),

            const SizedBox(height: 25),

            const Text("Correo"),

            TextField(

              controller: emailCtrl,

              decoration: InputDecoration(

                hintText:
                    "ejemplo@ejemplo.com",

                filled: true,

                fillColor:
                    AppColors.inputLogin,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Contraseña",
            ),

            TextField(

              controller: passCtrl,

              obscureText:
                  ocultarPassword,

              decoration: InputDecoration(

                filled: true,

                fillColor:
                    AppColors.inputLogin,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),

                suffixIcon:
                    IconButton(

                  icon: Icon(

                    ocultarPassword
                        ? Icons
                            .visibility_off
                        : Icons.visibility,
                  ),

                  onPressed: () {

                    setState(() {

                      ocultarPassword =
                          !ocultarPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= LOGIN NORMAL =================
            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      AppColors
                          .colorBotonPrincipal,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),
                ),

                onPressed:
                    loginNormal,

                child: const Text(

                  "Iniciar Sesión",

                  style: TextStyle(
                    fontSize: 16,
                    color:
                        AppColors
                            .textoClaro,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= LOGIN GOOGLE =================
            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),
                ),

                onPressed:
                    loginGoogle,

                icon: const Icon(
                  Icons.login,
                  color: Colors.black,
                ),

                label: const Text(
                  "Continuar con Google",
                  style: TextStyle(
                    color: Colors.black,
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