part of 'emergencia_bloc.dart';

class EmergenciaEvent {}

class GetEmergenciaAllEvent extends EmergenciaEvent {}

class GetEmergenciaEvent extends EmergenciaEvent {
  final Emergencia emergencia;
  GetEmergenciaEvent({required this.emergencia});
}
