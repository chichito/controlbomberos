part of 'emergencia_bloc.dart';

class EmergenciaState {}

class EmergenciaInitial extends EmergenciaState {}

class EmergenciaLoaded extends EmergenciaState {
  final List<Emergencia> emergencias;
  final StatusResult status;
  final String? message;
  final ErrorCode? errorCode;
  EmergenciaLoaded(
    this.status, {
    this.message,
    this.errorCode,
    this.emergencias = const [],
  });

  EmergenciaLoaded copyWith({
    List<Emergencia>? emergencias,
    StatusResult? status,
    String? message,
    ErrorCode? errorCode,
  }) {
    return EmergenciaLoaded(
      status ?? this.status,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      emergencias: emergencias ?? this.emergencias,
    );
  }
}

class EmergenciaIDLoaded extends EmergenciaState {
  final Emergencia? emergencia;

  EmergenciaIDLoaded({this.emergencia});

  EmergenciaIDLoaded copyWith({Emergencia? emergencia}) {
    return EmergenciaIDLoaded(emergencia: emergencia ?? this.emergencia);
  }
}

class EmergenciaFailed extends EmergenciaState {
  final StatusResult status;
  final String? message;
  final ErrorCode? errorCode;

  EmergenciaFailed({
    required this.status,
    required this.message,
    required this.errorCode,
  });

  EmergenciaFailed copyWith({
    StatusResult? status,
    String? message,
    ErrorCode? errorCode,
  }) {
    return EmergenciaFailed(
      status: status ?? this.status,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
