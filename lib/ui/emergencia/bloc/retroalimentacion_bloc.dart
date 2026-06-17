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
      RetroalimentacionStateGrabado(
        texto: state.texto,
        status: RetroalimentacionStatus.loading,
      ),
    );
    if (state.texto.isEmpty) {
      emit(
        RetroalimentacionStateGrabado(
          texto: state.texto,
          status: RetroalimentacionStatus.empty,
          message: 'Retroalimentacion en Blanco',
        ),
      );
    } else {
      final retro = Retroalimentacion(
        guid: Uuid().v4(),
        idusuario: event.idUsuario,
        idemergencia: event.idEmergencia,
        tipotiempoestado: event.sTipoTiempo,
        fechahoraregistro: DateTime.now(),
        comentario: state.texto,
        synced: 0,
      );

      final result = await _retroalimentacionRepository.sendRetroalimentacion(
        retro,
      );
      if (result.success) {
        emit(
          RetroalimentacionStateGrabado(
            texto: state.texto,
            status: RetroalimentacionStatus.success,
            message: 'Grabado Exitosamente',
          ),
        );
      } else {
        emit(
          RetroalimentacionStateGrabado(
            texto: state.texto,
            status: RetroalimentacionStatus.error,
            message: result.message,
            errorCode: result.code,
          ),
        );
      }
    }
  }
}
