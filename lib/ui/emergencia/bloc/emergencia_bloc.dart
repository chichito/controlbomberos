import 'dart:async';

import 'package:controlbomberos/data/repositories/emergencia/emergencia_repository_impl.dart';
import 'package:controlbomberos/data/services/result.dart';
import 'package:controlbomberos/domain/models/emergencia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'emergencia_event.dart';
part 'emergencia_state.dart';

class EmergenciaBloc extends Bloc<EmergenciaEvent, EmergenciaState> {
  final EmergenciaRepositoryImpl _emergenciaRepository =
      EmergenciaRepositoryImpl();
  EmergenciaBloc() : super(EmergenciaInitial()) {
    on<GetEmergenciaAllEvent>(_getEmergenciaAllEvent);
    on<GetEmergenciaIDEvent>(_getEmergenciaIDEvent);
    on<GetEmergenciaSincronizarEvent>(_getEmergenciaSincronizarEvent);
  }

  Future<void> _getEmergenciaAllEvent(
    GetEmergenciaAllEvent event,
    Emitter<EmergenciaState> emit,
  ) async {
    print('INICIO CONSULTA SQLITE');
    final emergencias = await _emergenciaRepository.getAllEmergencias();
    print('FIN CONSULTA SQLITE');
    emit(EmergenciaLoaded(StatusResult.success, emergencias: emergencias));
  }

  Future<void> _getEmergenciaIDEvent(
    GetEmergenciaIDEvent event,
    Emitter<EmergenciaState> emit,
  ) async {
    final emergencia = await _emergenciaRepository.getEmergenciaById(
      event.idEmergencia,
    );
    emit(EmergenciaIDLoaded(emergencia: emergencia));
  }

  Future<(String?, bool)> getAtenderEmergencia(
    String idUsuario,
    String idEmergencia,
  ) async {
    final result = await _emergenciaRepository.getEmergenciaAtender(
      idUsuario,
      idEmergencia,
    );

    return (result.message, result.success);
  }

  Future<void> _getEmergenciaSincronizarEvent(
    GetEmergenciaSincronizarEvent event,
    Emitter<EmergenciaState> emit,
  ) async {
    emit(EmergenciaLoaded(StatusResult.loading));
    final resemer = await _emergenciaRepository.getEmergenciaSincronizar();
    if (resemer.isSuccess) {
      emit(
        EmergenciaLoaded(StatusResult.success, emergencias: resemer.data ?? []),
      );
    } else {
      emit(
        EmergenciaFailed(
          message: resemer.message,
          errorCode: resemer.code,
          status: StatusResult.error,
        ),
      );
    }
  }
}
