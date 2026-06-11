import 'dart:async';

import 'package:controlbomberos/data/repositories/tiempo/tiempo_repository_impl.dart';
import 'package:controlbomberos/domain/models/tiempo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tiempos_event.dart';
part 'tiempos_state.dart';

class TiemposBloc extends Bloc<TiemposEvent, TiemposState> {
  final TiempoRepositoryImpl _tiempoRepository = TiempoRepositoryImpl();
  TiemposBloc() : super(TiemposInitial()) {
    on<GetTiemposAllEvent>(_getTiemposAllEvent);
    on<SetTiemposAllEvent>(_setTiemposAllEvent);
  }

  Future<void> _getTiemposAllEvent(
    GetTiemposAllEvent event,
    Emitter<TiemposState> emit,
  ) async {
    final tiempos = await _tiempoRepository.getTiempoById(
      event.idEmergencia,
      event.idUsuario,
    );
    emit(TiemposLoaded(tiempos: tiempos));
  }

  Future<void> _setTiemposAllEvent(
    SetTiemposAllEvent event,
    Emitter<TiemposState> emit,
  ) async {
    final tiempos = await _tiempoRepository.updateEstadoTiempo(
      event.idEmergencia,
      event.idUsuario,
      event.sTipo,
    );
    emit(TiemposLoaded(tiempos: tiempos));
  }
}
