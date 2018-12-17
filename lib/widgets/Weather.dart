import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather/models/WeatherData.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF))),
        padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        //color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        height: 350.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  weather.name,
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(weather.condition,
                    style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 22.0,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            Row(
              children: <Widget>[
                Text(DateFormat.yMMMd().format(weather.date) + ' - ',
                    style: TextStyle(color: Colors.white)),
                Text(DateFormat.Hm().format(weather.date),
                    style: TextStyle(color: Colors.white))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${weather.temp_c.ceil()}°C',
                        style: TextStyle(color: Colors.white, fontSize: 82.0)),
                    Text('Feels Like: ${weather.feelslike_c.ceil()}°C',
                      textAlign: TextAlign.start, style: TextStyle(color: Colors.white),),
                  ],
                ),
                Image.network('https:${weather.icon}', scale: 0.6,),
                /*Image.asset(
                  'assets/clouds_moon.png',
                  width: 100.0,
                  height: 100.0,
                  color: Colors.blue[300],
                )*/
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                        Text(
                          '${weather.pressure_mb}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Pressure',
                      style: TextStyle(color: Colors.grey[100]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.pin_drop, color: Colors.white),
                        Text(
                          '${weather.humidity}' + '%',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Humidity',
                      style: TextStyle(color: Colors.grey[100]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.flag,
                          color: Colors.white,
                        ),
                        Text(
                          '${weather.wind_kph}km/h',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Wind',
                      style: TextStyle(color: Colors.grey[100]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.grey[100],
                        ),
                        Text(
                          '${weather.direction}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      'Direction',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
// @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Text(weather.name, style: TextStyle(color: Colors.blueGrey)),
//         Text(weather.main, style: TextStyle(color: Colors.blueGrey, fontSize: 32.0)),
//         Text('${weather.temp.toString()}°F', style: TextStyle(color: Colors.blueGrey)),
//         Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
//         Text(DateFormat.yMMMd().format(weather.date), style: TextStyle(color: Colors.blueGrey)),
//         Text(DateFormat.Hm().format(weather.date), style: TextStyle(color: Colors.blueGrey))
//       ],
//     );
//   }
