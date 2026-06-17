part of 'fotosvideos_bloc.dart';

enum FotosVideosStatus { initial, loading, success, error, empty }

class FotosVideosState {
  final List<TipoMedia> media;
  final FotosVideosStatus status;
  final String? message;
  final ErrorCode? errorCode;

  FotosVideosState({
    required this.media,
    this.status = FotosVideosStatus.initial,
    this.message,
    this.errorCode,
  });

  FotosVideosState copyWith({
    List<TipoMedia>? media,
    FotosVideosStatus? status,
    String? message,
    ErrorCode? errorCode,
  }) {
    return FotosVideosState(
      media: media ?? this.media,
      status: status ?? this.status,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
