import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

    /// 🔥 FECHA AUTOMÁTICA
    final fechaActual = DateFormat('dd MMM yyyy', 'es').format(DateTime.now());

    /// 🔥 DATOS DINÁMICOS SEGÚN PERFIL
    final datosSalud = obtenerDatosSalud(tipoPerfil);

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

                            Text(
                              perfilProvider.nombre.isNotEmpty
                                  ? perfilProvider.nombre
                                  : "Nombre completo",
                              style: AppTextStyles.heading.copyWith(
                                color: AppColors.textoClaro,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  "Edad\n${perfilProvider.edad} años",
                                  style: AppTextStyles.secundario.copyWith(
                                    color: AppColors.textoClaro,
                                  ),
                                ),

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

                  /// 🔥 TARJETA PRINCIPAL
                  Positioned(
                    top: 180,
                    left: (MediaQuery.of(context).size.width - 323) / 2,
                    child: Container(
                      width: 323,
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

                          /// 🔥 FILA 1 DINÁMICA
                          Row(
                            children: [
                              Expanded(
                                child: _beigeCard(
                                  "Condiciones registradas",
                                  datosSalud["condicion"]!,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _beigeCard(
                                  "Actividad recomendada",
                                  datosSalud["actividad"]!,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// 🔥 FILA 2
                          Row(
                            children: [
                              Expanded(
                                child: _beigeCard(
                                  "Estado de monitoreo",
                                  "Activo",
                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "Fecha $fechaActual",
                                    style: AppTextStyles.secundario.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
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

              /// 🔥 CONTACTO
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

                    Text(
                      perfilProvider.nombreContacto.isNotEmpty
                          ? perfilProvider.nombreContacto
                          : "Sin nombre",
                    ),

                    Text(
                      perfilProvider.telefonoContacto.isNotEmpty
                          ? perfilProvider.telefonoContacto
                          : "Sin teléfono",
                    ),

                    const Spacer(),

                    /// 🔥 BOTÓN LLAMAR
                    GestureDetector(
                      onTap: () async {

                        final numero = perfilProvider.telefonoContacto;

                        if (numero.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No hay número disponible"),
                            ),
                          );
                          return;
                        }

                        final Uri url = Uri(scheme: 'tel', path: numero);

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No se pudo abrir el marcador"),
                            ),
                          );
                        }
                      },
                      child: Container(
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

  /// 🔥 FUNCIÓN DINÁMICA
  Map<String, String> obtenerDatosSalud(String tipoPerfil) {
    switch (tipoPerfil) {

      case "Hipertensión":
        return {
          "condicion": "Hipertensión\ncontrolada",
          "actividad": "Reducir sal\nCaminar 30 min"
        };

      case "Diabetes":
        return {
          "condicion": "Diabetes\ncontrolada",
          "actividad": "Dieta baja azúcar\nEjercicio diario"
        };

      case "Hipertensión Y Diabetes":
        return {
          "condicion": "Hipertensión +\nDiabetes",
          "actividad": "Dieta estricta\nMonitoreo constante"
        };

      case "Sano":
      default:
        return {
          "condicion": "Sin condiciones",
          "actividad": "Ejercicio regular\nVida saludable"
        };
    }
  }

  /// 🔥 CARD
  static Widget _beigeCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fondoCamposTexto,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.secundario.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: AppTextStyles.headingPrimary.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}