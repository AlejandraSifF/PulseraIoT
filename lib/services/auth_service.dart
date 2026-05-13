import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.223:3000/api/auth';

  static String? token;

  // ================= REGISTRO =================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String telefono,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'telefono': telefono,
      }),
    );

    return jsonDecode(response.body);
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['ok']) {
      token = data['token'];
    }

    return data;
  }

  // ================= CUESTIONARIO =================
  static Future<Map<String, dynamic>> guardarCuestionario({
    required String tipoHome,
    //required int edad,
    required String sexo,
    required String viveSolo,
    required bool hipertension,
    required bool diabetes,
    required String caidas,
    required String movilidad,
    required String medicacion,
    required String contactoEmergenciaNombre,
    required String contactoEmergenciaTelefono,
    required String fechaNacimiento,
  }) async {
    final url = Uri.parse('$baseUrl/cuestionario');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
      body: jsonEncode({
        'tipoHome': tipoHome,
        // 'edad': edad,
        'sexo': sexo,
        'viveSolo': viveSolo,
        'hipertension': hipertension,
        'diabetes': diabetes,
        'caidas': caidas,
        'movilidad': movilidad,
        'medicacion': medicacion,
        'contactoEmergenciaNombre': contactoEmergenciaNombre,
        'contactoEmergenciaTelefono': contactoEmergenciaTelefono,
        'fechaNacimiento': fechaNacimiento,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return {
        'ok': false,
        'message': data['message'] ?? 'Error en cuestionario',
      };
    }

    return data;
  }

  // ================= ACTUALIZAR PERFIL =================
  static Future<Map<String, dynamic>> actualizarPerfil({
    required String name,
    required String telefono,
    required String contactoNombre,
    required String contactoTelefono,
    required String fechaNacimiento,
  }) async {
    final url = Uri.parse('$baseUrl/update-profile');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
      body: jsonEncode({
        'name': name,
        'telefono': telefono,
        'contactoNombre': contactoNombre,
        'contactoTelefono': contactoTelefono,
        'fechaNacimiento': fechaNacimiento,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return {
        'ok': false,
        'message': data['message'] ?? 'Error actualizando perfil',
      };
    }

    return data;
  }
}