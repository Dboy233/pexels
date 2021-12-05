// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';


class Anim {
 ///单例模式
 Anim._internal();

 ///单例模式
 static Anim? _instance;

 ///单例模式
 factory Anim() => _getInstance();

 ///单例模式
 static Anim get instance => _getInstance();

 ///单例模式
 static Anim _getInstance(){
     _instance ??= Anim._internal();
     return _instance!;
 }

}

void main() {
 var anim1 = Anim();

 var anim2 = Anim.instance;

 print("anim1 ${anim1.hashCode} anim2 ${anim2.hashCode}");

 print("anim1 ${anim1 == anim2?"等于":"不等于"} anim2");

}

