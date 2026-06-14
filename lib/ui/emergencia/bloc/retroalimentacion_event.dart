part of 'retroalimentacion_bloc.dart';

class RetroalimentacionEvent {}

class TextoRetroalimentacion extends RetroalimentacionEvent {
  final String nuevoTexto;
  TextoRetroalimentacion(this.nuevoTexto);
}

class GetRetroalimentacionEvent extends RetroalimentacionEvent {
  final String idEmergencia;
  final String idUsuario;

  GetRetroalimentacionEvent({
    required this.idEmergencia,
    required this.idUsuario,
  });
}

class SetRetroalimentacionEvent extends RetroalimentacionEvent {
  final String idEmergencia;
  final String idUsuario;
  final String sTipoTiempo;

  SetRetroalimentacionEvent({
    required this.idEmergencia,
    required this.idUsuario,
    required this.sTipoTiempo,
  });
}
