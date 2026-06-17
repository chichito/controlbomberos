import 'package:controlbomberos/data/helper/result.dart';
import 'package:controlbomberos/domain/models/fotosvideos.dart';

abstract class FotosVideosRepository {
  // funcion para enviar mensajes y gaurdar en la base de datos
  Future<Result<Fotosvideos>> sendFotosVideos(Fotosvideos fotosvideos);
  Future<Result<List<Fotosvideos>>> batchInsertFotosvideos(
    List<Fotosvideos> fotosvideosList,
  );
  // Obtener la lista de mensajes del chat
  Future<List<Fotosvideos>> getAllFotosVideos(
    String idEmergencia,
    String idUsuario,
  );
  Future<void> eliminarFotosVideosBYId(String idEmergencia, String idUsuario);
  Future<void> eliminarFotosVideos();
}
