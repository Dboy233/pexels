import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pexels/net/bean/collection_info.dart';
import 'package:pexels/net/bean/photo.dart';
import 'package:pexels/net/net_state.dart';
import 'package:pexels/net/pexels_api.dart';

class CollectionsLogic extends GetxController {
  ///提示消息信息
  var msg = "".obs;

  ///收藏列表
  var contentsList = List<CollectionInfo>.empty(growable: true).obs;

  ///收藏列表的中转位置
  final _contentsList = List<CollectionInfo>.empty(growable: true);

  ///数据刷新请求状态
  var refreshData = false.obs;

  ///收藏集的封面map通过网络单独获取的。
  final contentsMediaCoverMap = <String, RxString>{};

  var cancelTokens = <CancelToken>[];

  ///刷新我的收藏列表
  refreshMineContentsList() async {
    refreshData.value = true;
    contentsList.clear();
    _contentsList.clear();
    //请求网络
    await _getAllContentsList();
    if (_contentsList.isEmpty) {
      //如果没有数据就还是显示空视图，只不过false是修改了UI显示效果。
      refreshData.value = false;
      _refreshTip("没有收藏集？");
    } else {
      for (var element in _contentsList) {
        //创建对应收藏集的封面观察对象
        contentsMediaCoverMap[element.id!] = "".obs;
      }
      contentsList.addAll(_contentsList);
      //添加完后清空。
      _contentsList.clear();
    }

    ///收藏集列表获取完成之后获取收藏列表内容的媒体元素，用于UI展示
    _getContentPhotos();
  }

  ///获取某个收藏集的图片，目前只获取图片
  _getContentPhotos() async {
    if (contentsList.isEmpty) {
      return;
    }
    for (var content in contentsList) {
      var cancelToken = CancelToken();
      cancelTokens.add(cancelToken);

      ///只获取第一个图片就行了
      Api.getCollectionContentsMedia(content.id!,
              pageSize: 1, page: 1, cancelToken: cancelToken)
          .then((data) {
        Get.log("图片数据");
        if (data.data?.media?.isNotEmpty == true) {
          var media = data.data?.media?[0];
          if (media is Photo) {
            //添加对应封面
            var mediaCoverObs = contentsMediaCoverMap[content.id!];
            var val = media.src?.large ?? "";
            Get.log("图片 = $val");
            mediaCoverObs?.value = val;
          }
        }
      });
    }
  }

  ///获取所有的收藏列表,一页一页的请求
  _getAllContentsList({int nextPage = 1}) async {
    var token = CancelToken();
    cancelTokens.add(token);
    //请求数据
    var request = await Api.getMineCollections(
      pageSize: 10,
      pageIndex: nextPage,
      cancelToken: token,
    );
    if (request.netState == NetState.success) {
      if (request.data?.collections?.isNotEmpty ?? false) {
        //将数据添加到数据中转列表中。
        request.data?.collections?.forEach((element) {
          //排除没有内容的合集
          if (element.mediaCount != null && element.mediaCount != 0) {
            _contentsList.add(element);
          }
        });
        //有下一页，就继续请求。
        if (request.data?.nextPage != null) {
          await _getAllContentsList(nextPage: nextPage + 1);
        }
      }
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
    for (var value in cancelTokens) {
      try {
        if (!value.isCancelled) {
          value.cancel();
        }
      } catch (e) {}
    }
    cancelTokens.clear();
    super.onClose();
  }
}
