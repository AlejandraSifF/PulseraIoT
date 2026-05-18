import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../provider/perfil_provider.dart';

class CambiarCorreoPantalla extends StatefulWidget {
  const CambiarCorreoPantalla({super.key});

  @override
  State<CambiarCorreoPantalla> createState() =>
      _CambiarCorreoPantallaState();
}

class _CambiarCorreoPantallaState
    extends State<CambiarCorreoPantalla> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController
      correoActualController =
          TextEditingController();

  final TextEditingController
      nuevoCorreoController =
          TextEditingController();

  final TextEditingController
      passwordController =
          TextEditingController();

  bool ocultarPassword = true;

  // ================= CARGAR CORREO =================
  @override
  void initState() {
    super.initState();
    _cargarCorreo();
  }

  Future<void> _cargarCorreo() async {

    final prefs =
        await SharedPreferences.getInstance();

    String correo =
        prefs.getString("correo") ?? "";

    correoActualController.text = correo;
  }

  // ================= CAMBIAR CORREO =================
  Future<void> _cambiarCorreo() async {

    if (!_formKey.currentState!
        .validate()) return;

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String? token =
          prefs.getString('token');

      if (token == null) {

        _mostrarError(
          "No hay sesión activa",
        );

        return;
      }

      final response = await http.put(

        Uri.parse(
          'http://10.0.2.2:3000/api/auth/change-email',
        ),

        headers: {

          'Content-Type':
              'application/json',

          'x-token': token,
        },

        body: jsonEncode({

          'newEmail':
              nuevoCorreoController.text
                  .trim(),

          'currentPassword':
              passwordController.text
                  .trim(),
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['ok'] == true) {

        final nuevoCorreo =
            nuevoCorreoController.text
                .trim();

        // ================= GUARDAR LOCAL =================
        await prefs.setString(
          "correo",
          nuevoCorreo,
        );

        // ================= ACTUALIZAR PROVIDER =================
        final perfilProvider =
            Provider.of<PerfilProvider>(
          context,
          listen: false,
        );

        await perfilProvider
            .actualizarCorreo(
          nuevoCorreo,
        );

        // ================= ACTUALIZAR INPUT =================
        correoActualController.text =
            nuevoCorreo;

        nuevoCorreoController.clear();

        passwordController.clear();

        // ================= MENSAJE =================
        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: const Text(
              "Correo actualizado. Inicia sesión nuevamente.",
            ),

            backgroundColor:
                AppColors.exito,
          ),
        );

        // ================= CERRAR SESIÓN =================
        await Future.delayed(
          const Duration(seconds: 2),
        );

        await perfilProvider
            .cerrarSesion();

        if (mounted) {

          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        }

      } else {

        _mostrarError(

          data['message'] ??
              "No se pudo actualizar",
        );
      }

    } catch (e) {

      print(e);

      _mostrarError(
        "Error de conexión con el servidor",
      );
    }
  }

  // ================= ERROR =================
  void _mostrarError(String mensaje) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(mensaje),

        backgroundColor:
            AppColors.error,
      ),
    );
  }

  @override
  void dispose() {

    correoActualController.dispose();

    nuevoCorreoController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.fondoPantallaPrincipal,

      appBar: AppBar(

        backgroundColor:
            AppColors.colorPrincipal,

        centerTitle: true,

        iconTheme: const IconThemeData(
          color: AppColors.textoClaro,
        ),

        title: const Text(

          "Actualizar correo",

          style:
              AppTextStyles.appBarLight,
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 30,
        ),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              // ================= CORREO ACTUAL =================
              _titulo("Correo actual"),

              _campoCorreo(

                controller:
                    correoActualController,

                enabled: false,
              ),

              const SizedBox(height: 25),

              // ================= NUEVO CORREO =================
              _titulo("Nuevo correo"),

              _campoCorreo(

                controller:
                    nuevoCorreoController,

                enabled: true,
              ),

              const SizedBox(height: 25),

              // ================= CONTRASEÑA =================
              _titulo(
                "Contraseña actual",
              ),

              TextFormField(

                controller:
                    passwordController,

                obscureText:
                    ocultarPassword,

                style:
                    AppTextStyles.normal,

                decoration: InputDecoration(

                  filled: true,

                  fillColor:
                      AppColors
                          .fondoCamposTexto,

                  hintText:
                      "Ingrese su contraseña",

                  hintStyle:
                      AppTextStyles
                          .secundario,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),

                  suffixIcon:
                      IconButton(

                    icon: Icon(

                      ocultarPassword
                          ? Icons
                              .visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {

                      setState(() {

                        ocultarPassword =
                            !ocultarPassword;
                      });
                    },
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return
                        "Ingrese su contraseña";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 60),

              // ================= BOTÓN =================
              ElevatedButton(

                onPressed:
                    _cambiarCorreo,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      AppColors
                          .colorBotonPrincipal,

                  minimumSize:
                      const Size(
                    double.infinity,
                    55,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),
                ),

                child: const Text(

                  "Actualizar correo",

                  style:
                      AppTextStyles
                          .buttonLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TITULO =================
  Widget _titulo(String texto) {

    return Align(

      alignment:
          Alignment.centerLeft,

      child: Padding(

        padding:
            const EdgeInsets.only(
          bottom: 8,
        ),

        child: Text(

          texto,

          style:
              AppTextStyles
                  .headingPrimary,
        ),
      ),
    );
  }

  // ================= CAMPO CORREO =================
  Widget _campoCorreo({

    required TextEditingController
        controller,

    required bool enabled,
  }) {

    return TextFormField(

      controller: controller,

      enabled: enabled,

      keyboardType:
          TextInputType.emailAddress,

      style:
          AppTextStyles.normal,

      decoration: InputDecoration(

        filled: true,

        fillColor:
            AppColors
                .fondoCamposTexto,

        hintText: enabled
            ? "Ingrese su nuevo correo"
            : null,

        hintStyle:
            AppTextStyles.secundario,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            13,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),

      validator: (value) {

        if (enabled) {

          if (value == null ||
              value.isEmpty) {

            return
                "Campo obligatorio";
          }

          if (!value.contains('@')) {

            return
                "Correo inválido";
          }
        }

        return null;
      },
    );
  }
}