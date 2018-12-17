import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather/models/ForecastData.dart';
import 'package:flutter_weather/models/WeatherData.dart';
import 'package:flutter_weather/widgets/Weather.dart';
import 'package:flutter_weather/widgets/WeatherItem.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyWeatherApp(),
    );
  }
}

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {

  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  Location _location = Location(); //Location
  String error; //location


  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Arreglar el home
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: weatherData != null ? Weather(weather: weatherData) : Container(
                    child: Text('nooo'),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(0.0),
                //   child: isLoading ? CircularProgressIndicator(
                //     strokeWidth: 2.0,
                //     valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
                //   ) : IconButton(
                //     icon: Icon(Icons.refresh),
                //     tooltip: 'Refresh',
                //     onPressed: () => loadWeather,
                //     color: Colors.blueGrey,
                //   ),
                // ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 200.0,
                child: forecastData != null ? ListView.builder(
                    itemCount: forecastData.list.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
                ) : Container(),
              ),
            ),
          ),
        ],
      ),
    );
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
        error = 'Permission denied - please ask  the user to enable it from the app settings';
      }

      location = null;
    }

    if (location != null) {
      final lat = location['latitude'];
      final lon = location['longitude'];

      debugPrint(lat.toString());
      debugPrint(lon.toString());
      //final lat = 3.4219180;
      //final lon = -76.5038870;
      final weatherResponse = await http.get(
        'http://api.apixu.com/v1/current.json?key=c835bd34c7e44586ac843135181612&q=${lat.toString()},${lon.toString()}&lang=es'
      );
      final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=aa0bc262dc7cb866eda2d2ebb175b494&lat=${lat.toString()}&lon=${lon.toString()}'
      );
      
      print(weatherResponse.statusCode);
      print(forecastResponse.statusCode);

      if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData = ForecastData.fromJson(jsonDecode(forecastResponse.body));
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