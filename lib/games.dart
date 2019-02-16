
import 'dart:math';

import 'package:odd1out/challenge.dart';

class Games{

  var lastIndex = 0;
  final List<Challenge> games = [
    Challenge('0', 'O'),
    Challenge('B', 'D'),
    Challenge('I', 'L'),
    Challenge('B', '8'),
    Challenge('N', 'M'),
    Challenge('1', 'I'),
    Challenge('I', 'J'),
    Challenge('J', 'I'),
    Challenge('N', 'W'),
    Challenge('S', '5'),
    Challenge('8', 'B'),
    Challenge('O', 'Q'),
    Challenge('R', 'H'),
    Challenge('I', 'P'),
    Challenge('F', 'L'),
  ];

  Challenge getRandomChallenge(){
    var i = Random().nextInt(games.length);

    // prevent to generate the same game consecutively
    if(i == lastIndex){
      return getRandomChallenge();
    }

    lastIndex = i;
    return games.elementAt(i);
  }

}