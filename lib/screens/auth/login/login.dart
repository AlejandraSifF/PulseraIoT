import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'login_form.dart';
import '../registro/registro_p.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        /// FONDO GENERAL
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [

              /// ARRIBA MÁS CLARITO
              Color(0xFFF8FAFF),

              /// ABAJO MÁS OSCURITO
              Color(0xFFDCE3F8),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 45,
                ),

                decoration: BoxDecoration(

                  /// CARD BLANCA
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(38),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// LOGO CON FONDO MÁS OSCURO
                    Container(
                      width: 185,
                      height: 185,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [

                            /// MÁS OSCURITO
                            Color(0xFFB9C2FF),
                            Color(0xFFAEDBCB),
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.colorPrincipal
                                .withOpacity(.18),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// TITULO
                    const Text(
                      "Tecnología con corazón",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B5B73),
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// SUBTEXTO
                    const Text(
                      "Cuidamos tu salud,\nestés donde estés",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 38),

                    /// BOTÓN LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.colorBotonPrincipal,

                          elevation: 4,

                          shadowColor:
                              Colors.black.withOpacity(.15),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LoginForm(),
                            ),
                          );
                        },

                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                          /// COLOR DEL CÍRCULO DEL LOGO
                          color: Color(0xFF8CBFAF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}