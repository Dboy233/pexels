import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'main_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(pexelsApp());
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
