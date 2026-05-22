//MODIFIQUE 07/05/25

import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {

    static const String baseUrl =
       'http://10.0.2.2:3000/api';

  //static const String baseUrl =
      //'http://192.168.1.111:3000/api/auth';

  static Future<bool> createReport({
    required String usuarioId,
    required String tipoProblema,
    required String descripcion
  }) async {

    try {

      final response = await http.post(

        Uri.parse('$baseUrl/report'),

        headers: {
          'Content-Type': 'application/json'
        },

        body: jsonEncode({

          'usuarioId': usuarioId,
          'tipoProblema': tipoProblema,
          'descripcion': descripcion

        }),

      );

      print(response.body);

      if (response.statusCode == 201) {
        return true;
      }

      return false;

    } catch (e) {

      print(e);
      return false;

    }

  }

}