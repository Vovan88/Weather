import 'package:flutter/material.dart';
import 'package:weather/data.dart';

import 'package:weather/mainbloc.dart';
import 'package:weather/ui/result_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();

  bool _isShowIndicator = false;
  String? currentTown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
                    controller: textController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        fillColor: Colors.amber,
                        focusColor: Colors.blueAccent,
                        hintText: "введите город",
                        hintStyle: TextStyle(
                          color: Colors.purple,
                          fontStyle: FontStyle.italic,
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        currentTown = textController.text;
                        MainBloc().getData(textController.text);
                        _isShowIndicator = true;
                      }
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          ),
          Center(
            child: StreamBuilder<DataWheather>(
                stream: MainBloc.streamController.stream,
                builder: (context, AsyncSnapshot<DataWheather> snapshotData) {
                  switch (snapshotData.connectionState) {
                    case ConnectionState.none:
                      break;
                    case ConnectionState.waiting:
                      return Visibility(
                          visible: _isShowIndicator,
                          child: const CircularProgressIndicator());

                    case ConnectionState.active:
                      if (snapshotData.hasData) {
                        DataWheather dataWheather = snapshotData.data!;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultPage(
                                    dataWheather: dataWheather,
                                    title: textController.text,
                                  )),
                        );

                        int temperature = (dataWheather.temp - 273.15).round();
                        String plus = "";

                        if (temperature > 0) {
                          plus = "+";
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dataWheather.name,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 30),
                            ),
                            Text(
                              plus + temperature.toString(),
                              style: TextStyle(
                                  color: temperature > 0
                                      ? Colors.red
                                      : Colors.blue,
                                  fontSize: 60),
                            ),
                          ],
                        );
                      }
                      break;
                    case ConnectionState.done:
                      break;
                  }
                  return Container();
                }),
          ),
          Positioned(
              right: 20,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    if (currentTown != null && currentTown!.isNotEmpty) {
                      MainBloc().getData(currentTown!);
                    }
                  },
                  icon: const Icon(
                    Icons.update_outlined,
                    color: Colors.blue,
                    size: 40,
                  )))
        ],
      ),
    );
  }
}
