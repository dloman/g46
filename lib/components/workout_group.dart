import 'package:flutter/material.dart';
import 'exercise.dart';

class WorkoutGroup{
  List<Exercise> mExercises = [];
  List<String> mExerciseNames = [];

  WorkoutGroup(int workTimeMilliseconds, int restTimeMilliseconds, int numberOfSets, List<String> exercises) {
      mExerciseNames = exercises;

      mExercises = [];
      for (var i = 0; i < numberOfSets; i++) {
        for (var j = 0; j < exercises.length; j++) {
          mExercises.add(Exercise(1000*workTimeMilliseconds, 1000*restTimeMilliseconds));
        }
      }
  }



  List<String> getDisplayText(int numberOfPeopleDoingWorkout) {
    List<String> text = [];
    if (mExercises.length == 0 || mExerciseNames.length == 0)
    {
      return text;
    }

    int startIndex = mExerciseNames.length - (mExercises.length % mExerciseNames.length);

    for (var i = 0; i < numberOfPeopleDoingWorkout; i++) {
      text.add(mExerciseNames[(startIndex + i) % mExerciseNames.length]);
    }
    return text;
  }

  int getTime(int stopwatchTimeElapsed) {
    return mExercises.length == 0 ? 0 : mExercises.first.getTime(stopwatchTimeElapsed);
  }

  TextStyle getStyle(int stopwatchTimeElapsed) {
    return mExercises.length == 0 ? TextStyle() : mExercises.first.getStyle(stopwatchTimeElapsed);
  }

  void pop() {
    mExercises.removeAt(0);
  }

  bool isEmpty() {
    return mExercises.length == 0;
  }
}

