import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class EditarPerfilSubpantalla extends StatefulWidget {
  const EditarPerfilSubpantalla({super.key});

  @override
  State<EditarPerfilSubpantalla> createState() =>
      _EditarPerfilSubpantallaState();
}

class _EditarPerfilSubpantallaState
    extends State<EditarPerfilSubpantalla> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  String telefonoCompleto = "";
  String numeroTelefono = "";
  String codigoPais = "MX";
  String codigoNumerico = "+52";

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    String? rutaImagen = prefs.getString("imagen");

    setState(() {
      nombreController.text = prefs.getString("nombre") ?? "";
      fechaController.text = prefs.getString("fecha") ?? "";

      numeroTelefono = prefs.getString("numero") ?? "";
      codigoPais = prefs.getString("codigoPais") ?? "MX";
      codigoNumerico = prefs.getString("codigoNumerico") ?? "+52";
      telefonoCompleto = prefs.getString("telefono") ?? "";

      telefonoController.text = numeroTelefono;

      if (rutaImagen != null && File(rutaImagen).existsSync()) {
        _imagenSeleccionada = File(rutaImagen);
      }
    });
  }

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

  Future<void> _guardarDatos() async {
    if (!_formKey.currentState!.validate()) return;

    if (fechaController.text.isEmpty) {
      _mostrarError("Selecciona una fecha");
      return;
    }

    numeroTelefono = telefonoController.text;

    if (numeroTelefono.isEmpty) {
      _mostrarError("Ingresa un teléfono válido");
      return;
    }

    if (telefonoCompleto.isEmpty) {
      telefonoCompleto = "$codigoNumerico$numeroTelefono";
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("nombre", nombreController.text);
    await prefs.setString("telefono", telefonoCompleto);
    await prefs.setString("numero", numeroTelefono);
    await prefs.setString("codigoPais", codigoPais);
    await prefs.setString("codigoNumerico", codigoNumerico);
    await prefs.setString("fecha", fechaController.text);

    if (_imagenSeleccionada != null) {
      await prefs.setString("imagen", _imagenSeleccionada!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Perfil guardado correctamente"),
        backgroundColor: AppColors.exito,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoBlanco,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textoClaro),
        title: const Text(
          "Editar perfil",
          style: TextStyle(
            color: AppColors.textoClaro,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
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
                          : const AssetImage("assets/imagen_1.jpg")
                              as ImageProvider,
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

              _titulo("Nombre completo"),
              TextFormField(
                controller: nombreController,
                decoration: _inputDecoration("Escribe tu nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre es obligatorio";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              _titulo("Número de teléfono"),
              IntlPhoneField(
                key: ValueKey(codigoPais),
                controller: telefonoController,
                decoration: _inputDecoration("Ej. 1234567890"),
                initialCountryCode: codigoPais,
                onChanged: (phone) {
                  codigoPais = phone.countryISOCode;
                  codigoNumerico = phone.countryCode;
                  telefonoCompleto = phone.completeNumber;
                },
              ),

              const SizedBox(height: 25),

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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textoClaro,
                  ),
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.textoOscuro,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.fondoCamposTexto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
    );
  }
}