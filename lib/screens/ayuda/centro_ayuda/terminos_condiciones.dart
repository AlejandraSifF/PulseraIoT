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

  const TCSection({
    required this.title,
    required this.body,
  });
}

class TCLink {
  final String label;
  final String url;
  final IconData icon;

  const TCLink({
    required this.label,
    required this.url,
    this.icon = Icons.link,
  });
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
        'El presente documento establece los términos y condiciones de acceso, '
        'uso y operación de la pulsera inteligente para adultos mayores, así '
        'como de la aplicación móvil asociada ofrecidos por TecnoLYB, '
        'con domicilio en [DOMICILIO], correo electrónico de contacto '
        '[tecnolyb3@gmail.com] y teléfono [TELÉFONO]. '
        'Al adquirir, activar, configurar, descargar, instalar, acceder o '
        'utilizar el Servicio, la persona usuaria y, en su caso, su representante '
        'legal o cuidador autorizado, declara que ha leído, entendido y aceptado '
        'íntegramente estos Términos y Condiciones, el Aviso de Privacidad '
        'y demás políticas aplicables.',
  ),

  TCSection(
    title: '2. Definiciones',
    body:
        'Pulsera: dispositivo inteligente portátil diseñado para registrar y '
        'transmitir, según su configuración, datos relacionados con frecuencia '
        'cardiaca (BPM), saturación de oxígeno en sangre (SpO2) y temperatura corporal. '
        'Aplicación: software móvil compatible con dispositivos iOS y/o Android '
        'mediante el cual el usuario visualiza, administra y consulta la información '
        'generada por la Pulsera. '
        'Usuario: persona adulta mayor que porta la Pulsera o cualquier persona '
        'autorizada para consultar la información en la Aplicación. '
        'Representante autorizado: familiar, tutor, cuidador o persona designada '
        'por el Usuario para administrar o consultar el Servicio. '
        'Datos de salud: información derivada del uso del Servicio, incluyendo '
        'signos vitales, historial de mediciones, alertas y demás datos '
        'relacionados con la condición física del Usuario.',
  ),

  TCSection(
    title: '3. Objeto del Servicio',
    body:
        'El Servicio permite capturar, almacenar, sincronizar y mostrar en la '
        'Aplicación ciertos indicadores de salud mediante el uso de la pulsera. '
        'El Servicio tiene fines de apoyo, seguimiento y visualización de información, '
        'sin sustituir la valoración, diagnóstico ni tratamiento médico profesional.',
  ),

  TCSection(
    title: '4. Aceptación y capacidad legal',
    body:
        'El uso del Servicio implica la aceptación total de estos Términos y '
        'Condiciones. Cuando el Usuario sea menor de edad o carezca de capacidad '
        'legal para obligarse por sí mismo, el acceso y uso deberán realizarse '
        'por conducto de su representante legal, tutor o persona legalmente autorizada.',
  ),

  TCSection(
    title: '5. Uso permitido',
    body:
        'El Usuario se obliga a utilizar el Servicio de forma lícita, responsable '
        'y conforme a las instrucciones de uso proporcionadas por el proveedor. '
        'Queda prohibido: manipular, alterar, desmontar o intervenir la Pulsera '
        'o la Aplicación; usar el Servicio para fines fraudulentos, ilegales o '
        'distintos a los previstos; compartir credenciales de acceso con terceros '
        'no autorizados; intentar vulnerar la seguridad, integridad o funcionamiento '
        'del Servicio; utilizar la información obtenida del Servicio como único '
        'criterio para emergencias médicas.',
  ),

  TCSection(
    title: '6. Naturaleza de la información y limitación médica',
    body:
        'Las mediciones obtenidas por la Pulsera pueden variar por factores como '
        'movimiento, ajuste del dispositivo, condiciones ambientales, coloración '
        'de piel, sudoración, conectividad, batería, interferencias u otras '
        'circunstancias técnicas o fisiológicas. La información mostrada en la '
        'Aplicación tiene carácter orientativo y de monitoreo. No constituye por '
        'sí misma un diagnóstico médico, una prescripción ni una indicación de '
        'tratamiento. Ante cualquier síntoma, lectura inusual o emergencia, '
        'el Usuario deberá acudir de inmediato a un profesional de la salud o '
        'a los servicios de emergencia correspondientes.',
  ),

  TCSection(
    title: '7. Advertencias de uso en adultos mayores',
    body:
        'El Servicio está diseñado para facilitar el monitoreo de adultos mayores; '
        'sin embargo, no garantiza la prevención de enfermedades, accidentes, '
        'caídas, descompensaciones o eventos clínicos. El Usuario y su cuidador '
        'aceptan que la supervisión humana sigue siendo indispensable. '
        'En caso de enfermedad cardiaca, respiratoria, fiebre persistente, '
        'deterioro cognitivo, riesgo de desmayo u otra condición clínica relevante, '
        'el uso del Servicio deberá complementar y no reemplazar la atención médica profesional.',
  ),

  TCSection(
    title: '8. Requisitos técnicos',
    body:
        'Para operar el Servicio, el Usuario deberá contar con un teléfono '
        'inteligente compatible, conexión a internet o Bluetooth, batería suficiente '
        'en la Pulsera y el dispositivo móvil, así como permisos de acceso necesarios '
        'para la Aplicación. El Proveedor no será responsable por fallas derivadas '
        'de incompatibilidad del equipo, actualizaciones del sistema operativo, '
        'falta de conectividad, mal uso, daño físico o interferencias ajenas al Servicio.',
  ),

  TCSection(
    title: '9. Cuenta, acceso y seguridad',
    body:
        'Cuando el Servicio requiera creación de cuenta, el Usuario será responsable '
        'de proporcionar información veraz, completa y actualizada. El Usuario deberá '
        'resguardar sus credenciales de acceso y notificar de inmediato cualquier uso '
        'no autorizado. El Proveedor podrá suspender temporal o definitivamente el acceso '
        'al Servicio en caso de detectar fraude, abuso, uso indebido, riesgos de seguridad '
        'o incumplimiento de estos Términos.',
  ),

  TCSection(
    title: '10. Datos personales, salud y privacidad',
    body:
        'El tratamiento de datos personales se regirá por el Aviso de Privacidad '
        'del Proveedor. Los datos de salud generados por el Servicio serán tratados '
        'con medidas de seguridad administrativas, técnicas y físicas razonables. '
        'El Usuario podrá ejercer sus derechos de acceso, rectificación, cancelación '
        'u oposición conforme al procedimiento previsto en el Aviso de Privacidad.',
  ),
];

