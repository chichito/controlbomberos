import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/emergencia/emergencia_repository.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class EmergenciaRepositoryImpl extends EmergenciaRepository {
  @override
  Future<Emergencia> sendEmergencia(Emergencia emergencia) async {
    final db = await SQLiteHelper().database;
    db.insert(
      "emergencias",
      emergencia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return emergencia;
  }

  @override
  Future<List<Emergencia>> batchInsertEmergencias(
    List<Emergencia> emergenciasList,
  ) async {
    final db = await SQLiteHelper().database;
    final batch = db.batch();
    for (final emergencia in emergenciasList) {
      await sendEmergencia(emergencia);
    }
    await batch.commit();
    return await getAllEmergencias();
  }

  @override
  Future<List<Emergencia>> getAllEmergencias() async {
    final db = await (SQLiteHelper()).database;
    final List<Map<String, dynamic>> maps = await db.query('emergencias');

    return List.generate(maps.length, (index) {
      return Emergencia(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
        fechahoraregistro: DateTime.parse(maps[index]['fechahoraregistro']),
        direccion: maps[index]['direccion'],
        referencia: maps[index]['referencia'],
        latitud: maps[index]['latitud'],
        longitud: maps[index]['longitud'],
        latitudemergencia: maps[index]['latitudemergencia'],
        longitudemergencia: maps[index]['longitudemergencia'],
        idusuarioactualizogeo: maps[index]['idusuarioactualizogeo'],
        estado: maps[index]['estado'],
        synced: maps[index]['synced'],
      );
    });
  }

  @override
  Future<Emergencia?> getEmergenciaById(String id) async {
    final db = await (SQLiteHelper()).database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM emergencias  WHERE id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return Emergencia(
        id: maps[0]['id'],
        name: maps[0]['name'],
        description: maps[0]['description'],
        fechahoraregistro: DateTime.parse(maps[0]['fechahoraregistro']),
        direccion: maps[0]['direccion'],
        referencia: maps[0]['referencia'],
        latitud: maps[0]['latitud'],
        longitud: maps[0]['longitud'],
        latitudemergencia: maps[0]['latitudemergencia'],
        longitudemergencia: maps[0]['longitudemergencia'],
        idusuarioactualizogeo: maps[0]['idusuarioactualizogeo'],
        estado: maps[0]['estado'],
        synced: maps[0]['synced'],
      );
    }
    return null;
  }
}
