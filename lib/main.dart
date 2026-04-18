import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/notificacion_service.dart';
import 'screens/splash_screen/splash.dart';
import 'provider/perfil_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  await initializeDateFormatting('es', null); //fecha en español

  runApp(
    ChangeNotifierProvider(
      create: (_) => PerfilProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'), // 🔥 fuerza español

  supportedLocales: const [
    Locale('es', 'ES'),
  ],

  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
      theme: ThemeData(
        fontFamily: 'Karla',
      ),
      home: const SplashScreen(),
    );
  }
}