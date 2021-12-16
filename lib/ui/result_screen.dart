import 'package:flutter/material.dart';
import 'package:weather/data.dart';

class ResultPage extends StatefulWidget {
  final DataWheather dataWheather;
  final String title;
  const ResultPage({Key? key, required this.title, required this.dataWheather}) : super(key: key);
 

  

  @override
  State<ResultPage> createState() => ResultPageState();
}


class ResultPageState extends State<ResultPage> {
  var snackBar = const SnackBar(content: Text('Error'));
  

  @override
  Widget build(BuildContext context) {
     String plus = "";

      int temperature = (widget.dataWheather.temp - 273.15).round();
 if (temperature > 0) {
                          plus = "+";
                        }



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
                  child:  
                    
              ],
            ),
          ),
          Center(       
                    child:   
                          Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.dataWheather.name,
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
                      
          ),
          Positioned(
              right: 20,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                     
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
