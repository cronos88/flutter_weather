import 'package:flutter/material.dart';
import 'package:flutter_weather/models/ForecastData.dart';
import 'package:flutter_weather/widgets/ForecastItem.dart';


class Forecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {

  bool isLoading = false;
  ForecastData forecastData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: 200.0,
          child: forecastData != null ? ListView.builder(
              itemCount: forecastData.list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index))
          ) : Container(
            child: Text('No hay datos'),
          ),
        ),
      ),
    );
  }
}
