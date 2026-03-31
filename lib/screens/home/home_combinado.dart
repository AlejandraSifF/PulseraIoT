import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../widgets/buscador/buscador.dart';
import '../../provider/perfil_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class HomeCombinado extends StatelessWidget {
  const HomeCombinado({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);
    File? imagenPerfil = perfilProvider.imagenPerfil;

    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      body: _homeContent(context, perfilProvider, imagenPerfil),
    );
  }

  Widget _homeContent(BuildContext context, PerfilProvider perfilProvider, File? imagenPerfil) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 HEADER DINÁMICO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hola, Bienvenido",
                      style: AppTextStyles.secundario,
                    ),
                    Text(
                      perfilProvider.nombre.isNotEmpty
                          ? perfilProvider.nombre
                          : "Usuario",
                      style: AppTextStyles.subtitulo,
                    ),
                  ],
                ),

                SizedBox(
                  width: 200,
                  child: Buscador(
                    onNavigate: (index) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 PERFIL CARD DINÁMICO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [

                  CircleAvatar(
                    radius: 35,
                    backgroundImage: imagenPerfil != null
                        ? FileImage(imagenPerfil)
                        : const AssetImage('assets/images/perfil.png')
                            as ImageProvider,
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perfilProvider.nombre.isNotEmpty
                              ? perfilProvider.nombre
                              : "Nombre completo",
                          style: AppTextStyles.subtitulo,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${perfilProvider.edad} años",
                          style: AppTextStyles.secundario,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gradientStart,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Perfil Combinado",
                      style: AppTextStyles.pequeno,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// CARDS (igual)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardFixed(
                          "Frecuencia\nCardíaca",
                          "100 lpm",
                          "Crítico",
                          AppColors.error,
                          "assets/images/bpm.png",
                        ),
                        _buildCardFixed(
                          "Oxigenación",
                          "98 %",
                          "Normal",
                          AppColors.exito,
                          "assets/images/spo2.png",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardFixed(
                          "Temperatura",
                          "36.5 °C",
                          "Normal",
                          AppColors.exito,
                          "assets/images/temperatura.png",
                        ),
                        _buildCardFixed(
                          "Caídas",
                          "Caída",
                          "Peligro",
                          AppColors.colorPrincipal,
                          "assets/images/caida.png",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _buildUbicacionCard(
                      "Ubicación",
                      "Zacatecas, Centro",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFixed(
    String title,
    String value,
    String status,
    Color statusColor,
    String imagePath,
  ) {
    return Container(
      width: 156,
      height: 137,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.normal,
                ),
              ),
              Image.asset(
                imagePath,
                width: 43,
                height: 43,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: AppTextStyles.secundario,
          ),

          const Spacer(),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: AppTextStyles.pequeno.copyWith(
                color: AppColors.textoClaro,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUbicacionCard(String title, String value) {
    return Container(
      width: 291,
      height: 137,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/gps.png",
                width: 32,
                height: 32,
              ),
            ],
          ),

          Text(
            title,
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: 10),

          const Text(
            "Lugar de ubicación:",
            style: AppTextStyles.secundario,
          ),

          Text(
            value,
            style: AppTextStyles.normal,
          ),
        ],
      ),
    );
  }
}