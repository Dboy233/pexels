import 'package:get/get.dart';
import 'package:pexels/net/bean/photo.dart';
import 'package:pexels/net/net_state.dart';
import 'package:pexels/net/pexels_api.dart';

class HomeLogic extends GetxController {
  ///当前请求的图片页面下标
  var _pageIndex = 1;

  ///页面大小一页几张图
  final _pageSize = 3;

  ///当前请求到的所有图片列表
  var photos = List<Photo>.empty(growable: true).obs;

  ///当请求出错的时候进行分发通知;true的时候展示提示
  var requestErrorState = false.obs;


  @override
  void onReady() {
    super.onReady();
    refreshPhotos();
  }

  ///刷新所有Photos
  refreshPhotos() async {
    _pageIndex = 1;
    var data =
        await Api.getPictureList(pageIndex: _pageIndex, pageSize: _pageSize);
    if (data.netState == NetState.success) {
      photos.clear();
      photos.addAll(data.data?.photos ?? []);
      _notifyErrorState(false);
    } else {
      _notifyErrorState(true);
    }
  }

  ///加载更多的Photos
  loadMorePhotos() async {
    _pageIndex++;
    var data =
    await Api.getPictureList(pageIndex: _pageIndex, pageSize: _pageSize);
    if (data.netState == NetState.success) {
      photos.addAll(data.data?.photos ?? []);
      _notifyErrorState(false);
    } else {
      _pageIndex--;
      _notifyErrorState(true);
    }
  }

  ///用于刷新请求出错提示状态
  _notifyErrorState(bool state) {
    if (requestErrorState.value == state) {
      requestErrorState.refresh();
    } else {
      requestErrorState.value = state;
    }
  }
}
