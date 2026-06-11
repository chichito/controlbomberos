part of 'gps_bloc.dart';

class GpsEvent {}

class GpsInitialStatusEvent extends GpsEvent {}

class ChangeGpsStatusEvent extends GpsEvent {}

class AskLocationPermissionsEvent extends GpsEvent {}
