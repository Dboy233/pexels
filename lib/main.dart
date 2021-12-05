import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/tools/sp_key.dart';
import 'package:pexels/tools/sp_utils.dart';

import 'main_router.dart';
import 'net/net_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils.instance.init();
  await dataInit();
  runApp(pexelsApp());
}

///数据初始化
dataInit() async {
  //检查保存的用户认证，并赋值运行时参数
  var auth = SpKey.USER_AUTH.getSpString;
  if (auth?.isNotEmpty == true) {
    User_Auth = auth;
  }
}

Widget pexelsApp() {
  return ScreenUtilInit(
    //2340x1080
    designSize: const Size(1080, 2340),
    builder: () => GetMaterialApp(
      defaultTransition: Transition.cupertino,
      initialRoute: '/',
      getPages: mainRouter,
    ),
  );
}
