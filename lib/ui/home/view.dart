import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:pexels/widget/empty_tip_widget.dart';
import 'package:pexels/widget/item_photo_widget.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage() : super(key: const ValueKey("HomePage"));

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logic = Get.put(HomeLogic());

  @override
  void initState() {
    logic.requestErrorState.listen(_requestErrorTip);
    super.initState();
  }

  ///请求出错的时候展示的提示信息
  void _requestErrorTip(bool isShow) {
    if (isShow) {
      Get.showSnackbar(GetBar(
        backgroundColor: Colors.blue,
        messageText: const Text(
          "数据请求失败了啊。",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey("ListViewScaffold"),
      body: RefreshIndicator(
        displacement: 50,
        onRefresh: () async {
          //刷新图片
          await logic.refreshPhotos();
        },
        child: ScrollConfiguration(
          key: const ValueKey('scroll configuration'),
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              var pixels = notification.metrics.pixels;
              var maxScrollExtent = notification.metrics.maxScrollExtent;

              ///这里等于0是因为在没有数据的时候，下拉刷新的时候进行的通知，此时两个都是0。
              if (maxScrollExtent != 0 &&
                  pixels.toInt() == maxScrollExtent.toInt()) {
                ///这里就判定已经滚动到底部了。进行加载下一页数据。
                logic.loadMorePhotos();
              }
              return false;
            },
            child: const PhotoListWidget(),
          ),
        ),
      ),
    );
  }
}

//图片列表List部件
class PhotoListWidget extends GetWidget<HomeLogic> {
  const PhotoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: GetPlatform.isWeb ? ScrollController() : null,
        itemCount: controller.photos.isEmpty ? 1 : controller.photos.length,
        itemBuilder: (context, index) {
          if (controller.photos.isEmpty) {
            return const EmptyTipWidget(
              tip: "⬇ 下拉刷新,获取精选图片...",
              heightPercent: 0.8,
            );
          }
          var photo2 = controller.photos[index];
          return PhotoItemWidget(
            key: ValueKey(photo2.id),
            photo: photo2,
          );
        },
      );
    });
  }
}
