import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorialVitalsService {

  // BASE URL:
  
  static const String baseUrl =
      'http://10.0.2.2:3000/api/vitals';


  // OBTENER TOKEN:

  static Future<String?> _getToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }


  // GUARDAR UNA MEDICIÓN:

  static Future<Map<String, dynamic>> guardarVitales({

    double? frecuenciaCardiaca,
    double? oxigenacion,
    double? temperatura,
    String? movimiento,

  }) async {

    try {

      final token = await _getToken();

      if (token == null || token.isEmpty) {

        return {
          'ok': false,
          'message': 'No hay token de autenticación',
        };

      }
      // ============================================================
    // FECHA Y HORA DEL DISPOSITIVO
    // ============================================================

    final ahora = DateTime.now();

    // Fecha LOCAL del dispositivo.
    // Ejemplo: 2026-10-08
    final fechaLocal =
        '${ahora.year.toString().padLeft(4, '0')}-'
        '${ahora.month.toString().padLeft(2, '0')}-'
        '${ahora.day.toString().padLeft(2, '0')}';

    // Instante convertido a UTC para almacenarlo correctamente.
    final fechaHoraUtc = ahora.toUtc().toIso8601String();


      final response = await http.post(

        Uri.parse(baseUrl),

        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },

        body: jsonEncode({
          'fechaLocal': fechaLocal,
          'fechaHora': fechaHoraUtc,

          'frecuenciaCardiaca':
              frecuenciaCardiaca,

          'oxigenacion':
              oxigenacion,

          'temperatura':
              temperatura,

          'movimiento':
              movimiento,

        }),

      );


      final data = jsonDecode(response.body);


      if (response.statusCode == 201) {

        return data;

      }


      return {

        'ok': false,

        'message':
            data['msg'] ??
            data['message'] ??
            'Error al guardar la medición',

      };


    } catch (e) {

      print(
        'Error guardando vitales: $e',
      );

      return {

        'ok': false,

        'message':
            e.toString(),

      };

    }

  }


  // OBTENER HISTORIAL:

  static Future<Map<String, dynamic>> obtenerHistorial() async {

    try {

      final token = await _getToken();


      if (token == null || token.isEmpty) {

        return {

          'ok': false,

          'message':
              'No hay token de autenticación',

        };

      }


      final response = await http.get(

        Uri.parse(baseUrl),

        headers: {

          'Content-Type':
              'application/json',

          'x-token':
              token,

        },

      );


      final data = jsonDecode(response.body);


      if (response.statusCode == 200) {

        return data;

      }


      return {

        'ok': false,

        'message':
            data['msg'] ??
            data['message'] ??
            'Error al obtener el historial',

      };


    } catch (e) {

      print(
        'Error obteniendo historial: $e',
      );

      return {

        'ok': false,

        'message':
            e.toString(),

      };

    }

  }

// ==================================================
// PRUEBA TEMPORAL - VARIAS MEDICIONES
// ==================================================
static Future<void> pruebaGuardar() async {
  final medicionesPrueba = [
    {
      'frecuenciaCardiaca': 75.0,
      'oxigenacion': 98.0,
      'temperatura': 36.7,
    },
    {
      'frecuenciaCardiaca': 82.0,
      'oxigenacion': 97.0,
      'temperatura': 36.8,
    },
    {
      'frecuenciaCardiaca': 110.0,
      'oxigenacion': 98.0,
      'temperatura': 36.9,
    },
    {
      'frecuenciaCardiaca': 78.0,
      'oxigenacion': 91.0,
      'temperatura': 36.7,
    },
    {
      'frecuenciaCardiaca': 85.0,
      'oxigenacion': 96.0,
      'temperatura': 38.2,
    },
    {
      'frecuenciaCardiaca': 45.0,
      'oxigenacion': 99.0,
      'temperatura': 35.8,
    },
    {
      'frecuenciaCardiaca': 90.0,
      'oxigenacion': 98.0,
      'temperatura': 37.0,
    },
  ];

  for (final medicion in medicionesPrueba) {
    final resultado = await guardarVitales(
      frecuenciaCardiaca: medicion['frecuenciaCardiaca'],
      oxigenacion: medicion['oxigenacion'],
      temperatura: medicion['temperatura'],
    );

    print('RESULTADO PRUEBA VITALES: $resultado');

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }
} 
  
}