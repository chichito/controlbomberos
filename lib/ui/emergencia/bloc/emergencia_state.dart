part of 'emergencia_bloc.dart';

class EmergenciaState {}

class EmergenciaInitial extends EmergenciaState {}

class EmergenciaLoaded extends EmergenciaState {
  final List<Emergencia> emergencias;
  EmergenciaLoaded({this.emergencias = const []});

  EmergenciaLoaded copyWith({List<Emergencia>? emergencias}) {
    return EmergenciaLoaded(emergencias: emergencias ?? this.emergencias);
  }
}

class EmergenciaIDLoaded extends EmergenciaState {
  final Emergencia? emergencia;
  EmergenciaIDLoaded({this.emergencia});

  EmergenciaIDLoaded copyWith({Emergencia? emergencia}) {
    return EmergenciaIDLoaded(emergencia: emergencia ?? this.emergencia);
  }
}

class EmergenciaFailed extends EmergenciaState {}
