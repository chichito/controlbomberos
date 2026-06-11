import 'dart:io';
import 'dart:typed_data';

import 'package:controlbomberos/data/repositories/emergencia/emergencia_repository_impl.dart';
import 'package:controlbomberos/data/repositories/tiempo/tiempo_repository_impl.dart';
import 'package:controlbomberos/data/repositories/user/user_repository_impl.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:controlbomberos/domain/models/user.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLiteHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    //_database = await initWinDB();
    return _database!;
  }

  // Platform Specific
  void closeDB() async {
    // _database?.close() ?? Future.value();
  }

  Future<Database> initWinDB() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    final appDocumentsDir = Directory.current;
    final dbPath = join(appDocumentsDir.path, "databases", "data.db");
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(onCreate: _onCreate, version: 1),
    );
  }

  Future<Database> initDB() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir =
          Directory.current; //await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentsDir.path, "databases", "data.db");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
      return winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "data.db");
      final iOSAndroidDB = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
      return iOSAndroidDB;
    }

    throw Exception("NO Unsupported platform");
  }

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(""" CREATE TABLE IF NOT EXISTS ubicaciones(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cedula TEXT,
            latitud REAL,
            longitud REAL,
            distancia REAL,
            fechahoraregistro TEXT,
            synced INTEGER DEFAULT 0
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS users(
            cedula TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            password TEXT,
            celular TEXT
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS emergencias(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            fechahoraregistro TEXT,
            direccion TEXT,
            referencia TEXT,
            latitud REAL,
            longitud REAL,
            latitudemergencia REAL,
            longitudemergencia REAL,
            idusuarioactualizogeo TEXT,
            estado TEXT,
            synced INTEGER DEFAULT 0
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS tiempos(
            idusuario TEXT,
            idemergencia TEXT,
            numerorevisado INTEGER,
            fechahorareviso TEXT,
            fechahoraasigno TEXT,
            fechahorasitio TEXT,
            fechahoraretorno TEXT,
            fechahorafinalizo TEXT,
            synced INTEGER DEFAULT 0,
            PRIMARY KEY (idusuario, idemergencia)
          )
 """);
  }

  Future<void> insertInitialData() async {
    final userRepository = UserRepositoryImpl();
    final emergenciaRepository = EmergenciaRepositoryImpl();
    final tiempoRepository = TiempoRepositoryImpl();

    // Insertar tiempos de ejemplo
    // Insertar usuarios de ejemplo
    await userRepository.sendUser(
      User(
        cedula: "111",
        name: "Admin Admin",
        email: "111",
        password: "111",
        celular: "1111",
      ),
    );

    await emergenciaRepository.batchInsertEmergencias([
      Emergencia(
        id: "1",
        name: "Emergencia 1",
        description:
            "Descripción de la emergencia 1 Descripción de la emergencia 1 Descripción de la emergencia 1 Descripción de la emergencia 1 Descripción de la emergencia 1 Descripción de la emergencia 1 Descripción de la emergencia 1",
        fechahoraregistro: DateTime.now(),
        direccion: "Calle Falsa 123",
        referencia: "Frente a la plaza",
        idusuarioactualizogeo: "111",
        latitud: -0.180653,
        longitud: -78.467838,
        synced: 0,
      ),
      Emergencia(
        id: "2",
        name: "Emergencia 2",
        description: "Descripción de la emergencia 2",
        fechahoraregistro: DateTime.now(),
        direccion: "Calle Falsa 123",
        referencia: "Frente a la plaza",
        idusuarioactualizogeo: "111",
        latitud: -0.180653,
        longitud: -78.467838,
        synced: 0,
      ),
      Emergencia(
        id: "3",
        name: "Emergencia 3",
        description: "Descripción de la emergencia 3",
        fechahoraregistro: DateTime.now(),
        direccion: "Calle Falsa 123",
        referencia: "Frente a la plaza",
        idusuarioactualizogeo: "111",
        latitud: -0.180653,
        longitud: -78.467838,
        synced: 0,
      ),
      Emergencia(
        id: "4",
        name: "Emergencia 4",
        description: "Descripción de la emergencia 4  ",
        fechahoraregistro: DateTime.now(),
        direccion: "Calle Falsa 123",
        referencia: "Frente a la plaza",
        idusuarioactualizogeo: "111",
        latitud: -0.180653,
        longitud: -78.467838,
        synced: 0,
      ),
      Emergencia(
        id: "5",
        name: "Emergencia 5",
        description: "Descripción de la emergencia 5",
        fechahoraregistro: DateTime.now(),
        direccion: "Calle Falsa 123",
        referencia: "Frente a la plaza",
        idusuarioactualizogeo: "111",
        latitud: -0.180653,
        longitud: -78.467838,
        synced: 0,
      ),
    ]);

    await tiempoRepository.batchInsertTiempos([
      Tiempo(
        idusuario: "111",
        idemergencia: "1",
        numerorevisado: 1,
        fechahorareviso: DateTime.now(),
        /*fechahoraasigno: DateTime.now(),
        fechahorasitio: DateTime.now(),
        fechahoraretorno: DateTime.now(),
        fechahorafinalizo: DateTime.now(),*/
        synced: 0,
      ),
    ]);

    print("Datos iniciales insertados correctamente");
  }

  Future<Uint8List?> getImageBytes(String url) async {
    try {
      final dio = Dio();

      // 1. Realizar la petición GET especificando ResponseType.bytes
      final response = await dio.get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // 2. Obtener los bytes directamente
      return response.data;
    } catch (e) {
      print("Error al descargar la imagen: $e");
      return null;
    }
  }
}
