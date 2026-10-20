import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class Alarmas extends StatelessWidget {
  final String tipoVital;

  const Alarmas({
    super.key,
    required this.tipoVital,
  });

  String get titulo {
    switch (tipoVital) {
      case 'frecuenciaCardiaca':
        return 'Alarmas de frecuencia cardíaca';
      case 'oxigenacion':
        return 'Alarmas de oxigenación';
      case 'temperatura':
        return 'Alarmas de temperatura';
      default:
        return 'Alarmas';
    }
  }

  IconData get icono {
    switch (tipoVital) {
      case 'frecuenciaCardiaca':
        return Icons.favorite_rounded;
      case 'oxigenacion':
        return Icons.water_drop_rounded;
      case 'temperatura':
        return Icons.thermostat_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  String get descripcion {
    switch (tipoVital) {
      case 'frecuenciaCardiaca':
        return 'Consulta la información relacionada con las '
            'alertas de frecuencia cardíaca.';
      case 'oxigenacion':
        return 'Consulta la información relacionada con las '
            'alertas de oxigenación.';
      case 'temperatura':
        return 'Consulta la información relacionada con las '
            'alertas de temperatura.';
      default:
        return 'Consulta la información de las alertas.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CABECERA MORADA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20, 18, 20, 30,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.colorPrincipal,
                      Color(0xFF9D8CFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textoClaro,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Alarmas',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.appBarLight,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.cardTransparente,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.bordeGlass,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icono,
                        size: 48,
                        color: AppColors.colorBotonPrincipal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.appBarLight.copyWith(
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      descripcion,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.normal.copyWith(
                        color: AppColors.textoClaro,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // INFORMACIÓN GENERAL
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.moradoDecoracion
                            .withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: AppColors.colorPrincipal,
                            size: 27,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Información de las alarmas',
                              style: AppTextStyles.subtitulo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'En esta sección se consultará la '
                        'información relacionada con las alertas '
                        'del signo vital seleccionado.',
                        style: AppTextStyles.paragraph,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.iconoSuave,
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color:
                                  AppColors.colorBotonPrincipal,
                              size: 23,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Esta pantalla todavía no consulta '
                                'un registro de alertas. Los eventos '
                                'deberán conectarse al sistema de '
                                'monitoreo para mostrarse aquí.',
                                style: AppTextStyles.secundario,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LÍMITES DE REFERENCIA
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.fondoBlanco,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.moradoDecoracion
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety_outlined,
                            color: AppColors.colorPrincipal,
                            size: 27,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Límites de referencia',
                              style: AppTextStyles.subtitulo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Los límites utilizados por el sistema '
                        'están pendientes de revisión y validación. '
                        'Por el momento, no se presentan aquí '
                        'como valores médicos personalizados.',
                        style: AppTextStyles.paragraph,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Los valores deben evaluarse considerando '
                        'el perfil del usuario, las condiciones '
                        'de medición y fuentes clínicas pertinentes. '
                        'Esta información no sustituye una '
                        'valoración profesional.',
                        style: AppTextStyles.secundario,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