const List<TCLink> tcLinks = [
  TCLink(
    label: 'Facebook',
    url: 'https://www.facebook.com',
    icon: Icons.facebook,
  ),
  TCLink(
    label: 'Otros productos TecnoLYB',
    url: 'https://l3slywawa.github.io/pagina_web_pinkcarebeby/',
    icon: Icons.public,
  ),
];

Future<void> _openUrlTC(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
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
        backgroundColor: AppColors.colorPrincipal,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          tcTitle,
          style: AppTextStyles.appBarLight,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textoClaro,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: _HeaderCardTC(),
            ),

            SliverList.builder(
              itemCount: tcSections.length,
              itemBuilder: (context, index) {
                return _SectionCardTC(
                  section: tcSections[index],
                );
              },
            ),

            const SliverToBoxAdapter(
              child: _LinksCardTC(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
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
          const Icon(
            Icons.rule,
            color: AppColors.colorPrincipal,
            size: 30,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Última actualización: '
              '${lastUpdatedTC.day}/'
              '${lastUpdatedTC.month}/'
              '${lastUpdatedTC.year}',
              style: AppTextStyles.highlight,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================
/// CARD DE SECCIÓN
/// =====================================
class _SectionCardTC extends StatelessWidget {
  final TCSection section;

  const _SectionCardTC({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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
            textAlign: TextAlign.justify,
            style: AppTextStyles.paragraph.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================
/// LINKS
/// =====================================
class _LinksCardTC extends StatelessWidget {
  const _LinksCardTC();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tcLinks.map((link) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(
              link.icon,
              color: AppColors.colorPrincipal,
            ),
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