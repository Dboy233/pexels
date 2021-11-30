import 'package:pexels/net/net_state.dart';

///包装网络请求，对数据进行一次包装，增加数据的状态码
class Request<T> {
  //数据状态 200 = success
  NetState netState;
  T? data;

  Request(this.netState, {this.data});
}
