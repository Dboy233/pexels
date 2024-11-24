import '../tools/sp_key.dart';

///基础请求地址
const BASE_URL = "https://api.pexels.com/v1";

///精选照片
const apiCuratedPhotos = "/curated";

///搜索照片
const apiSearch = "/search";

///我的收藏列表
const apiCollectionMine = "/collections";

///某个收藏集的内容
String  apiCollectionContentMedia(String id) =>"/collections/$id";


///默认数据请求认证key
// const PEXELS_KEY_DEF = "563492ad6f91700001000001130b9756705240f58228cf3781972f5d";
const PEXELS_KEY_DEF = "563492ad6f917000010000019841bfce1f484ab3945c74722afe8fd1";

//默认请求Header
var BASE_HEADER = {"Authorization":PEXELS_KEY_DEF};

///用户使用的认证令牌
late String? User_Auth = SpKey.USER_AUTH.getSpString;
