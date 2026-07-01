import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestNotificationPermission(BuildContext? context) async {
  var status = await Permission.notification.status;

  // Ya concedido
  if (status.isGranted) {
    return true;
  }

  // Solicitar permiso
  status = await Permission.notification.request();

  if (status.isGranted) {
    return true;
  }

  // Denegado permanentemente
  if (status.isPermanentlyDenied) {
    if (context != null && context.mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Permiso requerido'),
          content: const Text(
            'Para recibir alertas de emergencias debe habilitar las notificaciones en la configuración de la aplicación.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text('Configuración'),
            ),
          ],
        ),
      );
    } else {
      await openAppSettings();
    }

    return false;
  }

  // Denegado normal
  if (status.isDenied) {
    debugPrint('Usuario rechazó el permiso de notificaciones');
    return false;
  }

  return false;
}
