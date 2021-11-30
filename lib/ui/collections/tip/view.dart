import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/main_router.dart';

class CollectionsTipPage extends StatelessWidget {
  const CollectionsTipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffededed),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                )),
            title: Text(
              '如何创建收藏集',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('第一步: 在Web端找到任意一个图片，点击图片右下角 \'➕\'。'),
                  const SizedBox(height: 8),
                  const Text("第二步: 点击弹窗右上角 '建立收藏' 按钮。"),
                  const SizedBox(height: 8),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(RouterName.photoPreviewRoutName,
                            parameters: {
                              RouterKey.URL: "images/step_one.gif",
                              RouterKey.IS_NET_ASSETS: "false"
                            });
                      },
                      child: Hero(
                        tag: "images/step_one.gif",
                        child: Image.asset("images/step_one.gif",
                            width: double.infinity),
                      )),
                  const SizedBox(height: 16),
                  const Text("第三步: 创建好收藏集之后，选择收藏集，添加成功"),
                  const SizedBox(height: 8),
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(RouterName.photoPreviewRoutName,
                            parameters: {
                              RouterKey.URL: "images/step_two.gif",
                              RouterKey.IS_NET_ASSETS: "false"
                            });
                      },
                      child: Hero(
                        tag: "images/step_two.gif",
                        child: Image.asset("images/step_two.gif",
                            width: double.infinity),
                      )),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
