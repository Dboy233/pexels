import 'package:flutter/material.dart';

import 'error_widget.dart';
import 'loading_widget.dart';

enum WidgetState {
  loading,
  success,
  error,
}

class DataStateWidget extends StatelessWidget {
  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget successWidget;
  final WidgetState widgetState;

  const DataStateWidget({
    Key? key,
    required this.successWidget,
    this.loadingWidget = const LoadingWidget(),
    this.errorWidget = const UiErrorWidget(),
    required this.widgetState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: Alignment.center,
      index: widgetState.index,
      children: [loadingWidget, successWidget, errorWidget],
    );
  }
}
