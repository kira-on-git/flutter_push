import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter_push',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = ""; //content of the show window with milliseconds
  GameState gameState =
      GameState.readyToStart; //default state of our "START" button
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D), // Д/З#1-1
      body: Stack(children: [
        // Верхний текстовый виджет
        Align(
          alignment: const Alignment(0, -0.8), // Д/З#3-6
          child: Text(
            'Test your\nreaction speed',
            textAlign: TextAlign.center,
            // Д/З#1-2 Равнение самого текста по центру виджета
            style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white), //Д/З#1-2
          ),
        ),
        // Центральный элемент
        Align(
          alignment: Alignment.center,
          child: ColoredBox(
            color: Color(0xFF6D6D6D), //Д/З#1-3
            child: SizedBox(
              width: 300,
              height: 160,
              child: Center(
                child: Text(
                  millisecondsText,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white), //Д/З#2-4
                ),
              ),
            ),
          ),
        ),


        Align(
          alignment: Alignment(0, 0.8), // Д/З#3-6
          child: GestureDetector(
            onTap: ()=> setState(() {
              switch (gameState) {
                case GameState.readyToStart: // "START" 0xFF40CA88
                  gameState = GameState.waiting; // button name "WAIT"
                  millisecondsText = "";
                  _startWaitingTimer(); //our Timer starts
                  break;
                case GameState.waiting: // "WAIT" 0xFFE0982D

                //gameState = GameState.canBeStopped; // button name "STOP"
                  break;
                case GameState.canBeStopped: // "STOP" 0xFFE02D47

                  gameState = GameState.readyToStart; // button name "START"
                  stoppableTimer?.cancel(); //stop the timer
                  break;
              }
            }),
            child: ColoredBox(
              color: Color(_getButtonColor()), // Д/З #3-7
              child: SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    _getButtonText(),
                    //title of the button, default is GameState.readyToStart="START"
                    style: TextStyle(
                        fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }


  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      // in $randomMilliseconds seconds our state changed to canBeStopped = "STOP"
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer(); //почему это метод стоит именно здесь?
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

// reset the value on the show-window
  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  // Д/З #3-7
  int _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return 0xFF40CA88;
      case GameState.waiting:
        return 0xFFE0982D;
      case GameState.canBeStopped:
        return 0xFFE02D47;
    }
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }
}
enum GameState { readyToStart, waiting, canBeStopped }
