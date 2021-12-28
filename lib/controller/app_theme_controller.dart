import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController {
  /*
  *
  * Returns true if it's dark theme, returns false if it's white theme
  *
   */
  static Future<bool> getSavedAppTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('app_theme') == null) {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      saveAppTheme(brightness == Brightness.dark);
      return brightness == Brightness.dark;
    } else {
      return prefs.getBool('app_theme');
    }
  }

  /*
  *
  * Saves to shared prefs the user's selection of theme
  *
   */
  static void saveAppTheme(bool newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('app_theme', newTheme);
  }
}

// NO context needed, you can use it in initState:
//
// var brightness = SchedulerBinding.instance.window.platformBrightness;
// bool darkModeOn = brightness == Brightness.dark;
// context is needed:
//
// var brightness = MediaQuery.of(context).platformBrightness;
// bool darkModeOn = brightness == Brightness.dark;
