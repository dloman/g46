import 'package:flutter/material.dart';
import 'exercise.dart';

class WorkoutGroup{
  List<Exercise> mExercises = [];
  List<String> mExerciseNames = [];
  int mWaterBreakTimeMilliseconds = 60000;
  bool mIsWaterBreak = false;
  List<int> mWorkTimeMilliseconds = [60000];
  List<int> mRestTimeMilliseconds = [30000];
  int mNumberOfSets = 1;
  int mNumberOfTimesThrough = 1;

  WorkoutGroup(
    List<int> workTimeSeconds,
    List<int> restTimeSeconds,
    int numberOfSets,
    int numberOfTimesThrough,
    List<String> exercises,
    int waterBreakTimeSeconds) {
      if ((workTimeSeconds.length != numberOfTimesThrough) && (restTimeSeconds.length != numberOfTimesThrough)) {
        throw new FormatException("must be same length");
      }
      mExerciseNames = exercises;
      mWaterBreakTimeMilliseconds = waterBreakTimeSeconds *1000;
      mWorkTimeMilliseconds = workTimeSeconds.map((v) => v * 1000).toList();
      mRestTimeMilliseconds = restTimeSeconds.map((v) => v * 1000).toList();
      mNumberOfSets = numberOfSets;
      mNumberOfTimesThrough = numberOfTimesThrough;

      _fill_exercises();
  }

  factory WorkoutGroup.fromSame(
    int workTimeSeconds,
    int restTimeSeconds,
    int numberOfSets,
    int numberOfTimesThrough,
    List<String> exercises,
    int waterBreakTimeSeconds) {
    return WorkoutGroup(
      List<int>.filled(numberOfTimesThrough, workTimeSeconds),
      List<int>.filled(numberOfTimesThrough, restTimeSeconds),
      numberOfSets,
      numberOfTimesThrough,
      exercises,
      waterBreakTimeSeconds *1000);
  }

  void _fill_exercises() {
      mExercises = [];
      for (var k = 0; k < mNumberOfTimesThrough; k++) {
        for (var j = 0; j < mExerciseNames.length; j++) {
          for (var i = 0; i < mNumberOfSets; i++) {
            mExercises.add(Exercise(mWorkTimeMilliseconds[k], mRestTimeMilliseconds[k], j));
          }
        }
      }
  }



  List<String> getDisplayText(int numberOfPeopleDoingWorkout) {
    List<String> text = [];

    if (mIsWaterBreak) {
      return List<String>.filled(numberOfPeopleDoingWorkout, "Hydrate Bitches");
    }

    if (mExercises.length == 0 || mExerciseNames.length == 0) {
      return text;
    }

    int startIndex = mExercises.first.mStartIndex;

    for (var i = 0; i < numberOfPeopleDoingWorkout; i++) {
      text.add(mExerciseNames[(startIndex + i) % mExerciseNames.length]);
    }
    return text;
  }

  int getTime(int stopwatchTimeElapsed) {
    return mExercises.length == 0 ?
        mWaterBreakTimeMilliseconds - stopwatchTimeElapsed :
        mExercises.first.getTime(stopwatchTimeElapsed);
  }

  TextStyle getStyle(int stopwatchTimeElapsed) {
    return mExercises.length == 0 ?
       TextStyle(fontSize: 50, backgroundColor: Colors.blue) :
       mExercises.first.getStyle(stopwatchTimeElapsed);
  }

  void popExercise() {
    if (mExercises.length == 0 && mIsWaterBreak) {
      mIsWaterBreak = false;
      return;
    }

    mExercises.removeAt(0);
    if (mExercises.length == 0) {
      mIsWaterBreak = true;
    }
  }

  bool isEmpty() {
    return mExercises.length == 0 && !mIsWaterBreak;
  }

  String getNextExerciseName(int numberOfPeopleDoingWorkout) {
    if (mExercises.length < numberOfPeopleDoingWorkout + 1) {
      return "Water Break";
    }

    return mExerciseNames[mExercises[numberOfPeopleDoingWorkout].mStartIndex];
  }

  factory WorkoutGroup.fromJson(Map<String, dynamic> json, int waterBreakTimeSeconds) {
    try
    {
      return WorkoutGroup(
        List<int>.from(json['workTimeSeconds']),
        List<int>.from(json['restTimeSeconds']),
        json['numberOfSets'] as int,
        json['numberOfTimesThrough'] as int,
        List<String>.from(json['exercises']),
        waterBreakTimeSeconds);
    } catch (e){
      return WorkoutGroup.fromSame(
        json['workTimeSeconds'] as int,
        json['restTimeSeconds'] as int,
        json['numberOfSets'] as int,
        json['numberOfTimesThrough'] as int,
        List<String>.from(json['exercises']),
        waterBreakTimeSeconds);
    }
  }
}

