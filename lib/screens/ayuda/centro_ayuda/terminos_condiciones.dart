import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// =====================================
/// MODELOS
/// =====================================
class TCSection {
  final String title;
  final String body;
  const TCSection({required this.title, required this.body});
}

class TCLink {
  final String label;
  final String url;
  final IconData icon;
  const TCLink({required this.label, required this.url, this.icon = Icons.link});
}

/// =====================================
/// CONTENIDO
/// =====================================
const String tcTitle = 'Términos y Condiciones';

final DateTime lastUpdatedTC = DateTime(2026, 9, 1);

const List<TCSection> tcSections = [
  TCSection(
    title: '1. Aceptación',
    body:
        'Al descargar, instalar y utilizar la aplicación vinculada a la pulsera inteligente, el usuario acepta cumplir con los presentes Términos y Condiciones.',
  ),
  TCSection(
    title: '2. Uso de la Aplicación',
    body:
        'Monitoreo de salud, alertas y seguimiento del bienestar.\nUso únicamente personal y no comercial.',
  ),
  TCSection(
    title: '3. Limitaciones de Responsabilidad',
    body:
        'No sustituye atención médica.\nConsultar siempre a un profesional.',
  ),
];

const List<TCLink> tcLinks = [
  TCLink(label: 'Facebook', url: 'https://www.facebook.com', icon: Icons.facebook),
  TCLink(label: 'Sitio Web', url: 'https://l3slywawa.github.io/pagina_web_pinkcarebeby/', icon: Icons.public),
];

Future<void> _openUrlTC(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// =====================================
/// PANTALLA
/// =====================================
class TerminosCondiciones extends StatelessWidget {
  const TerminosCondiciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        title: const Text(
          tcTitle,
          style: AppTextStyles.appBarLight,
        ),
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textoClaro),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _HeaderCardTC()),

            SliverList.builder(
              itemCount: tcSections.length,
              itemBuilder: (context, index) {
                return _SectionCardTC(section: tcSections[index]);
              },
            ),

            const SliverToBoxAdapter(child: _LinksCardTC()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}

/// =====================================
/// HEADER
/// =====================================
class _HeaderCardTC extends StatelessWidget {
  const _HeaderCardTC();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.rule, color: AppColors.colorPrincipal, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Última actualización: ${lastUpdatedTC.day}/${lastUpdatedTC.month}/${lastUpdatedTC.year}',
              style: AppTextStyles.secundario,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================
class _SectionCardTC extends StatelessWidget {
  final TCSection section;
  const _SectionCardTC({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: AppTextStyles.subtitulo,
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: AppTextStyles.secundario.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// =====================================
class _LinksCardTC extends StatelessWidget {
  const _LinksCardTC();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tcLinks.map((link) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(link.icon, color: AppColors.colorPrincipal),
            title: Text(
              link.label,
              style: AppTextStyles.normal,
            ),
            onTap: () => _openUrlTC(link.url),
          ),
        );
      }).toList(),
    );
  }
}