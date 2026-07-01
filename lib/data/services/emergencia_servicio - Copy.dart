import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  bool isProcessing = false;
  bool emergenciaActiva = false;
  String? ultimaEmergenciaId;

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    if (isProcessing) return;

    if (service is AndroidServiceInstance) {
      final isForeground = await service.isForegroundService();

      if (!isForeground) {
        return;
      }
    }

    isProcessing = true;

    try {
      /*
      final response = await http
          .get(
            Uri.parse('https://tu-api.com/api/emergencias/pendientes'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));


      if (response.statusCode != 200) {
        throw Exception('Error HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      final bool hayEmergencia = data['hay_emergencia'] ?? false;

      if (hayEmergencia) {
        final String emergenciaId = data['id'].toString();

        final String mensaje = data['mensaje_emergencia'] ?? 'Nueva emergencia';

        // Procesar solo emergencias nuevas
        if (ultimaEmergenciaId != emergenciaId) {
          ultimaEmergenciaId = emergenciaId;

          // Notificar a la UI 
          service.invoke('nuevaEmergencia', {
            'id': emergenciaId,
            'mensaje': mensaje,
            'fecha': DateTime.now().toIso8601String(),
          });

          // Aquí puedes guardar en SQLite
          // await database.insert(...);

          // Aquí puedes reproducir sonido
          // await player.play(...);

          // Aquí puedes vibrar
          // Vibration.vibrate(...);
        }

        if (!emergenciaActiva) {
          emergenciaActiva = true;
          final androidService = service as AndroidServiceInstance;
          androidService.setForegroundNotificationInfo(
            title: '🚨 EMERGENCIA ACTIVA',
            content: mensaje,
          );
        }
      } else {
        if (emergenciaActiva) {
          emergenciaActiva = false;
          final androidService = service as AndroidServiceInstance;
          androidService.setForegroundNotificationInfo(
            title: 'Sistema de Emergencias',
            content: 'Sin emergencias activas',
          );
        }
      }
      */

      /*
      print('Actualizando notificación funciona');
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: '🚨 EMERGENCIA ACTIVA',
          content: 'hola mensaje',
        );
      }
      */
      // final isRunning = await FlutterBackgroundService().isRunning();

      //  print('Servicio activo: $isRunning');

      print('hola lelgo el servicio');
    } on TimeoutException {
      service.invoke('errorConexion', {'mensaje': 'Tiempo de espera agotado'});
    } on SocketException {
      service.invoke('sinInternet', {'mensaje': 'Sin conexión a Internet'});
    } catch (e, stack) {
      //log('Error en servicio' as num, {'error': e, 'stackTrace': stack});

      service.invoke('errorServicio', {'mensaje': e.toString()});
    } finally {
      isProcessing = false;
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

// Función para inicializar el servicio desde el main
Future<void> initializeEmergencyService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'emergencias_channel',
    'Emergencias',
    description: 'Canal para monitoreo de emergencias',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  await notifications.initialize(
    const InitializationSettings(android: initializationSettingsAndroid),
  );

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'emergencias_channel',
      initialNotificationTitle: 'Sistema de Emergencias',
      initialNotificationContent: 'Conectando...',
      foregroundServiceNotificationId: 1001,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
}
