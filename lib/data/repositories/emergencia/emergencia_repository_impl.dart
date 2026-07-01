import 'dart:async';
import 'dart:io';

import 'package:controlbomberos/data/services/result.dart';
import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/emergencia/emergencia_repository.dart';
import 'package:controlbomberos/data/services/api_service.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

class EmergenciaRepositoryImpl extends EmergenciaRepository {
  late ApiService _dioApi;

  EmergenciaRepositoryImpl() {
    final String baseUrl =
        'http://192.168.2.5:5000'; //'${GlobalVariables.isUrl}/Prueba';
    //final String token = ''; //GlobalVariables.token;
    _dioApi = ApiService(baseUrl: baseUrl);
  }

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

  @override
  Future<Result<bool>> getEmergenciaAtender(
    String idUsuario,
    String idEmergencia,
  ) async {
    final db = await (SQLiteHelper()).database;

    var result = await db.rawQuery(
      '''
    SELECT COUNT(*) 
    FROM tiempos
    WHERE idusuario = ? AND idemergencia = ? 
      AND fechahorareviso IS NOT NULL AND fechahoraasigno IS NOT NULL
      AND fechahorasitio IS NOT NULL AND fechahoraretorno IS NOT NULL
      AND fechahorafinalizo IS NOT NULL
    ''',
      [idUsuario, idEmergencia],
    );
    if ((Sqflite.firstIntValue(result) ?? 0) > 0) {
      return Result.ok(true, message: 'La Emergencia fue ya finalizada');
    }

    result = await db.rawQuery(
      '''
    SELECT *
    FROM tiempos
   WHERE idusuario = ? AND idemergencia = ?
    AND (fechahoraasigno IS NOT NULL OR fechahorasitio IS NOT NULL OR fechahoraretorno IS NOT NULL)
    ''',
      [idUsuario, idEmergencia],
    );

    if ((Sqflite.firstIntValue(result) ?? 0) > 0) {
      return Result.ok(true, message: 'Usted esta Atendiendo esta Emergencia');
    }

    result = await db.rawQuery(
      '''
    SELECT count(*)
    FROM tiempos
    WHERE idusuario = ?
    AND (fechahoraasigno IS NOT NULL OR fechahorasitio IS NOT NULL OR fechahoraretorno IS NOT NULL) and fechahorafinalizo is null 
    ''',
      [idUsuario],
    );

    if ((Sqflite.firstIntValue(result) ?? 0) > 0) {
      return Result.fail(
        message: 'Hay una Emergencia que esta Atendiendo Usted',
      );
    }

    return Result.ok(true, message: 'Puede Proceder a Atender si Acepta');
  }

  @override
  Future<void> eliminarEmergencias() async {
    final db = await SQLiteHelper().database;
    await db.delete("emergencias");
  }

  @override
  Future<Result<List<Emergencia>>> getEmergenciaSincronizar() async {
    try {
      final response = await _dioApi.get(
        endPoint: '/api/Emergencias',
        //data: {'username': user, 'password': password},
      );
      final List<dynamic> data = response.data;
      final emergencias = data.map((e) => Emergencia.fromJson(e)).toList();
      await eliminarEmergencias();
      await batchInsertEmergencias(emergencias);
      return Result.ok(
        await getAllEmergencias(),
        message: 'Se realizo la Sincronizacion Correctamente',
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
    } on DioException catch (e) {
      return Result.fail(
        code: ErrorCode.network,
        message: 'Servidor: ${e.error.toString()}',
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
}
