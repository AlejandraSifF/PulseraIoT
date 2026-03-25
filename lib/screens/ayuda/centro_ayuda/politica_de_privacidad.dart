import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class PoliticaDePrivacidadScreen extends StatelessWidget {
  const PoliticaDePrivacidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        backgroundColor: AppColors.colorPrincipal,
        elevation: 0,
        title: const Text(
          "Políticas De Privacidad",
          style: AppTextStyles.appBarLight,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textoClaro),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Last Update: 14/08/2024",
              style: AppTextStyles.highlight,
            ),
            SizedBox(height: 10),

            Text(
              "La empresa responsable de la aplicación y del tratamiento de los"
              " datos personales es [Nombre de la empresa/proyecto], con domicilio en México."
              " El cumplimiento se realiza conforme a la Ley Federal de Protección de Datos "
              "Personales en Posesión de los Particulares (LFPDPPP) \n."
              " utiliza y protege la información personal y de salud de los "
              "usuarios de la aplicación vinculada a la pulsera inteligente."
              "Nuestro compromiso es garantizar la seguridad, confidencialidad y"
              " uso responsable de los datos, especialmente considerando que "
              "el dispositivo está diseñado para personas de la tercera edad. ",
              style: AppTextStyles.paragraph,
            ),

            SizedBox(height: 25),

            Text(
              "Información que recopilamos",
              style: AppTextStyles.heading,
            ),

            SizedBox(height: 15),
            _CondicionesBox(),

            SizedBox(height: 60),

            Text(
              "Uso de la información",
              style: AppTextStyles.headingPrimary,
            ),

            SizedBox(height: 10),
            _CondicionesBox2(),

            SizedBox(height: 3),
            _CondicionesBox3(),
          ],
        ),
      ),
    );
  }
}

// 🔹 BOX 1
class _CondicionesBox extends StatelessWidget {
  const _CondicionesBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fondoCirculoIcono,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: const TextSpan(
          style: AppTextStyles.paragraph,
          children: [
            TextSpan(
              text: "Datos biométricos: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "frecuencia cardiaca, niveles de SpO2, detector de caídas.\n",
            ),
            TextSpan(
              text: "Datos de perfil: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "nombre, edad, número de contacto, correo electrónico.\n",
            ),
            TextSpan(
              text: "Datos de uso: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "registros de actividad, interacción con la aplicación, reportes enviados.\n",
            ),
            TextSpan(
              text: "Datos técnicos: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "modelo del dispositivo, sistema operativo, errores de funcionamiento.",
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 BOX 2
class _CondicionesBox2 extends StatelessWidget {
  const _CondicionesBox2();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fondoBlanco,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: const TextSpan(
          style: AppTextStyles.paragraph,
          children: [
            TextSpan(
              text: "Los datos recopilados se utilizan para:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  "\nMonitorear la salud y seguridad del usuario en tiempo real.\n"
                  "Notificar a familiares o cuidadores en caso de emergencia.\n"
                  "Mejorar el funcionamiento de la pulsera y la aplicación.\n"
                  "Proporcionar soporte técnico y atención personalizada.\n"
                  "Cumplir con requisitos legales o regulatorios aplicables.\n",
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 BOX 3
class _CondicionesBox3 extends StatelessWidget {
  const _CondicionesBox3();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: const TextSpan(
          style: AppTextStyles.paragraph,
          children: [
            TextSpan(
              text: "\n Derechos del usuario: \n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  "Acceder a sus datos personales. "
                  "Solicitar la corrección de información inexacta, "
                  "solicitar la eliminación de sus datos cuando ya no sean necesarios, "
                  "revocar el consentimiento para el uso de datos en cualquier momento. "
                  "Para ejercer estos derechos, el usuario podrá enviar una solicitud al correo ",
            ),
            TextSpan(
              text: "[tecnolyb3@gmail.com].\n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}