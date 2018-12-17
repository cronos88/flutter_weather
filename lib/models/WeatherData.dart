class WeatherData {
  final DateTime date;
  final String name;
  final String country;
  final double temp_c;
  final double feelslike_c;
  final double pressure_mb;
  final int humidity;
  final double wind_kph;
  final String direction;
  final String condition;
  final String icon;
  final double uv;
  final int is_day;


  WeatherData({this.date, this.name, this.country, this.temp_c, this.feelslike_c,
      this.pressure_mb, this.humidity, this.wind_kph, this.direction,
      this.condition, this.icon, this.uv, this.is_day});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['location']['localtime_epoch'] * 1000, isUtc: false),
      name: json['location']['name'],
      country: json['location']['country'],
      temp_c: json['current']['temp_c'],
      feelslike_c: json['current']['feelslike_c'],
      pressure_mb: json['current']['pressure_mb'],
      humidity: json['current']['humidity'],
      wind_kph: json['current']['wind_kph'],
      direction: json['current']['wind_dir'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      is_day: json['current']['is_day'],
      uv: json['current']['uv']
    );
  }
}