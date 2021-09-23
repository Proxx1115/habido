import 'package:flutter/material.dart';

class ShowcaseKeyName {
  static const dashboard = 'dashboard';
  static const slidable = 'slidable';
  static const habitCategory = 'habitCategory';
  static const habit = 'habit';
  static const userHabit = 'userHabit';
  static const timer = 'timer';
}

class ShowcaseKey {
  static final addHabit = GlobalKey();
  static final psyTest = GlobalKey();
  static final assistant = GlobalKey();
  static final content = GlobalKey();
  static final profile = GlobalKey();
  static final calendar = GlobalKey();
  static final notification = GlobalKey();
  static final slidable = GlobalKey();
  static final habitCategory = GlobalKey();
  static final habit = GlobalKey();
  static final userHabit = GlobalKey();
  static final timer = GlobalKey();

  static List<GlobalKey> getKeysByName(String? keyName) {
    switch (keyName) {
      case ShowcaseKeyName.dashboard:
        return [addHabit, psyTest, assistant, content, profile, calendar, notification];
      case ShowcaseKeyName.slidable:
        return [slidable];
      case ShowcaseKeyName.habitCategory:
        return [habitCategory];
      case ShowcaseKeyName.habit:
        return [habit];
      case ShowcaseKeyName.userHabit:
        return [userHabit];
      case ShowcaseKeyName.timer:
        return [timer];
      default:
        return [];
    }
  }
}
