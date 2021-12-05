import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/ui/main/logic.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({Key? key}) : super(key: key);

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  var logic = Get.find<MainLogic>();

  @override
  void initState() {
    logic.downloadState.listen((isShow) {
      if (!isShow) {
        Get.back();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 600.r,
          height: 500.r,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.r,
              ),
              Text(
                "正在下载",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 60.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 60.r,
              ),
              SizedBox(
                width: 80.r,
                height: 80.r,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(
                height: 35.r,
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  logic.cancelDownload();
                },
                child: Text(
                  "取消下载",
                  style: TextStyle(fontSize: 40.sp, color: Colors.red[200]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
