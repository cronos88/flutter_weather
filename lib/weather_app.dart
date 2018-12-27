import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/models/ForecastData.dart';
import 'package:flutter_weather/widgets/ForecastItem.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter_weather/widgets/Weather.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_weather/models/WeatherData.dart';

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> with WidgetsBindingObserver {
  Location _location = Location(); //Location
  String error; //location
  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;
  Future<WeatherData> weatherInfo;
  Future<ForecastData> forecastInfo;


  _MyWeatherAppState({this.error, this.weatherData,
      this.forecastData, this.isLoading, this.weatherInfo, this.forecastInfo});

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  // Ciclo de vida de la app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        loadWeather();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: FutureBuilder<WeatherData>(
          future: weatherInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('snapshot: $snapshot');
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Weather(weather: weatherData)
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('No Network'),
                    RaisedButton(
                      child: Text('Intente de nuevo'),
                      onPressed: loadWeather,
                    )
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        )
      );
    }
  }

  Future<WeatherData> loadWeatherData(var location) async {
    print('Función loadWeatherData');
    print('location: $location');
    if (location != null) {
      final lat = location['latitude'];
      final lon = location['longitude'];

      final response = await http.get(
          'http://api.apixu.com/v1/current.json?key=c835bd34c7e44586ac843135181612&q=${lat
              .toString()},${lon.toString()}&lang=es');

      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }

    }

    setState(() {
      isLoading = false;
    });
  }

  Future<ForecastData> loadForecastData(var location) async {
    print('Función loadForecastData');
    if (location != null) {
      final lat = location['latitude'];
      final lon = location['longitude'];

      final forecastResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=aa0bc262dc7cb866eda2d2ebb175b494&lat=${lat
              .toString()}&lon=${lon.toString()}');

      if (forecastResponse.statusCode == 200) {
        return ForecastData.fromJson(json.decode(forecastResponse.body));
      } else {
        throw Exception('Failed to load Forecast Data');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  loadWeather() async {

    setState(() {
      isLoading = true;
    });

    Map<String, double> location;

    try {
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        'Permission denied - please ask  the user to enable it from the app settings';
      }

      location = null;
    }
    print("Mi Location: $location");
    loadWeatherData(location);
    loadForecastData(location);
  }
}