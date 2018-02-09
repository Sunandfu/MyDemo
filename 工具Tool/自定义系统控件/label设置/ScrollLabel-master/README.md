# ScrollLabel
滚动的文字，超出边界滚动，不超出边界静止。


# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/image/image/aedfsfdg.gif)


# How To Use

```ruby

#import "WSScrollLabel.h"

WSScrollLabel *label2 = [[WSScrollLabel alloc]initWithFrame:CGRectMake(30, 120, 250, 30)];;
label2.text = @"我是一个能动的文字，你他妈倒是东给我看看啊";
label2.textFont = [UIFont systemFontOfSize:20];
label2.textColor = [UIColor whiteColor];
label2.backgroundColor = [UIColor grayColor];
[self.view addSubview:label2];



参数说明：
@property (nonatomic, strong) NSString *text; /**< 文字*/
@property (nonatomic, strong) UIColor *textColor; /**< 字体颜色 默认白色*/
@property (nonatomic, strong) UIFont *textFont; /**< 字体大小 默认25*/

@property (nonatomic, assign) CGFloat space; /**< 首尾间隔 默认25*/
@property (nonatomic, assign) CGFloat velocity; /**< 滚动速度 pixels/second,默认30*/
@property (nonatomic, assign) NSTimeInterval pauseTimeIntervalBeforeScroll; /**< 每次开始滚动前暂停的间隔 默认2s*/

```