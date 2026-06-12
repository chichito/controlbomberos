import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/tiempo/tiempo_repository.dart';
import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TiempoRepositoryImpl extends TiempoRepository {
  @override
  Future<Tiempo> sendTiempo(Tiempo tiempo) async {
    final db = await SQLiteHelper().database;
    db.insert(
      "tiempos",
      tiempo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return tiempo;
  }

  @override
  Future<void> eliminarTiempo() async {
    final db = await SQLiteHelper().database;
    db.delete("tiempos");
  }

  @override
  Future<Tiempo?> updateTiempo(Tiempo tiempo) async {
    final db = await SQLiteHelper().database;
    await db.update(
      'tiempos',
      tiempo.toMap(),
      where: 'idemergencia = ? amd idusuario = ?',
      whereArgs: [tiempo.idemergencia, tiempo.idusuario],
    );
    return getTiempoById(
      tiempo.idemergencia.toString(),
      tiempo.idusuario.toString(),
    );
  }

  @override
  Future<Tiempo?> updateEstadoTiempo(
    String idEmergencia,
    String idUsuario,
    String sTipo,
  ) async {
    final db = await SQLiteHelper().database;
    final tiem = await getTiempoById(idEmergencia, idUsuario);
    if (tiem == null) {
      await sendTiempo(
        Tiempo(
          idusuario: idUsuario,
          idemergencia: idEmergencia,
          numerorevisado: 1,
          fechahorareviso: DateTime.now(),
        ),
      );
    } else if (sTipo == 'TR') {
      await db.rawUpdate(
        'UPDATE tiempos SET numerorevisado = numerorevisado + 1,fechahorareviso = ? WHERE idemergencia = ? and idusuario = ?',
        [DateTime.now().toIso8601String(), idEmergencia, idUsuario],
      );
    } else if (sTipo == 'TA') {
      await db.rawUpdate(
        'UPDATE tiempos SET numerorevisado = numerorevisado + 1,fechahoraasigno = ? WHERE idemergencia = ? and idusuario = ?',
        [DateTime.now().toIso8601String(), idEmergencia, idUsuario],
      );
      await db.rawUpdate('UPDATE emergencias SET estado = ? WHERE id = ?', [
        'PROCESANDO',
        idEmergencia,
      ]);
    } else if (sTipo == 'TS') {
      await db.rawUpdate(
        'UPDATE tiempos SET numerorevisado = numerorevisado + 1,fechahorasitio = ? WHERE idemergencia = ? and idusuario = ?',
        [DateTime.now().toIso8601String(), idEmergencia, idUsuario],
      );
    } else if (sTipo == 'TRE') {
      await db.rawUpdate(
        'UPDATE tiempos SET numerorevisado = numerorevisado + 1,fechahoraretorno = ? WHERE idemergencia = ? and idusuario = ?',
        [DateTime.now().toIso8601String(), idEmergencia, idUsuario],
      );
    } else if (sTipo == 'TF') {
      await db.rawUpdate(
        'UPDATE tiempos SET numerorevisado = numerorevisado + 1,fechahorafinalizo = ? WHERE idemergencia = ? and idusuario = ?',
        [DateTime.now().toIso8601String(), idEmergencia, idUsuario],
      );
      await db.rawUpdate('UPDATE emergencias SET estado = ? WHERE id = ?', [
        'FINALIZADO',
        idEmergencia,
      ]);
    }
    return getTiempoById(idEmergencia, idUsuario);
  }

  @override
  Future<List<Tiempo>> batchInsertTiempos(List<Tiempo> tiempoList) async {
    final db = await SQLiteHelper().database;
    final batch = db.batch();
    for (final tiempo in tiempoList) {
      await sendTiempo(tiempo);
    }
    await batch.commit();
    return await getAllTiempos();
  }

  @override
  Future<List<Tiempo>> getAllTiempos() async {
    final db = await SQLiteHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('tiempos');

    return List.generate(maps.length, (index) {
      return Tiempo(
        idusuario: maps[index]["idusuario"],
        idemergencia: maps[index]["idemergencia"],
        numerorevisado: maps[index]["numerorevisado"],
        fechahorareviso: maps[index]["fechahorareviso"] == null
            ? null
            : DateTime.parse(maps[index]["fechahorareviso"]),
        fechahoraasigno: maps[index]["fechahoraasigno"] == null
            ? null
            : DateTime.parse(maps[index]["fechahoraasigno"]),
        fechahorasitio: maps[index]["fechahorasitio"] == null
            ? null
            : DateTime.parse(maps[index]["fechahorasitio"]),
        fechahoraretorno: maps[index]["fechahoraretorno"] == null
            ? null
            : DateTime.parse(maps[index]["fechahoraretorno"]),
        fechahorafinalizo: maps[index]["fechahorafinalizo"] == null
            ? null
            : DateTime.parse(maps[index]["fechahorafinalizo"]),
        synced: maps[index]["synced"],
      );
    });
  }

  @override
  Future<Tiempo?> getTiempoById(String idemergencia, String idusuario) async {
    final db = await SQLiteHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM tiempos WHERE idemergencia = ? and idusuario = ?',
      [idemergencia, idusuario],
    );
    if (maps.isNotEmpty) {
      return Tiempo(
        idusuario: maps[0]["idusuario"],
        idemergencia: maps[0]["idemergencia"],
        numerorevisado: maps[0]["numerorevisado"],
        fechahorareviso: maps[0]["fechahorareviso"] == null
            ? null
            : DateTime.parse(maps[0]["fechahorareviso"]),
        fechahoraasigno: maps[0]["fechahoraasigno"] == null
            ? null
            : DateTime.parse(maps[0]["fechahoraasigno"]),
        fechahorasitio: maps[0]["fechahorasitio"] == null
            ? null
            : DateTime.parse(maps[0]["fechahorasitio"]),
        fechahoraretorno: maps[0]["fechahoraretorno"] == null
            ? null
            : DateTime.parse(maps[0]["fechahoraretorno"]),
        fechahorafinalizo: maps[0]["fechahorafinalizo"] == null
            ? null
            : DateTime.parse(maps[0]["fechahorafinalizo"]),
        synced: maps[0]["synced"],
      );
    }
    return null;
  }
}
