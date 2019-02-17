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

  int points = 0;
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

  void restartGame(){
    points = 0;
    generateGame();
  }


  bool generated = false;
  int lastOddPosition;
  String getGameItem(int index) {
    var r = random.nextInt(totalElements);
    var result = challenge.common;

    if (index == r && generated == false) {
      if(lastOddPosition == r) {
        return getGameItem(index);
      }
        result = challenge.odd;
      generated = true;
      lastOddPosition = r;
    } else if(index == totalElements && generated == false){
      if(lastOddPosition == r) {
        return getGameItem(index);
      }
      result = challenge.odd;
      lastOddPosition = r;
      generated = true;
    }


    return result;
  }

  onItemClick(int i){
    if(i == lastOddPosition){
      // winner
      setState(() {
        points += 1;
        generateGame();
      });
    }else{
      // loser
      if(points == 0){
        showDialog(
            context: context,
          builder: (BuildContext context){
              return AlertDialog(
                title: Text('End of the Game :('),
                content: Text('You\'ve lost all your points, keep hitting to stay in the game!'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Close".toUpperCase())),
                  FlatButton(
                      onPressed: (){
                        setState(() {
                          Navigator.of(context).pop();
                          restartGame();
                        });
                      },
                      child: Text("RESTART"))
                ],
              );
          }
        );
        return;
      }

      setState(() {
        points -= 2;
        generateGame();
      });
    }
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
           Text("Pick the Odd One Out!\n ${points == 0 ? '': points}",
             textAlign: TextAlign.center,
             style: TextStyle(
             color: Colors.grey,
             fontSize: 18
           ),),
           Spacer(),
           GridView.count(
             crossAxisCount: 10,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             children: List.generate(totalElements, (i){
               return InkWell(
                 onTap: (){
                   onItemClick(i);
                 },
                 child: Center(
                   child: Text(
                     getGameItem(i),
                     style: TextStyle(color: Colors.black,
                       fontSize: 26
                     ),
                   ),
                 ),
               );
             }),
           ),
           Spacer(),
           GestureDetector(
               onTap: () {
                 setState(() {
                   generateGame();
                 });
               },
               child: Container(
                 height: 40,
                 width: 100,
                 child: Center(
                   child: Text(
                     'Skip Round', style: TextStyle(color: Colors.deepOrange),
                   ),
                 ),
               ),),
         ],
       ),
     ),
   );
  }
}
