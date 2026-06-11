import 'dart:convert';

Tiempo tiempoFromJson(String str) => Tiempo.fromJson(json.decode(str));

String tiempoToJson(Tiempo data) => json.encode(data.toJson());

class Tiempo {
  final String? idusuario;
  final String? idemergencia;
  final int? numerorevisado;
  final DateTime? fechahorareviso;
  final DateTime? fechahoraasigno;
  final DateTime? fechahorasitio;
  final DateTime? fechahoraretorno;
  final DateTime? fechahorafinalizo;
  final int? synced;

  Tiempo({
    this.idusuario,
    this.idemergencia,
    this.numerorevisado,
    this.fechahorareviso,
    this.fechahoraasigno,
    this.fechahorasitio,
    this.fechahoraretorno,
    this.fechahorafinalizo,
    this.synced,
  });

  factory Tiempo.fromJson(Map<dynamic, dynamic> json) => Tiempo(
    idusuario: json["idusuario"],
    idemergencia: json["idemergencia"],
    numerorevisado: json["numerorevisado"],
    fechahorareviso: json["fechahorareviso"],
    fechahoraasigno: json["fechahoraasigno"],
    fechahorasitio: json["fechahorasitio"],
    fechahoraretorno: json["fechahoraretorno"],
    fechahorafinalizo: json["fechahorafinalizo"],
    synced: json["synced"],
  );

  Map<String, dynamic> toJson() => {
    "idusuario": idusuario,
    "idemergencia": idemergencia,
    "numerorevisado": numerorevisado,
    "fechahorareviso": fechahorareviso?.toIso8601String(),
    "fechahoraasigno": fechahoraasigno?.toIso8601String(),
    "fechahorasitio": fechahorasitio?.toIso8601String(),
    "fechahoraretorno": fechahoraretorno?.toIso8601String(),
    "fechahorafinalizo": fechahorafinalizo?.toIso8601String(),
    "synced": synced,
  };

  // Obtener una lista de Tiempo a partir de un array de Maps
  static List<Tiempo> fromJsonArray(List object) {
    return object.map((item) {
      return Tiempo.fromJson(item);
    }).toList()..sort((a, b) => a.idusuario!.compareTo(b.idusuario!));
  }

  Map<String, dynamic> toMap() {
    return {
      "idusuario": idusuario,
      "idemergencia": idemergencia,
      "numerorevisado": numerorevisado,
      "fechahorareviso": fechahorareviso?.toIso8601String(),
      "fechahoraasigno": fechahoraasigno?.toIso8601String(),
      "fechahorasitio": fechahorasitio?.toIso8601String(),
      "fechahoraretorno": fechahoraretorno?.toIso8601String(),
      "fechahorafinalizo": fechahorafinalizo?.toIso8601String(),
      "synced": synced,
    };
  }
}
