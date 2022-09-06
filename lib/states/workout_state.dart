import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/workout_screen.dart';
import '../components/exercise.dart';

abstract class WorkoutState extends State<WorkoutScreen> {
  @protected
  Stopwatch mStopwatch = new Stopwatch();
  Timer? mRefreshTimer;

  Duration mRefreshTickDuration = new Duration(milliseconds: 30);
  int mNumberOfPeopleDoingWorkout = 1;
  int mCurrentTimeMilliseconds = 0;
  TextStyle mCurrentStyle = TextStyle(fontWeight: FontWeight.bold);

  List<TimeBlock> mExercises = [];
  List<String> mExerciseNames = [];
  int mTimeRemaining = 0;

  bool mIsRunning = false;

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  @protected
  void start() {

    reset();
    mRefreshTimer = new Timer.periodic(mRefreshTickDuration, _refreshTick);
    mStopwatch.start();

    setState(() {
      mIsRunning = true;
    });
    HapticFeedback.selectionClick();
  }

  @protected
  void stop() {
    setState(() {
      mIsRunning = false;
    });
    mStopwatch.stop();
    HapticFeedback.selectionClick();
  }

  @protected
  void reset() {
    setState(() {
      mStopwatch = new Stopwatch();

      if (mIsRunning) {
        mStopwatch.start();
      }
    });
  }

  @protected
  void setWorkout(int workValueMilliseconds, int restValueMilliseconds, int numberOfSets, List<String> exercises, int numberOfPeopleDoingWorkout) {
    setState(() {
      mNumberOfPeopleDoingWorkout = numberOfPeopleDoingWorkout;
      mExerciseNames = exercises;

      mExercises = [];
      for (var i = 0; i < numberOfSets; i++) {
        for (var j = 0; j < exercises.length; j++) {
          mExercises.add(TimeBlock(1000*workValueMilliseconds, 1000*restValueMilliseconds));
        }
      }
    });
  }

  void _refreshTick(Timer time) {
    if (mExercises.length == 0) {
      return;
    }

    setState(() {
      mCurrentTimeMilliseconds = mExercises.first.getTime(mStopwatch.elapsedMilliseconds);
      mCurrentStyle = mExercises.first.getStyle(mStopwatch.elapsedMilliseconds);

      if (mCurrentTimeMilliseconds < 0) {
        horn();

        mExercises.removeAt(0);
        reset();
      }

    });
  }

  String getDisplayTime() {
    return (mCurrentTimeMilliseconds ~/ 1000).toString();
  }

  List<String> getDisplayText() {
    List<String> text = [];
    if (mExercises.length == 0 || mExerciseNames.length == 0)
    {
      return text;
    }

    int startIndex = (mExercises.length % mExerciseNames.length);

    for (var i = 0; i < mNumberOfPeopleDoingWorkout; i++) {
      text.add(mExerciseNames[(startIndex + i) % mExerciseNames.length]);
    }
    return text;
  }

  TextStyle getStyle() {
    return mCurrentStyle;
  }

  void horn() {
  }
}
