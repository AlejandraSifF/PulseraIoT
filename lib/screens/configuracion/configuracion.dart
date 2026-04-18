import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'editar_perfil.dart';
import 'cambiar_password.dart';
import 'actualizar_correo_electronico.dart';
import 'notificaciones.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../auth/login/login.dart';
import '../../provider/perfil_provider.dart';

class ConfiguracionPantalla extends StatelessWidget {
  const ConfiguracionPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        iconTheme: const IconThemeData(color: AppColors.textoClaro),
        title: const Text(
          'Configuración',
          style: AppTextStyles.appBarLight,
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [

          _itemConfiguracion(
            context,
            icono: Icons.person,
            texto: "Editar Perfil",
            pantalla: const EditarPerfilSubpantalla(),
          ),

          _itemConfiguracion(
            context,
            icono: Icons.lock,
            texto: "Cambiar contraseña",
            pantalla: const CambiarPasswordPantalla(),
          ),

          _itemConfiguracion(
            context,
            icono: Icons.email,
            texto: "Actualizar correo electrónico",
            pantalla: const CambiarCorreoPantalla(),
          ),

          _itemConfiguracion(
            context,
            icono: Icons.notifications,
            texto: "Notificaciones",
            pantalla: const NotificacionesPantalla(),
          ),

          _itemCerrarSesion(context),
        ],
      ),
    );
  }

  Widget _itemConfiguracion(
    BuildContext context, {
    required IconData icono,
    required String texto,
    required Widget pantalla,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
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
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.fondoCirculoIcono,
            child: Icon(icono, color: AppColors.colorBotonPrincipal),
          ),
          title: Text(texto, style: AppTextStyles.listItem),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => pantalla),
            );
          },
        ),
      ),
    );
  }

  // 🔴 BOTÓN LOGOUT

  Widget _itemCerrarSesion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
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
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.red.withOpacity(0.15),
            child: const Icon(Icons.logout, color: Colors.red),
          ),
          title: const Text(
            "Cerrar sesión",
            style: TextStyle(color: Colors.red),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.red),
          onTap: () => _confirmarLogout(context),
        ),
      ),
    );
  }

  // 🔥 CONFIRMAR LOGOUT REAL

  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro que deseas salir?"),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),

          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // 🔐 Firebase
              await FirebaseAuth.instance.signOut();

              // 🧹 Limpiar datos
              final perfilProvider =
                  Provider.of<PerfilProvider>(context, listen: false);
              await perfilProvider.cerrarSesion();

              // 🔄 Ir al login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}