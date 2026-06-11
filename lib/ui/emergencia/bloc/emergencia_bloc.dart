import 'dart:async';

import 'package:controlbomberos/data/repositories/emergencia/emergencia_repository_impl.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'emergencia_event.dart';
part 'emergencia_state.dart';

class EmergenciaBloc extends Bloc<EmergenciaEvent, EmergenciaState> {
  final EmergenciaRepositoryImpl _emergenciaRepository =
      EmergenciaRepositoryImpl();
  EmergenciaBloc() : super(EmergenciaInitial()) {
    on<GetEmergenciaAllEvent>(_getEmergenciaAllEvent);
  }

  Future<void> _getEmergenciaAllEvent(
    GetEmergenciaAllEvent event,
    Emitter<EmergenciaState> emit,
  ) async {
    final emergencias = await _emergenciaRepository.getAllEmergencias();
    emit(EmergenciaLoaded(emergencias: emergencias));
  }
}
