import 'package:flutter/material.dart';
import 'package:flutter_weather/models/WeatherData.dart';
import 'package:intl/intl.dart';

class WeatherItem extends StatelessWidget {

  final WeatherData weather;

  const WeatherItem({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weather.name, style: TextStyle(color: Colors.red)),
            Text(weather.condition, style: TextStyle(color: Colors.black, fontSize: 32.0)),
            Text('${weather.temp_c.ceil()+5}°', style: TextStyle(color: Colors.black)),
            Image.network(weather.icon),
            Text(DateFormat.yMMMd().format(weather.date), style: TextStyle(color: Colors.black)),
            Text(DateFormat.Hm().format(weather.date), style: TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
  }
}
