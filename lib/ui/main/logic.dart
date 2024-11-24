import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pexels/net/net_config.dart';
import 'package:pexels/net/pexels_api.dart';
import 'package:pexels/tools/getx_extensions.dart';
import 'package:pexels/tools/sp_key.dart';
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

  ///消息提示
  var msgTip = "".obs;

  ///用户的搜藏数据列表。
  final authCollections = List.empty(growable: true);

  ///下载状态 true正在下载,弹出提示；false下载结束，关闭提示。
  var downloadState = false.obs;

  ///取消下载
  CancelToken? _cancelDownloadToken;

  @override
  void onReady() {
    super.onReady();
    checkPexelsAuthStatus();
  }

  @override
  void onClose() {
    _cancelDownloadToken?.cancel();
    super.onClose();
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
    if (User_Auth == null || User_Auth?.isEmpty == true) {
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

  ///下载图片
  ///[saveName] 图片保存的名字
  ///[downloadUrl] 图片下载地址
  void downloadPhoto(String? saveName, String? downloadUrl) async {
    if (downloadState.value) return;
    if (saveName == null || saveName.isEmpty == true) {
      msgTip.alwaysUpToDate("文件名称错误~");
      return;
    }
    if (downloadUrl == null || downloadUrl.isEmpty) {
      msgTip.alwaysUpToDate("下载地址获取失败~");
      return;
    }
    //权限申请,先尝试申请高版本的权限 ios和android通用的权限
    var permission = await Permission.photos.request();
    if (permission.isDenied) {
      //如果权限被拒绝了,再单独判断是否是android平台,尝试使用低版本api请求权限
      if (GetPlatform.isAndroid) {
        var androidPermission = await Permission.storage.request();
        if (androidPermission.isDenied) {
          androidPermission.printError(info: "dboy");
          msgTip.alwaysUpToDate("没有权限,请开启读写权限～");
          return;
        }
      } else {
        permission.printError(info: "dboy");
        msgTip.alwaysUpToDate("没有权限,请开启读写权限～");
        return;
      }
    }

    //显示提示
    downloadState.value = true;

    //创建取消下载token
    _cancelDownloadToken = CancelToken();

    //开始下载
    var result =
        await Api.downloadPhoto(saveName, downloadUrl, _cancelDownloadToken!);

    //修改下载状态
    downloadState.alwaysUpToDate(false);

    //这里做延迟是因为，上面修改状态后会通知关闭下载弹窗，
    //然而弹窗还没有关闭前，下面的提示bar显示了。
    //这就导致Getx进行关闭的时候，监测到对后弹出的是Snackbar,就把SnackBar关闭了
    //导致弹窗无法关闭，调用手动取消的时候也出现了问题。所以加个延迟确保
    //下载弹窗已经被关闭。
    await Future.delayed(const Duration(milliseconds: 200));

    //通过结果判断弹出提示
    if (result) {
      msgTip.alwaysUpToDate("保存成功");
    } else {
      msgTip.alwaysUpToDate("保存失败了");
    }
  }

  ///取消下载
  void cancelDownload() {
    _cancelDownloadToken?.cancel();
    downloadState.alwaysUpToDate(false);
  }
}
