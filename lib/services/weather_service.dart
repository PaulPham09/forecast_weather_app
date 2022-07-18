import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/api_status.dart';
import 'package:weather_app/utils/constants.dart';

class WeatherService {
  static Future<Object> getWeather(double lat, double long) async {
    String FORECAST_WEATHER =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=670f49dc656610684467e63f03687475&units=metric';
    try {
      var response = await http.get(Uri.parse(FORECAST_WEATHER));

      if (response.statusCode == 200) {
        return Success(response: weatherModelFromJson(response.body));
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: 'Invalid Response');
    } on HttpException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERRORS, errorResponse: 'Unknown error');
    }
  }
}
