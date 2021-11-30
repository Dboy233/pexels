import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pexels/main_router.dart';
import 'package:pexels/ui/collections/photo/view.dart';
import 'package:pexels/ui/collections/tip/view.dart';
import 'package:pexels/widget/empty_tip_widget.dart';

import '_local_router.dart';
import 'contents/view.dart';
import 'logic.dart';

///收藏页面
class CollectionsPage extends StatefulWidget {
  CollectionsPage() : super(key: const ValueKey("Collections"));

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final logic = Get.put(CollectionsLogic());

  @override
  void initState() {
    logic.msg.listen(showMsgTip);
    super.initState();
  }

  ///显示提示信息
  void showMsgTip(String msg) {
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
    return Navigator(
      onPopPage: _onPopPage,
      initialRoute: CollectionRouterName.collections_contents,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    Get.log("router:${route.toString()}, result:${result.toString()}");
    return false;
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CollectionRouterName.collections_contents:
        return CupertinoPageRoute(
            builder: (context) => const CollectionContents());
      case CollectionRouterName.collections_photo:
        var id = "";
        var arguments = settings.arguments;
        if (arguments is Map<dynamic, dynamic>) {
          id = arguments[RouterKey.ID];
        }
        if(id.isEmpty) {
          return _get404Widget();
        }
        return CupertinoPageRoute(
            builder: (context) => CollectionPhotos(
                  collectionContentId: id,
                ));
      case CollectionRouterName.collection_tips:
        return CupertinoPageRoute(
            builder: (context) => const CollectionsTipPage());
    }
    return _get404Widget();
  }

  Route _get404Widget() {
    return CupertinoPageRoute(
      builder:(context)=> Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("404"),
          ),
          body: const EmptyTipWidget(
            tip: "emmm 可能出了点问题.... 😅",
            isPercent: false,
          )),
    );
  }
}
