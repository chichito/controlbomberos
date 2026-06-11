import 'package:controlbomberos/data/helper/sqlhelper.dart';
import 'package:controlbomberos/data/repositories/user/user_repository.dart';
import 'package:controlbomberos/domain/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<User> sendUser(User user) async {
    final db = await SQLiteHelper().database;
    db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final db = await (SQLiteHelper()).database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (index) {
      return User(
        cedula: maps[index]['cedula'],
        name: maps[index]['name'],
        email: maps[index]['email'],
        password: maps[index]['password'],
        celular: maps[index]['celular'],
      );
    });
  }

  @override
  Future<User?> getUserByValidate(String email, String password) async {
    final db = await (SQLiteHelper()).database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, password],
    );
    if (maps.isNotEmpty) {
      return User(
        cedula: maps[0]['cedula'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        celular: maps[0]['celular'],
      );
    }
    return null;
  }
}
