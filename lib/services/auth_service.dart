import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'telefono': telefono,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    return {
      'ok': false,
      'message': data['message'] ?? 'Error en registro',
    };
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['ok'] == true && data['token'] != null) {
      token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
    }

    return data;
  }

  // ================= CUESTIONARIO =================
  static Future<Map<String, dynamic>> guardarCuestionario({
    required String tipoHome,
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

    final prefs = await SharedPreferences.getInstance();
    token ??= prefs.getString('token'); // Intentar obtener token de SharedPreferences si no está en la variable estática 
    print("TOKEN EN CUESTIONARIO: $token");
    
    final response = await http.post(
      Uri.parse('$baseUrl/cuestionario'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
      body: jsonEncode({
        'tipoHome': tipoHome,
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

  // ================= REGISTRO GOOGLE =================
  static Future<Map<String, dynamic>> registerGoogle({
    required String name,
    required String email,
    required String telefono,
    required String fechaNacimiento,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register-google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'telefono': telefono,
          'fechaNacimiento': fechaNacimiento,
        }),
      );

      final data = jsonDecode(response.body);

      // 🔥 CASO: YA REGISTRADO
      if (response.statusCode == 400 || data['yaRegistrado'] == true) {
        return {
          'ok': false,
          'yaRegistrado': true,
          'message': data['message'] ?? 'Usuario ya registrado',
        };
      }

      // 🔥 CASO: ÉXITO
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['token'] != null) {
          token = data['token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token!);
        
        }

        return {
          'ok': true,
          'data': data,
        };
      }

      return {
        'ok': false,
        'message': data['message'] ?? 'Error en registro Google',
      };
    } catch (e) {
      return {
        'ok': false,
        'message': e.toString(),
      };
    }
  }

  // ================= LOGIN GOOGLE =================
  static Future<Map<String, dynamic>> loginGoogle({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login-google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        print("TOKEN GOOGLE: ${data['token']}");
        await prefs.setString('token', token!);
      }

      return data;
    } catch (e) {
      return {
        'ok': false,
        'message': e.toString(),
      };
    }
    
  }

  // ================= ACTUALIZAR PERFIL =================
  static Future<Map<String, dynamic>> actualizarPerfil({
    required String name,
    required String telefono,
    required String contactoNombre,
    required String contactoTelefono,
    required String fechaNacimiento,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-profile'),
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