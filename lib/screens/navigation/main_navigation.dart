import 'package:flutter/material.dart';
import '../configuracion.dart';
import '../../theme/app_colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Inicio")),
    const Center(child: Text("Perfil")),
    const Center(child: Text("Ayuda")),
    ConfiguracionPantalla(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantallaPrincipal,
      extendBody: true, //más flotante

      body: _pages[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: SizedBox(
            height: 80, //  controlar qué tan delgado rs
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
              iconSize: 22, // más estilizado
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