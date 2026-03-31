import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilProvider extends ChangeNotifier {

  File? imagenPerfil;

  String nombre = "";
  int edad = 0;
  String sexo = "";

  String telefonoUsuario = ""; 
  String nombreContacto = "";
  String telefonoContacto = "";

  String fechaNacimiento = "";
  String tipoPerfil = "";

  PerfilProvider(){
    cargarDatos();
    cargarImagen();
  }

  // ================= IMAGEN =================

  Future cargarImagen() async {
    final prefs = await SharedPreferences.getInstance();
    String? ruta = prefs.getString("imagen");

    if(ruta != null && File(ruta).existsSync()){
      imagenPerfil = File(ruta);
      notifyListeners();
    }
  }

  Future guardarImagen(String ruta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("imagen", ruta);

    imagenPerfil = File(ruta);
    notifyListeners();
  }

  // ================= DATOS =================

  Future cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    nombre = prefs.getString("nombre") ?? "";
    edad = prefs.getInt("edad") ?? 0;
    sexo = prefs.getString("sexo") ?? "";

    telefonoUsuario = prefs.getString("telefonoUsuario") ?? "";
    nombreContacto = prefs.getString("nombreContacto") ?? "";
    telefonoContacto = prefs.getString("telefonoContacto") ?? "";

    fechaNacimiento = prefs.getString("fecha") ?? "";
    tipoPerfil = prefs.getString("tipoPerfil") ?? "";

    notifyListeners();
  }

  Future guardarDatos({
    required String nombre,
    required int edad,
    required String sexo,
    required String nombreContacto,
    required String telefonoContacto,
    String telefonoUsuario = "",
    String fechaNacimiento = "",
  }) async {

    final prefs = await SharedPreferences.getInstance();

    /// 🔥 Evitar sobreescribir con datos vacíos
    final telefonoUsuarioFinal =
        telefonoUsuario.isNotEmpty ? telefonoUsuario : this.telefonoUsuario;

    final telefonoContactoFinal =
        telefonoContacto.isNotEmpty ? telefonoContacto : this.telefonoContacto;

    final nombreContactoFinal =
        nombreContacto.isNotEmpty ? nombreContacto : this.nombreContacto;

    final fechaFinal =
        fechaNacimiento.isNotEmpty ? fechaNacimiento : this.fechaNacimiento;

    /// 🔥 Guardar en almacenamiento
    await prefs.setString("nombre", nombre);
    await prefs.setInt("edad", edad);
    await prefs.setString("sexo", sexo);

    await prefs.setString("telefonoUsuario", telefonoUsuarioFinal);
    await prefs.setString("nombreContacto", nombreContactoFinal);
    await prefs.setString("telefonoContacto", telefonoContactoFinal);

    await prefs.setString("fecha", fechaFinal);

    await prefs.setString("tipoPerfil", tipoPerfil);

    /// 🔥 Actualizar variables en memoria
    this.nombre = nombre;
    this.edad = edad;
    this.sexo = sexo;

    this.telefonoUsuario = telefonoUsuarioFinal;
    this.nombreContacto = nombreContactoFinal;
    this.telefonoContacto = telefonoContactoFinal;

    this.fechaNacimiento = fechaFinal;
    this.tipoPerfil = tipoPerfil;

    notifyListeners();
  }
}