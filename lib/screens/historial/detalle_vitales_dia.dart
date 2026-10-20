import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';


class DetalleVitalesDia extends StatelessWidget {
  final DateTime fecha;
  final List<dynamic> mediciones;
  final String? tipoVital;

  const DetalleVitalesDia({
    super.key,
    required this.fecha,
    required this.mediciones,
    this.tipoVital,
  });


  // ============================================================
  // DATOS DE FRECUENCIA CARDÍACA
  // ============================================================

  List<FlSpot> datosFrecuenciaCardiaca() {
    final puntos = <FlSpot>[];

    for (int i = 0; i < mediciones.length; i++) {
      final medicion = mediciones[i];
      final valor = medicion['frecuenciaCardiaca'];

      if (valor == null) {
        continue;
      }

      final frecuencia = double.tryParse(valor.toString());

      if (frecuencia == null) {
        continue;
      }

      puntos.add(
        FlSpot(
          i.toDouble(),
          frecuencia,
        ),
      );
    }

    return puntos;
  }

  // ============================================================
  // DATOS DE OXIGENACIÓN
  // ============================================================

  List<FlSpot> datosOxigenacion() {
    final puntos = <FlSpot>[];

    for (int i = 0; i < mediciones.length; i++) {
      final medicion = mediciones[i];
      final valor = medicion['oxigenacion'];

      if (valor == null) {
        continue;
      }

      final oxigenacion = double.tryParse(valor.toString());

      if (oxigenacion == null) {
        continue;
      }

      puntos.add(
        FlSpot(
          i.toDouble(),
          oxigenacion,
        ),
      );
    }

    return puntos;
  }

  // ============================================================
  // DATOS DE TEMPERATURA
  // ============================================================

  List<FlSpot> datosTemperatura() {
    final puntos = <FlSpot>[];

    for (int i = 0; i < mediciones.length; i++) {
      final medicion = mediciones[i];
      final valor = medicion['temperatura'];

      if (valor == null) {
        continue;
      }

      final temperatura = double.tryParse(valor.toString());

      if (temperatura == null) {
        continue;
      }

      puntos.add(
        FlSpot(
          i.toDouble(),
          temperatura,
        ),
      );
    }

    return puntos;
  }

  // ============================================================
  // CONVERTIR FECHA/HORA DE LA MEDICIÓN
  // ============================================================

  DateTime? obtenerFechaHora(dynamic medicion) {
    final valor = medicion['fechaHora'];

    if (valor == null) {
      return null;
    }

    if (valor is DateTime) {
      return valor.toLocal();
    }

    final fechaHora = DateTime.tryParse(valor.toString());

    return fechaHora?.toLocal();
  }

  // ============================================================
  // FORMATO DE HORA
  // ============================================================

