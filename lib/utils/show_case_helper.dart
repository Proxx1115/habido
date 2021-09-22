import 'package:flutter/material.dart';

class ShowcaseKeyName {
  static const addHabit = 'addHabit';
  static const psyTest = 'psyTest';
  static const assistant = 'assistant';
  static const content = 'content';
  static const profile = 'profile';
  static const calendar = 'calendar';
  static const notification = 'notification';
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

  static GlobalKey? getKeyByName(String? keyName) {
    if (keyName == null) return null;

    switch (keyName) {
      case ShowcaseKeyName.addHabit:
        return addHabit;
      case ShowcaseKeyName.psyTest:
        return psyTest;
      case ShowcaseKeyName.assistant:
        return assistant;
      case ShowcaseKeyName.profile:
        return profile;
      case ShowcaseKeyName.calendar:
        return calendar;
      case ShowcaseKeyName.notification:
        return notification;
      case ShowcaseKeyName.slidable:
        return slidable;
      case ShowcaseKeyName.habitCategory:
        return habitCategory;
      case ShowcaseKeyName.habit:
        return habit;
      case ShowcaseKeyName.userHabit:
        return userHabit;
      case ShowcaseKeyName.timer:
        return timer;
      default:
        return null;
    }
  }
}
