import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/auth_service.dart';

import '../password_rec/recuperar_password.dart';

class CambiarPasswordPantalla extends StatefulWidget {
  const CambiarPasswordPantalla({super.key});

  @override
  State<CambiarPasswordPantalla> createState() =>
      _CambiarPasswordPantallaState();
}

class _CambiarPasswordPantallaState
    extends State<CambiarPasswordPantalla> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController actualController =
      TextEditingController();

  final TextEditingController nuevaController =
      TextEditingController();

  final TextEditingController confirmarController =
      TextEditingController();

  bool ocultarActual = true;
  bool ocultarNueva = true;
  bool ocultarConfirmar = true;

  bool cargando = false;
  bool esGoogle = false;

  double fuerzaPassword = 0;

  bool tiene8Caracteres = false;
  bool tieneMayuscula = false;
  bool tieneNumero = false;
  bool tieneEspecial = false;

  // ==================================================
  // CAMBIAR PASSWORD
  // ==================================================
  Future<void> _cambiarPassword() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (nuevaController.text !=
        confirmarController.text) {

      _mostrarError(
        "Las contraseñas no coinciden",
      );

      return;
    }

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String? token =
          prefs.getString('token');

      token ??= AuthService.token;

      if (token == null) {

        _mostrarError(
          "No hay sesión activa",
        );

        return;
      }

      final url = Uri.parse(
        'http://10.0.2.2:3000/api/auth/change-password',
      );

      final response = await http.put(

        url,

        headers: {

          'Content-Type':
              'application/json',

          'x-token':
              token,
        },

        body: jsonEncode({

          'currentPassword':
              actualController.text,

          'newPassword':
              nuevaController.text,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['ok']) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: const Text(
              "Contraseña actualizada correctamente",
            ),

            backgroundColor:
                AppColors.exito,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 2),
        );

        if (mounted) {
          Navigator.pop(context);
        }

      } else {

        _mostrarError(
          data['message'] ??
              "Error al cambiar contraseña",
        );
      }

    } catch (e) {

      _mostrarError(
        "Error de conexión con el servidor",
      );
    }
  }

  // ==================================================
  // CREAR PASSWORD GOOGLE
  // ==================================================
  Future<void> _crearPasswordGoogle() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (nuevaController.text !=
        confirmarController.text) {

      _mostrarError(
        "Las contraseñas no coinciden",
      );

      return;
    }

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String? token =
          prefs.getString('token');

      token ??= AuthService.token;

      if (token == null) {

        _mostrarError(
          "No hay sesión activa",
        );

        return;
      }

      final response = await http.post(

        Uri.parse(
          'http://10.0.2.2:3000/api/auth/set-password',
        ),

        headers: {

          'Content-Type':
              'application/json',

          'x-token':
              token,
        },

        body: jsonEncode({

          'newPassword':
              nuevaController.text,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['ok']) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: const Text(
              "Contraseña creada correctamente",
            ),

            backgroundColor:
                AppColors.exito,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 2),
        );

        if (mounted) {
          Navigator.pop(context);
        }

      } else {

        _mostrarError(
          data['message'] ??
              "Error al crear contraseña",
        );
      }

    } catch (e) {

      _mostrarError(
        "Error de conexión con el servidor",
      );
    }
  }

  // ==================================================
  // VERIFICAR GOOGLE
  // ==================================================
  Future<void> _verificarTipoCuenta() async {

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String? correo =
          prefs.getString('correo');

      if (correo == null) return;

      final response = await http.post(

        Uri.parse(
          'http://10.0.2.2:3000/api/auth/login-google',
        ),

        headers: {

          'Content-Type':
              'application/json',
        },

        body: jsonEncode({

          'email':
              correo,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data['ok'] == true &&
          data['user'] != null) {

        setState(() {

          esGoogle =
              data['user']['password'] ==
                  'GOOGLE_LOGIN';
        });
      }

    } catch (e) {

      debugPrint(
        "Error verificando cuenta: $e",
      );
    }
  }

  // ==================================================
  // VALIDAR PASSWORD
  // ==================================================
  void _validarPassword(String value) {

    setState(() {

      tiene8Caracteres =
          value.length >= 8;

      tieneMayuscula =
          RegExp(r'[A-Z]')
              .hasMatch(value);

      tieneNumero =
          RegExp(r'[0-9]')
              .hasMatch(value);

      tieneEspecial =
          RegExp(
            r'[!@#$%^&*(),.?":{}|<>]',
          ).hasMatch(value);

      int puntos = 0;

      if (tiene8Caracteres) puntos++;
      if (tieneMayuscula) puntos++;
      if (tieneNumero) puntos++;
      if (tieneEspecial) puntos++;

      fuerzaPassword =
          puntos / 4;
    });
  }

  // ==================================================
  // ERROR
  // ==================================================
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
  void initState() {

    super.initState();

    _verificarTipoCuenta();
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
          "Cambiar contraseña",
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

              // ==================================================
              // PASSWORD ACTUAL
              // ==================================================
              if (!esGoogle) ...[

                _titulo(
                  "Contraseña actual",
                ),

                _campoPassword(

                  controller:
                      actualController,

                  ocultar:
                      ocultarActual,

                  toggle: () {

                    setState(() {

                      ocultarActual =
                          !ocultarActual;
                    });
                  },
                ),

                Align(

                  alignment:
                      Alignment.centerRight,

                  child: TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              const RecuperarPasswordScreen(
                            volverALogin: false,
                          ),
                        ),
                      );
                    },

                    child: Text(

                      "¿Olvidaste tu contraseña?",

                      style: AppTextStyles
                          .subtitulo
                          .copyWith(

                        color: AppColors
                            .colorBotonPrincipal,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

              ] else ...[

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(14),

                  margin:
                      const EdgeInsets.only(
                    bottom: 25,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Colors.blue.withOpacity(
                      0.08,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: const Text(

                    "Tu cuenta fue creada con Google. "
                    "Puedes crear una contraseña para iniciar sesión también con correo y contraseña.",

                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],

              // ==================================================
              // NUEVA PASSWORD
              // ==================================================
              _titulo(
                "Nueva contraseña",
              ),

              _campoPassword(

                controller:
                    nuevaController,

                ocultar:
                    ocultarNueva,

                toggle: () {

                  setState(() {

                    ocultarNueva =
                        !ocultarNueva;
                  });
                },

                onChanged:
                    _validarPassword,
              ),

              const SizedBox(
                height: 15,
              ),

              // ==================================================
              // BARRA SEGURIDAD
              // ==================================================
              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  ClipRRect(

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),

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
                            : fuerzaPassword <=
                                    0.50
                                ? Colors.orange
                                : fuerzaPassword <=
                                        0.75
                                    ? Colors.yellow
                                        .shade700
                                    : Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(

                    fuerzaPassword <= 0.25
                        ? "Contraseña débil"
                        : fuerzaPassword <=
                                0.50
                            ? "Contraseña media"
                            : fuerzaPassword <=
                                    0.75
                                ? "Contraseña buena"
                                : "Contraseña segura",

                    style: TextStyle(

                      fontWeight:
                          FontWeight.w600,

                      color:
                          fuerzaPassword <= 0.25
                              ? Colors.red
                              : fuerzaPassword <=
                                      0.50
                                  ? Colors.orange
                                  : fuerzaPassword <=
                                          0.75
                                      ? Colors.amber
                                          .shade700
                                      : Colors.green,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _itemValidacion(
                    "Mínimo 8 caracteres",
                    tiene8Caracteres,
                  ),

                  _itemValidacion(
                    "Al menos una mayúscula",
                    tieneMayuscula,
                  ),

                  _itemValidacion(
                    "Al menos un número",
                    tieneNumero,
                  ),

                  _itemValidacion(
                    "Un carácter especial (!@#\$...)",
                    tieneEspecial,
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              // ==================================================
              // CONFIRMAR PASSWORD
              // ==================================================
              _titulo(
                "Confirmar contraseña",
              ),

              _campoPassword(

                controller:
                    confirmarController,

                ocultar:
                    ocultarConfirmar,

                toggle: () {

                  setState(() {

                    ocultarConfirmar =
                        !ocultarConfirmar;
                  });
                },
              ),

              const SizedBox(
                height: 60,
              ),

              // ==================================================
              // BOTON
              // ==================================================
              ElevatedButton(

                onPressed: esGoogle
                    ? _crearPasswordGoogle
                    : _cambiarPassword,

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

                child: Text(

                  esGoogle
                      ? "Crear contraseña"
                      : "Cambiar contraseña",

                  style:
                      AppTextStyles.buttonLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // TITULO
  // ==================================================
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
              AppTextStyles.headingPrimary,
        ),
      ),
    );
  }

  // ==================================================
  // VALIDACION VISUAL
  // ==================================================
  Widget _itemValidacion(
    String texto,
    bool valido,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
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

          const SizedBox(
            width: 8,
          ),

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

  // ==================================================
  // CAMPO PASSWORD
  // ==================================================
  Widget _campoPassword({

    required TextEditingController
        controller,

    required bool ocultar,

    required VoidCallback toggle,

    Function(String)? onChanged,

  }) {

    return TextFormField(

      controller: controller,

      obscureText: ocultar,

      onChanged: onChanged,

      style:
          AppTextStyles.normal,

      decoration: InputDecoration(

        filled: true,

        fillColor:
            AppColors.fondoCamposTexto,

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

        suffixIcon:
            IconButton(

          icon: Icon(

            ocultar
                ? Icons.visibility_off
                : Icons.visibility,
          ),

          onPressed: toggle,
        ),
      ),

      validator: (value) {

        if (esGoogle &&
            controller ==
                actualController) {

          return null;
        }

        if (value == null ||
            value.isEmpty) {

          return "Campo obligatorio";
        }

        if (value.length < 8) {

          return "Debe tener al menos 8 caracteres";
        }

        if (!RegExp(r'[A-Z]')
            .hasMatch(value)) {

          return "Debe incluir una letra mayúscula";
        }

        if (!RegExp(r'[0-9]')
            .hasMatch(value)) {

          return "Debe incluir un número";
        }

        if (!RegExp(
          r'[!@#$%^&*(),.?\":{}|<>]',
        ).hasMatch(value)) {

          return "Debe incluir un carácter especial";
        }

        return null;
      },
    );
  }
}