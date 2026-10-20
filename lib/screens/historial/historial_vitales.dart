import 'package:flutter/material.dart';

import '../../services/historial_vitals_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'detalle_vitales_dia.dart';

class HistorialVitales extends StatefulWidget {
  final String? tipoVital;

  const HistorialVitales({
    super.key,
    this.tipoVital,
  });

  @override
  State<HistorialVitales> createState() => _HistorialVitalesState();
}

class _HistorialVitalesState extends State<HistorialVitales> {
  List<dynamic> historial = [];
  bool cargando = true;

  // Mes que actualmente estamos visualizando
  DateTime mesActual = DateTime.now();

  // Día seleccionado
  DateTime? diaSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarHistorial();
  }

  // ============================================================
  // CARGAR HISTORIAL
  // ============================================================

  Future<void> cargarHistorial() async {
    setState(() {
      cargando = true;
    });

    final resultado =
        await HistorialVitalsService.obtenerHistorial();

    if (!mounted) return;

    if (resultado['ok'] == true) {
      setState(() {
        historial = resultado['historial'] ?? [];
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado['message'] ??
                'No se pudo obtener el historial',
          ),
        ),
      );
    }
  }

  
  // ============================================================
  // FILTRAR POR SIGNO VITAL
  // ============================================================

  String? obtenerCampoVital() {
    switch (widget.tipoVital) {
      case 'frecuenciaCardiaca':
        return 'frecuenciaCardiaca';
      case 'oxigenacion':
        return 'oxigenacion';
      case 'temperatura':
        return 'temperatura';
      default:
        return null;
    }
  }

  bool tieneVital(dynamic medicion) {
    final campo = obtenerCampoVital();

    // Si no se eligió un signo, se conserva el historial completo.
    if (campo == null) return true;

    final valor = medicion[campo];

    if (valor == null) return false;

    final numero = double.tryParse(valor.toString());

    return numero != null && numero.isFinite;
  }


  // ============================================================
  // NOMBRE DEL MES
  // ============================================================

  String nombreMes(int mes) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return meses[mes - 1];
  }

  // ============================================================
  // CAMBIAR MES
  // ============================================================

  void mesAnterior() {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month - 1,
      );

      diaSeleccionado = null;
    });
  }

  void mesSiguiente() {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + 1,
      );

      diaSeleccionado = null;
    });
  }

  // ============================================================
  // SABER SI UN DÍA TIENE REGISTROS
  // ============================================================

  
  bool tieneRegistro(int dia) {
    for (final medicion in historial) {
      // Ignorar registros que no tengan el signo vital elegido.
      if (!tieneVital(medicion)) {
        continue;
      }

      final fecha = medicion['fechaHora'];

      if (fecha == null) {
        continue;
      }

      try {
        final fechaMedicion =
            DateTime.parse(fecha.toString()).toLocal();

        if (fechaMedicion.year == mesActual.year &&
            fechaMedicion.month == mesActual.month &&
            fechaMedicion.day == dia) {
          return true;
        }
      } catch (e) {
        // Ignoramos fechas que no puedan convertirse.
      }
    }

    return false;
  }


  // ============================================================
  // CANTIDAD DE DÍAS DEL MES
  // ============================================================

  int diasDelMes() {
    return DateTime(
      mesActual.year,
      mesActual.month + 1,
      0,
    ).day;
  }

  // ============================================================
  // PRIMER DÍA DEL MES
  // ============================================================

  int primerDiaSemana() {
    final primerDia = DateTime(
      mesActual.year,
      mesActual.month,
      1,
    );

    // DateTime.weekday:
    // lunes = 1
    // domingo = 7

    return primerDia.weekday;
  }

  // ============================================================
  // OBTENER MEDICIONES DE UN DÍA
  // ============================================================

  
  List<dynamic> medicionesDelDia(DateTime dia) {
    return historial.where((medicion) {
      // Ignorar registros que no tengan el signo vital elegido.
      if (!tieneVital(medicion)) {
        return false;
      }

      final fecha = medicion['fechaHora'];

      if (fecha == null) {
        return false;
      }

      try {
        final fechaMedicion =
            DateTime.parse(fecha.toString()).toLocal();

        return fechaMedicion.year == dia.year &&
            fechaMedicion.month == dia.month &&
            fechaMedicion.day == dia.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }


  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        iconTheme: const IconThemeData(
          color: AppColors.textoClaro,
        ),
        
        title: Text(
          widget.tipoVital == 'frecuenciaCardiaca'
              ? 'Historial de frecuencia cardíaca'
              : widget.tipoVital == 'oxigenacion'
                  ? 'Historial de oxigenación'
                  : widget.tipoVital == 'temperatura'
                      ? 'Historial de temperatura'
                      : 'Historial de signos vitales',
          style: AppTextStyles.appBarLight,
        ),

        centerTitle: true,
        elevation: 0,
      ),

      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: cargarHistorial,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _calendario(),

                  const SizedBox(height: 20),

                  if (diaSeleccionado != null)
                    _resumenDia(),
                ],
              ),
            ),
    );
  }

  // ============================================================
  // CALENDARIO
  // ============================================================

  Widget _calendario() {
    final totalDias = diasDelMes();
    final primerDia = primerDiaSemana();

    // Cantidad de espacios antes del día 1.
    final espaciosIniciales = primerDia - 1;

    final totalCeldas =
        espaciosIniciales + totalDias;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [

          // ------------------------------------------------------
          // MES Y AÑO
          // ------------------------------------------------------

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              IconButton(
                onPressed: mesAnterior,
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),

              Text(
                '${nombreMes(mesActual.month)} ${mesActual.year}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: mesSiguiente,
                icon: const Icon(
                  Icons.chevron_right,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // DÍAS DE LA SEMANA
          // ------------------------------------------------------

          Row(
            children: [
              _nombreDia('L'),
              _nombreDia('M'),
              _nombreDia('M'),
              _nombreDia('J'),
              _nombreDia('V'),
              _nombreDia('S'),
              _nombreDia('D'),
            ],
          ),

          const SizedBox(height: 8),

          // ------------------------------------------------------
          // DÍAS DEL MES
          // ------------------------------------------------------

          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),

            itemCount: totalCeldas,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),

            itemBuilder: (context, index) {

              // Espacios antes del día 1
              if (index < espaciosIniciales) {
                return const SizedBox();
              }

              final dia =
                  index - espaciosIniciales + 1;

              final tieneDatos =
                  tieneRegistro(dia);

              final seleccionado =
                  diaSeleccionado != null &&
                  diaSeleccionado!.year ==
                      mesActual.year &&
                  diaSeleccionado!.month ==
                      mesActual.month &&
                  diaSeleccionado!.day == dia;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    diaSeleccionado = DateTime(
                      mesActual.year,
                      mesActual.month,
                      dia,
                    );
                  });
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? AppColors.colorBotonPrincipal
                        : tieneDatos
                            ? AppColors.fondoCirculoIcono
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),

                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      Text(
                        '$dia',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              seleccionado ||
                                      tieneDatos
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color: seleccionado
                              ? AppColors.textoClaro
                              : Colors.black87,
                        ),
                      ),

                      if (tieneDatos &&
                          !seleccionado)
                        Positioned(
                          bottom: 5,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration:
                                BoxDecoration(
                              color: AppColors
                                  .colorBotonPrincipal,
                              shape:
                                  BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // LEYENDA
          // ------------------------------------------------------

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color:
                      AppColors.colorBotonPrincipal,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                'Día con registros',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOMBRE DE DÍA
  // ============================================================

  Widget _nombreDia(String dia) {
    return Expanded(
      child: Center(
        child: Text(
          dia,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RESUMEN DEL DÍA SELECCIONADO
  // ============================================================

  Widget _resumenDia() {
    final mediciones =
        medicionesDelDia(diaSeleccionado!);

    final dia = diaSeleccionado!.day
        .toString()
        .padLeft(2, '0');

    final mes = diaSeleccionado!.month
        .toString()
        .padLeft(2, '0');

    final anio = diaSeleccionado!.year;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ------------------------------------------------------
          // FECHA SELECCIONADA
          // ------------------------------------------------------

          Row(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.fondoCirculoIcono,

                child: Icon(
                  Icons.calendar_today,
                  color:
                      AppColors.colorBotonPrincipal,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      '$dia/$mes/$anio',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      mediciones.isEmpty
                          ? 'Sin mediciones registradas'
                          : '${mediciones.length} medición(es) registradas',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // BOTÓN PARA VER MEDICIONES
          // ------------------------------------------------------

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: mediciones.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleVitalesDia(
                            fecha: diaSeleccionado!,
                            mediciones: mediciones,
                            tipoVital: widget.tipoVital,
                          ),
                        ),
                      );
                    },

              icon: const Icon(
                Icons.bar_chart,
              ),

              label: const Text(
                'Ver mediciones del día',
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.colorBotonPrincipal,

                foregroundColor:
                    AppColors.textoClaro,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}