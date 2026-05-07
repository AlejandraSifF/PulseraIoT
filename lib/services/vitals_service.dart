import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vitals_model.dart';

class VitalsService {

  static const String baseUrl =
      'http://192.168.1.241/vitals';//http://192.168.1.241:80

  static Future<VitalsModel?> getVitals() async {
    try {

      final response = await http.get(
        Uri.parse(baseUrl),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return VitalsModel.fromJson(data);
      }

    } catch (e) {
      print("Error obteniendo datos: $e");
    }

    return null;
  }
}