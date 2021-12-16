class DataWheather {
  final String name;
  final double temp;
  final double speedWind;
  DataWheather(this.name, this.temp, this.speedWind);

  DataWheather.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        temp = json['main']["temp"],
        speedWind = json['wind']["speed"];
}
