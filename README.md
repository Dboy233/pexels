# pexels flutter lean demo flutter学习demo

Pexels 的API访问需要翻墙。

Pexels 官网:[https://www.pexels.com/zh-tw/](https://www.pexels.com/zh-tw/)

自己注册一个账号: 将Auth的认证修改为自己的。

目前完成的功能：

- 首页：精选图片推荐
- 收藏功能：只能查看在网页端的收藏，API没有提供收藏功能。
- 下载：下载原图保存的相册。
- 搜索：搜索图片，仅限英语，毕竟国外API。

Flutter SDK Version : 
```text
Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision dec2ee5c1f (11 days ago) • 2024-11-13 11:13:06 -0800
Engine • revision a18df97ca5
Tools • Dart 3.5.4 • DevTools 2.37.3
```

Android权限需求
```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"
        tools:ignore="ScopedStorage" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED"/>
```

IOS权限需求
```xml
	<key>NSPhotoLibraryUsageDescription</key>
	<string>我们需要访问您的照片库的权限才能查看和选择您的照片和视频.</string>
	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>为了您的方便,我们需要获得许可才能将照片和视频保存到您的库中.</string>
```

| 图片 | 图片 |
| ---- | ---- |
| ![img](/readme_img/main_page.png)     |   ![](/readme_img/main_page_full.png)   |
| ![](/readme_img/search_page_null.png)   |   ![](/readme_img/search_page_cat.png)   |
| ![](/readme_img/search_page_cat_full.png)    |  ![](/readme_img/collection_page.png)    |
| ![](/readme_img/collection_photo.png)   |   ![](/readme_img/setting_page.png)   |



