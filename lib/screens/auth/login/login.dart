import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'login_form.dart';
import '../registro/registro_p.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoLogin,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/logo.png',
                width: 160,
              ),

              const SizedBox(height: 10),

              const Text(
                "Tecnología\nCon\nCorazón",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: AppColors.textoMedio,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Cuidamos tu salud, estés donde estés",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textoSecundario,
                ),
              ),

              const SizedBox(height: 60),

              /// INICIAR SESIÓN
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginForm(),
                      ),
                    );
                  },
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoClaro,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// REGISTRARSE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistroP(),
                    ),
                  );
                },
                child: const Text(
                  "Registrarse",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.colorLink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}