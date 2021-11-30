import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pexels/net/bean/collection_info_mine.dart';
import 'package:pexels/net/net_request.dart';
import 'package:pexels/net/net_state.dart';

import 'bean/collection_contents_info.dart';
import 'bean/curated_photos.dart';
import 'bean/search_photos.dart';
import 'net_config.dart';
import 'net_util.dart';

class Api {
  ///获取精选照片列表
  ///[pageIndex] 请求的页码
  ///[pageSize] 一页数据量
  static Future<Request<CuratedPhotos>> getPictureList(
      {int pageIndex = 1, int pageSize = 15}) async {
    return NetUtil.instance.dio().get(
      apiCuratedPhotos,
      queryParameters: {"page": pageIndex, "per_page": pageSize},
    ).then<Request<CuratedPhotos>>((value) {
      //数据检查，是否超过请求限制、或是否请求成功。请求失败了就返回空数据
      if (!_checkMaxRequestSize(value.headers) && value.statusCode == 200) {
        return Request(NetState.success,
            data: CuratedPhotos.fromJson(value.data));
      } else {
        return Request(NetState.error);
      }
    }).onError((error, stackTrace) {
      return Request(NetState.error);
    });
  }

  ///获取搜索列表
  ///[search] 搜索的内容
  ///[pageIndex] 请求的页码
  ///[pageSize] 一页数据量
  static Future<Request<SearchPhotos>> getSearchList(String search,
      {int pageIndex = 1, int pageSize = 15}) async {
    return NetUtil.instance.dio().get(apiSearch, queryParameters: {
      "query": search,
      "page": pageIndex,
      "per_page": pageSize
    }).then<Request<SearchPhotos>>((value) {
      if (!_checkMaxRequestSize(value.headers) && value.statusCode == 200) {
        return Request(NetState.success,
            data: SearchPhotos.fromJson(value.data));
      } else {
        return Request(NetState.error);
      }
    }).onError((error, stackTrace) {
      return Request(NetState.error);
    });
  }

  ///获取我的收藏列表
  static Future<Request<CollectionInfoMine>> getMineCollections(
      {int pageIndex = 1, int pageSize = 10,CancelToken? cancelToken}) {
    return NetUtil.instance.dio().get(apiCollectionMine, queryParameters: {
      "per_page": pageSize,
      "page": pageIndex
    },cancelToken: cancelToken).then<Request<CollectionInfoMine>>((value) {
      if (value.statusCode == 200 && !_checkMaxRequestSize(value.headers)) {
        return Request(NetState.success,
            data: CollectionInfoMine.fromJson(value.data));
      } else {
        Get.log("错误");
        return Request(NetState.error);
      }
    }).onError((error, stackTrace) {
      Get.log("$stackTrace");
      return Request(NetState.error);
    });
  }

  /// 获取用户某个收藏集的图片
  static Future<Request<CollectionContentsInfo>> getCollectionContentsMedia(
      String id,
      {String type = "photos",
      int page = 1,
      int pageSize = 3,
      CancelToken? cancelToken}) async {
    return NetUtil()
        .dio()
        .get(apiCollectionContentMedia(id),
            queryParameters: {"type": type, "page": page, "per_page": pageSize},
            cancelToken: cancelToken)
        .then<Request<CollectionContentsInfo>>((value) {
      if (value.statusCode == 200 && !_checkMaxRequestSize(value.headers)) {
        return Request(NetState.success,
            data: CollectionContentsInfo.fromJson(value.data));
      }
      return Request(NetState.error);
    }).onError((error, stackTrace) {
      return Request(NetState.error);
    });
  }

  ///检查是否超过或已到达最大API请求次数限制
  ///true超过了最大限制，没有数据
  ///false没有超过最大限制，可能有数据
  static bool _checkMaxRequestSize(Headers headers) {
    var maxLimit = headers["X-Ratelimit-Limit"];
    var currentRequest = headers["X-Ratelimit-Remaining"];
    if (maxLimit != null && currentRequest != null) {
      try {
        return num.parse(currentRequest[0]) <= 0;
      } catch (e) {
        Get.log("已到达数据请求限制,明天再看吧。");
      }
    }
    return false;
  }
}
