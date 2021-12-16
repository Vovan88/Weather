import 'package:flutter/material.dart';
import 'package:weather/data/data.dart';

import 'package:weather/bloc/mainbloc.dart';
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
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

                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(
                                      dataWheather: dataWheather,
                                      title: textController.text,
                                    )),
                          );
                        });
                      }
                      if (snapshotData.hasError) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(
                                      dataWheather: null,
                                      title: textController.text,
                                    )),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(snapshotData.error.toString())));
                        });
                      }
                      break;
                    case ConnectionState.done:
                      break;
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
