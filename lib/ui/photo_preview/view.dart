import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/main_router.dart';
import 'package:photo_view/photo_view.dart';

///图片预览页面
class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //进行Hero专场动画的id
    String? heroId = Get.parameters[RouterKey.ID];

    //图片的网络地址
    String? photoUrl = Get.parameters[RouterKey.URL];

    //是否是网络资源 'true' 'false' 字符类型就行.默认是true
    String isNetAssets = Get.parameters[RouterKey.IS_NET_ASSETS] ?? "true";

    if (photoUrl == null) {
      return const Center(child: Text("图片数据异常，检查图片地址。。"));
    }

    heroId ??= photoUrl;

    ImageProvider provider;
    if ("true" == isNetAssets) {
      provider = NetworkImage(photoUrl);
    } else {
      provider = AssetImage(photoUrl);
    }
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: heroId),
            imageProvider: provider,
          ),
          Positioned(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            top: Get.statusBarHeight.h + 30.h,
          )
        ],
      ),
    );
  }
}
