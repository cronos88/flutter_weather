import 'package:flutter/material.dart';
import 'package:flutter_weather/weather_app.dart';

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