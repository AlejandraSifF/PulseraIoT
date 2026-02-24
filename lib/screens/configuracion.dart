import 'package:flutter/material.dart';
import 'editar_perfil.dart';
import 'cambiar_contraseña.dart';
import 'Actualizar_correo_electrónico.dart';
import 'notificaciones.dart';
import '../theme/app_colors.dart';

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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textoClaro,
          ),
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
            child: Icon(
              icono,
              color: AppColors.colorBotonPrincipal,
            ),
          ),
          title: Text(
            texto,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textoOscuro,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: AppColors.colorBotonPrincipal,
          ),
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
}