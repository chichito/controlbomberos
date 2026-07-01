import 'package:controlbomberos/data/services/result.dart';
import 'package:controlbomberos/domain/models/retroalimentacion.dart';

abstract class RetroalimentacionRepository {
  // funcion para enviar mensajes y gaurdar en la base de datos
  Future<Result<Retroalimentacion>> sendRetroalimentacion(
    Retroalimentacion retroalimentacion,
  );

  // Obtener la lista de mensajes del chat
  Future<List<Retroalimentacion>> getAllRetroalimentacion(
    String idEmergencia,
    String idUsuario,
  );
  Future<void> eliminarRetroalimentacion();
}
