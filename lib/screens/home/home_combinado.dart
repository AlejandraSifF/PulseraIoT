
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
import '../../services/historial_vitals_service.dart';
import '../historial/detalle_signo_vital.dart';

class HomeCombinado extends StatefulWidget {
  const HomeCombinado({super.key});

  @override
  State<HomeCombinado> createState() => _HomeCombinadoState();
}

class _HomeCombinadoState extends State<HomeCombinado> {
  VitalsModel? vitals;
  Timer? timer;

  // Control de guardado de datos históricos.
  DateTime? ultimaFrecuenciaGuardada;
  DateTime? ultimosOtrosGuardados;

  @override
  void initState() {
    super.initState();

    cargarDatos();

    // Prueba temporal para guardar datos.
    // HistorialVitalsService.pruebaGuardar();

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
      if (!mounted) return;

      setState(() {
        vitals = data;
      });

      await guardarDatosHistoricos(data);
    }
  }

  // GUARDADO DE DATOS HISTÓRICOS.

  Future<void> guardarDatosHistoricos(VitalsModel data) async {
    final ahora = DateTime.now();

    // FRECUENCIA CARDÍACA: cada 5 minutos.
    if (data.hr != null) {
      final debeGuardarFrecuencia =
          ultimaFrecuenciaGuardada == null ||
          ahora.difference(ultimaFrecuenciaGuardada!).inMinutes >= 5;

      if (debeGuardarFrecuencia) {
        final resultado = await HistorialVitalsService.guardarVitales(
          frecuenciaCardiaca: data.hr,
        );

        print('GUARDADO FRECUENCIA CARDÍACA: $resultado');

        if (resultado['ok'] == true) {
          ultimaFrecuenciaGuardada = ahora;
        }
      }
    }

    // OXIGENACIÓN + TEMPERATURA: cada 10 minutos.
    final debeGuardarOtros =
        ultimosOtrosGuardados == null ||
        ahora.difference(ultimosOtrosGuardados!).inMinutes >= 10;

    if (debeGuardarOtros) {
      if (data.spo2 != null || data.temp != null) {
        final resultado = await HistorialVitalsService.guardarVitales(
          oxigenacion: data.spo2,
          temperatura: data.temp,
        );

        print('GUARDADO OXIGENACIÓN + TEMPERATURA: $resultado');

        if (resultado['ok'] == true) {
          ultimosOtrosGuardados = ahora;
        }
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);
    final File? imagenPerfil = perfilProvider.imagenPerfil;

    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ENCABEZADO CON DEGRADADO DE COLORES EXISTENTES.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.colorPrincipal,
                      AppColors.moradoDecoracion,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.colorPrincipal.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hola, Bienvenido',
                            style: TextStyle(
                              color: AppColors.textoClaro,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            perfilProvider.nombre.isNotEmpty
                                ? perfilProvider.nombre
                                : 'Usuario',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textoClaro,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
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
              ),

              const SizedBox(height: 18),

              // TARJETA DE PERFIL.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.bordeGlass,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.moradoDecoracion.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.iconoSuave,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: imagenPerfil != null
                            ? FileImage(imagenPerfil)
                            : const AssetImage('assets/images/perfil.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            perfilProvider.nombre.isNotEmpty
                                ? perfilProvider.nombre
                                : 'Nombre completo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textoOscuro,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${perfilProvider.edadCalculada} años',
                            style: const TextStyle(
                              color: AppColors.textoSecundario,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.iconoSuave,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Perfil Hipertensión y Diabetes',
                              style: AppTextStyles.pequeno,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // TARJETAS DE SIGNOS VITALES.
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCardFixed(
                            'Frecuencia\nCardíaca',
                            vitals?.hr != null
                                ? '${vitals!.hr!.toStringAsFixed(1)} lpm'
                                : '--',
                            vitals?.hrCat ?? 'Sin datos',
                            vitals?.hrCat == 'normal'
                                ? AppColors.exito
                                : AppColors.error,
                            'assets/images/bpm.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetalleSignoVital(
                                    tipoVital: 'frecuenciaCardiaca',
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildCardFixed(
                            'Oxigenación',
                            vitals?.spo2 != null
                                ? '${vitals!.spo2!.toStringAsFixed(1)} %'
                                : '--',
                            vitals?.spo2Cat ?? 'Sin datos',
                            vitals?.spo2Cat == 'normal'
                                ? AppColors.exito
                                : AppColors.error,
                            'assets/images/spo2.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetalleSignoVital(
                                    tipoVital: 'oxigenacion',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCardFixed(
                            'Temperatura',
                            vitals?.temp != null
                                ? '${vitals!.temp!.toStringAsFixed(1)} °C'
                                : '--',
                            vitals?.tempCat ?? 'Sin datos',
                            vitals?.tempCat == 'normal'
                                ? AppColors.exito
                                : AppColors.error,
                            'assets/images/temperatura.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetalleSignoVital(
                                    tipoVital: 'temperatura',
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildCardFixed(
                            'Caídas',
                            'Sin caída',
                            'Seguro',
                            AppColors.exito,
                            'assets/images/caida.png',
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _buildUbicacionCard(
                        'Ubicación',
                        'Zacatecas, Centro',
                      ),

                      const SizedBox(height: 12),
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

  // TARJETAS DE SIGNOS VITALES.
  Widget _buildCardFixed(
    String title,
    String value,
    String status,
    Color statusColor,
    String imagePath, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 156,
        height: 165,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.bordeGlass,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.moradoDecoracion.withValues(alpha: 0.16),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textoElegante,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textoOscuro,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textoClaro,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 6),

            if (onTap != null)
              const Text(
                'Toca para ver más detalles',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textoSecundario,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TARJETA DE UBICACIÓN.
  Widget _buildUbicacionCard(
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 137),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.bordeGlass,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.moradoDecoracion.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.colorBotonPrincipal,
                size: 23,
              ),
              const SizedBox(width: 7),
              Text(
                '$title:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textoOscuro,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/gps.png',
                width: 32,
                height: 32,
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Lugar de ubicación:',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textoSecundario,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textoMedio,
            ),
          ),
        ],
      ),
    );
  }
}
