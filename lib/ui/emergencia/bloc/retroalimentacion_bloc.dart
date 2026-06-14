import 'dart:async';

import 'package:controlbomberos/data/helper/result.dart';
import 'package:controlbomberos/data/repositories/retroalimentacion/retroalimentacion_repository_impl.dart';
import 'package:controlbomberos/domain/models/retroalimentacion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'retroalimentacion_event.dart';
part 'retroalimentacion_state.dart';

class RetroalimentacionBloc
    extends Bloc<RetroalimentacionEvent, RetroalimentacionState> {
  final RetroalimentacionRepositoryImpl _retroalimentacionRepository =
      RetroalimentacionRepositoryImpl();

  RetroalimentacionBloc() : super(RetroalimentacionInitial()) {
    on<GetRetroalimentacionEvent>(_getRetroalimentacionEvent);
    on<SetRetroalimentacionEvent>(_setRetroalimentacionEvent);
    on<TextoRetroalimentacion>(_textoRetroalimentacion);
  }

  FutureOr<void> _textoRetroalimentacion(
    TextoRetroalimentacion event,
    Emitter<RetroalimentacionState> emit,
  ) {
    emit(state.copyWith(texto: event.nuevoTexto));
  }

  Future<void> _getRetroalimentacionEvent(
    GetRetroalimentacionEvent event,
    Emitter<RetroalimentacionState> emit,
  ) async {
    final List<Retroalimentacion> retroalimentaciones =
        await _retroalimentacionRepository.getAllRetroalimentacion(
          event.idEmergencia,
          event.idUsuario,
        );
    emit(RetroalimentacionLoaded(retroalimentacion: retroalimentaciones));
  }

  Future<void> _setRetroalimentacionEvent(
    SetRetroalimentacionEvent event,
    Emitter<RetroalimentacionState> emit,
  ) async {
    emit(
      RetroalimentacionStateGrabado(status: RetroalimentacionStatus.loading),
    );

    final result = await _retroalimentacionRepository.sendRetroalimentacion(
      Retroalimentacion(
        guid: Uuid().v4(),
        idusuario: event.idUsuario,
        idemergencia: event.idEmergencia,
        tipotiempoestado: event.sTipoTiempo,
        fechahoraregistro: DateTime.now(),
        comentario: state.texto,
        synced: 0,
      ),
    );
    if (result.success) {
      emit(
        RetroalimentacionStateGrabado(
          status: RetroalimentacionStatus.success,
          message: result.message,
        ),
      );
    } else {
      emit(
        RetroalimentacionStateGrabado(
          status: RetroalimentacionStatus.error,
          message: result.message,
          errorCode: result.code,
        ),
      );
    }
  }
}
