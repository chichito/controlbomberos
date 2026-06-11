part of 'tiempos_bloc.dart';

class TiemposState {}

class TiemposInitial extends TiemposState {}

class TiemposLoaded extends TiemposState {
  final Tiempo? tiempos;
  TiemposLoaded({this.tiempos});

  TiemposLoaded copyWith({Tiempo? tiempos}) {
    return TiemposLoaded(tiempos: tiempos ?? this.tiempos);
  }
}

class TiemposFailed extends TiemposState {}
