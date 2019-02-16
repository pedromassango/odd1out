import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odd1out/challenge.dart';
import 'package:odd1out/games.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odd1Out!!',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int totalElements = 100;
  bool isGameRunning;
  Challenge challenge;
  var random = Random();

  generateGame(){
    print('generateGame');
    generated = false;
    isGameRunning = true;
    challenge = Games().getRandomChallenge();
  }


  bool generated = false;
  int lastOddPosition;
  String getGameItem(int index) {
    var r = random.nextInt(totalElements);
    var result = challenge.common;

    print('First IF> $index & $r');

    if (index == r && generated == false) {
      if(lastOddPosition == r) {
        return getGameItem(index);
      }
        result = challenge.odd;
      generated = true;
      lastOddPosition = r;
    } else if(index == totalElements-1 && generated == false){
      if(lastOddPosition == r) {
        return getGameItem(index);
      }
      result = challenge.odd;
      lastOddPosition = r;
      generated = true;
    }


    return result;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    generateGame();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
       child: Column(
         mainAxisSize: MainAxisSize.max,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           Text("Pick the Odd One Out!"),
           Spacer(),
           GridView.count(
             crossAxisCount: 10,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             children: List.generate(totalElements, (i){
               return Text(
                 getGameItem(i),
                 style: TextStyle(color: Colors.black,
                   fontSize: 32
                 ),
               );
             }),
           ),
           Spacer(),
           GestureDetector(
             onTap: (){
               setState(() {
                 generateGame();
               });
             },
               child: Text('Skip Round', style: TextStyle(color: Colors.deepOrange),)),
         ],
       ),
     ),
   );
  }
}
