import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/tools/sp_key.dart';
import 'package:pexels/tools/sp_utils.dart';

import 'main_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(pexelsApp());
}

Widget pexelsApp() {
  return ScreenUtilInit(
    //2340x1080
    designSize: const Size(1080, 2340),
    builder: (_, child) => GetMaterialApp(
      defaultTransition: Transition.cupertino,
      initialRoute: '/',
      getPages: mainRouter,
    ),
  );
}
