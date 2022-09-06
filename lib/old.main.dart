import 'package:flutter/material.dart';

import 'countDownTimer.dart';
import 'states/workout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-46',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'G 46'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Workout _workout = Workout();

  void _timerExpired() {
    setState(() {
    });
  }

  void _resetTimer() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60.0,
              padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: 30,
                whenTimeExpires: () {
                  _timerExpired();
                },
                countDownTimerStyle: TextStyle(
                                       color: Color(0XFFf5a623),
                                       fontSize: 17.0,
                                       height: 1.2,
                                     ),
              ),
            )
          ],
        ),
      ),

      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: _resetTimer,
                child: const Icon(Icons.fitness_center),
                tooltip: 'New Workout',
                heroTag: null,
              ),),),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _resetTimer,
              heroTag: null,
              child: const Icon(Icons.play_circle),
              tooltip: 'Play',
            ),
          ),
        ],
      )
      );
  }
}
