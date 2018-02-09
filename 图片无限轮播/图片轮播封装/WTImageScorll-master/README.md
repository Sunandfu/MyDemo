# WTImageScorll


使用方法：

1.导入头文件  WTImageScroll.h 

2.在需要的地方添加如下代码：

//创建显示本地图片view

    UIView *imageScorll=[WTImageScroll ShowLocationImageScrollWithFream:CGRectMake(0, 0, SCREENWIDTH, 200) andImageArray:array andBtnClick:^(NSInteger tagValue) {
    NSLog(@"点击的图片----%@",@(tagValue));
    }];
   
//创建显示网络图片view

    UIView *imageScorll=[WTImageScroll ShowNetWorkImageScrollWithFream:CGRectMake(0, 20, SCREENWIDTH, 200) andImageArray:netArray andBtnClick:^(NSInteger tagValue) {
        NSLog(@"点击的图片--%@",@(tagValue));
        }];


//添加到父视图

    [self.view addSubview:imageScorll];

//清楚网络图片的缓存

    [WTImageScroll clearNetImageChace];
