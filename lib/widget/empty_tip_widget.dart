import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmptyTipWidget extends StatelessWidget {
  final String tip;

  //高度百分比,与屏幕的高度进行百分比大小，最小不能==0，最大不能超过1
  final double heightPercent;

  //高度计算是否按百分比
  final bool isPercent;

  /// 具体高度
  final double height;

  const EmptyTipWidget(
      {Key? key,
      required this.tip,
      this.isPercent = true,
      this.heightPercent = 0.5,
      this.height = double.infinity})
      : assert(heightPercent != 0 || heightPercent <= 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isPercent ? Get.height * heightPercent : double.infinity,
      child: Center(
        child: Text(
          tip,
          style: TextStyle(
              fontSize: 60.sp,
              color: Colors.black54,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
