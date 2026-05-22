import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'terminos_condiciones.dart';
import 'politica_de_privacidad.dart';
import 'reportar_problema.dart';
import 'contactar_soporte.dart';

class CentroAyudaScreen extends StatelessWidget {
  const CentroAyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorPrincipal,
        elevation: 0,
        title: const Text(
          'Centro De Ayuda',
          style: AppTextStyles.appBarLight,
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [

          _listItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Política De Privacidad',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PoliticaDePrivacidadScreen(),
              ),
            ),
          ),

          _listItem(
            context: context,
            icon: Icons.description_outlined,
            title: 'Términos Y Condiciones',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TerminosCondiciones(),
              ),
            ),
          ),

          _listItem(
            context: context,
            icon: Icons.error_outline,
            title: 'Reportar Un Problema',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ReportarProblema(),
              ),
            ),
          ),

          _listItem(
            context: context,
            icon: Icons.headset_mic_outlined,
            title: 'Contactar Soporte',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ContactarSoporte(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
          onTap: onTap,

          /// ICONO
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.fondoCirculoIcono,
            child: Icon(
              icon,
              color: AppColors.colorBotonPrincipal,
            ),
          ),

          /// TEXTO
          title: Text(
            title,
            style: AppTextStyles.listItem,
          ),

          /// FLECHA
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: AppColors.colorBotonPrincipal,
          ),
        ),
      ),
    );
  }
}