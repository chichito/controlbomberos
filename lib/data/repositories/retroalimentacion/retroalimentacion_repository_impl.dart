import 'dart:async';

import 'package:controlbomberos/data/helper/result.dart';
import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/retroalimentacion/retroalimentacion_repository.dart';
import 'package:controlbomberos/domain/models/retroalimentacion.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RetroalimentacionRepositoryImpl extends RetroalimentacionRepository {
  @override
  Future<Result<Retroalimentacion>> sendRetroalimentacion(
    Retroalimentacion retroalimentacion,
  ) async {
    try {
      // Validaciones de negocio
      final db = await SQLiteHelper().database;
      final id = await db.insert(
        "retroalimentacion",
        retroalimentacion.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (id <= 0) {
        return Result.fail(
          code: ErrorCode.insert,
          message: 'No se pudo guardar el registro',
        );
      }

      return Result.ok(
        retroalimentacion,
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
  Future<List<Retroalimentacion>> getAllRetroalimentacion(
    String idEmergencia,
    String idUsuario,
  ) {
    // TODO: implement getAllRetroalimentacion
    throw UnimplementedError();
  }
}
