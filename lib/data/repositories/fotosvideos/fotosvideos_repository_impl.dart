import 'dart:async';
import 'dart:typed_data';

import 'package:controlbomberos/data/helper/result.dart';
import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/fotosvideos/fotosvideos_repository.dart';
import 'package:controlbomberos/domain/models/fotosvideos.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FotosVideosRepositoryImpl extends FotosVideosRepository {
  @override
  Future<Result<Fotosvideos>> sendFotosVideos(Fotosvideos fotosvideos) async {
    try {
      // Validaciones de negocio
      final db = await SQLiteHelper().database;
      final id = await db.insert(
        "fotosvideosemergencia",
        fotosvideos.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (id <= 0) {
        return Result.fail(
          code: ErrorCode.insert,
          message: 'No se pudo guardar el registro',
        );
      }

      return Result.ok(fotosvideos, message: 'Registro guardado correctamente');
    } on DatabaseException catch (e) {
      return Result.fail(
        code: ErrorCode.database,
        message: 'Error en SQLite',
        error: e,
      );
    } on TimeoutException catch (e) {
      return Result.fail(
        code: ErrorCode.timeout,
        message: 'La operación excedió el tiempo permitido',
        error: e,
      );
    } catch (e) {
      return Result.fail(
        code: ErrorCode.unknown,
        message: 'Error inesperado',
        error: e,
      );
    }
  }

  @override
  Future<Result<List<Fotosvideos>>> batchInsertFotosvideos(
    List<Fotosvideos> fotosvideosList,
  ) async {
    try {
      if (fotosvideosList.isEmpty) {
        return Result.fail(
          code: ErrorCode.notdata,
          message: 'No Existe Datos',
          error: 'No Existe Datos',
        );
      }
      await eliminarFotosVideosBYId(
        fotosvideosList[0].idusuario,
        fotosvideosList[0].idemergencia,
      );
      final db = await SQLiteHelper().database;
      final batch = db.batch();
      for (final fotosvideos in fotosvideosList) {
        await sendFotosVideos(fotosvideos);
      }
      await batch.commit();

      return Result.ok(
        fotosvideosList,
        message: 'Registro guardado correctamente',
      );
    } on DatabaseException catch (e) {
      return Result.fail(
        code: ErrorCode.database,
        message: 'Error en SQLite',
        error: e,
      );
    } on TimeoutException catch (e) {
      return Result.fail(
        code: ErrorCode.timeout,
        message: 'La operación excedió el tiempo permitido',
        error: e,
      );
    } catch (e) {
      return Result.fail(
        code: ErrorCode.unknown,
        message: 'Error inesperado',
        error: e,
      );
    }
  }

  @override
  Future<List<Fotosvideos>> getAllFotosVideos(
    String idEmergencia,
    String idUsuario,
  ) async {
    final db = await SQLiteHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT guid,idusuario,idemergencia,tipotiempoestado,fechahoraregistro,tipoarchivo,synced FROM fotosvideosemergencia WHERE idemergencia = ? and idusuario = ?',
      [idEmergencia, idUsuario],
    );

    final fotosvideosList = <Fotosvideos>[];
    for (final map in maps) {
      final blocmedia = await getMediaByGuidChunked(map["guid"]);
      fotosvideosList.add(
        Fotosvideos(
          guid: map["guid"],
          idusuario: map["idusuario"],
          idemergencia: map["idemergencia"],
          tipotiempoestado: map["tipotiempoestado"],
          fechahoraregistro: map["fechahoraregistro"] == null
              ? DateTime.fromMillisecondsSinceEpoch(0)
              : DateTime.parse(map["fechahoraregistro"]),
          media: blocmedia,
          tipoarchivo: map["tipoarchivo"],
          synced: map["synced"],
        ),
      );
    }

    return fotosvideosList;
  }

  Future<Uint8List> getMediaByGuidChunked(String guid) async {
    final db = await SQLiteHelper().database;
    final builder = BytesBuilder();
    int offset = 1;
    const chunkSize = 500000; // 500 KB
    while (true) {
      final result = await db.rawQuery(
        '''
      SELECT substr(media, ?, ?) as chunk
      FROM fotosvideosemergencia
      WHERE guid = ?
      ''',
        [offset, chunkSize, guid],
      );
      if (result.isEmpty) break;
      final chunk = result.first['chunk'] as Uint8List?;
      if (chunk == null || chunk.isEmpty) {
        break;
      }
      builder.add(chunk);
      if (chunk.length < chunkSize) {
        break;
      }
      offset += chunkSize;
    }
    return builder.toBytes();
  }

  Future<Uint8List?> getMedia(String guid) async {
    final db = await SQLiteHelper().database;

    final result = await db.query(
      'fotosvideosemergencia',
      columns: ['media'],
      where: 'guid = ?',
      whereArgs: [guid],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['media'] as Uint8List;
  }

  @override
  Future<void> eliminarFotosVideosBYId(
    String idUsuario,
    String idEmergencia,
  ) async {
    final db = await SQLiteHelper().database;
    await db.delete(
      'fotosvideosemergencia',
      where: 'idusuario = ? AND idemergencia = ?',
      whereArgs: [idUsuario, idEmergencia],
    );
  }

  @override
  Future<void> eliminarFotosVideos() async {
    final db = await SQLiteHelper().database;
    await db.delete("fotosvideosemergencia");
  }
}
