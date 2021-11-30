import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:pexels/main_router.dart';
import 'package:pexels/net/bean/collection_info.dart';
import 'package:pexels/tools/util.dart';
import 'package:pexels/ui/collections/_local_router.dart';

import '../logic.dart';

///搜藏目录
class CollectionContents extends GetWidget<CollectionsLogic> {
  const CollectionContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      // appBar: _CollectionContentsAppBar(),
      body: Obx(() {
        return CustomScrollView(
          controller: GetPlatform.isWeb ? ScrollController() : null,
          slivers: [
            //toolbar
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: null,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Collection',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 70.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            //如果列表空展示空图
            if (controller.contentsList.isEmpty)
              const SliverToBoxAdapter(
                child: _ContentsEmptyItemWidget(),
              ),
            //如果列表不空展示列表
            if (controller.contentsList.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var collectionInfo = controller.contentsList[index];
                    return _ContentsItemWidget(collectionInfo);
                  },
                  childCount: controller.contentsList.length,
                ),
              ),
          ],
        );
      }),
    );
  }
}

///收藏列表空提示Widget
class _ContentsEmptyItemWidget extends GetWidget<CollectionsLogic> {
  const _ContentsEmptyItemWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Get.height - Get.statusBarHeight - kToolbarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () {
                if (!controller.refreshData.value) {
                  controller.refreshMineContentsList();
                }
              },
              child: RefreshProgressIndicator(
                value: controller.refreshData.value ? null : 1,
              ),
            );
          }),
          const Text(
            '点击⬆️重试',
            style:
                TextStyle(color: Colors.black26, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 60.h,
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, CollectionRouterName.collection_tips);
              },
              child: const Text('还没有收藏集?点我查看如何创建收藏集')),
        ],
      ),
    );
  }
}

/// 列表视图
class _ContentsItemWidget extends GetWidget<CollectionsLogic> {
  final CollectionInfo collectionInfo;

  const _ContentsItemWidget(this.collectionInfo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (collectionInfo.id?.isEmpty == true) {
          return;
        }
        //params
        var params = <dynamic, dynamic>{};
        params[RouterKey.ID] = collectionInfo.id;
        Navigator.pushNamed(
          context,
          CollectionRouterName.collections_photo,
          arguments: params,
        );
      },
      child: Container(
        width: double.infinity,
        height: 400.h,
        margin: EdgeInsets.only(top: 20.r, right: 50.r, left: 50.r),
        child: Stack(
          children: [
            //封面
            _ContentsFrontCover(collectionInfo.id!),
            //毛玻璃效果
            GlassContainer.clearGlass(
              height: double.infinity,
              width: double.infinity,
              borderColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              blur: 2,
            ),
            //名字描述
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    collectionInfo.title ?? "No Title",
                    style: TextStyle(
                        fontSize: 65.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                  if (collectionInfo.description != null)
                    SizedBox(
                      height: 30.h,
                    ),
                  if (collectionInfo.description != null)
                    Text(
                      collectionInfo.description!,
                      style: TextStyle(
                          fontSize: 34.sp,
                          color: Colors.black26,
                          fontWeight: FontWeight.normal),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

///收藏集封面Img
class _ContentsFrontCover extends GetWidget<CollectionsLogic> {
  ///收藏集id
  final contentsId;

  const _ContentsFrontCover(this.contentsId);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ///如果没有图片就给个空的容器
      if (controller.contentsMediaCoverMap[contentsId]?.value.isEmpty == true) {
        return Container(
          decoration: BoxDecoration(
            color: randomColor(),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        );
      }
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.network(
          controller.contentsMediaCoverMap[contentsId]!.value,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    });
  }
}
