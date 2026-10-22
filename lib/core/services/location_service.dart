import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

import '../network/network_exceptions.dart';
import '../utils/locale_keys.dart';

class LocationFix {
  const LocationFix({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.isMock,
  });

  final double lat;
  final double lng;
  final double accuracy;
  final bool isMock;
}

class LocationService {
  Future<LocationFix> currentFix() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw NetworkException(LocaleKeys.attendance_locationDisabled.tr());
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw NetworkException(LocaleKeys.attendance_locationDeniedForever.tr());
    }
    if (permission == LocationPermission.denied) {
      throw NetworkException(LocaleKeys.attendance_locationDenied.tr());
    }
    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (_) {
      throw NetworkException(LocaleKeys.attendance_locationFailed.tr());
    }
    // if (position.isMocked) {
    //   throw NetworkException(LocaleKeys.attendance_mockLocation.tr());
    // }
    return LocationFix(
      lat: position.latitude,
      lng: position.longitude,
      accuracy: position.accuracy,
      isMock: false,
      // isMock: position.isMocked,
    );
  }

  Future<void> openSettings() => Geolocator.openAppSettings();
}
