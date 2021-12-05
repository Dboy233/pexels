import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pexels/net/net_config.dart';
import 'package:pexels/tools/sp_key.dart';
import 'package:pexels/tools/sp_utils.dart';
import 'package:pexels/ui/collections/view.dart';
import 'package:pexels/ui/home/view.dart';
import 'package:pexels/ui/search/view.dart';
import 'package:pexels/ui/setting/view.dart';

class MainLogic extends GetxController {
  ///所有页面的集合列表
  late final pageList = <Widget>[
    //主页
    const HomePage(),
    //搜索页面
    SearchPage(),
    //收藏页面
    CollectionsPage(),
    //设置页面
    SettingPage(),
  ];

  ///当前页面选中的下标， [pageList]对应位置的页面。
  var pageIndex = 0.obs;

  ///Pexels 的认证状态。如果需要填写认证Key则为True，反之False；
  var pexelsAuthState = false.obs;

  ///用户的搜藏数据列表。
  final authCollections = List.empty(growable: true);

  @override
  void onReady() {
    super.onReady();
    checkPexelsAuthStatus();
  }

  ///修改页面滚动
  void selectPage(int index) {
    if (pageIndex.value == index) {
      return;
    }
    pageIndex.value = index;
  }

  ///检查Pexels认证状态，当app 初始化的时候会对[User_Auth]进行赋值，如果之前保存了数据
  ///则，[User_Auth] 是用户自己设置的认证key
  checkPexelsAuthStatus() async {
    if (User_Auth == null || User_Auth?.isEmpty==true) {
      pexelsAuthState.toggle();
    }
  }

  ///保存用户的Auth
  void saveUserAuth(String? auth) async {
    //如果数据为null 使用 默认Auth
    var authStr = auth?.isNotEmpty == true ? auth! : PEXELS_KEY_DEF;
    User_Auth = authStr;
    SpKey.USER_AUTH.setSpString(authStr);
    pexelsAuthState.toggle();
  }
}
