import 'package:flutter/material.dart';
import 'package:weather/data.dart';
import 'package:weather/mainbloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheather',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Wheather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                        int temperature = (dataWheather.temp - 273.15).round();
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
                              (dataWheather.temp - 273.15).round().toString(),
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
