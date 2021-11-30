import 'package:flutter/material.dart';

class ScrollDirectionDetect {
  double _lastOffset = 0;

  AxisDirection? _lastDirection;

  AxisDirection? detect(ScrollMetrics metrics,
      [bool isLogicalDirection = false]) {
    if (metrics.pixels >= metrics.maxScrollExtent || metrics.pixels < 0) {
      return _lastDirection;
    }
    var size = metrics.pixels - _lastOffset;

    if (size.abs() < 10) {
      return _lastDirection;
    }

    return _detectDirection(
        metrics.axisDirection, metrics.pixels, isLogicalDirection);
  }

  AxisDirection _detectDirection(

      ///监听滚动的方向
      AxisDirection direction,

      ///滚动偏移
      double offset,

      ///是否是逻辑方向。true:与`offset`的增减一致，false:只是主观上方向。
      bool isLogicalDirection) {

    switch (direction) {
      case AxisDirection.up:
        if (isLogicalDirection) {
          return _verticalLogical(offset);
        } else {
          return _verticalSubjective(offset);
        }
      case AxisDirection.down:
        return _verticalSubjective(offset);
      case AxisDirection.right:
        if (isLogicalDirection) {
          return _horizontalLogical(offset);
        } else {
          return _horizontalSubjective(offset);
        }
      case AxisDirection.left:
        return _horizontalSubjective(offset);
    }
  }

  AxisDirection _horizontalSubjective(double offset) {
    AxisDirection dire;
    if (offset > _lastOffset) {
      dire = AxisDirection.left;
    } else {
      dire = AxisDirection.right;
    }
    _reset(offset, dire);
    return dire;
  }

  AxisDirection _horizontalLogical(double offset) {
    AxisDirection dire;
    if (offset > _lastOffset) {
      dire = AxisDirection.right;
    } else {
      dire = AxisDirection.left;
    }
    _reset(offset, dire);
    return dire;
  }

  ///逻辑上的垂直滚动方向
  AxisDirection _verticalLogical(double offset) {
    AxisDirection dire;
    if (offset > _lastOffset) {
      dire = AxisDirection.up;
    } else {
      dire = AxisDirection.down;
    }
    _reset(offset, dire);
    return dire;
  }

  ///主观上的垂直滚动方向
  AxisDirection _verticalSubjective(double offset) {
    AxisDirection dire;
    if (offset > _lastOffset) {
      dire = AxisDirection.down;
    } else {
      dire = AxisDirection.up;
    }
    _reset(offset, dire);
    return dire;
  }

  _reset(double offset, AxisDirection axisDirection) {
    _lastOffset = offset;
    _lastDirection = axisDirection;
  }
}
