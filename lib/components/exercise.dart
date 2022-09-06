import 'package:flutter/material.dart';

class Exercise{
  final int mWorkTimeMilliseconds;
  final int mRestTimeMilliseconds;
  final int mStartIndex;

  Exercise(this.mWorkTimeMilliseconds, this.mRestTimeMilliseconds, this.mStartIndex);

  int getTime(int stopwatchTimeElapsed) {
    int time = mWorkTimeMilliseconds - stopwatchTimeElapsed;

    if (time < 0)
    {
      time = mWorkTimeMilliseconds + mRestTimeMilliseconds - stopwatchTimeElapsed;
    }
    return time;
  }

  TextStyle getStyle(int stopwatchTimeElapsed) {
    var textColor = stopwatchTimeElapsed < mWorkTimeMilliseconds ? Colors.green : Colors.red;
    return TextStyle(fontSize: 50, backgroundColor: textColor);
  }
}
