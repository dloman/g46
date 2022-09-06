import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/workout_screen.dart';
import '../components/workout_group.dart';

abstract class WorkoutState extends State<WorkoutScreen> {
  @protected
  Stopwatch mStopwatch = new Stopwatch();
  Timer? mRefreshTimer;

  Duration mRefreshTickDuration = new Duration(milliseconds: 30);
  int mNumberOfPeopleDoingWorkout = 1;
  int mCurrentTimeMilliseconds = 0;
  TextStyle mCurrentStyle = TextStyle(fontWeight: FontWeight.bold);

  List<WorkoutGroup> mWorkoutGroups = [];

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
    mStopwatch.stop();
    mRefreshTimer = null;
    setState(() {
      mIsRunning = false;
    });
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
  void resetWorkout() {
    setState(() {
      mWorkoutGroups = [];
    });
  }

  @protected
  void addToWorkout(WorkoutGroup group, int numberOfPeopleDoingWorkout) {
    setState(() {
      mNumberOfPeopleDoingWorkout = numberOfPeopleDoingWorkout;
      mWorkoutGroups.add(group);
    });
  }

  void _refreshTick(Timer time) {
    if (mWorkoutGroups.length == 0) {
      return;
    }

    setState(() {
      mCurrentTimeMilliseconds = mWorkoutGroups.first.getTime(mStopwatch.elapsedMilliseconds);
      mCurrentStyle = mWorkoutGroups.first.getStyle(mStopwatch.elapsedMilliseconds);

      if (mCurrentTimeMilliseconds < 0) {
        horn();

        mWorkoutGroups.first.pop();
        if (mWorkoutGroups.first.isEmpty())
        {
          mWorkoutGroups.removeAt(0);
        }
        reset();
      }

    });
  }

  String getDisplayTime() {
    return (mCurrentTimeMilliseconds ~/ 1000).toString();
  }

  List<String> getDisplayText() {
    List<String> text = [];
    if (mWorkoutGroups.length > 0) {
      text = mWorkoutGroups.first.getDisplayText(mNumberOfPeopleDoingWorkout);
    }
    return text;
  }

  TextStyle getStyle() {
    return mCurrentStyle;
  }

  void horn() {
  }
}
