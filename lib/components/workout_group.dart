import 'package:flutter/material.dart';
import 'exercise.dart';

class WorkoutGroup{
  List<Exercise> mExercises = [];
  List<String> mExerciseNames = [];
  int mWaterBreakTimeMilliseconds = 60000;
  bool mIsWaterBreak = false;

  WorkoutGroup(int workTimeSeconds, int restTimeSeconds, int numberOfSets, List<String> exercises, int waterBreakTimeSeconds) {
      mExerciseNames = exercises;
      mWaterBreakTimeMilliseconds = waterBreakTimeSeconds *1000;

      mExercises = [];
      for (var j = 0; j < exercises.length; j++) {
        for (var i = 0; i < numberOfSets; i++) {
          mExercises.add(Exercise(1000*workTimeSeconds, 1000*restTimeSeconds, j));
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
}

