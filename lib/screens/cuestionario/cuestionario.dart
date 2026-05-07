import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../navigation/main_navigation.dart';
import '../../provider/perfil_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/auth_service.dart';
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

  //final TextEditingController edadCtrl = TextEditingController();
  final TextEditingController nombreContactoCtrl = TextEditingController();
  final TextEditingController telefonoContactoCtrl = TextEditingController();

  String? sexoSeleccionado;
  String? viveSolo;

  bool tieneHipertension = false;
  bool tieneDiabetes = false;
  bool tieneNinguna = false;

  String? caidasRecientes;
  String? movilidad;
  String? medicacion;

  String codigoEmergencia = "+52";
  String codigoPais = "MX";

  String? errorTelefono;

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
                      const SizedBox(height: 20),
                      _buildExtraSalud(),
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
    return Text(texto, style: AppTextStyles.headingPrimary);
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

        /*TextField(
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
        ),*/

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
          // 👇 color del cuadrito deshabilitado
          side: BorderSide(
            color: tieneNinguna
                ? Colors.grey
                : Colors.black,
          ),

          checkColor: AppColors.textoClaro,

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
            side: BorderSide(
              color: tieneNinguna
                  ? Colors.grey
                  : Colors.black,
            ),

          title: const Text("Diabetes", style: AppTextStyles.option),
          value: tieneDiabetes,
          onChanged: (v) => setState(() {
            tieneDiabetes = v!;
            if (v) tieneNinguna = false;
          }),
        ),

        CheckboxListTile(
          activeColor: AppColors.colorBotonPrincipal,
            side: BorderSide(
              color: (tieneHipertension || tieneDiabetes)
                  ? Colors.grey
                  : Colors.black,
            ),
          title: const Text("Ninguna", style: AppTextStyles.option),
          value: tieneNinguna,
          onChanged: (v) => setState(() {
            tieneNinguna = v!;

            if (v) {
              // Si selecciona "Ninguna", desmarcar las otras opciones
              tieneHipertension = false;
              tieneDiabetes = false;
            }
          }),
        ),
      ],
    );
  }

  Widget _buildExtraSalud() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _titulo("Historial y condición física"),

        _subtitulo("¿Ha sufrido caídas recientemente?"),
        _radio("Sí", caidasRecientes, (v) => caidasRecientes = v),
        _radio("No", caidasRecientes, (v) => caidasRecientes = v),

        const SizedBox(height: 10),

        _subtitulo("Movilidad"),
        _radio("Camina sin ayuda", movilidad, (v) => movilidad = v),
        _radio("Usa bastón", movilidad, (v) => movilidad = v),
        _radio("Usa andadera", movilidad, (v) => movilidad = v),
        _radio("Silla de ruedas", movilidad, (v) => movilidad = v),

        const SizedBox(height: 10),

        _subtitulo("¿Toma medicamentos diariamente?"),
        _radio("Sí", medicacion, (v) => medicacion = v),
        _radio("No", medicacion, (v) => medicacion = v),
      ],
    );
  }

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

        IntlPhoneField(
          controller: telefonoContactoCtrl,
          initialCountryCode: codigoPais,
          decoration: InputDecoration(
            hintText: "Teléfono del contacto",
            hintStyle: AppTextStyles.secundario,
            filled: true,
            fillColor: AppColors.inputRegistro,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: errorTelefono,
          ),
          onChanged: (phone) {
            codigoEmergencia = phone.countryCode;

            if (phone.number.length < 8) {
              setState(() {
                errorTelefono = "Número inválido";
              });
            } else {
              setState(() {
                errorTelefono = null;
              });
            }
          },
        ),
      ],
    );
  }

  // ================= VALIDACIONES =================

  bool _validarPaso1() {
    /*int? edad = int.tryParse(edadCtrl.text);

    if (edad == null || edad < 65) {
      _mensaje("Edad inválida (65+)");
      return false;
    }*/

    if (sexoSeleccionado == null) {
      _mensaje("Selecciona el sexo");
      return false;
    }

    if (viveSolo == null) {
      _mensaje("Indica si vive solo(a)");
      return false;
    }

    if (!tieneHipertension && !tieneDiabetes && !tieneNinguna) {
      _mensaje("Selecciona condición de salud");
      return false;
    }

    if (caidasRecientes == null) {
      _mensaje("Responde sobre caídas");
      return false;
    }

    if (movilidad == null) {
      _mensaje("Selecciona movilidad");
      return false;
    }

    if (medicacion == null) {
      _mensaje("Indica medicamentos");
      return false;
    }

    return true;
  }

  bool _validarPaso2() {
    if (nombreContactoCtrl.text.isEmpty) {
      _mensaje("Ingresa el nombre del contacto");
      return false;
    }

    if (telefonoContactoCtrl.text.isEmpty || errorTelefono != null) {
      _mensaje("Teléfono inválido");
      return false;
    }

    return true;
  }

  // 🔥 SnackBar con color de la app
  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.colorBotonPrincipal,
      ),
    );
  }

  // ================= LÓGICA =================

  void _siguientePaso() {
    if (pasoActual == 0) {
      if (!_validarPaso1()) return;
      setState(() => pasoActual++);
      return;
    }

    if (pasoActual == 1) {
      if (!_validarPaso2()) return;
      _confirmarFinal(); // 👈 aquí el popup
    }
  }

  // 🔥 Popup de confirmación
  void _confirmarFinal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Deseas guardar la información?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: AppColors.colorBotonPrincipal),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _finalizarCuestionario();
            },
            child: Text(
              "Guardar",
              style: TextStyle(color: AppColors.colorBotonPrincipal),
            ),
          ),
        ],
      ),
    );
  }

  void _finalizarCuestionario() async {

  final perfilProvider =
      Provider.of<PerfilProvider>(context, listen: false);

  String tipoHome;

  if (tieneHipertension && tieneDiabetes) {
    tipoHome = "Hipertension y Diabetes";
  } else if (tieneHipertension) {
    tipoHome = "Hipertension";
  } else if (tieneDiabetes) {
    tipoHome = "Diabetes";
  } else {
    tipoHome = "Sano";
  }

  final telefonoCompleto =
      "$codigoEmergencia${telefonoContactoCtrl.text}";

  // ✅ Guardado local (opcional)
  await perfilProvider.guardarDatos(
    nombre: widget.nombre,
    //edad: int.parse(edadCtrl.text),
    sexo: sexoSeleccionado!,
    nombreContacto: nombreContactoCtrl.text,
    telefonoContacto: telefonoCompleto,
    telefonoUsuario: widget.telefono,
    fechaNacimiento: widget.fecha,
  );

  // 🔥 NUEVO: GUARDAR EN BACKEND
  final response = await AuthService.guardarCuestionario(
    //nombre: widget.nombre,
    //correo: widget.correo,
    tipoHome: tipoHome,
    //edad: int.parse(edadCtrl.text),
    sexo: sexoSeleccionado!,
    viveSolo: viveSolo!,
    hipertension: tieneHipertension,
    diabetes: tieneDiabetes,
    caidas: caidasRecientes!,
    movilidad: movilidad!,
    medicacion: medicacion!,
    contactoEmergenciaNombre: nombreContactoCtrl.text,
    contactoEmergenciaTelefono: telefonoCompleto,
    fechaNacimiento: widget.fecha,
  );

  print(response); // 🔍 DEBUG

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => MainNavigation(tipoHome: tipoHome.toLowerCase(), user: {
        "name": widget.nombre,
        "email": widget.correo,
        "tipoHome": tipoHome,
        "cuestionario": {
          //"edad": int.parse(edadCtrl.text),
          "sexo": sexoSeleccionado,
          "viveSolo": viveSolo,
          "hipertension": tieneHipertension,
          "diabetes": tieneDiabetes,
          "caidasRecientes": caidasRecientes,
          "movilidad": movilidad,
          "medicacion": medicacion,
          "contactoNombre": nombreContactoCtrl.text,
          "contactoTelefono": telefonoCompleto,
        }
      }),
    ),
    (route) => false,
    
  );
}

}