import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import '../screens/workout_screen.dart';
import '../components/workout_group.dart';
import '../components/horn.dart';

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
    setState(() {
      mStopwatch.stop();
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
      stop();
      reset();
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
    assert(mIsRunning == mStopwatch.isRunning);
    if (mWorkoutGroups.length == 0) {
      return;
    }

    setState(() {
      mCurrentTimeMilliseconds = mWorkoutGroups.first.getTime(mStopwatch.elapsedMilliseconds);
      mCurrentStyle = mWorkoutGroups.first.getStyle(mStopwatch.elapsedMilliseconds);

      if (mCurrentTimeMilliseconds < 0) {
        horn();

        mWorkoutGroups.first.popExercise();
        if (mWorkoutGroups.first.isEmpty())
        {
          mWorkoutGroups.removeAt(0);
        }
        reset();
      }

    });
  }

  String getDisplayTime() {
    if (mCurrentTimeMilliseconds == 0 && mWorkoutGroups.length == 0) {
      return "Create a workout to begin";
    }
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


  String? getNextExerciseName() {
    if (mWorkoutGroups.length == 0) {
      return null;
    }
    return mWorkoutGroups.first.getNextExerciseName(mNumberOfPeopleDoingWorkout);
  }

  void fromJson(Map<String, dynamic> json) {
    resetWorkout();
    mNumberOfPeopleDoingWorkout = json['numberOfPeopleDoingWorkout'];
    mCurrentTimeMilliseconds = 0;
    int waterBreakTimeSeconds = json['waterBreakTimeSeconds'];
    mWorkoutGroups = List<WorkoutGroup>.from(json['workoutGroups'].map((json) => WorkoutGroup.fromJson(json, waterBreakTimeSeconds)));
  }
}
