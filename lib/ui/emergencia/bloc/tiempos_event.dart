part of 'tiempos_bloc.dart';

class TiemposEvent {}

class GetTiemposAllEvent extends TiemposEvent {
  final String idEmergencia;
  final String idUsuario;

  GetTiemposAllEvent({required this.idEmergencia, required this.idUsuario});
}

class SetTiemposAllEvent extends TiemposEvent {
  final String idEmergencia;
  final String idUsuario;
  final String sTipo;

  SetTiemposAllEvent({
    required this.idEmergencia,
    required this.idUsuario,
    required this.sTipo,
  });
}
