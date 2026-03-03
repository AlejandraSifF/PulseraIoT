import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService _instance =
      NotificationService._privateConstructor();

  factory NotificationService() {
    return _instance;
  }

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  late AndroidNotificationChannel _channelConSonido;
  late AndroidNotificationChannel _channelSinSonido;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _initLocalNotifications();
    await _setupFCMListeners();
    await _printToken();

    // 🔥 SUSCRIPCIÓN TEMPORAL PARA PRUEBA
    await _messaging.subscribeToTopic("alertas_importantes");
    await _messaging.subscribeToTopic("mensajes");

    print("✅ Suscrito a alertas_importantes y mensajes");
  }

  Future<void> _printToken() async {
    String? token = await _messaging.getToken();
    print("🔥 FCM TOKEN: $token");

    _messaging.onTokenRefresh.listen((newToken) {
      print("🔄 Nuevo token: $newToken");
    });
  }

  Future<void> _initLocalNotifications() async {
    _channelConSonido = const AndroidNotificationChannel(
      'canal_con_sonido',
      'Canal con sonido',
      description: 'Notificaciones con sonido',
      importance: Importance.high,
      playSound: true,
    );

    _channelSinSonido = const AndroidNotificationChannel(
      'canal_sin_sonido',
      'Canal sin sonido',
      description: 'Notificaciones sin sonido',
      importance: Importance.high,
      playSound: false,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channelConSonido);
    await androidPlugin?.createNotificationChannel(_channelSinSonido);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);
  }

  Future<void> _setupFCMListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Mensaje recibido tipo: ${message.data['tipo']}");
      _handleMessage(message);
    });
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();

    final recibirNotificaciones =
        prefs.getBool('recibirNotificaciones') ?? true;
    final alertas = prefs.getBool('alertas') ?? true;
    final mensajes = prefs.getBool('mensajes') ?? true;
    final sonidoAlertas = prefs.getBool('sonidoAlertas') ?? false;
    final sonidoMensajes = prefs.getBool('sonidoMensajes') ?? true;

    if (!recibirNotificaciones) return;

    final tipo = message.data['tipo'];
    final titulo = message.data['titulo'] ?? 'Sin título';
    final cuerpo = message.data['cuerpo'] ?? '';

    if (tipo == 'alerta' && !alertas) return;
    if (tipo == 'mensaje' && !mensajes) return;

    final usarSonido =
        (tipo == 'alerta') ? sonidoAlertas : sonidoMensajes;

    final channel =
        usarSonido ? _channelConSonido : _channelSinSonido;

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      cuerpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ),
    );
  }
}