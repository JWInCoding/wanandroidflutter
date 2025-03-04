# WanAndroid Flutter 客户端

一个使用 Flutter 开发的 WanAndroid 客户端应用，提供了 WanAndroid 网站的主要功能和内容展示。

## 功能特性

- 首页文章列表
- 项目分类与展示
- 知识体系分类浏览
- 公众号文章阅读
- 搜索功能
- 收藏文章管理
- 登录注册
- 深色模式支持
- 文章分享功能

## 技术栈

- Flutter SDK
- GetX 状态管理
- Dio 网络请求
- Provider 辅助状态管理
- MMKV 高性能存储
- WebView 文章展示
- CachedNetworkImage 图片缓存

## 开始使用

### 环境要求

- Flutter 3.29.0 或更高版本
- Dart 3.7.0 或更高版本
- DevTools 2.42.2 或更高版本

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/JWInCoding/wanandroidflutter.git
```

2. 进入项目目录
```bash
cd wanandroidflutter
```

3. 获取依赖
```bash
flutter pub get
```

4. 运行项目
```bash
flutter run
```

## 项目结构

```
lib/
├── api/            # API 接口定义
├── models/         # 数据模型
├── pages/          # 页面 UI 代码
├── routes/         # 路由管理
├── utils/          # 工具类
├── widgets/        # 自定义 Widget 组件
└── main.dart       # 应用入口文件
```


## 致谢

- [WanAndroid API](https://www.wanandroid.com/blog/show/2)
- 原始仓库参考：[qianyue0317/wan_android_flutter](https://github.com/qianyue0317/wan_android_flutter)