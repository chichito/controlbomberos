import 'dart:convert';

Retroalimentacion retroalimentacionFromJson(String str) =>
    Retroalimentacion.fromJson(json.decode(str));

String retroalimentacionToJson(Retroalimentacion data) =>
    json.encode(data.toJson());

class Retroalimentacion {
  final String guid;
  final String idusuario;
  final String idemergencia;
  final String tipotiempoestado;
  final DateTime fechahoraregistro;
  final String comentario;
  final int synced;

  Retroalimentacion({
    required this.guid,
    required this.idusuario,
    required this.idemergencia,
    required this.tipotiempoestado,
    required this.fechahoraregistro,
    required this.comentario,
    required this.synced,
  });

  factory Retroalimentacion.fromJson(Map<dynamic, dynamic> json) =>
      Retroalimentacion(
        guid: json["guid"],
        idusuario: json["idusuario"],
        idemergencia: json["idemergencia"],
        tipotiempoestado: json["tipotiempoestado"],
        fechahoraregistro: json["fechahoraregistro"],
        comentario: json["comentario"],
        synced: json["synced"],
      );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "idusuario": idusuario,
    "idemergencia": idemergencia,
    "tipotiempoestado": tipotiempoestado,
    "fechahoraregistro": fechahoraregistro.toIso8601String(),
    "comentario": comentario,
    "synced": synced,
  };

  // Obtener una lista de Tiempo a partir de un array de Maps
  static List<Retroalimentacion> fromJsonArray(List object) {
    return object.map((item) {
      return Retroalimentacion.fromJson(item);
    }).toList()..sort((a, b) => a.idusuario.compareTo(b.idusuario));
  }

  Map<String, dynamic> toMap() {
    return {
      "guid": guid,
      "idusuario": idusuario,
      "idemergencia": idemergencia,
      "tipotiempoestado": tipotiempoestado,
      "fechahoraregistro": fechahoraregistro.toIso8601String(),
      "comentario": comentario,
      "synced": synced,
    };
  }
}
