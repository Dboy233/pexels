import 'package:get/get.dart';
import 'package:pexels/net/net_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  ///单例模式
  SpUtils._internal();

  ///单例模式
  static SpUtils? _instance;

  ///单例模式
  factory SpUtils() => _getInstance();

  ///单例模式
  static SpUtils get instance => _getInstance();

  ///单例模式
  static SpUtils _getInstance() {
    _instance ??= SpUtils._internal();
    return _instance!;
  }

  SharedPreferences? _sharedPreferences;

  ///app main方法中执行
  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ///保存一个数据 [value] 类型只能是 [int] [bool] [String] [double]类型的数据
  Future<bool> put(String key, dynamic value) async {
    Get.log("Sp set : [$key : $value]");
    switch (value.runtimeType) {
      case int:
        {
          return _sharedPreferences?.setInt(key, value) ?? Future.value(false);
        }
      case bool:
        {
          return _sharedPreferences?.setBool(key, value) ?? Future.value(false);
        }
      case double:
        {
          return _sharedPreferences?.setDouble(key, value) ??
              Future.value(false);
        }
      case String:
        {
          return _sharedPreferences?.setString(key, value) ??
              Future.value(false);
        }
      default:
        {
          throw Exception("无法保存这个类型类型数据 $key => ${value.runtimeType}");
        }
    }
  }

  ///获取 保存的名字为[key] 的数据
  String? getString(String key) {
    var value = _sharedPreferences?.getString(key);
    Get.log("Sp getString: [$key : $value]");
    return value;
  }

  bool? getBool(String key) {
    var value =  _sharedPreferences?.getBool(key);
    Get.log("Sp getBool: [$key : $value]");
    return value;
  }

  double? getDouble(String key) {
    var value = _sharedPreferences?.getDouble(key);
    Get.log("Sp getDouble: [$key : $value]");
    return value;
  }

  int? getInt(String key) {
    var value = _sharedPreferences?.getInt(key);
    Get.log("Sp getInt: [$key : $value]");
    return value;
  }
}

///Sp扩展
extension SpExt on String {
  int? get getSpInt => SpUtils().getInt(this);

  Future<bool?> setSpInt(int value) async {
    return SpUtils().put(this, value);
  }

  double? get getSpDouble => SpUtils().getDouble(this);

  Future<bool?> setSpDouble(double value) async {
    return SpUtils().put(this, value);
  }

  String? get getSpString => SpUtils().getString(this);

  Future<bool?> setSpString(String value) async {
    return SpUtils().put(this, value);
  }

  bool? get getSpBool => SpUtils().getBool(this);

  Future<bool?> setSpBool(bool value) async {
    return SpUtils().put(this, value);
  }
}
