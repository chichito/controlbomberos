import 'dart:convert';

Emergencia emergenciaFromJson(String str) =>
    Emergencia.fromJson(json.decode(str));

String emergenciaToJson(Emergencia data) => json.encode(data.toJson());

class Emergencia {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? fechahoraregistro;
  final String? direccion;
  final String? referencia;
  final double? latitud;
  final double? longitud;
  final double? latitudemergencia;
  final double? longitudemergencia;
  final String? idusuarioactualizogeo;
  final String? estado;
  final int? synced;

  Emergencia({
    this.id,
    this.name,
    this.description,
    this.fechahoraregistro,
    this.direccion,
    this.referencia,
    this.latitud,
    this.longitud,
    this.latitudemergencia,
    this.longitudemergencia,
    this.idusuarioactualizogeo,
    this.estado,
    this.synced,
  });

  factory Emergencia.fromJson(Map<dynamic, dynamic> json) => Emergencia(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    fechahoraregistro: json["fechahoraregistro"],
    direccion: json["direccion"],
    referencia: json["referencia"],
    latitud: json["latitud"],
    longitud: json["longitud"],
    latitudemergencia: json["latitudemergencia"],
    longitudemergencia: json["longitudemergencia"],
    idusuarioactualizogeo: json["idusuarioactualizogeo"],
    estado: json["estado"],
    synced: json["synced"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "fechahoraregistro": fechahoraregistro,
    "direccion": direccion,
    "referencia": referencia,
    "latitud": latitud,
    "longitud": longitud,
    "latitudemergencia": latitudemergencia,
    "longitudemergencia": longitudemergencia,
    "idusuarioactualizogeo": idusuarioactualizogeo,
    "estado": estado,
    "synced": synced,
  };

  // Obtener una lista de Emergencia a partir de un array de Maps
  static List<Emergencia> fromJsonArray(List object) {
    return object.map((item) {
      return Emergencia.fromJson(item);
    }).toList()..sort((a, b) => a.id!.compareTo(b.id!));
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "fechahoraregistro": fechahoraregistro?.toIso8601String(),
      "direccion": direccion,
      "referencia": referencia,
      "latitud": latitud,
      "longitud": longitud,
      "latitudemergencia": latitudemergencia,
      "longitudemergencia": longitudemergencia,
      "idusuarioactualizogeo": idusuarioactualizogeo,
      "estado": estado,
      "synced": synced,
    };
  }
}
