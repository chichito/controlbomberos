part of 'gps_bloc.dart';

enum StatusGps { initial, loading, success, error, empty }

class GpsState {
  final StatusGps statusGps;
  final bool isGpsEnabled;
  final bool isLocationPermissionsGranted;

  GpsState({
    this.isGpsEnabled = false,
    this.isLocationPermissionsGranted = false,
    this.statusGps = StatusGps.initial,
  });

  /// Returns whether is all enable with the gps and Permissions
  bool get isAllEnable => isGpsEnabled && isLocationPermissionsGranted;

  // copyWith

  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isLocationPermissionsGranted,
    StatusGps? statusGps,
  }) {
    return GpsState(
      // isGpsEnabled: isGpsEnable1 != null ? isGpsEnabled1! : this.isGpsEnabled,
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isLocationPermissionsGranted:
          isLocationPermissionsGranted ?? this.isLocationPermissionsGranted,
      statusGps: statusGps ?? this.statusGps,
    );
  }
}
