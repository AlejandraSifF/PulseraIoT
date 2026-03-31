import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/main_navigation.dart';
import '../../provider/perfil_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class Cuestionario extends StatefulWidget {
  final String nombre;
  final String correo;

  final String telefono;
  final String fecha;

  const Cuestionario({
    super.key,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.fecha,
  });

  @override
  State<Cuestionario> createState() => _CuestionarioState();
}

class _CuestionarioState extends State<Cuestionario> {

  final TextEditingController edadCtrl = TextEditingController();
  final TextEditingController nombreContactoCtrl = TextEditingController();
  final TextEditingController telefonoContactoCtrl = TextEditingController();

  String? sexoSeleccionado;
  String? viveSolo;

  bool tieneHipertension = false;
  bool tieneDiabetes = false;
  bool tieneNinguna = false;

  int pasoActual = 0;
  final int totalPasos = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        backgroundColor: AppColors.fondoBlanco,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 18, color: AppColors.colorBotonPrincipal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cuestionario de Salud",
          style: AppTextStyles.appBar,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            pasoActual == 0
                ? Column(
                    children: [
                      _buildDatosGenerales(),
                      const SizedBox(height: 30),
                      _buildSalud(),
                    ],
                  )
                : Column(
                    children: [
                      _buildUsoSistema(),
                    ],
                  ),

            const SizedBox(height: 25),

            Row(
              children: [

                if (pasoActual > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => pasoActual--),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.colorBotonPrincipal,
                        side: BorderSide(
                            color: AppColors.colorBotonPrincipal),
                      ),
                      child: const Text("Anterior"),
                    ),
                  ),

                if (pasoActual > 0) const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _siguientePaso,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorBotonPrincipal,
                      foregroundColor: AppColors.textoClaro,
                    ),
                    child: Text(
                      pasoActual == totalPasos - 1
                          ? "Finalizar"
                          : "Siguiente",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: AppTextStyles.headingPrimary,
    );
  }

  Widget _subtitulo(String texto) {
    return Text(
      texto,
      style: AppTextStyles.subtitulo.copyWith(
        color: AppColors.colorBotonPrincipal,
      ),
    );
  }

  Widget _radio(String texto, String? grupo, Function(String?) onChanged) {
    return RadioListTile(
      activeColor: AppColors.colorBotonPrincipal,
      title: Text(texto, style: AppTextStyles.option),
      value: texto,
      groupValue: grupo,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  // ================= PASO 1 =================

  Widget _buildDatosGenerales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _titulo("Datos generales del adulto mayor"),

        const SizedBox(height: 15),

        TextField(
          controller: edadCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Edad (en años)",
            hintStyle: AppTextStyles.secundario,
            filled: true,
            fillColor: AppColors.inputRegistro,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        _subtitulo("Sexo:"),

        _radio("Femenino", sexoSeleccionado, (v) => sexoSeleccionado = v),
        _radio("Masculino", sexoSeleccionado, (v) => sexoSeleccionado = v),
        _radio("Prefiero no decir", sexoSeleccionado, (v) => sexoSeleccionado = v),

        const SizedBox(height: 10),

        _subtitulo("¿Vive solo(a)?"),

        _radio("Sí", viveSolo, (v) => viveSolo = v),
        _radio("No", viveSolo, (v) => viveSolo = v),
      ],
    );
  }

  Widget _buildSalud() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _titulo("Condiciones de salud"),

        CheckboxListTile(
          activeColor: AppColors.colorBotonPrincipal,
          title: const Text("Hipertensión arterial",
              style: AppTextStyles.option),
          value: tieneHipertension,
          onChanged: (v) => setState(() {
            tieneHipertension = v!;
            if (v) tieneNinguna = false;
          }),
        ),

        CheckboxListTile(
          activeColor: AppColors.colorBotonPrincipal,
          title: const Text("Diabetes", style: AppTextStyles.option),
          value: tieneDiabetes,
          onChanged: (v) => setState(() {
            tieneDiabetes = v!;
            if (v) tieneNinguna = false;
          }),
        ),

        CheckboxListTile(
          activeColor: AppColors.colorBotonPrincipal,
          title: const Text("Ninguna", style: AppTextStyles.option),
          value: tieneNinguna,
          onChanged: (v) => setState(() {
            tieneNinguna = v!;
            if (v) {
              tieneHipertension = false;
              tieneDiabetes = false;
            }
          }),
        ),
      ],
    );
  }

  // ================= PASO 2 =================

  Widget _buildUsoSistema() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _titulo("Contacto de emergencia"),

        TextField(
          controller: nombreContactoCtrl,
          decoration: InputDecoration(
            hintText: "Nombre del contacto",
            hintStyle: AppTextStyles.secundario,
            filled: true,
            fillColor: AppColors.inputRegistro,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: telefonoContactoCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Teléfono del contacto",
            hintStyle: AppTextStyles.secundario,
            filled: true,
            fillColor: AppColors.inputRegistro,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ================= LÓGICA =================

  void _siguientePaso() {
    if (pasoActual == totalPasos - 1) {
      _finalizarCuestionario();
    } else {
      setState(() => pasoActual++);
    }
  }

  void _finalizarCuestionario() async {

    final perfilProvider =
        Provider.of<PerfilProvider>(context, listen: false);

    /// 🔥 CALCULAR PERFIL
    String tipoHome;

    if (tieneHipertension && tieneDiabetes) {
      tipoHome = "Hipertensión Y Diabetes";
    } else if (tieneHipertension) {
      tipoHome = "Hipertensión";
    } else if (tieneDiabetes) {
      tipoHome = "Diabetes";
    } else {
      tipoHome = "Sano";
    }

    /// 🔥 GUARDAR DATOS
    await perfilProvider.guardarDatos(
      nombre: widget.nombre,
      edad: int.tryParse(edadCtrl.text) ?? 0,
      sexo: sexoSeleccionado ?? "",
      nombreContacto: nombreContactoCtrl.text,
      telefonoContacto: telefonoContactoCtrl.text,
      telefonoUsuario: widget.telefono,
      fechaNacimiento: widget.fecha,
    );

    /// 🔥 IR AL HOME CORRECTO
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(tipoHome: tipoHome),
      ),
      (route) => false,
    );
  }
}