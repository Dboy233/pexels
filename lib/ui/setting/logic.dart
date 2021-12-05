import 'package:get/get.dart';
import 'package:pexels/net/net_config.dart';
import 'package:pexels/tools/sp_key.dart';
import 'package:pexels/tools/sp_utils.dart';

class SettingLogic extends GetxController {
  ///保存用户的Auth
  saveUserAuth(String? auth) async {
    //如果数据为null 使用 默认Auth
    var authStr = auth?.isNotEmpty == true ? auth! : PEXELS_KEY_DEF;
    User_Auth = authStr;
    SpKey.USER_AUTH.setSpString(authStr);
  }
}
