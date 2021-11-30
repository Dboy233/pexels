import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pexels/net/net_config.dart';
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

  ///检查Pexels认证状态
  checkPexelsAuthStatus() async {
    var auth = User_Auth;
    if (auth == null || auth.isEmpty) {
      pexelsAuthState.toggle();
    }
  }

  ///保存用户的Auth
  void saveUserAuth(String? auth) async {
    if (auth == null) {
      User_Auth = PEXELS_KEY_DEF;
    } else {
      User_Auth = auth;
    }
    pexelsAuthState.toggle();
  }

}
