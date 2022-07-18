import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/api_status.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class WeatherViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _onError = false;

  WeatherModel _weather = WeatherModel();

  WeatherViewModel() {
    getWeather();
  }

  bool get loading => _loading;
  bool get onError => _onError;
  WeatherModel get weather => _weather;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setError(bool error) async {
    _onError = error;
    notifyListeners();
  }

  setWeather(WeatherModel weather) async {
    _weather = weather;
    notifyListeners();
  }

  getWeather() async {
    setLoading(true);
    final checkPermission = await _determinePosition();
    Position? position;
    if (checkPermission == true) {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).timeout(const Duration(seconds: 5),
          onTimeout: () => const Position(
              longitude: 0.0,
              latitude: 0.0,
              timestamp: null,
              accuracy: 0.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0));
    } else {
      position = null;
    }
    if (position != null) {
      final response = await WeatherService.getWeather(
          position.latitude, position.longitude);
      if (response is Success) {
        setError(false);
        setWeather(response.response as WeatherModel);
      }
      if (response is Failure) {
        setError(true);
      }
    } else {
      setError(true);
    }
    setLoading(false);
  }

  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
