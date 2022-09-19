import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../states/workout_state.dart';
import '../components/workout_group.dart';
import '../colors.dart';

class WorkoutView extends WorkoutState {
  TextEditingController _workController = TextEditingController();
  TextEditingController _restController = TextEditingController();
  TextEditingController _repeatExerciseController = TextEditingController();
  TextEditingController _repeatGroupController = TextEditingController();
  TextEditingController _numPeopleController = TextEditingController();
  TextEditingController _numGroupController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  TextEditingController _jsonController = TextEditingController();
  TextEditingController _waterBreakController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(text: "40");
    _restController = TextEditingController(text: "20");
    _repeatExerciseController = TextEditingController(text: "1");
    _repeatGroupController = TextEditingController(text: "1");
    _textController = TextEditingController(text: "Pushups1 \nSitups \nPooping your Pants");
    _numPeopleController = TextEditingController(text: "1");
    _waterBreakController = TextEditingController(text: "1");
    _numGroupController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    _workController.dispose();
    _restController.dispose();
    _repeatExerciseController.dispose();
    _repeatGroupController.dispose();
    _textController.dispose();
    _numPeopleController.dispose();
    _waterBreakController.dispose();
    _numGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait ? _GetPortrait() : _GetLandscape();
        }
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () { _newWorkout(context); },
                child: const Icon(Icons.work),
                tooltip: 'New Workout with Wizard',
                heroTag: null,
              ),),),
          Padding(padding: EdgeInsets.only(left:91),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () { _newWorkoutFromJson(context); },
                child: const Icon(Icons.fitness_center),
                tooltip: 'New Workout From Json',
                heroTag: null,
              ),),),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _toggleStartStop,
              heroTag: null,
              child: _getStartStopIcon(),
              tooltip: 'Play',
            ),
          ),
        ],
      ),
      );
  }

   Center _GetPortrait() {
    List<String> items = getDisplayText();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
            Text(
              getDisplayTime(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: getStyle(),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      items[index],
                    ),
                  );
                },
              ),
            ),
        ]
      )
    );
  }


   Center _GetLandscape() {
    List<String> exercises = getDisplayText();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
            Text(
              getDisplayTime(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: getStyle(),
            ),

            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: exercises.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: _getColor(index),
                  child: Center(child: Text('${exercises[index]}')),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
            _getNext(),
        ]
      )
    );
  }

   void _newWorkout(BuildContext context) {
     stop();
     Widget cancelButton = TextButton(
       child: Text("Cancel"),
       onPressed:  () { Navigator.of(context).pop(); },
     );
     Widget continueButton = TextButton(
       child: Text("Continue"),
       onPressed:  () async {
           resetWorkout();
           for (var i = 0; i < int.parse(_numGroupController.text); i++) {
             await _newWorkoutGroup(context, i+1);
           }
           Navigator.of(context).pop();
       },
     );

     // set up the workoutgroupDialog
     AlertDialog alert = AlertDialog(
       title: Text("Create Workout"),
       content: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         //position
         mainAxisSize: MainAxisSize.min,
         // wrap content in flutter
         children: <Widget>[
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter number of workout groups',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _numGroupController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter number of People working out',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _numPeopleController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter Waterbreak Duration',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _waterBreakController,
           ),
         ],
       ),
       actions: [
         cancelButton,
         continueButton,
       ],
     );

     // show the dialog
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
   }

   void _newWorkoutFromJson(BuildContext context) {
     stop();
     Widget cancelButton = TextButton(
       child: Text("Cancel"),
       onPressed:  () { Navigator.of(context).pop(); },
     );
     Widget continueButton = TextButton(
       child: Text("Continue"),
       onPressed:  () {
         fromJson(jsonDecode(_jsonController.text));
         Navigator.of(context).pop();
       },
     );

     // set up the workoutDialog
     AlertDialog alert = AlertDialog(
       title: Text("Create Workout From Json"),
       content: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         //position
         mainAxisSize: MainAxisSize.min,
         // wrap content in flutter
         children: <Widget>[
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter json',
             ),
             keyboardType: TextInputType.multiline,
             scrollController: _scrollController,
             maxLines: null,
             autofocus: true,
             controller: _jsonController,
           ),
         ],
       ),
       actions: [
         cancelButton,
         continueButton,
       ],
     );

     // show the dialog
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
   }

   Future<dynamic> _newWorkoutGroup(BuildContext context, int num) async {
     Widget cancelButton = TextButton(
       child: Text("Cancel"),
       onPressed:  () { Navigator.of(context).pop(); },
     );
     Widget continueButton = TextButton(
       child: Text("Add to workout"),
       onPressed:  () {
         addToWorkout(
           WorkoutGroup.fromSame(
             int.parse(_workController.text),
             int.parse(_restController.text),
             int.parse(_repeatExerciseController.text),
             int.parse(_repeatGroupController.text),
             _textController.text.split("\n"),
             int.parse(_waterBreakController.text)),
           int.parse(_numPeopleController.text));
         Navigator.of(context).pop();
       },
     );

     // set up the workoutgroupDialog
     AlertDialog alert = AlertDialog(
       title: Text("Create Workout Group #" + num.toString()),
       content: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         //position
         mainAxisSize: MainAxisSize.min,
         // wrap content in flutter
         children: <Widget>[
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter workout time',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _workController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter rest time',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _restController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter Number of Sets per Exercise',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _repeatExerciseController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter Number of Times to Repeat Group',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _repeatGroupController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter exercises',
             ),
             keyboardType: TextInputType.multiline,
             scrollController: _scrollController,
             maxLines: null,
             autofocus: true,
             controller: _textController,
           ),
         ],
       ),
       actions: [
         cancelButton,
         continueButton,
       ],
     );

     // show the dialog
     return showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
}
  Color _getColor(int index) {
    final List<Color> colors = [Colors.amber, Colors.blue, Colors.green, Colors.orange, Colors.lime, Colors.pink, Colors.cyan];

    return colors[index % colors.length];
  }

  Container _getNext() {
    var next = getNextExerciseName();

    if (next != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        height: 50,
        color: Colors.grey,
        child: Center(child: Text(next as String)),
      );
    }
    return Container();
  }

  void _toggleStartStop() {
    if (mIsRunning) {
      stop();
      return;
    }
    start();

  }

 Icon _getStartStopIcon() {
   if (mIsRunning) {
     return Icon(Icons.stop_circle);
  }
   return Icon(Icons.play_circle);
 }
}
