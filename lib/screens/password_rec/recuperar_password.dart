//agregue nuevo tambien 07-05-2025
//13-05-25

//IP AGEGAR


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import 'nueva_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecuperarPasswordScreen extends StatefulWidget {

  final bool volverALogin;

  const RecuperarPasswordScreen({
    super.key,
    this.volverALogin = true,
  });

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState
    extends State<RecuperarPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController codigoController =
      TextEditingController();

  bool codigoEnviado = false;
  bool loading = false;

  String correoUsuario = "";

  bool reenviarDisponible = true;
  int segundosRestantes = 60;
  Timer? timer;
  
  // @override

  final String baseUrl =
      'http://10.0.2.2:3000/api/auth';

      @override
void initState() {
  super.initState();

  if (!widget.volverALogin) {
    cargarCorreo();
  }
}

Future<void> cargarCorreo() async {

  final prefs =
      await SharedPreferences.getInstance();

  setState(() {

    correoUsuario =
        prefs.getString('correo') ?? '';

    emailController.text =
        correoUsuario;
  });
}

  void iniciarContador() {
    setState(() {
      reenviarDisponible = false;
      segundosRestantes = 60;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (segundosRestantes == 1) {
          timer.cancel();

          setState(() {
            reenviarDisponible = true;
            segundosRestantes = 60;
          });
        } else {
          setState(() {
            segundosRestantes--;
          });
        }
      },
    );
  }

  Future<void> enviarCodigo() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu correo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        setState(() {
          codigoEnviado = true;
        });

        iniciarContador();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado a $email'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Error',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> verificarCodigo() async {
    final email = emailController.text.trim();
    final code = codigoController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el código'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
  final resetToken = data['resetToken'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaPasswordScreen(
          email: email,
          resetToken: resetToken,
          volverALogin: widget.volverALogin,
        ),
      ),
    );

    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  'Código incorrecto',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,
      appBar: AppBar(
        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,
        title: const Text(
          'Recuperar contraseña',
          style: TextStyle(
            color: AppColors.colorBotonPrincipal,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.colorBotonPrincipal,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                widget.volverALogin
                    ? 'Ingresa tu correo electrónico'
                    : '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors
                      .colorBotonPrincipal,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.volverALogin
                    ? 'Te enviaremos un código para recuperar tu contraseña.'
                    : 'Te enviaremos un código para recuperar tu contraseña asociado a tu cuenta.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

if (widget.volverALogin) ...[
  const Text('Correo'),
  const SizedBox(height: 8),

  TextField(
    controller: emailController,
    decoration: InputDecoration(
      hintText: 'example@example.com',
      filled: true,
      fillColor: AppColors.inputLogin,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  ),

  const SizedBox(height: 20),
] else ...[

  const Text(
  'Correo',
  style: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ),
),

const SizedBox(height: 8),
  const SizedBox(height: 8),
Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: AppColors.inputLogin,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      correoUsuario,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
    ),
  ),

  const SizedBox(height: 20),
],
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor:
          AppColors.colorBotonPrincipal,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(25),
      ),
    ),
    onPressed:
        loading || !reenviarDisponible
            ? null
            : enviarCodigo,
    child: Text(
      loading
          ? 'Enviando...'
          : reenviarDisponible
              ? 'Enviar código'
              : 'Enviar de nuevo en (${segundosRestantes}s)',
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textoClaro,
      ),
    ),
  ),
),

              if (codigoEnviado) ...[
                const SizedBox(height: 30),

                const Text('Código'),

                const SizedBox(height: 8),

                TextField(
                  controller:
                      codigoController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Ingresa código',
                    filled: true,
                    fillColor: AppColors
                        .inputLogin,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                    onPressed: loading
                        ? null
                        : verificarCodigo,
                    child: const Text(
                      'Verificar código',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors
                            .textoClaro,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}




/* ya funciona solo falta que no se rerese al login
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import 'nueva_password.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState
    extends State<RecuperarPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController codigoController =
      TextEditingController();

  bool codigoEnviado = false;
  bool loading = false;

  bool reenviarDisponible = true;
  int segundosRestantes = 60;
  Timer? timer;

  final String baseUrl =
      'http://192.168.1.111:3000/api/auth';

  void iniciarContador() {
    setState(() {
      reenviarDisponible = false;
      segundosRestantes = 60;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (segundosRestantes == 1) {
          timer.cancel();

          setState(() {
            reenviarDisponible = true;
            segundosRestantes = 60;
          });
        } else {
          setState(() {
            segundosRestantes--;
          });
        }
      },
    );
  }

  Future<void> enviarCodigo() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu correo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        setState(() {
          codigoEnviado = true;
        });

        iniciarContador();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado a $email'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Error',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> verificarCodigo() async {
    final email = emailController.text.trim();
    final code = codigoController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el código'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
  final resetToken = data['resetToken'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevaPasswordScreen(
          email: email,
          resetToken: resetToken,
        ),
      ),
    );
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  'Código incorrecto',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,
      appBar: AppBar(
        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,
        title: const Text(
          'Recuperar contraseña',
          style: TextStyle(
            color: AppColors.colorBotonPrincipal,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.colorBotonPrincipal,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Ingresa tu correo electrónico',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors
                      .colorBotonPrincipal,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Te enviaremos un código para recuperar tu contraseña.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              const Text('Correo'),
              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText:
                      'example@example.com',
                  filled: true,
                  fillColor:
                      AppColors.inputLogin,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(12),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
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
                              .circular(25),
                    ),
                  ),
                  onPressed:
                      loading ||
                              !reenviarDisponible
                          ? null
                          : enviarCodigo,
                  child: Text(
                    loading
                        ? 'Enviando...'
                        : reenviarDisponible
                            ? 'Enviar código'
                            : 'Enviar de nuevo en (${segundosRestantes}s)',
                    style:
                        const TextStyle(
                      fontSize: 16,
                      color: AppColors
                          .textoClaro,
                    ),
                  ),
                ),
              ),

              if (codigoEnviado) ...[
                const SizedBox(height: 30),

                const Text('Código'),

                const SizedBox(height: 8),

                TextField(
                  controller:
                      codigoController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Ingresa código',
                    filled: true,
                    fillColor: AppColors
                        .inputLogin,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                    onPressed: loading
                        ? null
                        : verificarCodigo,
                    child: const Text(
                      'Verificar código',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors
                            .textoClaro,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



*/






/* YA FUNCIONA SOLO EL PADDING SI NO LO DEJO YA
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import 'nueva_password.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState
    extends State<RecuperarPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController codigoController =
      TextEditingController();

  bool codigoEnviado = false;
  bool loading = false;

  bool reenviarDisponible = true;
  int segundosRestantes = 30;
  Timer? timer;

  final String baseUrl =
      'http://192.168.1.87:3000/api/auth';

  void iniciarContador() {
    setState(() {
      reenviarDisponible = false;
      segundosRestantes = 60;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (segundosRestantes == 1) {
          timer.cancel();

          setState(() {
            reenviarDisponible = true;
            segundosRestantes = 60;
          });
        } else {
          setState(() {
            segundosRestantes--;
          });
        }
      },
    );
  }

  Future<void> enviarCodigo() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu correo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        setState(() {
          codigoEnviado = true;
        });

        iniciarContador();

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                'Código enviado a $email'),
            backgroundColor:
                Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Error',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> verificarCodigo() async {
    final email = emailController.text.trim();
    final code = codigoController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el código'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/verify-reset-code',
        ),
        headers: {
          'Content-Type':
              'application/json'
        },
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NuevaPasswordScreen(
              email: email,
              code: code,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  'Código incorrecto',
            ),
            backgroundColor:
                Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    codigoController.dispose();
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
          'Recuperar contraseña',
          style: TextStyle(
            color: AppColors
                .colorBotonPrincipal,
          ),
        ),
        iconTheme:
            const IconThemeData(
          color: AppColors
              .colorBotonPrincipal,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Ingresa tu correo electrónico',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color: AppColors
                    .colorBotonPrincipal,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Te enviaremos un código para recuperar tu contraseña.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            const Text('Correo'),
            const SizedBox(height: 8),

            TextField(
              controller:
                  emailController,
              decoration:
                  InputDecoration(
                hintText:
                    'example@example.com',
                filled: true,
                fillColor:
                    AppColors.inputLogin,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(12),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
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
                            !reenviarDisponible
                        ? null
                        : enviarCodigo,
                child: Text(
                  loading
                      ? 'Enviando...'
                      : reenviarDisponible
                          ? 'Enviar código'
                          : 'Enviar de nuevo en (${segundosRestantes}s)',
                  style:
                      const TextStyle(
                    fontSize: 16,
                    color: AppColors
                        .textoClaro,
                  ),
                ),
              ),
            ),

            if (codigoEnviado) ...[
              const SizedBox(height: 30),

              const Text('Código'),

              const SizedBox(height: 8),

              TextField(
                controller:
                    codigoController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    InputDecoration(
                  hintText:
                      'Ingresa código',
                  filled: true,
                  fillColor:
                      AppColors
                          .inputLogin,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                12),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                  onPressed: loading
                      ? null
                      : verificarCodigo,
                  child: const Text(
                    'Verificar código',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors
                          .textoClaro,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}




*/



/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import 'nueva_password.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState
    extends State<RecuperarPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController codigoController =
      TextEditingController();

  bool codigoEnviado = false;
  bool loading = false;

  final String baseUrl =
      //'http://10.0.2.2:3000/api/auth';
      'http://192.168.1.87:3000/api/auth';
      

  Future<void> enviarCodigo() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu correo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        setState(() {
          codigoEnviado = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Código enviado a $email'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                data['message'] ?? 'Error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> verificarCodigo() async {
    final email = emailController.text.trim();
    final code = codigoController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el código'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['ok']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NuevaPasswordScreen(
              email: email,
              code: code,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  'Código incorrecto',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,
      appBar: AppBar(
        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,
        title: const Text(
          'Recuperar contraseña',
          style: TextStyle(
            color:
                AppColors.colorBotonPrincipal,
          ),
        ),
        iconTheme: const IconThemeData(
          color:
              AppColors.colorBotonPrincipal,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Ingresa tu correo electrónico',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors
                    .colorBotonPrincipal,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Te enviaremos un código para recuperar tu contraseña.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            const Text("Correo"),
            const SizedBox(height: 8),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText:
                    "example@example.com",
                filled: true,
                fillColor:
                    AppColors.inputLogin,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(12),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors
                          .colorBotonPrincipal,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(25),
                  ),
                ),
                onPressed: loading
                    ? null
                    : enviarCodigo,
                child: Text(
                  loading
                      ? 'Enviando...'
                      : 'Enviar código',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors
                        .textoClaro,
                  ),
                ),
              ),
            ),

            if (codigoEnviado) ...[
              const SizedBox(height: 30),

              const Text("Código"),

              const SizedBox(height: 8),

              TextField(
                controller:
                    codigoController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    InputDecoration(
                  hintText:
                      "Ingresa código",
                  filled: true,
                  fillColor: AppColors
                      .inputLogin,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(12),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
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
                  onPressed: loading
                      ? null
                      : verificarCodigo,
                  child: const Text(
                    'Verificar código',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors
                          .textoClaro,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

*/










/*
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RecuperarPasswordScreen extends StatelessWidget {

  RecuperarPasswordScreen({super.key});

  final TextEditingController emailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.fondoBlanco,

      appBar: AppBar(

        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,

        title: const Text(
          'Recuperar contraseña',

          style: TextStyle(
            color: AppColors.colorBotonPrincipal,
          ),
        ),

        iconTheme: const IconThemeData(
          color: AppColors.colorBotonPrincipal,
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 20),

            const Text(

              'Ingresa tu correo electrónico',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    AppColors.colorBotonPrincipal,
              ),
            ),

            const SizedBox(height: 10),

            const Text(

              'Te enviaremos un código para recuperar tu contraseña.',

              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // ================= EMAIL =================

            const Text("Correo"),

            const SizedBox(height: 8),

            TextField(

              controller: emailController,

              decoration: InputDecoration(

                hintText: "example@example.com",

                filled: true,
                fillColor: AppColors.inputLogin,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ================= BOTON =================

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor:
                      AppColors.colorBotonPrincipal,

                  shape: RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                ),

                onPressed: () {

                  final email =
                      emailController.text.trim();

                  if (email.isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content: Text(
                          'Ingresa tu correo',
                        ),

                        backgroundColor:
                            Colors.red,
                      ),
                    );

                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    SnackBar(

                      content: Text(
                        'Código enviado a $email',
                      ),

                      backgroundColor:
                          Colors.green,
                    ),
                  );
                },

                child: const Text(

                  'Enviar código',

                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textoClaro,
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


*/
