import 'package:get/get.dart';
import 'package:pexels/net/bean/photo.dart';
import 'package:pexels/net/net_state.dart';
import 'package:pexels/net/pexels_api.dart';

class SearchLogic extends GetxController {
  ///输入校验
  final RegExp _enReg = RegExp(r"^\w+$");

  ///UI上的消息提醒
  var tipMsg = "".obs;

  ///当前请求到的所有图片列表
  var photos = List<Photo>.empty(growable: true).obs;

  ///搜索数据总量
  var _totalCont = 0;

  ///保存搜索内容
  var _searchContent = "";

  ///页码
  var _pageIndex = 1;

  ///一页照片数量
  final _pageSize = 3;

  ///当触发搜索
  ///模拟 搜索大海(sea)
  onSearch(String content) {
    if (_enReg.hasMatch(content)) {
      _searchContent = content;
      _refreshTip("正在搜索内容:$content");
      _doSearch(content);
    } else {
      _refreshTip("只能输入英文、数字、下划线...");
    }
  }

  ///执行搜索任务
  _doSearch(String search) async {
    ///搜索页码归零
    _pageIndex = 1;

    ///请求搜索API
    var data = await Api.getSearchList(search, pageSize: _pageSize);

    ///处理结果
    if (data.netState == NetState.success) {
      _totalCont = data.data?.totalResults ?? 0;
      photos.clear();
      photos.addAll(data.data?.photos ?? []);
    } else {
      _refreshTip("没有'$search'的内容...");
    }
  }

  ///搜索下一页
  nextSearchPage() async {
    ///判断搜索剩余
    if (photos.length >= _totalCont) {
      _refreshTip("没有多余内容了...");
      return;
    }

    ///请求搜索API
    _pageIndex++;
    var data = await Api.getSearchList(_searchContent,
        pageIndex: _pageIndex, pageSize: _pageSize);

    ///处理数据
    if (data.netState == NetState.success) {
      _totalCont = data.data?.totalResults ?? 0;
      photos.addAll(data.data?.photos ?? []);
    } else {
      ///页码归位
      _pageIndex--;
      _refreshTip("查询剩余内容失败,请重试...");
    }
  }

  _refreshTip(String tip) {
    if (tipMsg.value == tip) {
      tipMsg.refresh();
    } else {
      tipMsg.value = tip;
    }
  }
}
