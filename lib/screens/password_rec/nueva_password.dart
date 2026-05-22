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

  final String baseUrl =
      'http://10.0.2.2:3000/api/auth';
  

  bool validarTodo() {
    return passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        passwordController.text.length >= 8 &&
        passwordController.text ==
            confirmController.text;
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
  
  //
  Future<void> resetPassword() async {
    final password = passwordController.text.trim();

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
            content: Text('Contraseña actualizada'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );

        if (widget.volverALogin) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pop(context); // cierra NuevaPasswordScreen
          Navigator.pop(context); // cierra RecuperarPasswordScreen
        }
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
            color: AppColors
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
                  color: AppColors
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
                onChanged: (_) =>
                    setState(() {}),
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
                      color: AppColors
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





/* ya duviona falta elk no regreso al login
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

  const NuevaPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
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

  final String baseUrl =
      'http://192.168.1.111:3000/api/auth';

  bool validarTodo() {
    return passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        passwordController.text.length >= 8 &&
        passwordController.text ==
            confirmController.text;
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

  Future<void> resetPassword() async {
    final password =
        passwordController.text.trim();

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type':
              'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
          'resetToken': widget.resetToken,
          'newPassword': password,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data['ok']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
                'Contraseña actualizada'),
            backgroundColor:
                Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  'Error',
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
          backgroundColor:
              Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

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
            color: AppColors
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
                  color: AppColors
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
                onChanged: (_) =>
                    setState(() {}),
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
                      color: AppColors
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

*/







/* ya esta por si no funciona el de arriba
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../auth/login/login.dart';

class NuevaPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const NuevaPasswordScreen({
    super.key,
    required this.email,
    required this.code,
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

  final String baseUrl =
      'http://192.168.1.87:3000/api/auth';

  bool validarTodo() {
    return passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        passwordController.text.length >= 8 &&
        passwordController.text ==
            confirmController.text;
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

  Future<void> resetPassword() async {
    final password =
        passwordController.text.trim();

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type':
              'application/json'
        },
        body: jsonEncode({
          'email': widget.email,
          'code': widget.code,
          'newPassword': password,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data['ok']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
                'Contraseña actualizada'),
            backgroundColor:
                Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                data['message'] ??
                    'Error'),
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
            color: AppColors
                .colorBotonPrincipal,
          ),
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
              'Ingresa tu nueva contraseña',
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
              onChanged: (_) =>
                  setState(() {}),
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
                    color: AppColors
                        .textoClaro,
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












/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_colors.dart';
import '../auth/login/login.dart';

class NuevaPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const NuevaPasswordScreen({
    super.key,
    required this.email,
    required this.code,
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

  final String baseUrl =
      'http://192.168.0.9:3000/api/auth';
      //'http://192.168.1.87:3000/api/auth';

  Future<void> resetPassword() async {
    final password =
        passwordController.text.trim();

    final confirm =
        confirmController.text.trim();

    if (password.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          'Content-Type':
              'application/json'
        },
        body: jsonEncode({
          'email': widget.email,
          'code': widget.code,
          'newPassword': password,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data['ok']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
                'Contraseña actualizada'),
            backgroundColor:
                Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
                data['message'] ??
                    'Error'),
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
              'Ingresa tu nueva contraseña',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color: AppColors
                    .colorBotonPrincipal,
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
                  InputDecoration(
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

            const Text(
                'Confirmar contraseña'),

            const SizedBox(height: 8),

            TextField(
              controller:
                  confirmController,
              obscureText:
                  ocultarPassword,
              decoration:
                  InputDecoration(
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
                onPressed: loading
                    ? null
                    : resetPassword,
                child: Text(
                  loading
                      ? 'Guardando...'
                      : 'Guardar contraseña',
                  style:
                      const TextStyle(
                    fontSize: 16,
                    color: AppColors
                        .textoClaro,
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