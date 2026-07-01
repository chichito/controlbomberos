import 'package:controlbomberos/data/services/result.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';

abstract class EmergenciaRepository {
  // funcion para enviar emergencias y guardar en la base de datos
  Future<Emergencia> sendEmergencia(Emergencia emergencia);

  // Obtener la lista de emergencias
  Future<List<Emergencia>> getAllEmergencias();
  Future<List<Emergencia>> batchInsertEmergencias(List<Emergencia> listaList);
  Future<Emergencia?> getEmergenciaById(String id);
  Future<Result<bool>> getEmergenciaAtender(
    String idUsuario,
    String idEmergencia,
  );
  Future<void> eliminarEmergencias();
  Future<Result<List<Emergencia>>> getEmergenciaSincronizar();
}
