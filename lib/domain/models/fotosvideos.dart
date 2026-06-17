import 'dart:convert';
import 'dart:typed_data';

Fotosvideos fotosvideosFromJson(String str) =>
    Fotosvideos.fromJson(json.decode(str));

String fotosvideosToJson(Fotosvideos data) => json.encode(data.toJson());

class Fotosvideos {
  final String guid;
  final String idusuario;
  final String idemergencia;
  final String tipotiempoestado;
  final DateTime fechahoraregistro;
  final Uint8List media;
  final String tipoarchivo;
  final int synced;

  Fotosvideos({
    required this.guid,
    required this.idusuario,
    required this.idemergencia,
    required this.tipotiempoestado,
    required this.fechahoraregistro,
    required this.media,
    required this.tipoarchivo,
    required this.synced,
  });

  factory Fotosvideos.fromJson(Map<dynamic, dynamic> json) => Fotosvideos(
    guid: json["guid"],
    idusuario: json["idusuario"],
    idemergencia: json["idemergencia"],
    tipotiempoestado: json["tipotiempoestado"],
    fechahoraregistro: json["fechahoraregistro"],
    media: json["media"],
    tipoarchivo: json["tipoarchivo"],
    synced: json["synced"],
  );

  Map<String, dynamic> toJson() => {
    "guid": guid,
    "idusuario": idusuario,
    "idemergencia": idemergencia,
    "tipotiempoestado": tipotiempoestado,
    "fechahoraregistro": fechahoraregistro.toIso8601String(),
    "media": media,
    "tipoarchivo": tipoarchivo,
    "synced": synced,
  };

  // Obtener una lista de Candidaturas a partir de un array de Maps
  static List<Fotosvideos> fromJsonArray(List object) {
    return object.map((item) {
      return Fotosvideos.fromJson(item);
    }).toList()..sort((a, b) => a.idemergencia.compareTo(b.idemergencia));
  }

  Map<String, dynamic> toMap() {
    return {
      "guid": guid,
      "idusuario": idusuario,
      "idemergencia": idemergencia,
      "tipotiempoestado": tipotiempoestado,
      "fechahoraregistro": fechahoraregistro.toIso8601String(),
      "media": media,
      "tipoarchivo": tipoarchivo,
      "synced": synced,
    };
  }
}
