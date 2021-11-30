// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

void main() {
  var random = Random();
 int r=  random.nextInt(255);
 int g=  random.nextInt(255);
 int b=  random.nextInt(255);
 int a= random.nextInt(255);
  print(" r$r g$g b$b a$a");
}

