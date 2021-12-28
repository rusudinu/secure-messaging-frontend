import 'package:flutter/material.dart';

//REMOVES THE SCROLL OVERFLOW
class ScrollBehaviorNoOverflow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}