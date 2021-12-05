import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:pexels/tools/scroll_direction.dart';
import 'package:pexels/widget/widget_download_dialog.dart';

import 'logic.dart';

///主页面架构
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final logic = Get.put(MainLogic());

  ///滚动方向检测器
  final _directionDetect = ScrollDirectionDetect();

  ///当前的滚动方向
  AxisDirection? _direction;

  ///改变UI状态，底部导航栏的可见可点击状态
  var _bottomNavigationState = true;

  @override
  void initState() {
    //监听
    logic.pexelsAuthState.listen(showSettingKeyDialog);
    //消息提示监听
    logic.msgTip.listen(showMsgTip);

    ///下载状态监听
    logic.downloadState.listen(showDownloadDialog);
    super.initState();
  }

  ///显示Loading弹窗
  void showDownloadDialog(bool isShow) {
    if (isShow) {
      Get.dialog(
        const DownloadDialog(),
        barrierDismissible: false,
        useSafeArea: false,
      );
    }
  }

  ///显示提示消息
  void showMsgTip(String msg) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.blue,
      messageText: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            /// 取消焦点，相当于关闭键盘
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          children: [
            ///监听主体内容视图的上下滚动
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                var direction = _directionDetect.detect(notification.metrics);
                if (direction != null && direction != _direction) {
                  _direction = direction;
                  _changeBottomNavigationState();
                }
                return false;
              },
              child: const CenterWidget(),
            ),

            ///包装底部导航栏进行唯一动画，和可点击控制
            AnimatedPositioned(
              key: const ValueKey("AnimatedPositioned"),
              child: AbsorbPointer(
                child: const BottomNavigation(),
                absorbing: !_bottomNavigationState,
              ),
              height: 180.h,
              right: 40.w,
              left: 40.w,
              bottom: _bottomNavigationState ? 100.h : -180.h,
              duration: const Duration(milliseconds: 200),
            )
          ],
        ),
      ),
    );
  }

  ///显示设置密钥弹窗
  void showSettingKeyDialog(isShow) {
    Get.log("是否显示设置Key:$isShow");
    if (isShow) {
      Get.dialog(
        SettingPexelsAuthDialog(),
      );
    } else {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  ///修改底部导航栏的状态
  void _changeBottomNavigationState() {
    if (_direction == AxisDirection.down) {
      setState(() {
        _bottomNavigationState = false;
      });
    } else if (_direction == AxisDirection.up) {
      setState(() {
        _bottomNavigationState = true;
      });
    }
  }
}

///中心主体Widget 单独提取是为了方式频繁的重建
class CenterWidget extends GetWidget<MainLogic> {
  const CenterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: controller.pageIndex.value,
        children: controller.pageList,
      );
    });
  }
}

///底部导航Widget
class BottomNavigation extends GetWidget<MainLogic> {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer.clearGlass(
      width: Get.width,
      height: double.infinity,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              controller.selectPage(0);
            },
            child: const Text('首页'),
          ),
          TextButton(
            onPressed: () {
              controller.selectPage(1);
            },
            child: const Text('搜索'),
          ),
          TextButton(
            onPressed: () {
              controller.selectPage(2);
            },
            child: const Text('收藏'),
          ),
          TextButton(
            onPressed: () {
              controller.selectPage(3);
            },
            child: const Text('设置'),
          ),
        ],
      ),
    );
  }
}

class SettingPexelsAuthDialog extends GetWidget<MainLogic> {
  ///弹窗输入的控制器
  final _textEditingController = TextEditingController();

  //编辑框焦点管理
  final _focusNode = FocusNode();

  SettingPexelsAuthDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 900.w,
        height: 700.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(35.w)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '请填写你的 Pexels Auth',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: 35.w, top: 120.h, left: 35.w, bottom: 35.w),
              width: double.infinity,
              height: 200.h,
              child: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  _focusNode.unfocus();
                  var auth = _textEditingController.value.text;
                  controller.saveUserAuth(auth);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  fillColor: const Color(0x80e2e2e3),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xfff6f7f8)),
                      borderRadius: BorderRadius.all(Radius.circular(30.r))),
                  hintText: '  --auth--',
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xfff6f7f8)),
                      borderRadius: BorderRadius.all(Radius.circular(30.r))),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.saveUserAuth(null);
              },
              child: const Text('使用默认Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
