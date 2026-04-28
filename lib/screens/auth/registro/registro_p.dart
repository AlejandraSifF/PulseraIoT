import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registro_c.dart';
import 'package:prueba/screens/cuestionario/cuestionario.dart';
import '../../ayuda/centro_ayuda/terminos_condiciones.dart';
import '../../ayuda/centro_ayuda/politica_de_privacidad.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
//import '../../../services/auth_service.dart';

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

  bool correoValido = true;
  bool aceptaTerminos = false;

  int edad = 0;
  bool esMayor = false;

  // 🔴 calcular edad
  int _calcularEdad(DateTime fechaNacimiento) {
    final hoy = DateTime.now();

    int edad = hoy.year - fechaNacimiento.year;

    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month &&
            hoy.day < fechaNacimiento.day)) {
      edad--;
    }

    return edad;
  }

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
        correoValido &&
        telefonoCompleto.isNotEmpty &&
        fechaCtrl.text.isNotEmpty &&
        esMayor; // 🔴 BLOQUEA SI NO ES MAYOR
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputRegistro,
      border: OutlineInputBorder(
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
          icon: const Icon(Icons.arrow_back_ios, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Crear cuenta", style: AppTextStyles.appBar),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Nombre completo", style: AppTextStyles.subtitulo),
            const SizedBox(height: 8),
            TextField(
              controller: nombreCtrl,
              decoration: _inputDecoration(),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            const Text("Correo electrónico", style: AppTextStyles.subtitulo),
            const SizedBox(height: 8),
            TextField(
              controller: correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration().copyWith(
                errorText: correoValido ? null : "Correo inválido",
              ),
              onChanged: (value) {
                setState(() {
                  correoValido = _isValidEmail(value) || value.isEmpty;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Número de teléfono", style: AppTextStyles.subtitulo),
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

            const Text("Fecha de nacimiento", style: AppTextStyles.subtitulo),
            const SizedBox(height: 8),
            TextField(
              controller: fechaCtrl,
              readOnly: true,
              decoration: _inputDecoration(),
              onTap: () async {
                DateTime? fecha = await showDatePicker(
                  context: context,
                  locale: const Locale('es', 'ES'),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (fecha != null) {
                  final edadCalculada = _calcularEdad(fecha);

                  setState(() {
                    edad = edadCalculada;
                    esMayor = edadCalculada >= 18;
                  });

                  if (!esMayor) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Debes ser mayor de 18 años"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  fechaCtrl.text =
                      "${fecha.day}/${fecha.month}/${fecha.year}";
                }
              },
            ),

            // 🔴 MOSTRAR EDAD
            if (fechaCtrl.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  esMayor
                      ? "Edad: $edad años"
                      : "Edad: $edad años (Debe ser mayor de 18)",
                  style: TextStyle(
                    color: esMayor ? Colors.green : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 25),

            Row(
              children: [
                Checkbox(
                  value: aceptaTerminos,
                  activeColor: AppColors.colorBotonPrincipal,
                  onChanged: (value) {
                    setState(() {
                      aceptaTerminos = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "Acepto los Términos y Condiciones y la Política de Privacidad",
                    style: AppTextStyles.pequeno,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TerminosCondiciones(),
                      ),
                    );
                  },
                  child: const Text("Ver términos"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PoliticaDePrivacidadScreen(),
                      ),
                    );
                  },
                  child: const Text("Ver privacidad"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_todosCamposCompletos() && aceptaTerminos)
                      ? () async {

                          final prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              "correo", correoCtrl.text.trim());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistroC(
                                nombre: nombreCtrl.text,
                                correo: correoCtrl.text,
                                telefono: telefonoCompleto,
                                fecha: fechaCtrl.text,
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
                  child: const Text("Siguiente", style: AppTextStyles.boton),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(child: Text("o regístrate con")),

            const SizedBox(height: 20),

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
                      final userCredential = await signInWithGoogle();

                      if (userCredential != null &&
                          userCredential.user != null) {

                        final prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                          "correo",
                          userCredential.user?.email ?? "",
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Cuestionario(
                              nombre:
                                  userCredential.user?.displayName ?? '',
                              correo:
                                  userCredential.user?.email ?? '',
                              telefono: "",
                              fecha: "",
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata),
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