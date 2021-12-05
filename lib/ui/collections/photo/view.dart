import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pexels/ui/collections/photo/logic.dart';
import 'package:pexels/widget/item_photo_widget.dart';

class CollectionPhotos extends StatefulWidget {
  final String collectionContentId;

  const CollectionPhotos({Key? key, required this.collectionContentId})
      : super(key: key);

  @override
  State<CollectionPhotos> createState() => _CollectionPhotosState();
}

class _CollectionPhotosState extends State<CollectionPhotos> {
  final logic = Get.put<CollectionPhotosLogic>(CollectionPhotosLogic());

  @override
  void initState() {
    logic.getContentPhotos(widget.collectionContentId, isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await logic.getContentPhotos(widget.collectionContentId,
              isRefresh: true);
        },
        child: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
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
                  'Photo',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                ),
                shadowColor: Colors.transparent,
                backgroundColor: const Color(0x80ffffff),
                floating: true,
              ),
              if (logic.photos.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((c, index) {
                    var photo = logic.photos[index];
                    return PhotoItemWidget(
                      photo: photo,
                    );
                  }, childCount: logic.photos.length),
                ),
            ],
          );
        }),
      ),
    );
  }
}
