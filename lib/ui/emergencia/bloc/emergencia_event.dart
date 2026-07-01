part of 'emergencia_bloc.dart';

class EmergenciaEvent {}

class GetEmergenciaAllEvent extends EmergenciaEvent {}

class GetEmergenciaIDEvent extends EmergenciaEvent {
  final String idEmergencia;

  GetEmergenciaIDEvent({required this.idEmergencia});
}

class SetEmergenciaEvent extends EmergenciaEvent {
  final Emergencia emergencia;
  SetEmergenciaEvent({required this.emergencia});
}

class GetEmergenciaSincronizarEvent extends EmergenciaEvent {}
