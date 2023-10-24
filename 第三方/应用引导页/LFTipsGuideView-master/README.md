# LFTipsGuideView
tips 提示指南

## Installation 安装

* CocoaPods：pod 'LFTipsGuideView'
* 手动导入：将LFTipsGuideView\class文件夹拽入项目中，导入头文件：#import "NSObject+LFTipsGuideView.h"

## 调用代码

````
[self lf_showInView:[[UIApplication sharedApplication] keyWindow] maskViews:@[self.button1,self.button2,self.button3,self.button4,self.button5] withTips:@[@"点击此处进行搜索",@"点击此处进行编辑",@"举报用户",@"点击此处进行用于注册",@"..."]];
````

## 图片展示

![image](https://github.com/lincf0912/LFTipsGuideView/blob/master/ScreenShots/screenshot.gif)
