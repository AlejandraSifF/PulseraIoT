import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

// ================== HELPERS ==================
Future<void> _launchTel(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  await launchUrl(uri);
}

Future<void> _launchMail(String email) async {
  final uri = Uri(scheme: 'mailto', path: email);
  await launchUrl(uri);
}

// ================== SCREEN ==================
class ContactarSoporte extends StatelessWidget {
  const ContactarSoporte({super.key});

  static const String phoneDisplay = '491 55-893-9009';
  static const String phoneRaw = '4915589390';
  static const String emailDisplay = 'tecnolyb3@gmail.com';
  static const String emailRaw = 'tecnolyb3@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        title: const Text(
          'Contactar soporte',
          style: AppTextStyles.appBarLight,
        ),
        centerTitle: true,
        backgroundColor: AppColors.colorPrincipal,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textoClaro),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk, color: AppColors.textoClaro),
            onPressed: () => _launchTel(phoneRaw),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [

            /// 🔹 NÚMERO
            Text(
              "Número",
              style: AppTextStyles.sectionTitle,
            ),
            SizedBox(height: 10),

            _StickerField(
              icon: Icons.call,
              label: 'Número de Teléfono',
              value: phoneDisplay,
              type: _ActionType.phone,
              data: phoneRaw,
            ),

            SizedBox(height: 30),

            /// 🔹 CORREO
            Text(
              "Correo",
              style: AppTextStyles.sectionTitle,
            ),
            SizedBox(height: 10),

            _StickerField(
              icon: Icons.email,
              label: 'Correo electrónico',
              value: emailDisplay,
              type: _ActionType.mail,
              data: emailRaw,
            ),
          ],
        ),
      ),
    );
  }
}

// ================== COMPONENTE ==================
enum _ActionType { phone, mail }

class _StickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final _ActionType type;
  final String data;

  const _StickerField({
    required this.icon,
    required this.label,
    required this.value,
    required this.type,
    required this.data,
  });

  void _action() {
    if (type == _ActionType.phone) {
      _launchTel(data);
    } else {
      _launchMail(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.iconoSuave,
                child: Icon(icon, color: AppColors.textoOscuro),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.normal,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _action,
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.value,
        ),
      ],
    );
  }
}