  String formatoHora(DateTime fechaHora) {
    final hora = fechaHora.hour.toString().padLeft(2, '0');
    final minuto = fechaHora.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  // ============================================================
  // MÁXIMO DEL EJE X
  // ============================================================

  double _maximoX(List<FlSpot> puntos) {
    if (puntos.isEmpty) {
      return 1;
    }

    double maximo = puntos.first.x;

    for (final punto in puntos) {
      if (punto.x > maximo) {
        maximo = punto.x;
      }
    }

    return maximo == 0 ? 1 : maximo;
  }

  // ============================================================
  // MÁXIMO DEL EJE Y
  // ============================================================

  double _maximoGrafica(
    List<FlSpot> puntos,
    double limiteSuperior,
  ) {
    double maximo = limiteSuperior;

    for (final punto in puntos) {
      if (punto.y > maximo) {
        maximo = punto.y;
      }
    }

    return maximo + 5;
  }

  // ============================================================
  // MÍNIMO DEL EJE Y
  // ============================================================

  double _minimoGrafica(
    List<FlSpot> puntos,
    double limiteInferior,
    double margen,
  ) {
    double minimo = limiteInferior;

    for (final punto in puntos) {
      if (punto.y < minimo) {
        minimo = punto.y;
      }
    }

    minimo -= margen;

    if (minimo < 0) {
      return 0;
    }

    return minimo;
  }

  // ============================================================
  // MOSTRAR HORA EN EL EJE X
  // ============================================================

  bool _mostrarHora(int indice, int ultimoIndice) {
    if (ultimoIndice <= 6) {
      return true;
    }

    final intervalo = (ultimoIndice / 5).ceil();

    return indice % intervalo == 0 || indice == ultimoIndice;
  }

  // ============================================================
  // VERIFICAR SI ESTÁ FUERA DE RANGO
  // ============================================================

  bool _fueraDeRango(
    double valor,
    double limiteInferior,
    double limiteSuperior,
  ) {
    return valor < limiteInferior || valor > limiteSuperior;
  }

  // ============================================================
  // FORMATO DEL VALOR PARA LA ETIQUETA
  // ============================================================

  String formatoValor(double valor) {
    if (valor == valor.roundToDouble()) {
      return valor.toInt().toString();
    }

    return valor.toStringAsFixed(1);
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
  // FECHA
  // ============================================================

  String formatoFecha() {
    return '${fecha.day} de ${nombreMes(fecha.month)} de ${fecha.year}';
  }

  // ============================================================
  // ETIQUETAS DE VALORES FUERA DE RANGO
  // ============================================================

  Widget _etiquetasFueraDeRango({
    required List<FlSpot> puntos,
    required double minY,
    required double maxY,
    required double limiteInferior,
    required double limiteSuperior,
    required String Function(double) formato,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (puntos.isEmpty) {
          return const SizedBox.shrink();
        }

        const double espacioIzquierdo = 40;
        const double espacioDerecho = 8;
        const double espacioSuperior = 8;
        const double espacioInferior = 32;

        final anchoGrafica =
            constraints.maxWidth -
            espacioIzquierdo -
            espacioDerecho;

        final altoGrafica =
            constraints.maxHeight -
            espacioSuperior -
            espacioInferior;

        final maxX = _maximoX(puntos);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (final punto in puntos)
              if (_fueraDeRango(
                punto.y,
                limiteInferior,
                limiteSuperior,
              ))
                Positioned(
                  left: espacioIzquierdo +
                      (maxX == 0
                          ? 0
                          : (punto.x / maxX) * anchoGrafica) -
                      18,
                  top: espacioSuperior +
                      (1 -
                              ((punto.y - minY) /
                                  (maxY - minY))) *
                          altoGrafica -
                      28,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      formato(punto.y),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
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
        title: const Text(
          'Mediciones del día',
          style: AppTextStyles.appBarLight,
        ),
        centerTitle: true,
        elevation: 0,
      ),

      
body: mediciones.isEmpty
    ? const Center(
        child: Text(
          'No hay mediciones registradas.',
        ),
      )
    : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tarjetaFecha(),

          const SizedBox(height: 20),

          _tarjetaResumen(),

          const SizedBox(height: 20),

          // Mostrar únicamente la gráfica seleccionada.
          if (tipoVital == 'frecuenciaCardiaca') ...[
            _tarjetaGraficaFrecuencia(),
          ] else if (tipoVital == 'oxigenacion') ...[
            _tarjetaGraficaOxigenacion(),
          ] else if (tipoVital == 'temperatura') ...[
            _tarjetaGraficaTemperatura(),
          ] else ...[
            // Historial general: conservar todas las gráficas.
            _tarjetaGraficaFrecuencia(),

            const SizedBox(height: 16),

            _tarjetaGraficaOxigenacion(),

            const SizedBox(height: 16),

            _tarjetaGraficaTemperatura(),

            const SizedBox(height: 16),

            _tarjetaMovimiento(),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA DE FECHA
  // ============================================================

  Widget _tarjetaFecha() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.fondoCirculoIcono,
            child: Icon(
              Icons.calendar_today,
              color: AppColors.colorBotonPrincipal,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fecha seleccionada',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  formatoFecha(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA DE RESUMEN
  // ============================================================

  Widget _tarjetaResumen() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.fondoCirculoIcono,
            child: Icon(
              Icons.analytics_outlined,
              color: AppColors.colorBotonPrincipal,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mediciones registradas',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${mediciones.length}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'registros durante el día',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRÁFICA DE FRECUENCIA CARDÍACA
  // ============================================================

  Widget _tarjetaGraficaFrecuencia() {
    final puntos = datosFrecuenciaCardiaca();
    final maxX = _maximoX(puntos);
    final maxY = _maximoGrafica(puntos, 100);
    final minY = _minimoGrafica(puntos, 60, 10);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.fondoCirculoIcono,
                child: Icon(
                  Icons.favorite,
                  color: AppColors.colorBotonPrincipal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frecuencia cardíaca',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Referencia: 60–100 lpm',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 240,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                puntos.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay datos de frecuencia cardíaca',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,

                          gridData: FlGridData(
                            show: true,
                          ),

                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 60,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                              HorizontalLine(
                                y: 100,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                            ],
                          ),

                          borderData: FlBorderData(
                            show: true,
                          ),

                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final indice = value.toInt();

                                  if (indice < 0 ||
                                      indice >= mediciones.length) {
                                    return const SizedBox.shrink();
                                  }

                                  if (!_mostrarHora(
                                    indice,
                                    mediciones.length - 1,
                                  )) {
                                    return const SizedBox.shrink();
                                  }

                                  final fechaHora =
                                      obtenerFechaHora(
                                    mediciones[indice],
                                  );

                                  if (fechaHora == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      formatoHora(fechaHora),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              spots: puntos,
                              isCurved: true,
                              barWidth: 3,

                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (
                                  spot,
                                  percent,
                                  barData,
                                  index,
                                ) {
                                  final fueraDeRango =
                                      _fueraDeRango(
                                    spot.y,
                                    60,
                                    100,
                                  );

                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: fueraDeRango
                                        ? Colors.red
                                        : AppColors
                                            .colorBotonPrincipal,
                                    strokeWidth: 1,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),

                              belowBarData: BarAreaData(
                                show: true,
                              ),
                            ),
                          ],
                        ),
                      ),

                _etiquetasFueraDeRango(
                  puntos: puntos,
                  minY: minY,
                  maxY: maxY,
                  limiteInferior: 60,
                  limiteSuperior: 100,
                  formato: formatoValor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRÁFICA DE OXIGENACIÓN
  // ============================================================

  Widget _tarjetaGraficaOxigenacion() {
    final puntos = datosOxigenacion();
    final maxX = _maximoX(puntos);
    final maxY = _maximoGrafica(puntos, 100);
    final minY = _minimoGrafica(puntos, 95, 2);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.fondoCirculoIcono,
                child: Icon(
                  Icons.water_drop,
                  color: AppColors.colorBotonPrincipal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oxigenación',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Referencia: 95–100 %',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 240,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                puntos.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay datos de oxigenación',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,

                          gridData: FlGridData(
                            show: true,
                          ),

                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 95,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                              HorizontalLine(
                                y: 100,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                            ],
                          ),

                          borderData: FlBorderData(
                            show: true,
                          ),

                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final indice = value.toInt();

                                  if (indice < 0 ||
                                      indice >= mediciones.length) {
                                    return const SizedBox.shrink();
                                  }

                                  if (!_mostrarHora(
                                    indice,
                                    mediciones.length - 1,
                                  )) {
                                    return const SizedBox.shrink();
                                  }

                                  final fechaHora =
                                      obtenerFechaHora(
                                    mediciones[indice],
                                  );

                                  if (fechaHora == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      formatoHora(fechaHora),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              spots: puntos,
                              isCurved: true,
                              barWidth: 3,

                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (
                                  spot,
                                  percent,
                                  barData,
                                  index,
                                ) {
                                  final fueraDeRango =
                                      _fueraDeRango(
                                    spot.y,
                                    95,
                                    100,
                                  );

                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: fueraDeRango
                                        ? Colors.red
                                        : AppColors
                                            .colorBotonPrincipal,
                                    strokeWidth: 1,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),

                              belowBarData: BarAreaData(
                                show: true,
                              ),
                            ),
                          ],
                        ),
                      ),

                _etiquetasFueraDeRango(
                  puntos: puntos,
                  minY: minY,
                  maxY: maxY,
                  limiteInferior: 95,
                  limiteSuperior: 100,
                  formato: formatoValor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRÁFICA DE TEMPERATURA
  // ============================================================

  Widget _tarjetaGraficaTemperatura() {
    final puntos = datosTemperatura();
    final maxX = _maximoX(puntos);
    final maxY = _maximoGrafica(puntos, 37.3);
    final minY = _minimoGrafica(puntos, 36.5, 0.5);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.fondoCirculoIcono,
                child: Icon(
                  Icons.thermostat,
                  color: AppColors.colorBotonPrincipal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperatura',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Referencia: 36.5–37.3 °C',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 240,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                puntos.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay datos de temperatura',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,

                          gridData: FlGridData(
                            show: true,
                          ),

                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 36.5,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                              HorizontalLine(
                                y: 37.3,
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                              ),
                            ],
                          ),

                          borderData: FlBorderData(
                            show: true,
                          ),

                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final indice = value.toInt();

                                  if (indice < 0 ||
                                      indice >= mediciones.length) {
                                    return const SizedBox.shrink();
                                  }

                                  if (!_mostrarHora(
                                    indice,
                                    mediciones.length - 1,
                                  )) {
                                    return const SizedBox.shrink();
                                  }

                                  final fechaHora =
                                      obtenerFechaHora(
                                    mediciones[indice],
                                  );

                                  if (fechaHora == null) {
                                    return const SizedBox.shrink();
                                  }

                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      formatoHora(fechaHora),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 45,
                              ),
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              spots: puntos,
                              isCurved: true,
                              barWidth: 3,

                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (
                                  spot,
                                  percent,
                                  barData,
                                  index,
                                ) {
                                  final fueraDeRango =
                                      _fueraDeRango(
                                    spot.y,
                                    36.5,
                                    37.3,
                                  );

                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: fueraDeRango
                                        ? Colors.red
                                        : AppColors
                                            .colorBotonPrincipal,
                                    strokeWidth: 1,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),

                              belowBarData: BarAreaData(
                                show: true,
                              ),
                            ),
                          ],
                        ),
                      ),

                _etiquetasFueraDeRango(
                  puntos: puntos,
                  minY: minY,
                  maxY: maxY,
                  limiteInferior: 36.5,
                  limiteSuperior: 37.3,
                  formato: formatoValor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA DE MOVIMIENTO
  // ============================================================

  Widget _tarjetaMovimiento() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.fondoCirculoIcono,
                child: Icon(
                  Icons.directions_run,
                  color: AppColors.colorBotonPrincipal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movimiento',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Estado de movimiento',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.fondoCirculoIcono,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.directions_run,
                  size: 40,
                  color: Colors.grey,
                ),

                SizedBox(height: 10),

                Text(
                  'Sin datos de movimiento registrados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}