import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather/constants.dart';
import 'package:weather/data.dart';

class MainBloc {
  static StreamController<DataWheather> streamController =
      StreamController<DataWheather>();

  Future getData(String town) async {
    try {
      http.Response response = await http
          .get(Uri.parse("https://" + url + town + "&appid=" + apikey));

      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, dynamic> mapData = jsonDecode(data);

        DataWheather dataWheather = DataWheather.fromJson(mapData);

        streamController.sink.add(dataWheather);
      }
    } on SocketException catch (_) {
      return null;
    }
  }
}
