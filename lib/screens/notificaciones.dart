import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class NotificacionesPantalla extends StatefulWidget {
  const NotificacionesPantalla({super.key});

  @override
  State<NotificacionesPantalla> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesPantalla> {
  bool recibirNotificaciones = true;
  bool alertas = true;
  bool sonidoAlertas = false;
  bool mensajes = true;
  bool sonidoMensajes = true;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _pedirPermisos();
    _cargarPreferencias();
  }

  Future<void> _pedirPermisos() async {
    await _messaging.requestPermission();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      recibirNotificaciones =
          prefs.getBool('recibirNotificaciones') ?? true;
      alertas = prefs.getBool('alertas') ?? true;
      sonidoAlertas = prefs.getBool('sonidoAlertas') ?? false;
      mensajes = prefs.getBool('mensajes') ?? true;
      sonidoMensajes = prefs.getBool('sonidoMensajes') ?? true;
    });
  }

  Future<void> _guardarPreferencia(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _toggleNotificaciones(bool value) async {
    setState(() => recibirNotificaciones = value);
    await _guardarPreferencia('recibirNotificaciones', value);

    if (!value) {
      await _messaging.unsubscribeFromTopic("alertas_importantes");
      await _messaging.unsubscribeFromTopic("mensajes");
    }

    _mostrarSnackBar();
  }

  Future<void> _toggleAlertas(bool value) async {
    setState(() => alertas = value);
    await _guardarPreferencia('alertas', value);

    if (value) {
      await _messaging.subscribeToTopic("alertas_importantes");
    } else {
      await _messaging.unsubscribeFromTopic("alertas_importantes");
    }

    _mostrarSnackBar();
  }

  Future<void> _toggleMensajes(bool value) async {
    setState(() => mensajes = value);
    await _guardarPreferencia('mensajes', value);

    if (value) {
      await _messaging.subscribeToTopic("mensajes");
    } else {
      await _messaging.unsubscribeFromTopic("mensajes");
    }

    _mostrarSnackBar();
  }

  void _mostrarSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.colorBotonPrincipal,
        content: const Text(
          "Configuración guardada",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notificaciones",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [

          _switchItem(
            titulo: "Recibir notificaciones",
            value: recibirNotificaciones,
            onChanged: _toggleNotificaciones,
          ),

          const SizedBox(height: 25),

          _titulo("Alertas importantes"),

          _switchItem(
            titulo: "Activar alertas",
            value: alertas,
            onChanged: recibirNotificaciones ? _toggleAlertas : null,
          ),

          _switchItem(
            titulo: "Sonido",
            value: sonidoAlertas,
            onChanged: recibirNotificaciones
                ? (value) async {
                    setState(() => sonidoAlertas = value);
                    await _guardarPreferencia('sonidoAlertas', value);
                    _mostrarSnackBar();
                  }
                : null,
          ),

          const SizedBox(height: 25),

          _titulo("Mensajes"),

          _switchItem(
            titulo: "Activar mensajes",
            value: mensajes,
            onChanged: recibirNotificaciones ? _toggleMensajes : null,
          ),

          _switchItem(
            titulo: "Sonido",
            value: sonidoMensajes,
            onChanged: recibirNotificaciones
                ? (value) async {
                    setState(() => sonidoMensajes = value);
                    await _guardarPreferencia('sonidoMensajes', value);
                    _mostrarSnackBar();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _switchItem({
    required String titulo,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 18),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.colorBotonPrincipal,
          ),
        ],
      ),
    );
  }
}