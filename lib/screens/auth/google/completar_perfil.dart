import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../cuestionario/cuestionario.dart';
import '../../ayuda/centro_ayuda/terminos_condiciones.dart';
import '../../ayuda/centro_ayuda/politica_de_privacidad.dart';
import '../../../services/auth_service.dart';

class CompletarPerfil extends StatefulWidget {
  final String nombre;
  final String correo;

  const CompletarPerfil({
    super.key,
    required this.nombre,
    required this.correo,
  });

  @override
  State<CompletarPerfil> createState() => _CompletarPerfilState();
}

class _CompletarPerfilState extends State<CompletarPerfil> {

  final fechaCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  String telefonoCompleto = "";
  String codigoPais = "MX";

  bool esMayor = false;
  bool aceptaTerminos = false;

  int edad = 0;

  // ================= CALCULAR EDAD =================
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

  bool _datosValidos() {

    return telefonoCompleto.isNotEmpty &&
        fechaCtrl.text.isNotEmpty &&
        esMayor &&
        aceptaTerminos;
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
    fechaCtrl.dispose();
    telefonoCtrl.dispose();
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
        title: const Text(
          "Completar perfil",
          style: AppTextStyles.appBar,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text(
              "Solo necesitamos algunos datos más para continuar.",
              style: AppTextStyles.secundario,
            ),

            const SizedBox(height: 30),

            // ================= TELÉFONO =================
            const Text(
              "Número de teléfono",
              style: AppTextStyles.subtitulo,
            ),

            const SizedBox(height: 8),

            IntlPhoneField(
              controller: telefonoCtrl,
              initialCountryCode: codigoPais,

              decoration: _inputDecoration(),

              onChanged: (phone) {

                setState(() {
                  telefonoCompleto = phone.completeNumber;
                });
              },
            ),

            const SizedBox(height: 20),

            // ================= FECHA =================
            const Text(
              "Fecha de nacimiento",
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
                  locale: const Locale('es', 'ES'),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (fecha != null) {

                  final edadCalculada =
                      _calcularEdad(fecha);

                  setState(() {

                    edad = edadCalculada;
                    esMayor = edadCalculada >= 18;
                  });

                  if (!esMayor) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Debes ser mayor de 18 años",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  fechaCtrl.text =
                      "${fecha.day.toString().padLeft(2, '0')}/"
                      "${fecha.month.toString().padLeft(2, '0')}/"
                      "${fecha.year}";
                }
              },
            ),

            // ================= EDAD =================
            if (fechaCtrl.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),

                child: Text(
                  esMayor
                      ? "Edad: $edad años"
                      : "Edad: $edad años (Debe ser mayor de 18)",

                  style: TextStyle(
                    color: esMayor
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // ================= TÉRMINOS =================
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
                        builder: (_) =>
                            const PoliticaDePrivacidadScreen(),
                      ),
                    );
                  },
                  child: const Text("Ver privacidad"),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // ================= BOTÓN =================
            Center(
              child: SizedBox(
                width: 220,
                height: 50,

                child: ElevatedButton(

                  onPressed: _datosValidos() && aceptaTerminos
    ? () async {

        final response = await AuthService.registerGoogle(
          name: widget.nombre,
          email: widget.correo,
          telefono: telefonoCompleto,
          fechaNacimiento: fechaCtrl.text,
        );

        if (response['ok']) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Perfil completado"),
              backgroundColor: AppColors.exito,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Cuestionario(
                nombre: widget.nombre,
                correo: widget.correo,
                telefono: telefonoCompleto,
                fecha: fechaCtrl.text,
              ),
            ),
          );

        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? "Error",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.colorBotonPrincipal,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    "Continuar",
                    style: AppTextStyles.boton,
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