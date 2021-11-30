//列表的每一个item部件
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/net/bean/photo.dart';
import 'package:pexels/tools/util.dart';
import 'package:pexels/ui/main/logic.dart';

import '../main_router.dart';

class PhotoItemWidget extends GetWidget<MainLogic> {
  final Photo photo;

  const PhotoItemWidget({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = zoom(photo.width ?? 0, photo.height ?? 0, width: width);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //作者名字
        Padding(
          padding: EdgeInsets.only(top: 80.h, left: 30.w, bottom: 28.h),
          child: Text(
            photo.photographer ?? "",
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xff0d111b),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        //作者主页
        Padding(
          padding: EdgeInsets.only(left: 30.w, bottom: 30.h),
          child: Text(
            photo.photographerUrl ?? "",
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff757576),
            ),
          ),
        ),
        //图片
        GestureDetector(
          onTap: () {
            //打开图片预览页面
            var params = RouterUrlParams.routerPhotoPreviewUrl(
                photo.id.toString(), photo.src?.large2x ?? "");
            Get.toNamed(RouterName.photoPreviewRoutName, parameters: params);
          },
          child: Hero(
            tag: photo.id.toString(),
            child: Image.network(
              photo.src?.large2x ?? "",
              width: width,
              height: height,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                Get.log("图片尝试重新加载");
                return Image.network(
                  photo.src?.large2x ?? "",
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: 'Auth用户的收藏,不可操作',
              child: Icon(
                photo.liked ? Icons.favorite_rounded : Icons.favorite_border,
                color: Colors.pink,
                size: 80.r,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.download,
                size: 80.r,
              ),
            ),
            SizedBox(
              width: 30.w,
            )
          ],
        ),
      ],
    );
  }
}
