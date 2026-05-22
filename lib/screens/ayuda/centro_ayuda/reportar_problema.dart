//MODIFIQUE 07/05/25
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';


import '../../../services/report_service.dart';//n
import '../../../services/auth_service.dart';//n

class ReportarProblema extends StatefulWidget {
  const ReportarProblema({super.key});

  @override
  State<ReportarProblema> createState() => _ReportarProblemaState();
}

enum _IssueType {
  malMedicion,
  probConex,
  errorApp,
  sugerencia,
  pulserarota,
  otro
}

class _ReportarProblemaState extends State<ReportarProblema> {

  _IssueType _selected = _IssueType.probConex;

  final TextEditingController _summaryCtrl =
      TextEditingController();

  @override
  void dispose() {
    _summaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {

    final text = _summaryCtrl.text.trim();

    if (text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor escriba un resumen.'),
        ),
      );

      return;
    }

    String tipoProblema = '';

    switch (_selected) {

      case _IssueType.malMedicion:
        tipoProblema = 'Medición incorrecta';
        break;

      case _IssueType.probConex:
        tipoProblema = 'Problemas de conexión';
        break;

      case _IssueType.errorApp:
        tipoProblema = 'Errores en la aplicación';
        break;

      case _IssueType.sugerencia:
        tipoProblema = 'Sugerencia';
        break;

      case _IssueType.pulserarota:
        tipoProblema = 'Pulsera rota';
        break;

      case _IssueType.otro:
        tipoProblema = 'Otro';
        break;
    }

    bool success = await ReportService.createReport(

      usuarioId: AuthService.userId ?? '',

      tipoProblema: tipoProblema,

      descripcion: text,

    );

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Problema enviado correctamente!'),
        ),
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        Navigator.pop(context);
      });

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enviar reporte'),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.fondoBlanco,
        centerTitle: true,
        title: const Text(
          'Reportar un problema',
          style: AppTextStyles.appBar,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.colorPrincipal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  'Escriba a detalle el tipo de situación y/o problema que tenga con nuestro producto o servicio y lo resolveremos lo más pronto posible.\n',
                  style: AppTextStyles.secundario.copyWith(
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Medición incorrecta',
                  selected:
                      _selected == _IssueType.malMedicion,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.malMedicion;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label:
                      'Problemas de conexión (Bluetooth, WiFi)',
                  selected:
                      _selected == _IssueType.probConex,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.probConex;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Errores en la aplicación',
                  selected:
                      _selected == _IssueType.errorApp,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.errorApp;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Pulsera rota',
                  selected:
                      _selected == _IssueType.pulserarota,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.pulserarota;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Sugerencia',
                  selected:
                      _selected == _IssueType.sugerencia,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.sugerencia;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Otro',
                  selected:
                      _selected == _IssueType.otro,
                  onTap: () {
                    setState(() {
                      _selected =
                          _IssueType.otro;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  'El equipo de soporte revisará tu reporte y se pondrá en contacto contigo en un plazo máximo de 48 horas hábiles.\n',
                  style: AppTextStyles.secundario,
                ),

                const SizedBox(height: 20),

                TextField(

                  controller: _summaryCtrl,

                  maxLines: 8,

                  decoration: InputDecoration(

                    hintText: 'Escriba un resumen...',

                    hintStyle:
                        AppTextStyles.secundario,

                    filled: true,

                    fillColor: AppColors.cardColor,

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(16),

                      borderSide: BorderSide.none,

                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(

                  height: 50,
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: _onSend,

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                          AppColors.colorBotonPrincipal,

                      foregroundColor:
                          AppColors.textoClaro,

                      elevation: 0,

                      shape: RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(30),

                      ),

                      textStyle:
                          AppTextStyles.buttonLarge,

                    ),

                    child: const Text(
                      'Enviar problema',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// OPCIONES
class _IssueOption extends StatelessWidget {

  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _IssueOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: selected
              ? AppColors.inputLogin
              : Colors.transparent,

          borderRadius: BorderRadius.circular(24),

        ),

        child: Row(

          children: [

            Container(

              width: 22,
              height: 22,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                border: Border.all(
                  color: AppColors.colorPrincipal,
                  width: 2,
                ),
              ),

              child: selected

                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor:
                            AppColors.colorPrincipal,
                      ),
                    )

                  : null,
            ),

            const SizedBox(width: 10),

            Expanded(

              child: Text(
                label,
                style: AppTextStyles.option,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* lo modifigue también original
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';



//LINEA NUEVA
import '../../../services/report_service.dart';

class ReportarProblema extends StatefulWidget {
  const ReportarProblema({super.key});

  @override
  State<ReportarProblema> createState() => _ReportarProblemaState();
}

enum _IssueType { malMedicion, probConex, errorApp, sugerencia, pulserarota, otro }

class _ReportarProblemaState extends State<ReportarProblema> {
  _IssueType _selected = _IssueType.probConex;
  final TextEditingController _summaryCtrl = TextEditingController();

  @override
  void dispose() {
    _summaryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.fondoBlanco,
        centerTitle: true,
        title: const Text(
          'Reportar un problema',
          style: AppTextStyles.appBar,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.colorPrincipal),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Escriba a detalle el tipo de situación y/o problema que tenga con nuestro producto o servicio y lo resolveremos lo más pronto posible.\n',
                  style: AppTextStyles.secundario.copyWith(height: 1.6),
                ),

                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Medición incorrecta',
                  selected: _selected == _IssueType.malMedicion,
                  onTap: () => setState(() => _selected = _IssueType.malMedicion),
                ),
                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Problemas de conexión (Bluetooth, WiFi)',
                  selected: _selected == _IssueType.probConex,
                  onTap: () => setState(() => _selected = _IssueType.probConex),
                ),
                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Errores en la aplicación',
                  selected: _selected == _IssueType.errorApp,
                  onTap: () => setState(() => _selected = _IssueType.errorApp),
                ),
                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Pulsera rota',
                  selected: _selected == _IssueType.pulserarota,
                  onTap: () => setState(() => _selected = _IssueType.pulserarota),
                ),
                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Sugerencia',
                  selected: _selected == _IssueType.sugerencia,
                  onTap: () => setState(() => _selected = _IssueType.sugerencia),
                ),
                const SizedBox(height: 10),

                _IssueOption(
                  label: 'Otro',
                  selected: _selected == _IssueType.otro,
                  onTap: () => setState(() => _selected = _IssueType.otro),
                ),

                const SizedBox(height: 20),

                Text(
                  'El equipo de soporte revisará tu reporte y se pondrá en contacto contigo en un plazo máximo de 48 horas hábiles.\n',
                  style: AppTextStyles.secundario,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _summaryCtrl,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Escriba un resumen...',
                    hintStyle: AppTextStyles.secundario,
                    filled: true,
                    fillColor: AppColors.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorBotonPrincipal,
                      foregroundColor: AppColors.textoClaro,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: AppTextStyles.buttonLarge,
                    ),
                    child: const Text('Enviar problema'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSend() {
    final text = _summaryCtrl.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escriba un resumen.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Problema enviado!')),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pop(context);
    });
  }
}

/// 🔘 OPCIONES
class _IssueOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _IssueOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.inputLogin : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.colorPrincipal, width: 2),
              ),
              child: selected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: AppColors.colorPrincipal,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.option,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/