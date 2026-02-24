import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class CambiarPasswordPantalla extends StatefulWidget {
  const CambiarPasswordPantalla({super.key});

  @override
  State<CambiarPasswordPantalla> createState() =>
      _CambiarPasswordPantallaState();
}

class _CambiarPasswordPantallaState
    extends State<CambiarPasswordPantalla> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController actualController = TextEditingController();
  final TextEditingController nuevaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  bool ocultarActual = true;
  bool ocultarNueva = true;
  bool ocultarConfirmar = true;

  Future<void> _cambiarPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (nuevaController.text != confirmarController.text) {
      _mostrarError("Las contraseñas no coinciden");
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _mostrarError("No hay sesión activa");
        return;
      }

      final url = Uri.parse('http://10.0.2.2:3000/api/auth/change-password');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: jsonEncode({
          'currentPassword': actualController.text,
          'newPassword': nuevaController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['ok']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Contraseña actualizada correctamente"),
            backgroundColor: AppColors.exito,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) Navigator.pop(context);
      } else {
        _mostrarError(data['message'] ?? "Error al cambiar contraseña");
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
  void dispose() {
    actualController.dispose();
    nuevaController.dispose();
    confirmarController.dispose();
    super.dispose();
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
          "Cambiar contraseña",
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

              _titulo("Contraseña actual"),
              _campoPassword(
                controller: actualController,
                ocultar: ocultarActual,
                toggle: () {
                  setState(() => ocultarActual = !ocultarActual);
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _mostrarError("Función no disponible aún");
                  },
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.colorBotonPrincipal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _titulo("Nueva contraseña"),
              _campoPassword(
                controller: nuevaController,
                ocultar: ocultarNueva,
                toggle: () {
                  setState(() => ocultarNueva = !ocultarNueva);
                },
              ),

              const SizedBox(height: 25),

              _titulo("Confirmar contraseña"),
              _campoPassword(
                controller: confirmarController,
                ocultar: ocultarConfirmar,
                toggle: () {
                  setState(() => ocultarConfirmar = !ocultarConfirmar);
                },
              ),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: _cambiarPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotonPrincipal,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Cambiar contraseña",
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

  Widget _campoPassword({
    required TextEditingController controller,
    required bool ocultar,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: ocultar,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fondoCamposTexto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            ocultar ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggle,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obligatorio";
        }
        if (value.length < 6) {
          return "Mínimo 6 caracteres";
        }
        return null;
      },
    );
  }
}