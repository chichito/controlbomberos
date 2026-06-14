part of 'fotosvideos_bloc.dart';

class FotosvideosState {
  final List<XFile> images;

  FotosvideosState({required this.images});

  FotosvideosState copyWith({List<XFile>? images}) {
    return FotosvideosState(images: images ?? this.images);
  }
}
