import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login/login.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navegar();
  }

  void _navegar() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.splashTop,
              AppColors.splashBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// LOGO
            Image.asset(
              'assets/images/logo.png',
              width: 180,
              height: 180,
            ),

            const SizedBox(height: 25),

            /// TEXTO
            Text(
              "Tecnología con corazón",
              style: AppTextStyles.heading.copyWith(
                color: AppColors.textoClaro,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            /// SUBTEXTO (opcional pro)
            Text(
              "Cuidando lo que más importa",
              style: AppTextStyles.secundario.copyWith(
                color: AppColors.textoClaro.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}