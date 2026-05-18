import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../provider/perfil_provider.dart';
import '../../widgets/buscador/buscador.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

import '../../services/vitals_service.dart';
import '../../models/vitals_model.dart';

class HomeSano extends StatefulWidget {
  const HomeSano({super.key});

  @override
  State<HomeSano> createState() => _HomeSanoState();
}

class _HomeSanoState extends State<HomeSano> {

  VitalsModel? vitals;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    cargarDatos();

    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        cargarDatos();
      },
    );
  }

  Future<void> cargarDatos() async {

    final data = await VitalsService.getVitals();

    if (data != null) {
      setState(() {
        vitals = data;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final perfilProvider =
        Provider.of<PerfilProvider>(context);

    File? imagenPerfil =
        perfilProvider.imagenPerfil;

    return Scaffold(
      backgroundColor:
          AppColors.fondoPantallaPrincipal,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              Row(
  children: [

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            "Hola, Bienvenido",
          ),

          Text(
            perfilProvider.nombre.isNotEmpty
                ? perfilProvider.nombre
                : "Usuario",

            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    ),

    const SizedBox(width: 10),

    SizedBox(
      width: 120,
      child: Buscador(
        onNavigate: (index) {},
      ),
    ),
  ],
),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 35,

                      backgroundImage:
                          imagenPerfil != null
                              ? FileImage(imagenPerfil)
                              : const AssetImage(
                                      'assets/images/perfil.png')
                                  as ImageProvider,
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            perfilProvider.nombre.isNotEmpty
                                ? perfilProvider.nombre
                                : "Nombre completo",
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${perfilProvider.edadCalculada} años",
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.iconoSuave,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Perfil Sano",
                        style: AppTextStyles.pequeno,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          _buildCardFixed(
                            "Frecuencia\nCardíaca",

                            vitals?.hr != null
                                ? "${vitals!.hr!.toStringAsFixed(1)} lpm"
                                : "--",

                            vitals?.hrCat ?? "Sin datos",

                            vitals?.hrCat == "normal"
                                ? AppColors.exito
                                : AppColors.error,

                            "assets/images/bpm.png",
                          ),

                          _buildCardFixed(
                            "Oxigenación",

                            vitals?.spo2 != null
                                ? "${vitals!.spo2!.toStringAsFixed(1)} %"
                                : "--",

                            vitals?.spo2Cat ?? "Sin datos",

                            vitals?.spo2Cat == "normal"
                                ? AppColors.exito
                                : AppColors.error,

                            "assets/images/spo2.png",
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          _buildCardFixed(
                            "Temperatura",

                            vitals?.temp != null
                                ? "${vitals!.temp!.toStringAsFixed(1)} °C"
                                : "--",

                            vitals?.tempCat ?? "Sin datos",

                            vitals?.tempCat == "normal"
                                ? AppColors.exito
                                : AppColors.error,

                            "assets/images/temperatura.png",
                          ),

                          _buildCardFixed(
                            "Caídas",
                            "Sin caída",
                            "Seguro",
                            AppColors.exito,
                            "assets/images/caida.png",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Text(title),
              ),

              Image.asset(
                imagePath,
                width: 43,
                height: 43,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(value),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4),

            decoration: BoxDecoration(
              color: statusColor,
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}