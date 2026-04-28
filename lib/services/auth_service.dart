import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // 🔹 REGISTRO
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // 🔹 LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // 🔹 GUARDAR CUESTIONARIO 🔥
  static Future<Map<String, dynamic>> guardarCuestionario({
    required String email,
    required int edad,
    required String sexo,
    required String viveSolo,
    required bool hipertension,
    required bool diabetes,
    required String caidas,
    required String movilidad,
    required String medicacion,
    required String contactoNombre,
    required String contactoTelefono,
  }) async {
    final url = Uri.parse('$baseUrl/cuestionario');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'edad': edad,
        'sexo': sexo,
        'viveSolo': viveSolo,
        'hipertension': hipertension,
        'diabetes': diabetes,
        'caidas': caidas,
        'movilidad': movilidad,
        'medicacion': medicacion,
        'contactoNombre': contactoNombre,
        'contactoTelefono': contactoTelefono,
      }),
    );

    return jsonDecode(response.body);
  }
}