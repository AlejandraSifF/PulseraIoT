import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilProvider extends ChangeNotifier {

  File? imagenPerfil;

  String nombre = "";
  int edad = 0;
  String sexo = "";
  String nombreContacto = "";
  String telefonoContacto = "";
  String fechaNacimiento = "";

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
    nombreContacto = prefs.getString("nombreContacto") ?? "";
    telefonoContacto = prefs.getString("telefonoContacto") ?? "";
    fechaNacimiento = prefs.getString("fecha") ?? "";

    notifyListeners();
  }

  Future guardarDatos({
    required String nombre,
    required int edad,
    required String sexo,
    required String nombreContacto,
    required String telefonoContacto,
    String fechaNacimiento = "",
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("nombre", nombre);
    await prefs.setInt("edad", edad);
    await prefs.setString("sexo", sexo);
    await prefs.setString("nombreContacto", nombreContacto);
    await prefs.setString("telefonoContacto", telefonoContacto);
    await prefs.setString("fecha", fechaNacimiento);

    this.nombre = nombre;
    this.edad = edad;
    this.sexo = sexo;
    this.nombreContacto = nombreContacto;
    this.telefonoContacto = telefonoContacto;
    this.fechaNacimiento = fechaNacimiento;

    notifyListeners();
  }
}