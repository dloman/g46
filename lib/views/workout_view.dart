import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../states/workout_state.dart';
import '../colors.dart';

class WorkoutView extends WorkoutState {
  TextEditingController _workController = TextEditingController();
  TextEditingController _restController = TextEditingController();
  TextEditingController _repeatController = TextEditingController();
  TextEditingController _numPeopleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(text: "40");
    _restController = TextEditingController(text: "20");
    _repeatController = TextEditingController(text: "1");
    _textController = TextEditingController(text: "Pushups1 \nSitups \nPooping your Pants");
    _numPeopleController = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    _workController.dispose();
    _restController.dispose();
    _repeatController.dispose();
    _textController.dispose();
    _numPeopleController.dispose();
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
                child: const Icon(Icons.fitness_center),
                tooltip: 'New Workout',
                heroTag: null,
              ),),),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: start,
              heroTag: null,
              child: const Icon(Icons.play_circle),
              tooltip: 'Play',
            ),
          ),
        ],
      ),
      );
  }

   Center _GetPortrait() {
    List<String> items = getDisplayText();

    print("!!!! " + items.join("\n"));

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
        ]
      )
    );
  }

   void _newWorkout(BuildContext context) {
     Widget cancelButton = TextButton(
       child: Text("Cancel"),
       onPressed:  () { Navigator.of(context).pop(); },
     );
     Widget continueButton = TextButton(
       child: Text("Continue"),
       onPressed:  () {
         setWorkout(
           int.parse(_workController.text),
           int.parse(_restController.text),
           int.parse(_repeatController.text),
           _textController.text.split("\n"),
           int.parse(_numPeopleController.text));
         Navigator.of(context).pop();
       },
     );

     // set up the AlertDialog
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
               hintText: 'Enter number of sets',
             ),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[
               FilteringTextInputFormatter.digitsOnly,
             ],
             autofocus: true,
             controller: _repeatController,
           ),
           TextField(
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'Enter exercises',
             ),
             keyboardType: TextInputType.multiline,
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
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
}
  Color _getColor(int index) {
    final List<Color> colors = [Colors.amber, Colors.blue, Colors.green, Colors.orange];

    return colors[index % colors.length];
  }
}
