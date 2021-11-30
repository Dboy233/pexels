///1. 创建路由Name [RouterName]
///2. 如果路由中有参数，选择[RouterKey]中的通用Key,如果已存在key不满足创建新的。
///3. 创建路由Name拼接，这是路由有参数的情况下进行添加。在[RouterUrlParams]中创建
///4. 将路由添加到[mainRouter]集合中。
import 'package:flutter/material.dart' show UniqueKey;
import 'package:get/get.dart';
import 'package:pexels/ui/main/view.dart';
import 'package:pexels/ui/photo_preview/view.dart';

///路由名字
class RouterName {
  ///根路由
  static const mainRouterName = '/';

  ///图片预览页面
  static const photoPreviewRoutName = "/photo_preview";
}

///路由跳转所使用到的参数通用Key
abstract class RouterKey {
  static const String ID = "id";
  static const String URL = "url";
  ///是否是网络资源 String 类型的value "true" "false"
  static const String IS_NET_ASSETS ="is_net_assets";
}

///需要传惨的路由调用封装校验类
abstract class RouterUrlParams {
  ///跳转到图片预览，路由地址拼接
  static Map<String,String> routerPhotoPreviewUrl(String heroId, String photoUrl) {
    return {RouterKey.ID: heroId, RouterKey.URL: photoUrl};
  }
}

///路由集合
List<GetPage> mainRouter = [
  ///主页
  GetPage(
    name: RouterName.mainRouterName,
    page: () => MainPage(
      key: UniqueKey(),
    ),
  ),

  ///图片预览页面需要传入 id 和 url ,如果不是网络资源 传入 [RouterKey.IS_NET_ASSETS] = "false"
  GetPage(
    name: RouterName.photoPreviewRoutName,
    page: () => PhotoPreviewPage(
      key: UniqueKey(),
    ),
  ),
];
