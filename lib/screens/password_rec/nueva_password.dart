//11-05-2025
//12-05-25

//11-05-2025
//18-05-25
//cambiar ip

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../auth/login/login.dart';

class NuevaPasswordScreen extends StatefulWidget {

  final String email;
  final String resetToken;
  final bool volverALogin;

  const NuevaPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
    required this.volverALogin,
  });

  @override
  State<NuevaPasswordScreen> createState() =>
      _NuevaPasswordScreenState();
}

class _NuevaPasswordScreenState
    extends State<NuevaPasswordScreen> {

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmController =
      TextEditingController();

  bool loading = false;
  bool ocultarPassword = true;
  bool ocultarConfirm = true;

  // NUEVO
  double fuerzaPassword = 0;

  bool tiene8Caracteres = false;
  bool tieneMayuscula = false;
  bool tieneNumero = false;
  bool tieneEspecial = false;

  final String baseUrl =
      'http://10.0.2.2:3000/api/password-reset';

  bool validarTodo() {

    return passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        tiene8Caracteres &&
        tieneMayuscula &&
        tieneNumero &&
        tieneEspecial &&
        passwordController.text ==
            confirmController.text;
  }

  // NUEVO
  void validarPassword(String value) {

    setState(() {

      tiene8Caracteres =
          value.length >= 8;

      tieneMayuscula =
          RegExp(r'[A-Z]').hasMatch(value);

      tieneNumero =
          RegExp(r'[0-9]').hasMatch(value);

      tieneEspecial = RegExp(
        r'[!@#$%^&*(),.?":{}|<>]',
      ).hasMatch(value);

      int puntos = 0;

      if (tiene8Caracteres) puntos++;
      if (tieneMayuscula) puntos++;
      if (tieneNumero) puntos++;
      if (tieneEspecial) puntos++;

      fuerzaPassword = puntos / 4;
    });
  }

  InputDecoration inputDecoration(
    bool ocultar,
    VoidCallback toggle,
  ) {

    return InputDecoration(

      filled: true,
      fillColor: AppColors.inputLogin,

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(12),

        borderSide: BorderSide.none,
      ),

      suffixIcon: IconButton(

        icon: Icon(

          ocultar
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),

        onPressed: toggle,
      ),
    );
  }

  // NUEVO
  Widget itemValidacion(
    String texto,
    bool valido,
  ) {

    return Padding(

      padding: const EdgeInsets.only(
        bottom: 6,
      ),

      child: Row(

        children: [

          Icon(

            valido
                ? Icons.check_circle
                : Icons.radio_button_unchecked,

            color:
                valido
                    ? Colors.green
                    : Colors.grey,

            size: 20,
          ),

          const SizedBox(width: 8),

          Text(

            texto,

            style: TextStyle(

              color:
                  valido
                      ? Colors.green
                      : Colors.grey.shade700,

              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  //
  Future<void> resetPassword() async {

    final password =
        passwordController.text.trim();

    setState(() => loading = true);

    try {

      final response = await http.post(

        Uri.parse('$baseUrl/reset-password'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({

          'email': widget.email,
          'resetToken': widget.resetToken,
          'newPassword': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content:
                Text('Contraseña actualizada'),

            backgroundColor:
                Colors.green,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );

        if (widget.volverALogin) {

          Navigator.pushAndRemoveUntil(

            context,

            MaterialPageRoute(
              builder: (_) =>
                  const LoginScreen(),
            ),

            (route) => false,
          );

        } else {

          Navigator.pop(context);
          Navigator.pop(context);
        }

      } else {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content: Text(
              data['message'] ?? 'Error',
            ),

            backgroundColor:
                Colors.red,
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:
              Text('Error de conexión'),

          backgroundColor:
              Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  //
  @override
  void dispose() {

    passwordController.dispose();
    confirmController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.fondoBlanco,

      appBar: AppBar(

        backgroundColor:
            AppColors.fondoBlanco,

        elevation: 0,

        title: const Text(

          'Nueva contraseña',

          style: TextStyle(

            color:
                AppColors
                    .colorBotonPrincipal,
          ),
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 20),

              const Text(

                'Ingresa tu nueva contraseña',

                style: TextStyle(

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors
                          .colorBotonPrincipal,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                'La contraseña debe tener mínimo 8 caracteres.',

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                  'Nueva contraseña'),

              const SizedBox(height: 8),

              TextField(

                controller:
                    passwordController,

                obscureText:
                    ocultarPassword,

                decoration:
                    inputDecoration(

                  ocultarPassword,

                  () {

                    setState(() {

                      ocultarPassword =
                          !ocultarPassword;
                    });
                  },

                ).copyWith(

                  helperText:
                      'Usa al menos 8 caracteres',

                  errorText:
                      passwordController
                              .text
                              .isEmpty
                          ? null
                          : (passwordController
                                      .text
                                      .length <
                                  8
                              ? 'La contraseña debe tener mínimo 8 caracteres'
                              : null),
                ),

                onChanged: (value) {

                  validarPassword(
                    value,
                  );
                },
              ),

              // NUEVO
              const SizedBox(height: 15),

              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  ClipRRect(

                    borderRadius:
                        BorderRadius.circular(10),

                    child:
                        LinearProgressIndicator(

                      value:
                          fuerzaPassword,

                      minHeight: 8,

                      backgroundColor:
                          Colors.grey.shade300,

                      valueColor:
                          AlwaysStoppedAnimation<Color>(

                        fuerzaPassword <= 0.25
                            ? Colors.red
                            : fuerzaPassword <= 0.50
                                ? Colors.orange
                                : fuerzaPassword <= 0.75
                                    ? Colors.yellow.shade700
                                    : Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    fuerzaPassword <= 0.25
                        ? "Contraseña débil"
                        : fuerzaPassword <= 0.50
                            ? "Contraseña media"
                            : fuerzaPassword <= 0.75
                                ? "Contraseña buena"
                                : "Contraseña segura",

                    style: TextStyle(

                      fontWeight:
                          FontWeight.w600,

                      color:
                          fuerzaPassword <= 0.25
                              ? Colors.red
                              : fuerzaPassword <= 0.50
                                  ? Colors.orange
                                  : fuerzaPassword <= 0.75
                                      ? Colors.amber.shade700
                                      : Colors.green,
                    ),
                  ),

                  const SizedBox(height: 12),

                  itemValidacion(
                    "Mínimo 8 caracteres",
                    tiene8Caracteres,
                  ),

                  itemValidacion(
                    "Al menos una mayúscula",
                    tieneMayuscula,
                  ),

                  itemValidacion(
                    "Al menos un número",
                    tieneNumero,
                  ),

                  itemValidacion(
                    "Un carácter especial (!@#\$...)",
                    tieneEspecial,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                  'Confirmar contraseña'),

              const SizedBox(height: 8),

              TextField(

                controller:
                    confirmController,

                obscureText:
                    ocultarConfirm,

                decoration:
                    inputDecoration(

                  ocultarConfirm,

                  () {

                    setState(() {

                      ocultarConfirm =
                          !ocultarConfirm;
                    });
                  },

                ).copyWith(

                  errorText:
                      confirmController
                              .text
                              .isEmpty
                          ? null
                          : (confirmController
                                      .text !=
                                  passwordController
                                      .text
                              ? 'Las contraseñas no coinciden'
                              : null),
                ),

                onChanged: (_) =>
                    setState(() {}),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 50,

                child:
                    ElevatedButton(

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        AppColors
                            .colorBotonPrincipal,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius
                              .circular(
                                  25),
                    ),
                  ),

                  onPressed:
                      loading ||
                              !validarTodo()
                          ? null
                          : resetPassword,

                  child: Text(

                    loading
                        ? 'Guardando...'
                        : 'Guardar contraseña',

                    style:
                        const TextStyle(

                      fontSize: 16,

                      color:
                          AppColors
                              .textoClaro,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}