part of 'retroalimentacion_bloc.dart';

enum RetroalimentacionStatus { initial, loading, success, error }

class RetroalimentacionState {
  final String texto;

  RetroalimentacionState({required this.texto});

  RetroalimentacionState copyWith({String? texto}) {
    return RetroalimentacionState(texto: texto ?? this.texto);
  }
}

final class RetroalimentacionInitial extends RetroalimentacionState {
  RetroalimentacionInitial() : super(texto: '');
}

class RetroalimentacionLoaded extends RetroalimentacionState {
  final List<Retroalimentacion> retroalimentacion;
  RetroalimentacionLoaded({
    super.texto = '',
    this.retroalimentacion = const [],
  });

  @override
  RetroalimentacionLoaded copyWith({
    String? texto,
    List<Retroalimentacion>? retroalimentacion,
  }) {
    return RetroalimentacionLoaded(
      texto: texto ?? this.texto,
      retroalimentacion: retroalimentacion ?? this.retroalimentacion,
    );
  }
}

class RetroalimentacionFailed extends RetroalimentacionState {
  RetroalimentacionFailed() : super(texto: '');
}

class RetroalimentacionStateGrabado extends RetroalimentacionState {
  final RetroalimentacionStatus status;
  final String? message;
  final ErrorCode? errorCode;

  RetroalimentacionStateGrabado({
    required this.status,
    this.message,
    this.errorCode,
  }) : super(texto: '');

  @override
  RetroalimentacionStateGrabado copyWith({
    RetroalimentacionStatus? status,
    String? message,
    ErrorCode? errorCode,
    String? texto,
  }) {
    return RetroalimentacionStateGrabado(
      status: status ?? this.status,
      message: message,
      errorCode: errorCode,
    );
  }
}
