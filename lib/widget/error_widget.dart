import 'package:flutter/material.dart';

class UiErrorWidget extends StatelessWidget {
  const UiErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('加载失败了...'));
  }
}
