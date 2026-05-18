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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashTop,
              AppColors.splashBottom,
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// LOGO MÁS GRANDE
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.18),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 240,
                  height: 240,
                ),
              ),

              const SizedBox(height: 15),

              /// TEXTO PRINCIPAL
              Text(
                "Tecnología con corazón",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.textoClaro,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),

              const SizedBox(height: 10),

              /// SUBTEXTO
              Text(
                "Cuidando lo que más importa",
                textAlign: TextAlign.center,
                style: AppTextStyles.secundario.copyWith(
                  color: AppColors.textoClaro.withOpacity(0.85),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}