import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SettingPage extends StatelessWidget {
  SettingPage() : super(key: const ValueKey("SettingPage"));

  final logic = Get.put(SettingLogic());

  @override
  Widget build(BuildContext context) {
    Get.log('"setting 页面构建"');
    return Scaffold(
      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _conetnt();
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conetnt() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250.h,
          ),
          Container(
            height: 300.r,
            width: 300.r,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://avatars.githubusercontent.com/u/37604230?v=4'))),
          ),
          SizedBox(
            height: 45.h,
          ),
          Text(
            'Dboy233',
            style: TextStyle(
                color: const Color(0xff0d0f1a),
                fontSize: 80.sp,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            'https://github.com/Dboy233',
            style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 40.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 200.h,
          ),
          _getItem(
            '修改Auth',
            '用于请求数据的Auth认证',
            () {
              _showChangeAuthDialog();
            },
          ),
          SizedBox(
            height: 100.h,
          ),
          ListTile(
            onTap: () {
              _showAboutDialog();
            },
            title: Text(
              '关于 Pexels Flutter',
              style: TextStyle(
                color: const Color(0xff0d0f1a),
                fontSize: 50.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.info,
              size: 70.r,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  ///tile item Widget
  Widget _getItem(String title, String subTitle, Function() onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xff0d0f1a),
          fontSize: 50.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          color: const Color(0xff5d5d5d),
          fontSize: 38.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 70.r,
        color: Colors.black,
      ),
    );
  }

  ///显示关于弹窗
  void _showAboutDialog() {
    Get.dialog(AboutDialog(
      applicationIcon: const FlutterLogo(),
      applicationName: 'Pexels Flutter',
      applicationVersion: 'v0.0.1',
      applicationLegalese: 'Copyright© 2021 Dboy233',
      children: <Widget>[
        SizedBox(
          height: 50.h,
        ),
        Container(
          height: 300.r,
          width: 300.r,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      'https://avatars.githubusercontent.com/u/37604230?v=4'))),
        ),
      ],
    ));
  }

  ///显示修改Auth弹窗
  void _showChangeAuthDialog() {
    Get.dialog(SettingPexelsAuthDialog());
  }
}

class SettingPexelsAuthDialog extends GetWidget<SettingLogic> {
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
                onEditingComplete: () async {
                  _focusNode.unfocus();
                  var auth = _textEditingController.value.text;
                  await controller.saveUserAuth(auth);
                  Get.back();
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
              onPressed: () async {
                await controller.saveUserAuth(null);
                Get.back();
              },
              child: const Text('使用默认Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
