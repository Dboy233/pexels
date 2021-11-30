
import 'dart:math';

import 'package:flutter/material.dart';

///如果 传入[width]则返回缩放后的height高度
///如果 传入[height]则返回缩放后的width宽度
double zoom(int orgWidth, int orgHeight, {double width = 0, double height = 0}) {
  if (width == 0 && height == 0) {
    throw Exception("width 和 height必须有一个");
  }
  if (width != 0) {
    return (width/orgWidth) * orgHeight;
  }
  if (height != 0) {
    return (height/orgHeight) * orgWidth;
  }
  return 0;
}


Color randomColor(){
  var random = Random();
  int r=  random.nextInt(255);
  int g=  random.nextInt(255);
  int b=  random.nextInt(255);
  int a= random.nextInt(100);
  return Color.fromARGB(a, r, g, b);
}