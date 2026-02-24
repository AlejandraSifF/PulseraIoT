import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class CambiarCorreoPantalla extends StatefulWidget {
  const CambiarCorreoPantalla({super.key});

  @override
  State<CambiarCorreoPantalla> createState() =>
      _CambiarCorreoPantallaState();
}

class _CambiarCorreoPantallaState extends State<CambiarCorreoPantalla> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController correoActualController = TextEditingController();
  final TextEditingController nuevoCorreoController = TextEditingController();

  Future<void> _cambiarCorreo() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _mostrarError("No hay sesión activa");
        return;
      }

      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/auth/change-email'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: jsonEncode({
          'newEmail': nuevoCorreoController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Correo actualizado correctamente"),
            backgroundColor: AppColors.exito,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) Navigator.pop(context);
      } else {
        _mostrarError(data['message']);
      }
    } catch (e) {
      _mostrarError("Error de conexión con el servidor");
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoClaro),
        title: const Text(
          "Actualizar correo",
          style: TextStyle(
            color: AppColors.textoClaro,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _titulo("Correo actual"),
              _campoCorreo(
                controller: correoActualController,
                enabled: false,
              ),

              const SizedBox(height: 25),

              _titulo("Nuevo correo"),
              _campoCorreo(
                controller: nuevoCorreoController,
                enabled: true,
              ),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: _cambiarCorreo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotonPrincipal,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Actualizar correo",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textoClaro,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.colorBotonPrincipal,
          ),
        ),
      ),
    );
  }

  Widget _campoCorreo({
    required TextEditingController controller,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fondoCamposTexto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (enabled) {
          if (value == null || value.isEmpty) {
            return "Campo obligatorio";
          }
          if (!value.contains('@')) {
            return "Correo inválido";
          }
        }
        return null;
      },
    );
  }
}