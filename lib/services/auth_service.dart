import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  // ==================================================
  // BASE URL
  // ==================================================
  static const String baseUrl =
       'http://10.0.2.2:3000/api/auth';

  //static const String baseUrl =
      //'http://192.168.1.111:3000/api/auth';

  // ==================================================
  // TOKEN / USER ID
  // ==================================================
  static String? token;

  static String? userId;

  // ==================================================
  // REGISTRO
  // ==================================================
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
      'email': email.trim().toLowerCase(),
      'password': password,
      'telefono': telefono,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode != 200 && response.statusCode != 201) {
    return {
      'ok': false,
      'message': data['message'] ?? 'Error en registro',
    };
  }

  return {
    'ok': true,
    'data': data,
  };
}
  // ==================================================
  // LOGIN
  // ==================================================
  static Future<Map<String, dynamic>> login({

    required String email,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'email': email.trim().toLowerCase(),
        'password': password,
      }),
    );

    final data =
        jsonDecode(response.body);

    if (data['ok'] == true &&
        data['token'] != null) {

      token =
          data['token'];

      userId =
          data['user']['_id'];

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'token',
        token!,
      );

      await prefs.setString(
        'correo',
        data['user']['email'],
      );
    }

    return data;
  }

  // ==================================================
  // GUARDAR CUESTIONARIO
  // ==================================================
  static Future<Map<String, dynamic>>
      guardarCuestionario({

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

    final prefs =
        await SharedPreferences.getInstance();

    token ??=
        prefs.getString('token');

    print(
      "TOKEN EN CUESTIONARIO: $token",
    );

    final response = await http.post(

      Uri.parse('$baseUrl/cuestionario'),

      headers: {

        'Content-Type':
            'application/json',

        'x-token':
            token ?? '',
      },

      body: jsonEncode({

        'tipoHome':
            tipoHome,

        'sexo':
            sexo,

        'viveSolo':
            viveSolo,

        'hipertension':
            hipertension,

        'diabetes':
            diabetes,

        'caidas':
            caidas,

        'movilidad':
            movilidad,

        'medicacion':
            medicacion,

        'contactoEmergenciaNombre':
            contactoEmergenciaNombre,

        'contactoEmergenciaTelefono':
            contactoEmergenciaTelefono,

        'fechaNacimiento':
            fechaNacimiento,
      }),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {

      return {

        'ok': false,

        'message':
            data['message'] ??
                'Error en cuestionario',
      };
    }

    return data;
  }

  // ==================================================
  // REGISTER GOOGLE
  // ==================================================
  static Future<Map<String, dynamic>> registerGoogle({
  required String name,
  required String email,
  required String telefono,
  required String fechaNacimiento,
}) async {

  try {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/register-google',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'name': name,
        'email':
            email.trim().toLowerCase(),
        'telefono': telefono,
        'fechaNacimiento':
            fechaNacimiento,
      }),
    );

    final data =
        jsonDecode(response.body);

    // =========================
    // YA EXISTE
    // =========================
    if (response.statusCode == 400) {

      return {

        'ok': false,
        'exists': true,

        'message':
            data['message'] ??
                'Ya existe la cuenta, inicia sesión',
      };
    }

    // =========================
    // REGISTRO EXITOSO
    // =========================
    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      if (data['token'] != null) {

        token =
            data['token'];

        userId =
            data['user']['_id'];

        final prefs =
            await SharedPreferences
                .getInstance();

        await prefs.setString(
          'token',
          token!,
        );

        await prefs.setString(
          'correo',
          data['user']['email'],
        );
      }

      return {

        'ok': true,
        'exists': false,
        'data': data,
      };
    }

    return {

      'ok': false,

      'message':
          data['message'] ??
              'Error en Google register',
    };

  } catch (e) {

    return {

      'ok': false,

      'message':
          e.toString(),
    };
  }
}

  // ==================================================
  // LOGIN GOOGLE
  // ==================================================
  static Future<Map<String, dynamic>>
      loginGoogle({

    required String email,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(
          '$baseUrl/login-google',
        ),

        headers: {
          'Content-Type':
              'application/json',
        },

        body: jsonEncode({
          'email': email.trim().toLowerCase(),
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['token'] != null) {

        token =
            data['token'];

        userId =
            data['user']['_id'];

        final prefs =
            await SharedPreferences
                .getInstance();

        print(
          "TOKEN GOOGLE: ${data['token']}",
        );

        await prefs.setString(
          'token',
          token!,
        );

        await prefs.setString(
          'correo',
          data['user']['email'],
        );
      }

      return data;

    } catch (e) {

      return {

        'ok': false,

        'message':
            e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>>
    verificarCorreo({

  required String email,

}) async {

  try {

    final response =
        await http.post(

      Uri.parse(
        '$baseUrl/login',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'email':
            email.trim().toLowerCase(),

        'password':
            'verificacion_fake',
      }),
    );

    final data =
        jsonDecode(response.body);

    // Usuario existe
    if (response.statusCode == 400 &&
        data['message'] !=
            'Usuario no existe') {

      return {
        'exists': true,
      };
    }

    // Usuario NO existe
    if (data['message'] ==
        'Usuario no existe') {

      return {
        'exists': false,
      };
    }

    return {
      'exists': false,
    };

  } catch (e) {

    return {
      'exists': false,
    };
  }
}

  // ==================================================
  // ACTUALIZAR PERFIL
  // ==================================================
  static Future<Map<String, dynamic>>
      actualizarPerfil({

    required String name,
    required String telefono,
    required String contactoNombre,
    required String contactoTelefono,
    required String fechaNacimiento,

  }) async {

    final response = await http.put(

      Uri.parse(
        '$baseUrl/update-profile',
      ),

      headers: {

        'Content-Type':
            'application/json',

        'x-token':
            token ?? '',
      },

      body: jsonEncode({

        'name':
            name,

        'telefono':
            telefono,

        'contactoNombre':
            contactoNombre,

        'contactoTelefono':
            contactoTelefono,

        'fechaNacimiento':
            fechaNacimiento,
      }),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200) {

      return {

        'ok': false,

        'message':
            data['message'] ??
                'Error actualizando perfil',
      };
    }

    return data;
  }
}