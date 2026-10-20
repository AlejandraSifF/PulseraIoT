import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/vitals_model.dart';
import '../../services/vitals_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../historial/historial_vitales.dart';
import 'alarmas.dart';

class DetalleSignoVital extends StatefulWidget {
  final String tipoVital;

  const DetalleSignoVital({
    super.key,
    required this.tipoVital,
  });

  @override
  State<DetalleSignoVital> createState() =>
      _DetalleSignoVitalState();
}

class _DetalleSignoVitalState
    extends State<DetalleSignoVital> {
  VitalsModel? vitals;
  Timer? timer;
  bool cargando = true;

  @override
  void initState() {
    super.initState();

    _cargarDatos();

    timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _cargarDatos(),
    );
  }

  Future<void> _cargarDatos() async {
    final datos = await VitalsService.getVitals();

    if (!mounted) return;

    setState(() {
      vitals = datos;
      cargando = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get titulo {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return 'Frecuencia cardíaca';
      case 'oxigenacion':
        return 'Oxigenación';
      case 'temperatura':
        return 'Temperatura';
      default:
        return 'Signo vital';
    }
  }

  IconData get icono {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return Icons.favorite_rounded;
      case 'oxigenacion':
        return Icons.water_drop_rounded;
      case 'temperatura':
        return Icons.thermostat_rounded;
      default:
        return Icons.monitor_heart_rounded;
    }
  }

  double? get valor {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return vitals?.hr;
      case 'oxigenacion':
        return vitals?.spo2;
      case 'temperatura':
        return vitals?.temp;
      default:
        return null;
    }
  }

  String get unidad {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return 'lpm';
      case 'oxigenacion':
        return '%';
      case 'temperatura':
        return '°C';
      default:
        return '';
    }
  }

  String get categoria {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return vitals?.hrCat ?? 'Sin datos';
      case 'oxigenacion':
        return vitals?.spo2Cat ?? 'Sin datos';
      case 'temperatura':
        return vitals?.tempCat ?? 'Sin datos';
      default:
        return 'Sin datos';
    }
  }

  Color get colorEstado {
    if (valor == null) {
      return AppColors.textoSecundario;
    }

    if (categoria.toLowerCase() == 'normal') {
      return AppColors.exito;
    }

    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final dato = valor;

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
                  20,
                  18,
                  20,
                  30,
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
                            titulo,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.appBarLight,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 100,
                      height: 100,
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
                        size: 54,
                        color: AppColors.colorBotonPrincipal,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Monitoreo en tiempo real',
                      style: AppTextStyles.appBarLight.copyWith(
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Consulta el estado de tu medición',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.normal.copyWith(
                        color: AppColors.textoClaro,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // TARJETA DEL VALOR ACTUAL
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.moradoDecoracion
                            .withValues(alpha: 0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Valor actual',
                        style: AppTextStyles.subtitulo,
                      ),

                      const SizedBox(height: 22),

                      if (cargando)
                        const CircularProgressIndicator(
                          color: AppColors.colorPrincipal,
                        )
                      else if (dato == null)
                        Text(
                          '--',
                          style: AppTextStyles.headingPrimary
                              .copyWith(fontSize: 46),
                        )
                      else
                        Text(
                          '${dato.toStringAsFixed(1)} $unidad',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingPrimary
                              .copyWith(fontSize: 38),
                        ),

                      const SizedBox(height: 22),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: colorEstado.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: colorEstado.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              dato == null
                                  ? Icons.info_outline
                                  : Icons.circle,
                              size: 12,
                              color: colorEstado,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              dato == null
                                  ? 'Sin datos'
                                  : categoria,
                              style: AppTextStyles.normal.copyWith(
                                color: colorEstado,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Actualización automática cada 2 segundos',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.secundario,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // OPCIONES
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opciones de monitoreo',
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 16),

                    _botonOpcion(
                      icono: Icons.calendar_month_rounded,
                      titulo: 'Ver historial',
                      descripcion:
                          'Consulta las mediciones por fecha',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistorialVitales(
                              tipoVital: widget.tipoVital,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    _botonOpcion(
                      icono: Icons.notifications_active_outlined,
                      titulo: 'Alarmas',
                      descripcion:
                          'Consulta información sobre las alertas de este signo vital',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Alarmas(
                              tipoVital: widget.tipoVital,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonOpcion({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.fondoBlanco,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.moradoDecoracion.withValues(
                alpha: 0.6,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.iconoSuave,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icono,
                  color: AppColors.colorBotonPrincipal,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      descripcion,
                      style: AppTextStyles.secundario,
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.colorPrincipal,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarInformacion() {
    String informacion;

    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        informacion =
            'En muchos adultos en reposo, la frecuencia cardíaca '
            'suele estar entre 60 y 100 latidos por minuto. '
            'La edad, la actividad física, los medicamentos y '
            'otras condiciones pueden modificar este rango.';
        break;

      case 'oxigenacion':
        informacion =
            'En muchas personas sanas, la saturación de oxígeno '
            'suele estar entre 95 % y 100 %. La altitud y algunas '
            'enfermedades pueden modificar este valor.';
        break;

      case 'temperatura':
        informacion =
            'La temperatura corporal varía según la persona, '
            'la hora y el sitio de medición. Una lectura cercana '
            'a 37 °C es frecuente, pero no existe un único valor '
            'normal para todas las personas.';
        break;

      default:
        informacion = 'No hay información disponible.';
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fondoPantallaPrincipal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: const Text(
          'Valores de referencia',
          style: AppTextStyles.headingPrimary,
        ),
        content: Text(
          informacion,
          style: AppTextStyles.paragraph,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(
                color: AppColors.colorBotonPrincipal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}