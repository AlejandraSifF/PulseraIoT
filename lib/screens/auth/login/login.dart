import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'login_form.dart';
import '../registro/registro_p.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
          AppColors.fondoPantallaPrincipal,

      body: Stack(
        children: [

          /// FONDO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  AppColors.fondoGradient1,
                  AppColors.fondoGradient2,
                  AppColors.fondoGradient3,
                  AppColors.fondoGradient4,
                ],

                stops: [
                  0.0,
                  0.35,
                  0.70,
                  1.0,
                ],
              ),
            ),
          ),

          /// LUZ SUPERIOR
          Positioned(
            top: -120,
            right: -80,

            child: Container(
              width: 320,
              height: 320,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors
                    .moradoDecoracion
                    .withOpacity(.40),
              ),
            ),
          ),

          /// LUZ CENTRAL
          Positioned(
            top: 170,
            left: -110,

            child: Container(
              width: 280,
              height: 280,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors
                    .verdeDecoracion
                    .withOpacity(.35),
              ),
            ),
          ),

          /// RUEDA MORADA
          Positioned(
            top: 90,
            right: -70,

            child: Container(
              width: 180,
              height: 180,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors
                    .moradoDecoracion
                    .withOpacity(.45),
              ),
            ),
          ),

          /// RUEDA VERDE
          Positioned(
            bottom: 120,
            left: -90,

            child: Container(
              width: 220,
              height: 220,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors
                    .verdeSuave
                    .withOpacity(.45),
              ),
            ),
          ),

          /// DETALLES ABAJO IZQUIERDA
          Positioned(
            bottom: -50,
            left: -60,

            child: Container(
              width: 220,
              height: 220,

              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius:
                    BorderRadius.circular(200),
              ),
            ),
          ),

          /// DETALLES ABAJO DERECHA
          Positioned(
            bottom: -40,
            right: -40,

            child: Container(
              width: 190,
              height: 190,

              decoration: BoxDecoration(
                color: AppColors.verdePastel,
                borderRadius:
                    BorderRadius.circular(200),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 40,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Colors.white.withOpacity(.82),

                    borderRadius:
                        BorderRadius.circular(45),

                    border: Border.all(
                      color:
                          Colors.white.withOpacity(.5),
                      width: 1.5,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(
                                .08),

                        blurRadius: 35,
                        spreadRadius: 1,

                        offset:
                            const Offset(0, 14),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      /// LOGO
                      Container(
                        width: 165,
                        height: 165,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient:
                              const LinearGradient(
                            begin:
                                Alignment.topLeft,
                            end:
                                Alignment
                                    .bottomRight,

                            colors: [
                              AppColors
                                  .moradoDecoracion,
                              AppColors
                                  .verdeSuave,
                            ],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: AppColors
                                  .verdePrincipal
                                  .withOpacity(.20),

                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  18),

                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// TITULO
                      RichText(
                        textAlign:
                            TextAlign.center,

                        text: const TextSpan(
                          children: [

                            TextSpan(
                              text:
                                  'Tecnología con\n',

                              style: TextStyle(
                                fontSize: 27,
                                fontWeight:
                                    FontWeight.bold,

                                color: Color(
                                    0xFF6E5A7A),
                              ),
                            ),

                            TextSpan(
                              text: 'corazón',

                              style: TextStyle(
                                fontSize: 27,
                                fontWeight:
                                    FontWeight.bold,

                                color: AppColors
                                    .verdePrincipal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// DECORACIÓN
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          Container(
                            width: 45,
                            height: 2,

                            color: AppColors
                                .iconoSuave,
                          ),

                          const Padding(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 10,
                            ),

                            child: Icon(
                              Icons.favorite,
                              size: 18,

                              color: AppColors
                                  .verdePrincipal,
                            ),
                          ),

                          Container(
                            width: 45,
                            height: 2,

                            color: AppColors
                                .iconoSuave,
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      /// TEXTO
                      const Text(
                        "Cuidamos tu salud,\nestés donde estés",

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          fontSize: 15,

                          color: Color(0xFF6B6578),

                          height: 1.6,

                          fontWeight:
                              FontWeight.w500,

                          letterSpacing: .2,
                        ),
                      ),

                      const SizedBox(height: 36),

                      /// BOTON LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 58,

                        child:
                            ElevatedButton.icon(

                          style:
                              ElevatedButton
                                  .styleFrom(

                            backgroundColor:
                                AppColors
                                    .colorBotonPrincipal,

                            elevation: 5,

                            shadowColor:
                                Colors.black
                                    .withOpacity(
                                        .18),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          30),
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

                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),

                          label: const Text(
                            "Iniciar Sesión",

                            style: TextStyle(
                              fontSize: 19,

                              fontWeight:
                                  FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// REGISTRO
                      SizedBox(
                        width: double.infinity,
                        height: 56,

                        child:
                            OutlinedButton.icon(

                          style:
                              OutlinedButton
                                  .styleFrom(

                            side: const BorderSide(
                              color: AppColors
                                  .verdePrincipal,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          30),
                            ),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    RegistroP(),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons
                                .person_add_alt_1,

                            color: AppColors
                                .verdePrincipal,
                          ),

                          label: const Text(
                            "Registrarse",

                            style: TextStyle(
                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,

                              color: AppColors
                                  .verdePrincipal,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// SEGURIDAD
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(.45),

                          borderRadius:
                              BorderRadius
                                  .circular(20),
                        ),

                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: const [

                            Icon(
                              Icons
                                  .verified_user_rounded,

                              color: AppColors
                                  .verdePrincipal,

                              size: 17,
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Tu información está protegida",

                              style: TextStyle(
                                color: Color(
                                    0xFF6E687A),

                                fontSize: 12.5,

                                fontWeight:
                                    FontWeight
                                        .w500,

                                letterSpacing: .2,
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

/// LINEA DECORATIVA
Container(
  width: double.infinity,
  height: 2,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        AppColors.verdePrincipal.withOpacity(.35),
        Colors.transparent,
      ],
    ),
  ),
),

const SizedBox(height: 5),

/// CORAZÓN + ECG
Align(
  alignment: Alignment.centerRight,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [

      Icon(
        Icons.favorite,
        color: AppColors.colorBotonPrincipal,
        size: 36,
      ),

      const SizedBox(width: 4),

      SizedBox(
        width: 100,
        height: 60,
        child: Image.asset(
          'assets/images/ecg.png',
          fit: BoxFit.contain,
        ),
      ),
    ],
  ),
),
                    ],
                  ),
                ),
              ),
    
            ),
          ),
        ],
      ),
    );
  }
}