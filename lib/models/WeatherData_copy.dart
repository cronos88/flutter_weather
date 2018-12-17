class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  final double tempMin;
  final double tempMax;
  final double pressure;
  final int humidity;
  final double wind;
  final double direction;
  final String main;
  final String icon;

  WeatherData({this.date, this.name, this.temp, this.tempMin, this.tempMax, this.pressure, this.humidity, this.wind, 
    this.direction, this.main, this.icon});
 
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false),
      name: json['name'],
      temp: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'],
      direction: json['wind']['deg'],
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}