import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';

import 'net_config.dart';

class NetUtil {
  ///创建对象的时候调用_getInstance()获取对象
  factory NetUtil() => _getInstance();

  ///使用instance对象的时候调用_getInstance()获取对象
  static NetUtil get instance => _getInstance();

  ///这个才是全局唯一单例
  static NetUtil? _instance;

  ///公共参数
  late final BaseOptions _baseOptions = BaseOptions(
    baseUrl: BASE_URL,
    headers: BASE_HEADER,
  );

  ///拦截器
  late final _customInterceptors = CustomInterceptors();

  ///dio请求对象
  late final Dio _dio = Dio(_baseOptions);

  NetUtil._internal() {
    _dio.interceptors.add(_customInterceptors);
  }

  static NetUtil _getInstance() {
    _instance ??= NetUtil._internal();
    return _instance!;
  }

  ///一般上传下载的时候不要带有拦截器，否则会有异常
  Dio dio() {
    return _dio;
  }
}

///自定义网络请求拦截器
class CustomInterceptors extends InterceptorsWrapper {
  static const TAG = "Http::";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (User_Auth != null && User_Auth != options.headers["Authorization"]) {
      options.headers["Authorization"] = User_Auth;
      Get.log("$TAG 请求[${options.method}] => Fix Auth:$User_Auth");
    }
    Get.log("$TAG 请求[${options.method}] => PATH: ${options.uri}");
    Get.log("$TAG 请求[${options.method}] => HEAD: ${options.headers}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Get.log(
        "$TAG 响应[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    var opt = response.requestOptions;
    if (opt.responseType == ResponseType.plain ||
        opt.responseType == ResponseType.json) {
      var data = jsonEncode(response.data);
      Get.log("====================");
      Get.log(data);
      Get.log("====================");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Get.log(
        "$TAG 错误[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} \n MSG:${err.message}");
    super.onError(err, handler);
  }
}
