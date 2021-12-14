# DDPushView

[![CI Status](https://img.shields.io/travis/dxjerry/DDPushView.svg?style=flat)](https://travis-ci.org/dxjerry/DDPushView)
[![Version](https://img.shields.io/cocoapods/v/DDPushView.svg?style=flat)](https://cocoapods.org/pods/DDPushView)
[![License](https://img.shields.io/cocoapods/l/DDPushView.svg?style=flat)](https://cocoapods.org/pods/DDPushView)
[![Platform](https://img.shields.io/cocoapods/p/DDPushView.svg?style=flat)](https://cocoapods.org/pods/DDPushView)

## 导入

```ruby
pod 'DDPushView',:git =>"https://github.com/dxjerry/DDPushView.git"
```

## 使用

```objc
//初始化
DDPushView *pushview = [[DDPushView alloc]init];

//设置弹出框标题（为空或不填则隐藏标题栏）
pushview.title = @"这里设置标题";

//设置view为弹出框内要显示的视图（自动匹配高度）
pushview.mainview = view;

//弹出动画
[pushview PushOutView];

//通过block获得返回值
pushview.comfirm = ^(NSInteger index){
    NSLog(@"%ld",(long)index);
};

支持用手势拖曳方式收回弹出框
```

## Author

dxjerry, dxjerry@sina.com

## License

DDPushView is available under the MIT license. See the LICENSE file for more info.
