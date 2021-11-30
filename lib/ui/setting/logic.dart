import 'package:get/get.dart';
import 'package:pexels/net/net_config.dart';

class SettingLogic extends GetxController {

  ///保存用户的Auth
    saveUserAuth(String? auth) async {
    if(auth==null){
      User_Auth = PEXELS_KEY_DEF;
    }else{
      User_Auth = auth;
    }
  }
}
