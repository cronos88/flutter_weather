import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/models/ForecastData.dart';
import 'package:flutter_weather/widgets/ForecastItem.dart';

import 'package:flutter_weather/widgets/Weather.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_weather/models/WeatherData.dart';

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  Location _location = Location(); //Location
  String error; //location
  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Arreglar el home
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: weatherData != null
            ? CircularProgressIndicator()
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                Text('No Network'),
                RaisedButton(
                  child: Text('Sin red'),
                  onPressed: loadWeather,
                )
              ],
            ),
      );
    } else {
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

            //Aqui va el Forecast
            Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 200.0,
                  child: ListView.builder(
                      itemCount: forecastData.list.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => WeatherItem(
                          weather: forecastData.list.elementAt(index)))
                ),
              ),
            )
          ],
        ),
      );
    }
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

    if (location != null) {
      final lat = location['latitude'];
      final lon = location['longitude'];

      debugPrint(lat.toString());
      debugPrint(lon.toString());
      final weatherResponse = await http.get(
          'http://api.apixu.com/v1/current.json?key=c835bd34c7e44586ac843135181612&q=${lat.toString()},${lon.toString()}&lang=es');
      final forecastResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=aa0bc262dc7cb866eda2d2ebb175b494&lat=${lat.toString()}&lon=${lon.toString()}');

      print(weatherResponse.statusCode);
      print(forecastResponse.statusCode);

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData =
              ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;
        });
      } else {
        print('Error');
      }
      print(weatherData);
      print(forecastData);
    } else {
      print('No hay datos');
    }

    setState(() {
      isLoading = false;
    });
  }
}
