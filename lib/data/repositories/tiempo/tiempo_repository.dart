import 'package:controlbomberos/domain/models/tiempo.dart';

abstract class TiempoRepository {
  // funcion para enviar tiempos y guardar en la base de datos
  Future<Tiempo> sendTiempo(Tiempo tiempo);
  Future<Tiempo?> updateTiempo(Tiempo tiempo);
  Future<Tiempo?> updateEstadoTiempo(
    String idEmergencia,
    String idUsuario,
    String sTipo,
  );
  Future<void> eliminarTiempo();
  // Obtener la lista de tiempos
  Future<List<Tiempo>> getAllTiempos();
  Future<List<Tiempo>> batchInsertTiempos(List<Tiempo> listaList);
  Future<Tiempo?> getTiempoById(String idemergencia, String idusuario);
}
