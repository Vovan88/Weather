class DataWheather {
  final String name;
  final double temp;

  DataWheather(this.name, this.temp);

  DataWheather.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        temp = json['main']["temp"];
}
