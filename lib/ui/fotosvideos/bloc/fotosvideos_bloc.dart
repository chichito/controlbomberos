import 'dart:async';
import 'dart:typed_data';

import 'package:controlbomberos/data/services/result.dart';
import 'package:controlbomberos/data/repositories/fotosvideos/fotosvideos_repository_impl.dart';
import 'package:controlbomberos/domain/models/fotosvideos.dart';
import 'package:controlbomberos/ui/fotosvideos/class/tipo_media.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

part 'fotosvideos_event.dart';
part 'fotosvideos_state.dart';

class FotosVideosBloc extends Bloc<FotosVideosEvent, FotosVideosState> {
  final ImagePicker _picker = ImagePicker();
  final FotosVideosRepositoryImpl _fotosvideosRepository =
      FotosVideosRepositoryImpl();

  FotosVideosBloc() : super(FotosVideosState(media: [])) {
    on<PickImagesFromCameraEvent>(_pickImagesFromCameraEvent);
    on<PickVideosFromCameraEvent>(_pickVideosFromCameraEvent);
    on<PickMultipleMediaFromGalleryEvent>(_pickMultipleMediaFromGalleryEvent);
    on<PickDeleteMediaEvent>(_pickDeleteMediaEvent);
    on<SendPickEvent>(_sendPickEvent);
    on<GetPickEvent>(_getPickEvent);
  }

  Future<void> _pickImagesFromCameraEvent(
    PickImagesFromCameraEvent event,
    Emitter<FotosVideosState> emit,
  ) async {
    final mediaCamera = await _picker.pickImage(source: ImageSource.camera);
    final photo = TipoMedia(
      tipo: 'imagen',
      file: await convertXFileToBytes(mediaCamera!),
    );
    if (photo.file != null) {
      emit(state.copyWith(media: [...state.media, photo]));
    }
  }

  Future<void> _pickVideosFromCameraEvent(
    PickVideosFromCameraEvent event,
    Emitter<FotosVideosState> emit,
  ) async {
    final mediaCamera = await _picker.pickVideo(source: ImageSource.camera);
    final photo = TipoMedia(
      tipo: 'video',
      file: await convertXFileToBytes(mediaCamera!),
    );
    if (photo.file != null) {
      emit(state.copyWith(media: [...state.media, photo]));
    }
  }

  Future<void> _pickMultipleMediaFromGalleryEvent(
    PickMultipleMediaFromGalleryEvent event,
    Emitter<FotosVideosState> emit,
  ) async {
    final List<XFile> selectedMedia = await _picker.pickMultipleMedia();

    if (selectedMedia.isNotEmpty) {
      final List<TipoMedia> newMediaList = await Future.wait(
        selectedMedia.map((xfile) async {
          // 1. Obtenemos el mimeType del archivo usando su path
          final mimeType = lookupMimeType(xfile.path);

          // 2. Evaluamos si contiene 'video' (o puedes validar la extensión)
          final esVideo = mimeType != null && mimeType.startsWith('video');
          final Uint8List compressed = await convertXFileToBytes(xfile);

          return TipoMedia(
            tipo: esVideo ? 'video' : 'imagen',
            file: compressed,
          );
        }).toList(),
      );
      emit(state.copyWith(media: [...state.media, ...newMediaList]));
    }
  }

  FutureOr<void> _pickDeleteMediaEvent(
    PickDeleteMediaEvent event,
    Emitter<FotosVideosState> emit,
  ) {
    final nuevasTipoMedia = List<TipoMedia>.from(state.media);
    // Eliminamos el archivo según el índice
    nuevasTipoMedia.removeAt(event.index);
    emit(state.copyWith(media: nuevasTipoMedia));
  }

  Future<void> _sendPickEvent(
    SendPickEvent event,
    Emitter<FotosVideosState> emit,
  ) async {
    emit(state.copyWith(status: FotosVideosStatus.loading));

    final maps = List<TipoMedia>.from(state.media);
    final List<Fotosvideos> fotosvideos = List.generate(maps.length, (index) {
      return Fotosvideos(
        guid: Uuid().v4(),
        idusuario: event.idUsuario,
        idemergencia: event.idEmergencia,
        tipotiempoestado: event.sTipoTiempo,
        fechahoraregistro: DateTime.now(),
        media: maps[index].file ?? Uint8List(0),
        tipoarchivo: maps[index].tipo,
        synced: 0,
      );
    });

    final result = await _fotosvideosRepository.batchInsertFotosvideos(
      fotosvideos,
    );
    if (result.success) {
      emit(
        state.copyWith(
          status: FotosVideosStatus.success,
          message: 'Grabado Exitosamente',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FotosVideosStatus.error,
          message: result.message,
          errorCode: result.code,
        ),
      );
    }
  }

  Future<void> _getPickEvent(
    GetPickEvent event,
    Emitter<FotosVideosState> emit,
  ) async {
    emit(state.copyWith(status: FotosVideosStatus.loading));
    List<Fotosvideos> lstMedia = await _fotosvideosRepository.getAllFotosVideos(
      event.idEmergencia,
      event.idUsuario,
    );
    final List<TipoMedia> mediaList = lstMedia
        .map(
          (fotoVideo) =>
              TipoMedia(tipo: fotoVideo.tipoarchivo, file: fotoVideo.media),
        )
        .toList();
    emit(
      state.copyWith(
        media: mediaList,
        status: FotosVideosStatus.success,
        message: 'Cargado Exitosamente',
      ),
    );
  }
}

Future<Uint8List> convertXFileToBytes(XFile xFile) async {
  final Uint8List bytes = await xFile.readAsBytes();
  return bytes;
}

/*
      final List<TipoMedia> photos = selectedMedia
          .map((xfile) => TipoMedia(tipo: 'imagen', file: xfile))
          .toList();
  */
