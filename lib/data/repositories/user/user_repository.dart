import 'package:controlbomberos/domain/models/user.dart';

abstract class UserRepository {
  // funcion para enviar mensajes y gaurdar en la base de datos
  Future<User> sendUser(User user);

  // Obtener la lista de mensajes del chat
  Future<List<User>> getAllUsers();
  Future<User?> getUserByValidate(String name, String password);
}
