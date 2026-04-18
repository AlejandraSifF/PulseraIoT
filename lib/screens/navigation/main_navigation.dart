import 'package:flutter/material.dart';
import '../configuracion/configuracion.dart';
import '../home/home_sano.dart';
import '../home/home_hipertension.dart';
import '../home/home_diabetes.dart';
import '../home/home_combinado.dart';
import '../../theme/app_colors.dart';
import '../perfil/perfil.dart';
import '../ayuda/centro_ayuda/centro_ayuda_screen.dart';

class MainNavigation extends StatefulWidget {
  final String tipoHome;

  const MainNavigation({super.key, required this.tipoHome});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int _selectedIndex = 0;

  /// 🔥 FUNCIÓN PARA OBTENER EL HOME CORRECTO
  Widget _obtenerHome() {

    print("TipoHome recibido: ${widget.tipoHome}"); // 👈 debug opcional

    switch (widget.tipoHome.toLowerCase()) {

      case "hipertension":
        return const HomeHipertension();

      case "diabetes":
        return const HomeDiabetes();

      case "hipertension y diabetes":
        return const HomeCombinado();

      default:
        return const HomeSano();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    /// 🔥 LISTA DINÁMICA (IMPORTANTE)
    final pages = [
      _obtenerHome(),
      Perfil(tipoPerfil: widget.tipoHome),
      CentroAyudaScreen(),
      const ConfiguracionPantalla(),
    ];

    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      extendBody: true,

      body: pages[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              backgroundColor: AppColors.colorBotonPrincipal,
              selectedItemColor: AppColors.textoClaro,
              unselectedItemColor:
                  AppColors.textoClaro.withOpacity(0.7),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              iconSize: 22,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}