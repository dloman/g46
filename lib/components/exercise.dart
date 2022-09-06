import 'package:flutter/material.dart';

class TimeBlock{
  final int mWorkTimeMilliseconds;
  final int mRestTimeMilliseconds;

  TimeBlock(this.mWorkTimeMilliseconds, this.mRestTimeMilliseconds);

  int getTime(int stopwatchTimeElapsed) {
    int time = mWorkTimeMilliseconds - stopwatchTimeElapsed;

    if (time < 0)
    {
      time = mWorkTimeMilliseconds + mRestTimeMilliseconds - stopwatchTimeElapsed;
    }
    return time;
  }

  TextStyle getStyle(int stopwatchTimeElapsed) {
    var textColor = stopwatchTimeElapsed < mWorkTimeMilliseconds ? Colors.blue : Colors.red;
    return TextStyle(fontSize: 50, backgroundColor: textColor);
  }
}
