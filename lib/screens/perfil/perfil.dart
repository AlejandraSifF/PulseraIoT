import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../provider/perfil_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class Perfil extends StatelessWidget {
  final String tipoPerfil;

  const Perfil({super.key, required this.tipoPerfil});

  @override
  Widget build(BuildContext context) {

    final perfilProvider = Provider.of<PerfilProvider>(context);
    File? imagenPerfil = perfilProvider.imagenPerfil;

    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: double.infinity,
                    height: 259,
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.colorPrincipal,
                          Color(0xFF9D8CFF),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    child: Stack(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Center(
                              child: Text(
                                "Perfil",
                                style: AppTextStyles.appBarLight,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// 🔥 NOMBRE DINÁMICO
                            Text(
                              perfilProvider.nombre,
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.textoClaro,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                /// 🔥 EDAD
                                Text(
                                  "Edad\n${perfilProvider.edad} años",
                                  style: AppTextStyles.secundario.copyWith(
                                    color: AppColors.textoClaro,
                                  ),
                                ),

                                /// 🔥 SEXO
                                Text(
                                  "Género\n${perfilProvider.sexo}",
                                  style: AppTextStyles.secundario.copyWith(
                                    color: AppColors.textoClaro,
                                  ),
                                ),

                                Text(
                                  "Perfil de Salud\n$tipoPerfil",
                                  style: AppTextStyles.secundario.copyWith(
                                    color: AppColors.textoClaro,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Positioned(
                          top: 10,
                          right: 20,
                          child: imagenPerfil != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.file(
                                    imagenPerfil,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/perfil.png',
                                  width: 80,
                                  height: 80,
                                ),
                        ),
                      ],
                    ),
                  ),

                  /// TARJETA
                  Positioned(
                    top: 180,
                    left: (MediaQuery.of(context).size.width - 323) / 2,
                    child: Container(
                      width: 323,
                      height: 280,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Column(
                        children: [

                          const Text(
                            "Información de Salud",
                            style: AppTextStyles.subtitulo,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _beigeCard(
                                  "Condiciones registradas",
                                  "Auto detectado",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _beigeCard(
                                  "Actividad recomendada",
                                  "Según perfil",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 220),

              /// 🔥 CONTACTO DINÁMICO
              Container(
                width: 278,
                height: 234,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.fondoCamposTexto,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Contacto de Emergencia",
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 15),

                    Text(perfilProvider.nombreContacto),
                    Text(perfilProvider.telefonoContacto),

                    const Spacer(),

                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.colorBotonPrincipal,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Llamar contacto",
                          style: AppTextStyles.boton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _beigeCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoCamposTexto,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(content),
        ],
      ),
    );
  }
}