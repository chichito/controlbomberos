part of 'fotosvideos_bloc.dart';

class FotosVideosEvent {}

class PickImagesFromCameraEvent extends FotosVideosEvent {}

class PickVideosFromCameraEvent extends FotosVideosEvent {}

class PickMultipleMediaFromGalleryEvent extends FotosVideosEvent {}

class PickDeleteMediaEvent extends FotosVideosEvent {
  final int index;

  PickDeleteMediaEvent({required this.index});
}

class SendPickEvent extends FotosVideosEvent {
  final String idEmergencia;
  final String idUsuario;
  final String sTipoTiempo;

  SendPickEvent({
    required this.idEmergencia,
    required this.idUsuario,
    required this.sTipoTiempo,
  });
}

class GetPickEvent extends FotosVideosEvent {
  final String idUsuario;
  final String idEmergencia;

  GetPickEvent({required this.idUsuario, required this.idEmergencia});
}
