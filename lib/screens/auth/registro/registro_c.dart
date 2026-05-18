import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'package:prueba/screens/cuestionario/cuestionario.dart';
import '../../../services/auth_service.dart';

class RegistroC extends StatefulWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final String fecha;

  const RegistroC({
    super.key,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.fecha,
  });

  @override
  State<RegistroC> createState() => _RegistroCState();
}

class _RegistroCState extends State<RegistroC> {

  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool ocultarPass = true;
  bool ocultarConfirm = true;

  double fuerzaPassword = 0;

  bool tiene8Caracteres = false;
  bool tieneMayuscula = false;
  bool tieneNumero = false;
  bool tieneEspecial = false;

  bool _todoValido() {

    return passCtrl.text.isNotEmpty &&
        confirmCtrl.text.isNotEmpty &&
        tiene8Caracteres &&
        tieneMayuscula &&
        tieneNumero &&
        tieneEspecial &&
        passCtrl.text == confirmCtrl.text;
  }

  void _validarPassword(String value) {

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

  InputDecoration _inputDecoration(
    String label,
    bool ocultar,
    VoidCallback toggle,
  ) {

    return InputDecoration(

      labelText: label,
      labelStyle: AppTextStyles.label,

      filled: true,
      fillColor: AppColors.inputRegistro,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      suffixIcon: IconButton(

        icon: Icon(
          ocultar
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,

          color: AppColors.textoSecundario,
        ),

        onPressed: toggle,
      ),
    );
  }

  Widget _itemValidacion(
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

  @override
  void dispose() {

    passCtrl.dispose();
    confirmCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.fondoRegistro,

      appBar: AppBar(

        backgroundColor:
            AppColors.fondoRegistro,

        elevation: 0,
        centerTitle: true,

        leading: IconButton(

          icon: const Icon(

            Icons.arrow_back_ios,

            size: 16,

            color:
                AppColors.colorBotonPrincipal,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(

          "Crear contraseña",

          style:
              AppTextStyles.appBar,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            const Text(

              "Crea una contraseña segura para proteger tu cuenta.",

              style:
                  AppTextStyles.secundario,
            ),

            const SizedBox(height: 5),

            /*const Text(

              "La contraseña debe tener mínimo 8 caracteres.",

              style:
                  AppTextStyles.secundario,
            ),*/

            const SizedBox(height: 25),

            const Text(

              "Contraseña",

              style:
                  AppTextStyles.subtitulo,
            ),

            const SizedBox(height: 8),

            TextField(

              controller: passCtrl,

              obscureText:
                  ocultarPass,

              decoration: _inputDecoration(

                "",

                ocultarPass,

                () {

                  setState(() {

                    ocultarPass =
                        !ocultarPass;
                  });
                },

              ).copyWith(

                helperText:
                    "Usa al menos 8 caracteres",

                errorText:
                    passCtrl.text.isEmpty
                        ? null
                        : (passCtrl.text.length < 8
                            ? "La contraseña debe tener mínimo 8 caracteres"
                            : null),
              ),

              onChanged: (value) {

                _validarPassword(
                  value,
                );
              },
            ),

            const SizedBox(height: 15),

            // 🔥 BARRA PASSWORD
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

            const SizedBox(height: 20),

            const Text(

              "Confirmar contraseña",

              style:
                  AppTextStyles.subtitulo,
            ),

            const SizedBox(height: 8),

            TextField(

              controller:
                  confirmCtrl,

              obscureText:
                  ocultarConfirm,

              decoration:
                  _inputDecoration(

                "",

                ocultarConfirm,

                () {

                  setState(() {

                    ocultarConfirm =
                        !ocultarConfirm;
                  });
                },

              ).copyWith(

                errorText:
                    confirmCtrl.text.isEmpty
                        ? null
                        : (confirmCtrl.text !=
                                passCtrl.text
                            ? "Las contraseñas no coinciden"
                            : null),
              ),

              onChanged: (_) {

                setState(() {});
              },
            ),

            const SizedBox(height: 35),

            Center(

              child: SizedBox(

                width: 260,
                height: 50,

                child:
                    ElevatedButton(

                  onPressed:
                      _todoValido()

                          ? () async {

                              final response =
                                  await AuthService.register(

                                name:
                                    widget.nombre,

                                email:
                                    widget.correo,

                                password:
                                    passCtrl.text,

                                telefono:
                                    widget.telefono,
                              );

                              if (response['ok']) {

                                final loginResp =
                                    await AuthService.login(

                                  email:
                                      widget.correo,

                                  password:
                                      passCtrl.text,
                                );

                                print(
                                  "TOKEN DESPUÉS DE REGISTER: ${AuthService.token}",
                                );

                                if (!loginResp['ok']) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    const SnackBar(

                                      content: Text(
                                        "Error en login automático",
                                      ),

                                      backgroundColor:
                                          Colors.red,
                                    ),
                                  );

                                  return;
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  const SnackBar(

                                    content: Text(
                                      "Cuenta creada con éxito",
                                    ),

                                    backgroundColor:
                                        AppColors.exito,
                                  ),
                                );

                                Navigator.pushReplacement(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        Cuestionario(

                                      nombre:
                                          widget.nombre,

                                      correo:
                                          widget.correo,

                                      telefono:
                                          widget.telefono,

                                      fecha:
                                          widget.fecha,
                                    ),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  SnackBar(

                                    content: Text(

                                      response['message'] ??
                                          "Error en registro",
                                    ),

                                    backgroundColor:
                                        Colors.red,
                                  ),
                                );
                              }
                            }

                          : null,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        AppColors.colorBotonPrincipal,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(

                    "Crear cuenta",

                    style:
                        AppTextStyles.boton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}