import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'registro_c.dart';
import 'package:prueba/screens/cuestionario/cuestionario.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class RegistroP extends StatefulWidget {
  const RegistroP({super.key});

  @override
  State<RegistroP> createState() => _RegistroPState();
}

class _RegistroPState extends State<RegistroP> {
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();

  String codigoPais = 'MX';
  String telefonoCompleto = '';
  TextEditingController telefonoController = TextEditingController();

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool _todosCamposCompletos() {
    return nombreCtrl.text.isNotEmpty &&
        correoCtrl.text.isNotEmpty &&
        _isValidEmail(correoCtrl.text) &&
        telefonoCompleto.isNotEmpty &&
        fechaCtrl.text.isNotEmpty;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputRegistro,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    correoCtrl.dispose();
    fechaCtrl.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoRegistro,
      appBar: AppBar(
        backgroundColor: AppColors.fondoRegistro,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: AppColors.colorBotonPrincipal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Crear Cuenta",
          style: AppTextStyles.appBar,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            /// NOMBRE
            const Text(
              "Nombre Completo",
              style: AppTextStyles.subtitulo,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nombreCtrl,
              decoration: _inputDecoration(),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            /// CORREO
            const Text(
              "Correo",
              style: AppTextStyles.subtitulo,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            /// TELÉFONO
            const Text(
              "Número de Teléfono",
              style: AppTextStyles.subtitulo,
            ),
            const SizedBox(height: 8),
            IntlPhoneField(
              controller: telefonoController,
              decoration: _inputDecoration(),
              initialCountryCode: codigoPais,
              onChanged: (phone) {
                setState(() {
                  telefonoCompleto = phone.completeNumber;
                });
              },
            ),

            const SizedBox(height: 20),

            /// FECHA
            const Text(
              "Fecha de Nacimiento",
              style: AppTextStyles.subtitulo,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: fechaCtrl,
              readOnly: true,
              decoration: _inputDecoration(),
              onTap: () async {
                DateTime? fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (fecha != null) {
                  fechaCtrl.text =
                      "${fecha.day}/${fecha.month}/${fecha.year}";
                  setState(() {});
                }
              },
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "By continuing, you agree to\nTerms of Use and Privacy Policy.",
                textAlign: TextAlign.center,
                style: AppTextStyles.pequeno,
              ),
            ),

            const SizedBox(height: 25),

            /// BOTÓN
            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _todosCamposCompletos()
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistroC(
                                nombre: nombreCtrl.text,
                                correo: correoCtrl.text,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorBotonPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Siguiente",
                    style: AppTextStyles.boton,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "or sign up with",
                style: AppTextStyles.secundario,
              ),
            ),

            const SizedBox(height: 20),

            /// GOOGLE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.inputRegistro,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        final userCredential = await signInWithGoogle();

                        if (userCredential != null &&
                            userCredential.user != null) {

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Cuestionario(
                                nombre: userCredential.user?.displayName ?? '',
                                correo: userCredential.user?.email ?? '',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.g_mobiledata,
                      color: AppColors.colorPrincipal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}