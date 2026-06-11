import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? cedula;
  final String name;
  final String? email;
  final String password;
  final String? celular;

  User({
    this.cedula,
    required this.name,
    this.email,
    required this.password,
    this.celular,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
    cedula: json["cedula"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    celular: json["celular"],
  );

  Map<String, dynamic> toJson() => {
    "cedula": cedula,
    "name": name,
    "email": email,
    "password": password,
    "celular": celular,
  };

  // Obtener una lista de Users a partir de un array de Maps
  static List<User> fromJsonArray(List object) {
    return object.map((item) {
      return User.fromJson(item);
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Map<String, dynamic> toMap() {
    return {
      "cedula": cedula,
      "name": name,
      "email": email,
      "password": password,
      "celular": celular,
    };
  }
}
