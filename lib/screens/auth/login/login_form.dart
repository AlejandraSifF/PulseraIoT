import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../theme/app_colors.dart';
import '../../../services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool ocultarPassword = true;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
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

            const SizedBox(height: 8),

            const Text(
              "Ingresa tu correo y contraseña para continuar",
              style: TextStyle(color: AppColors.textoSecundario),
            ),

            const SizedBox(height: 25),

            /// CORREO
            const Text("Correo"),
            const SizedBox(height: 5),

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

            /// PASSWORD
            const Text("Contraseña"),
            const SizedBox(height: 5),

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

            /// BOTON LOGIN 🔥
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login exitoso"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Aquí luego puedes navegar a Home
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

            const SizedBox(height: 15),

            /// GOOGLE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login, color: AppColors.textoClaro),
                label: const Text(
                  "Continuar con Google",
                  style: TextStyle(color: AppColors.textoClaro),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.botonGoogle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  final user = await signInWithGoogle();

                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login con Google exitoso"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}