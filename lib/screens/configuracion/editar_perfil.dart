import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../provider/perfil_provider.dart';

class EditarPerfilSubpantalla extends StatefulWidget {
  const EditarPerfilSubpantalla({super.key});

  @override
  State<EditarPerfilSubpantalla> createState() =>
      _EditarPerfilSubpantallaState();
}

class _EditarPerfilSubpantallaState
    extends State<EditarPerfilSubpantalla> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController telefonoUsuarioController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController nombrereContactoEmergenciaController = TextEditingController();
  final TextEditingController telefonoContactoEmergenciaController = TextEditingController();

  /// 🔥 CÓDIGOS SEPARADOS
  String codigoUsuario = "+52";
  String codigoEmergencia = "+52";
  String codigoPais = "MX";

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final perfil =
          Provider.of<PerfilProvider>(context, listen: false);

      await perfil.cargarDatos();

      if (!mounted) return;

      setState(() {
        /// 👤 USUARIO
        nombreUsuarioController.text = perfil.nombre;
        telefonoUsuarioController.text =
            perfil.telefonoUsuario.replaceAll("+52", "");

        /// 🎂 FECHA
        fechaController.text = perfil.fechaNacimiento;

        /// 🚨 CONTACTO EMERGENCIA
        nombrereContactoEmergenciaController.text = perfil.nombreContacto;
        telefonoContactoEmergenciaController.text =
            perfil.telefonoContacto.replaceAll("+52", "");
      });
    });
  }

  // ================= IMAGEN =================

  Future<void> _mostrarOpciones() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Tomar foto"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? imagen =
                      await _picker.pickImage(source: ImageSource.camera);

                  if (imagen != null) {
                    setState(() {
                      _imagenSeleccionada = File(imagen.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? imagen =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (imagen != null) {
                    setState(() {
                      _imagenSeleccionada = File(imagen.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= FECHA =================

  Future<void> _seleccionarFecha() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        fechaController.text =
            "${fechaSeleccionada.day.toString().padLeft(2, '0')}/"
            "${fechaSeleccionada.month.toString().padLeft(2, '0')}/"
            "${fechaSeleccionada.year}";
      });
    }
  }

  // ================= GUARDAR =================

  Future<void> _guardarDatos() async {

    if (!_formKey.currentState!.validate()) return;

    if (fechaController.text.isEmpty) {
      _mostrarError("Selecciona una fecha");
      return;
    }

    if (telefonoUsuarioController.text.isEmpty) {
      _mostrarError("Ingresa un teléfono");
      return;
    }

    final telefonoUsuarioCompleto =
        "$codigoUsuario${telefonoUsuarioController.text}";

    final telefonoEmergenciaCompleto =
        "$codigoEmergencia${telefonoContactoEmergenciaController.text}";

    final perfilProvider =
        Provider.of<PerfilProvider>(context, listen: false);

    await perfilProvider.guardarDatos(
      nombre: nombreUsuarioController.text,
      edad: perfilProvider.edad,
      sexo: perfilProvider.sexo,
      nombreContacto: nombrereContactoEmergenciaController.text,
      telefonoContacto: telefonoEmergenciaCompleto,
      telefonoUsuario: telefonoUsuarioCompleto,
      fechaNacimiento: fechaController.text,
    );

    if (_imagenSeleccionada != null) {
      await perfilProvider.guardarImagen(_imagenSeleccionada!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Perfil actualizado correctamente"),
        backgroundColor: AppColors.exito,
      ),
    );

    Navigator.pop(context);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final perfil = Provider.of<PerfilProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoClaro),
        title: const Text(
          "Editar perfil",
          style: AppTextStyles.appBarLight,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 30),

              GestureDetector(
                onTap: _mostrarOpciones,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [

                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _imagenSeleccionada != null
                          ? FileImage(_imagenSeleccionada!)
                          : (perfil.imagenPerfil != null
                              ? FileImage(perfil.imagenPerfil!)
                              : const AssetImage("assets/images/perfil.png")
                                  as ImageProvider),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.colorPrincipal,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.textoClaro,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// 👤 USUARIO
              _titulo("Nombre completo"),
              TextFormField(
                controller: nombreUsuarioController,
                decoration: _inputDecoration("Escribe tu nombre"),
              ),

              const SizedBox(height: 25),

              _titulo("Número de teléfono"),
              IntlPhoneField(
                controller: telefonoUsuarioController,
                initialCountryCode: codigoPais,
                decoration: _inputDecoration("Ej. 1234567890"),
                onChanged: (phone) {
                  codigoUsuario = phone.countryCode;
                },
              ),

              const SizedBox(height: 25),

              /// 🚨 CONTACTO EMERGENCIA
              _titulo("Nombre contacto de emergencia"),
              TextFormField(
                controller: nombrereContactoEmergenciaController,
                decoration: _inputDecoration("Nombre del contacto"),
              ),

              const SizedBox(height: 25),

              _titulo("Teléfono contacto de emergencia"),
              IntlPhoneField(
                controller: telefonoContactoEmergenciaController,
                initialCountryCode: codigoPais,
                decoration: _inputDecoration("Ej. 1234567890"),
                onChanged: (phone) {
                  codigoEmergencia = phone.countryCode;
                },
              ),

              const SizedBox(height: 25),

              /// 🎂 FECHA
              _titulo("Fecha de nacimiento"),
              GestureDetector(
                onTap: _seleccionarFecha,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: fechaController,
                    decoration: _inputDecoration("DD / MM / YYYY"),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: _guardarDatos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotonPrincipal,
                  minimumSize: const Size(200, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Guardar",
                  style: AppTextStyles.buttonLarge,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          texto,
          style: AppTextStyles.headingPrimary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.secundario,
      filled: true,
      fillColor: AppColors.fondoCamposTexto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
    );
  }
}