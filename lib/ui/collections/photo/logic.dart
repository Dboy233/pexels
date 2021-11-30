import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pexels/net/bean/photo.dart';
import 'package:pexels/net/net_state.dart';
import 'package:pexels/net/pexels_api.dart';

class CollectionPhotosLogic extends GetxController {
  CollectionPhotosLogic();

  ///提示消息信息
  var msg = "".obs;

  int _pageIndex = 0;

  int _toolCount = 0;

  final photos = List<Photo>.empty(growable: true).obs;

  //取消网络请求
  var cancelToken = CancelToken();


  ///获取收藏集中的所有Photo
  ///[id] 收藏集的id
  getContentPhotos(String id, {bool isRefresh = false}) async {
    if (isRefresh) {
      _pageIndex = 0;
      _toolCount = 0;
      photos.clear();
    } else {
      if (photos.length >= _toolCount) {
        return;
      }
    }
    _pageIndex++;
    //请求图片数据
    var data = await Api.getCollectionContentsMedia(id,
        page: _pageIndex, pageSize: 10, cancelToken: cancelToken);

    if (data.netState == NetState.success) {
      _toolCount = data.data?.totalResults ?? 0;
      //过滤图片类型的数据,其实请求的就是图片的，所有的数据都是Photo对象
      //为了保险起见
      var photoList = data.data?.media?.whereType<Photo>().toList() ?? [];
      photos.addAll(photoList);
    } else {
      _pageIndex--;
      _refreshTip("请求出错了");
    }
  }

  _refreshTip(String tip) {
    if (msg.value == tip) {
      msg.refresh();
    } else {
      msg.value = tip;
    }
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }
}
