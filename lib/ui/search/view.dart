import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/widget/empty_tip_widget.dart';
import 'package:pexels/widget/photo_widget.dart';

import 'logic.dart';

class SearchPage extends StatefulWidget {
  const SearchPage() : super(key: const ValueKey("SearchPage"));

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final logic = Get.put(SearchLogic());

  @override
  void initState() {
    logic.tipMsg.listen(_showTip);
    logic.photos.listen(_dataChange);
    super.initState();
  }

  ///搜索数据发生改变
  _dataChange(data) {
    setState(() {
      ///就重构一下ui
    });
  }

  ///显示提醒
  _showTip(String msg) {
    Get.showSnackbar(GetBar(
      backgroundColor: Colors.blue,
      messageText: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('SearchPageContent'),
      color: const Color(0xfffefefe),
      child: NotificationListener<ScrollEndNotification>(
        key: const ValueKey('search scroll load more listener'),
        onNotification: (notification) {
          var pixels = notification.metrics.pixels;
          var maxScrollExtent = notification.metrics.maxScrollExtent;

          ///这里等于0是因为在没有数据的时候，下拉刷新的时候进行的通知，此时两个都是0。
          if (maxScrollExtent != 0 &&
              pixels.toInt() == maxScrollExtent.toInt()) {
            ///这里就判定已经滚动到底部了。进行加载下一页数据。
            logic.nextSearchPage();
          }
          return false;
        },
        child: CustomScrollView(
          key: const ValueKey('ScrollView'),
          controller: GetPlatform.isWeb ? ScrollController() : null,
          slivers: [
            SliverPersistentHeader(
              key: const ValueKey('sliver search header'),
              delegate: _SliverSearchBar(),
              floating: true,
            ),
            SliverList(
              key: const ValueKey('sliver list'),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (logic.photos.isEmpty) {
                    return const EmptyTipWidget(
                      tip: "🔍 搜索点什么吧...",
                    );
                  }
                  var photo = logic.photos[index];
                  return PhotoItemWidget(
                      key: ValueKey('search item ${photo.id}'), photo: photo);
                },
                childCount: logic.photos.isEmpty ? 1 : logic.photos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///SearchBar的代理Sliver
class _SliverSearchBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SearchBar();
  }

  @override
  double get maxExtent => Get.statusBarHeight.h+kToolbarHeight.h+140.h;

  @override
  double get minExtent => Get.statusBarHeight.h+kToolbarHeight.h+140.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

///SearchBar
class SearchBar extends GetWidget<SearchLogic> {
  final FocusNode _focusNode = FocusNode();

  final _textEditingController = TextEditingController();

  SearchBar() : super(key: const ValueKey('Searchbar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(
        left: 20.w,
        top: Get.statusBarHeight.h + 40.h,
        right: 20.w,
      ),
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: _focusNode,
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        autofocus: false,
        onEditingComplete: () {
          _focusNode.unfocus();
          var content = _textEditingController.value.text;
          controller.onSearch(content);
        },
        onTap: () {
          if(!_focusNode.hasFocus){
            Get.focusScope?.requestFocus(_focusNode);
          }
        },
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 55.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          fillColor: const Color(0x80e2e2e3),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(30.r))),
          hintText: '输入搜索内容(英文)',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 50.sp,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0x80f6f7f8)),
              borderRadius: BorderRadius.all(Radius.circular(30.r))),
        ),
      ),
    );
  }
}
