/**
 匿名类目：可以声明方法和变量，属性为private（不允许在外部调用，且不能被继承
 */
/**
 发送数据的委托方，接收数据的时代理发（即代理的反向传值）
 委托方第一步：声明协议
 委托方第二步：声明代理指针
 委托方第三步：操作完成，告诉代理（即调用代理的方法）
 代理第一步：遵守协议
 代理第二步：成为代理
 代理第三步：实现协议方法
 */

// %zd %zi 表示NSInteger
// %g 表示数字去掉尾零

//代码块路径
/Users/ms/Library/Developer/Xcode/UserData/CodeSnippets

#pragma mark - Xcode快捷键

Control + A：移动光标到行首
Control + E：移动光标到行末
Control + D：删除光标右边的字符
Control + K：删除本行


Command + ->：移动到行尾

#pragma mark - 本地化

// 找到这个仓库
NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

// 存放数据
[ud setObject:@"hehe" forKey:@"a"];
// 同步
[ud synchronize];

// 从ud里通过key查询存储的对象（可以存放NSString，NSNumber，数组，数组，NSDate，NSData）
// 注：ud里不能存放自定义类型（放在容器里也不行）
NSString *str = [ud objectForKey:@"a"];

#pragma mark - 通知

NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"111", @"aaa", nil];
// 通过通知中心，发送一条通知，可以用第二个参数
// 工程中所有监控fm90的对象都可以收到者个通知
[[NSNotificationCenter defaultCenter] postNotificationName:@"FM90" object:self.textView.text userInfo:dic];

// 在通知中心注册了一个观察者（self），当工程中任何地方发送了FM90这个通知，self都会触发listenUp这个方法
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenUp:) name:@"FM90" object:nil];
// 如果通知中心的观察者回调里有参数，参数就是NSNotification
- (void)listenUp:(NSNotification *)sender
{
    // 发送广播时带的两个参数
    //    NSLog(@"%@ , %@", sender.name, sender.userInfo);
}

- (void)dealloc
{
    // 当观察者dealloc的时候，需要移除观察者身份
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FM90" object:nil];
}

#pragma mark - 获取程序文件相关目录

// 获取APP Home 目录
NSString * homeDirectory = NSHomeDirectory();
// 获取 文件.app 目录
NSString * appPath = [[NSBundle mainBundle] bundlePath];
// 获取 Documents 目录
NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString * path = [paths objectAtIndex:0];
// 获取 Library 目录
paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
path = [paths objectAtIndex:0];
// 获取 Caches 目录
paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
path = [paths objectAtIndex:0];
// 获取程序资源路径
//path = [NSBundle mainBundle] pathForResource:(NSString *)ofType:(NSString *)

// 加载资源
//[[NSBundle mainBundle] loadNibNamed:@"string" owner:nil options:nil]

#pragma mark - 手势

// 找到触摸事件
UITouch *momo = [touches anyObject];
// 判断触摸的图片是不是图片视图
if ([momo.view isKindOfClass:[UIImageView class]]) {
    [self.view bringSubviewToFront:momo.view];
    // 记录鼠标的原始坐标（移动轨迹原始坐标）
    _tempPoint = [momo locationInView:self.view];
}
// 鼠标点击次数
momo.tapCount

/**************六种基本手势******************/

// 点击手势（松开鼠标时响应）
UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCR:)];
// 将手势添加到view上
[view addGestureRecognizer:tapGR];
// 拖拽（移动，拖动，move）手势（这个手势和清扫手势冲突）
UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
// 缩放手势
UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGR:)];
// 旋转手势
UIRotationGestureRecognizer *rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGR:)];
// 长按手势
UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGR:)];
// 轻扫手势（和移动手势冲突）
UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGR:)];
// 设置轻扫方向
swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
// 如果想响应多个方向的清扫需要创建多个清扫手势的对象
UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGR:)];
// 设置轻扫方向
swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;

// 轻扫
- (void)swipeGR:(UISwipeGestureRecognizer *)swipeGR
{
    CGRect frame = swipeGR.view.frame;
    // 判断轻扫方向
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionUp) {
        frame.size.height += 10;
    }
    // 按位与判断（用数字1进行按位与运算的结果，可以用按位与来判断是否相等）
    if (swipeGR.direction & UISwipeGestureRecognizerDirectionLeft) {
        frame.size.height -= 10;
    }
}

// 长按
- (void)longPressGR:(UILongPressGestureRecognizer *)longPressGR
{
    // 判断手势状态
    if (longPressGR.state == UIGestureRecognizerStateBegan)
        }

// 旋转
- (void)rotationGR:(UIRotationGestureRecognizer *)rotationGR
{
    // 让view旋转，后面一个参数就是旋转的角度
    rotationGR.view.transform = CGAffineTransformRotate(rotationGR.view.transform, rotationGR.rotation);
    // 每次旋转以后需要将记录还原
    rotationGR.rotation = 0;
}

// 缩放
- (void)pinchGR:(UIPinchGestureRecognizer *)pinchGR
{
    // 让view缩放，后面2个参数，一个是x方向缩放的倍数，一个是y方向缩放的倍数
    pinchGR.view.transform = CGAffineTransformScale(pinchGR.view.transform, pinchGR.scale, pinchGR.scale);
    // 每次缩放后需要还原倍数的记录
    pinchGR.scale = 1.0;
}

// 移动
- (void)panGR:(UIPanGestureRecognizer *)panGR
{
    // 移动手势对应的消息（x方向移动多少，y方向移动多少）
    CGPoint point = [panGR translationInView:self.view];
    // 根据轨迹修改手势对应的view
    panGR.view.center = CGPointMake(panGR.view.center.x + point.x, panGR.view.center.y + point.y);
    // 每次移动以后需要将手势的轨迹清零
    [panGR setTranslation:CGPointMake(0, 0) inView:self.view];
}

// 点击
- (void)tapCR:(UITapGestureRecognizer *)tagRG
{
    [self.view bringSubviewToFront:tagRG.view];
}

#pragma mark - 图片截取

- (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect
{//返回image中rect范围内的图片
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    return subImage;
}

#pragma mark - 计算字符串尺寸

// 计算一个字符串完整展示所需要的size
// 第一个参数是最大不能超过的size
// 第二个参数固定写法
// 第三个参数是计算size时字符串的属性
CGSize size = [str boundingRectWithSize:CGSizeMake(width - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName, nil] context:nil].size;

// 根据计算的结果修改label的frame
CGRect frame = self.label.frame;
frame.size.width = size.width + 5;
frame.size.height = size.height + 5;
self.label.frame = frame;

#pragma mark - 动画
#pragma mark -简单动画

/** 动画1 **/
// 简单动画，可以修改frame，alpha（透明度1.0），背景色
// 完成frame修改的动作需要两秒，但是代码不会卡住，代码会继续运行
[UIView animateWithDuration:2 animations:^{
    bigView.frame = frame;
}];
/** 动画2 **/
[UIView animateWithDuration:2 animations:^{
    bigView.frame = frame;
} completion:^(BOOL finished) {
    NSLog(@"动画完成以后的回调=%d",finished);
}];
/** 动画3 **/
// 开始简单动画
[UIView beginAnimations:nil context:NULL];
// 设置动画时间
[UIView setAnimationDuration:2];
//... 添加代码，属于要展示动画的区域
// 提交动画
[UIView commitAnimations];

/** 跟随模式 **/
/*
 UIViewAutoresizingNone                 = 0,
 UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
 UIViewAutoresizingFlexibleWidth        = 1 << 1,
 UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
 UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
 UIViewAutoresizingFlexibleHeight       = 1 << 4,
 UIViewAutoresizingFlexibleBottomMargin = 1 << 5
 */
// 允许子视图跟随
bigView.autoresizesSubviews = YES;

// 子视图跟随的模式
smallView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

#pragma mark -基础动画

/***************CABasicAnimation************/
// 创建核心动画
// 缩放比例用transform.scale
//transform.scale代表缩放（倍数）
//transform.rotation.x   transform.rotation.y  transform.rotation.z 代表旋转（角度）
CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
// 动画的始末值
// @0.5 相当于 [NSNumber numberWithFloat:0.5]
ani.fromValue = @0;
ani.toValue = @M_PI;
// 单次动画时间
ani.duration = 2;
// 重复次数
ani.repeatCount = 10;
// 动画返回形式
ani.autoreverses = YES;
// 添加动画
[view.layer addAnimation:ani forKey:@"aaa"];
// 移除动画
[longPressGR.view.layer removeAnimationForKey:@"aaa"];

#pragma mark -转场动画

// 创建转场动画
CATransition *tt = [CATransition animation];
// 动画时间
tt.duration = 2;
// 方向
tt.subtype = kCATransitionFromBottom;
//四种预设，某些类型中此设置无效
kCATransitionFromRight
kCATransitionFromLeft
kCATransitionFromTop
kCATransitionFromBottom
// 类型（系统自带的有4个）
tt.type = kCATransitionMoveIn;
tt.type = @"rotate";
/*
 1---->
 #define定义的常量（基本型）
 kCATransitionFade   交叉淡化过渡
 kCATransitionMoveIn 新视图移到旧视图上面
 kCATransitionPush   新视图把旧视图推出去
 kCATransitionReveal 将旧视图移开,显示下面的新视图
 
 2--->
 苹果官方自定义类型:
 fade moveIn push reveal         和上面的四种一样
 pageCurl pageUnCurl             翻页
 rippleEffect                    滴水效果
 suckEffect                      收缩效果，如一块布被抽走
 cube alignedCube                立方体效果
 flip alignedFlip oglFlip        翻转效果
 rotate                          旋转
 cameraIris cameraIrisHollowOpen cameraIrisHollowClose 相机
 */

[self.navigationController.view.layer addAnimation:tt forKey:nil];
[self.navigationController pushViewController:dvc animated:NO];

#pragma mark - UIApplication

openURL:
● UIApplication有个功能⼗十分强⼤大的openURL:⽅方法 - (BOOL)openURL:(NSURL*)url;
● openURL:⽅方法的部分功能有
➢ 打电话
UIApplication *app = [UIApplication sharedApplication]; [app openURL:[NSURL URLWithString:@"tel://10086"]];
➢ 发短信
[app openURL:[NSURL URLWithString:@"sms://10086"]];
➢ 发邮件
[app openURL:[NSURL URLWithString:@"mailto://12345@qq.com"]];
➢ 打开⼀一个⺴⽹网⻚页资源
[app openURL:[NSURL URLWithString:@"http://ios.itcast.cn"]];


#pragma mark - UIView

// frame设置需要有中间值
CGRect frame = bigView.frame;
frame.size.width *= 2;
frame.size.height *= 2;
bigView.frame = frame;
// 圆角
bigView.layer.cornerRadius = 150; // 角度设为frame.width/height则是个圆
bigView.clipsToBounds = YES;
// 边框
bigView.layer.borderWidth = 2;
bigView.layer.borderColor = [[UIColor blackColor] CGColor];
// 设置背景图片
self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];

/*
 //相对父视图的坐标
 @property(nonatomic) CGRect frame;
 //相对于自己内容的坐标
 @property(nonatomic) CGRect bounds;
 //父视图
 @property(nonatomic,readonly) UIView *superview;
 //所有的子视图
 @property(nonatomic,readonly,copy) NSArray *subviews;
 //内容模式（填充一边位等比例模式）
 @property(nonatomic) UIViewContentMode contentMode;                // default UIViewContentModeScaleToFill
 
 //在最上层添加一个视图
 - (void)addSubview:(UIView *)view;
 //在指定层面插入一个视图(如果层级越界，就相当于add)
 - (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
 //在某个视图是下级插入一个新视图
 - (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
 //在某个视图的上级插入一个新视图
 - (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
 //从父视图中移除（自杀）
 - (void)removeFromSuperview;
 //修改2个视图的层级
 - (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
 //将某个视图移到最上层
 - (void)bringSubviewToFront:(UIView *)view;
 //将某个视力移到最底层
 - (void)sendSubviewToBack:(UIView *)view;
 
 //判断一个视图是否是别外一个视图的子视图（如果是同一个视图也会返回yes）
 - (BOOL)isDescendantOfView:(UIView *)view;
 //通过tag找view
 - (UIView *)viewWithTag:(NSInteger)tag;
 */

#pragma mark - UILabel

/*
 //设置文字
 @property(nonatomic,copy) NSString *text;
 
 //文字颜色
 @property(nonatomic,retain) UIColor *textColor;
 
 //阴影颜色
 @property(nonatomic,retain) UIColor *shadowColor;
 
 //阴影坐标
 @property(nonatomic) CGSize shadowOffset;
 
 //将label大小调整为单行展示文字所需要的大小
 - (void)sizeToFit;
 
 //对齐方式
 @property(nonatomic) NSTextAlignment textAlignment;
 
 //换行方式省略号位置
 @property(nonatomic) NSLineBreakMode lineBreakMode;
 
 //行数，默认是1，设为0后自动换行
 @property(nonatomic) NSInteger numberOfLines;
 
 //字体
 @property(nonatomic,retain) UIFont *font;
 */

// 不能自动换行，但能增加长度
[self.label sizeToFit];

//使用固定字体
label.font = [UIFont fontWithName:@"Zapfino" size:20];

//系统默认字体
label.font = [UIFont systemFontOfSize:20];

//系统默认字体加黑
label.font = [UIFont boldSystemFontOfSize:20];

//系统默认字体斜体
label.font = [UIFont italicSystemFontOfSize:20];

#pragma mark - UIButton

// btn的类型，除了custom和system，另外4个都自带大小和外观
UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
// 设置文字垂直和水平的对齐方式
btn.titleLabel.font = [UIFont systemFontOfSize:15];
btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

// 当btn接收到TouchUpInside这个事件时，会给self发送btnClick这个消息
// 事件-消息机制
[btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

#pragma mark - UIImageView

// 图片转为NSData
UIImagePNGRepresentation(_ivView.image)
// 图片转为点阵图（防止渲染）
[_ivView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

// 显示图片大小为imageView大小
_starsView.contentMode = UIViewContentModeLeft;
_starsView.clipsToBounds = YES;
// 设置图像填充模式，等比例显示(CTRL+6)
iv.contentMode = UIViewContentModeScaleAspectFit;

// 从iPhone4开始，设备的屏幕都是retina屏（2倍，一个坐标位横向纵向显示2个像素点，高清屏，视网膜屏），（6p是3倍的）
// retina屏幕会优先找a@2x.png，找不到就找a.png
iv.image = [UIImage imageNamed:@"a"];

// 图片对象（自带的大小是坐标体系的大小，如果用的是@2x图片，像素大小的宽高除以2就是坐标体系的大小
UIImage *image = [UIImage imageNamed:@"c"];
// 用图片直接创建图片视图，x，y默认是0，宽高默认是图片的大小
UIImageView *secondIv = [[UIImageView alloc] initWithImage:image];

/** 图片轮播 **/
// 设置图片视图轮播图片的数组，单次动画时间，循环次数(默认无线循环，0次也是无线循环），开始动画
iv.animationImages = tempArr;
iv.animationDuration = tempArr.count/10.0f;
iv.animationRepeatCount = 0;
[iv startAnimating];

/*
 //开始动画
 - (void)startAnimating;
 //手动结束动画
 - (void)stopAnimating;
 //判断动画状态
 - (BOOL)isAnimating;
 
 //图片
 @property(nonatomic,retain) UIImage *image;
 //动画的图片数组
 @property(nonatomic,copy) NSArray *animationImages;
 //动画时间(也就是一次完整的动画需要的时间)
 @property(nonatomic) NSTimeInterval animationDuration;
 //动画循环次数，循环完以后会自动停止
 @property(nonatomic) NSInteger animationRepeatCount;
 */

#pragma mark - UITextFiled

// 占位提示符
tf.placeholder = @"请输入QQ号";
// 边框风格
tf.borderStyle = UITextBorderStyleLine;
// 背景图片（和边框风格冲突）
// 如果风格是圆角，那么背景图片失效
// 如果边框风格不是圆角，那么边框风格失效
tf.background = [UIImage imageNamed:@"tf_bg"];


// 当字符串的长度超过tf的长度，可以自动缩小字体
tf.adjustsFontSizeToFitWidth = YES;
// 自动缩小的最小值
tf.minimumFontSize = 30;

// 水平方向的对齐方式（同label）
tf.textAlignment = NSTextAlignmentRight;
// 垂直方向对齐方式（同button）
tf.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;

// 当字符串的长度超过tf的长度，可以自动缩小字体
tf.adjustsFontSizeToFitWidth = YES;
// 自动缩小的最小值
tf.minimumFontSize = 30;

// 水平方向的对齐方式（同label）
tf.textAlignment = NSTextAlignmentRight;
// 垂直方向对齐方式（同button）
tf.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
// 当弹出键盘的时候，清空tf的文字
tf.clearsOnBeginEditing = YES;
// 设置清空按钮出现的方式
tf.clearButtonMode = UITextFieldViewModeWhileEditing;
// 安全输入（暗文输入，专门输入密码使用）
tf.secureTextEntry = YES;

// 键盘类型
tf.keyboardType = UIKeyboardTypeDefault;
// 回车键的外观（和功能没有任何关系）
tf.returnKeyType = UIReturnKeyNext;

// 设置tf的左边的附属view的出现模式（实际工作中一般都是图片imageview）
// 一个view只能成为一个地方的附属view
tf.leftView = view;
tf.leftViewMode = UITextFieldViewModeAlways;

// 键盘view和附属view
tf.inputView = view;
tf.inputAccessoryView = view;

// 收起这个页面的键盘
[self.view endEditing:YES];
// 放弃第一响应
[self.view resignFirstResponder]

#pragma mark - UIViewController

// 第一种跳转
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 通过连线的标识符来执行某个跳转
    // segue过渡的意思
    [self performSegueWithIdentifier:@"PushToCyan" sender:nil];
}

// 第二种跳转
// 通过storyboard跳转页面时都会走这个方法
// 第一个参数就是跳转的那根连线，第二个参数暂时理解成触发跳转的对象(storyboard里已经画出的view）
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 通过连线找到跳转到的页面
    UIViewController *nextVC = [segue destinationViewController];
    nextVC.view.backgroundColor = [UIColor yellowColor];
    // self.tableView就是表格页面自动带的tableview
    // 在一个tableView里通过cell找到所处的位置
    MovieCell *cell = (id)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
}

// 第三种跳转
// 找到自带的Main.storyboard
UIStoryboard *sd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
UIViewController *vc = [sd instantiateViewControllerWithIdentifier:@"Cyan"];
[self.navigationController pushViewController:vc animated:YES];



// 声明周期
3-->-[ThirdViewController initWithNibName:bundle:]
3-->-[ThirdViewController viewDidLoad]
3-->-[ThirdViewController viewWillAppear:]
3-->-[ThirdViewController viewDidAppear:]
-[FourthViewController initWithNibName:bundle:]
-[FourthViewController viewDidLoad]
3-->-[ThirdViewController viewWillDisappear:]
-[FourthViewController viewWillAppear:]
3-->-[ThirdViewController viewDidDisappear:]
-[FourthViewController viewDidAppear:]
-[FourthViewController viewWillDisappear:]
3-->-[ThirdViewController dealloc]
-[FourthViewController viewDidDisappear:]
-[FourthViewController dealloc]

//弹出一个新的viewController
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion;

//销毁当前viewcontroller
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

#pragma mark - UINavigationController

// 设置导航栏（导航栏是属于导航控制器的）
// 导航栏分为两部分（工具条高 20，以下高44）

// 针对导航栏的设置，全影响到整个导航控制器
// 设置导航栏的隐藏状态
self.navigationController.navigationBarHidden = NO;
// 通过vc找到nc，通过nc找到导航栏，设置背景色
self.navigationController.navigationBar.barTintColor = [UIColor magentaColor];
// 设置导航栏内容的渲染色（自带的返回按钮）
self.navigationController.navigationBar.tintColor = [UIColor greenColor];

// 半透明状态，如果写成YES，（0，0）坐标点在导航栏的左上角
// 如果写成NO，（0，0）坐标点在导航栏的左下角
self.navigationController.navigationBar.translucent = NO;

// 设置背景图(平铺模式：即如果图片过小，重复显示）（会引起坐标原点的改变）
// 以iPhone为例，如果图片size是320*44，那么就会展示成ios7以前的效果（系统状态栏和导航栏完全分离）
[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"aaa"] forBarMetrics:UIBarMetricsDefault];

// 这个方法可以获取当前导航栏
[UINavigationBar appearance];

// 设置导航栏title的文字属性
self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, [UIColor purpleColor], NSForegroundColorAttributeName, nil];

// 展示在当前页导航栏正中间的view，设置了这个view，title就不显示了
self.navigationItem.titleView = label;

/*
 4种创建专用按钮
 a，使用字符串创建
 b，使用图片（默认会被渲染，需要注意图片的大小写）
 c，使用系统自带的风格
 d，自定义（一般都用UIButton）
 */

UIBarButtonSystemItemFlexibleSpace，是自带的一种空的item，可以当作占位符用
[[UIImage imageNamed:@"gerenzhuye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]，去除图片的渲染

// 将专有按钮放到当前导航栏的左边
UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"aItem" style:UIBarButtonItemStylePlain target:self action:@selector(itemClick)];
[aItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil] forState:UIControlStateNormal];
self.navigationItem.leftBarButtonItem = aItem;
// 使用图片创建专用按钮（只取轮廓，不取颜色，系统会把不透明的地方渲染了）（默认渲染色为蓝色）
UIBarButtonItem *bItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"haoyou"] style:UIBarButtonItemStyleDone target:self action:@selector(itemClick)];
// 使用系统自带的风格
UIBarButtonItem *cItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(itemClick)];
// 使用view创建专有按钮（一般用btn，只有用btn才能添加监听事件）
UIBarButtonItem *dItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

// 系统自定义按钮
self.navigationItem.leftBarButtonItem = self.editButtonItem;

#pragma mark - UITabBarController

/*
 使用tabBarController的基本思路
 1，创建所有展示的页面
 2，如果需要将页面放到导航里
 3，设置每个页面或者导航显示到tabBar上的专用按钮
 4，将页面或者导航放到数组里，并且和标签栏控制器关联
 */

// 初始化分栏控制器（标签栏控制器）
UITabBarController *tbc = [[UITabBarController alloc] init];
// 设置需要控制的页面（可以是普通页面，也可以是导航控制器）
tbc.viewControllers = [NSArray arrayWithObjects:av, bnc, cv, dv, ev, fv, gv, nil];

// 推出新页面的时候，隐藏底层标签栏，返回的时候会自动出现
gv.hidesBottomBarWhenPushed = YES;

/* 创建专用按钮的3中方式 */
// 创建一个标签栏的专用按钮（系统自带样式）
UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];

homeNC.tabBarItem = homeItem;
// 使用一个字符串和一个图片创建专用按钮（默认渲染图片）
// UITabItem使用的图片最合适的大小是30*30
UITabBarItem *loveItem = [[UITabBarItem alloc] initWithTitle:@"love" image:[UIImage imageNamed:@"tab_0"] tag:0];
// 使用一个字符串和2张图片创建（默认会渲染)
UITabBarItem *nearlyItem = [[UITabBarItem alloc] initWithTitle:@"nearly" image:[UIImage imageNamed:@"tab2_1"] selectedImage:[UIImage imageNamed:@"tab2_2"]];


// 设置渲染色
UITabBarController.tabBar.tintColor = [UIColor redColor];
// 设置背景颜色
UITabBarController.tabBar.barTintColor = [UIColor cyanColor];
// 背景图片
UITabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbg"];
// 显示字体属性，字体属性单独设置
[homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName] forState:UIControlStateNormal];
// 让分栏控制器里对应的页面，展示出来
self.selectedIndex = sender.tag - 100;

#pragma mark - UIScrollView

// 设置滚动试图内可以展示的最大的size
sv.contentSize = CGSizeMake(480, 480);
// 设置偏移量（偏移就是位移，现在展示的子视图和默认子视图相比移动的距离）
sv.contentOffset = CGPointMake(20, 20);

// 水平和垂直方向的进度条
// 在有些版本里，垂直隐藏，水平也就不显示了
sv.showsHorizontalScrollIndicator = NO;
sv.showsVerticalScrollIndicator = NO;
// 弹簧效果
sv.bounces = NO;

// 代理方法中的bool值
// decelerate代表松手以后sv是否会继续滑行（1代表会）

// 如果页面实在导航里，而且第一个子视图是sv，那么系统会让这个sv有一个自动下沉的效果
self.automaticallyAdjustsScrollViewInsets = NO;


// sv中只能有一个子视图可以被缩放
// 如果sv中有多个子视图，缩放的时候会对整个sv产生不可预料的后果
// 最大、最小缩放倍数
sv.minimumZoomScale = 0.5;
sv.maximumZoomScale = 2;
// 放大缩小的代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1];
}

#pragma mark - UIPageControl

// 翻页控制器
UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 450, 0, 0)];
// 根据页数自动分配大小
[pc sizeForNumberOfPages:5];
// 设置页数
pc.numberOfPages = 5;
// 小点点的颜色
pc.currentPageIndicatorTintColor = [UIColor redColor];
pc.pageIndicatorTintColor = [UIColor greenColor];
// 一般关闭用户交互
pc.userInteractionEnabled = NO;

#pragma mark - UITableView

// 注册复用标示符
[_myTableView registerClass:[BookCell class] forCellReuseIdentifier:@"cell"];
[_myTableView registerNib:[UINib nibWithNibName:@"BookCell" bundle:nil] forCellReuseIdentifier:@"cell"];
// 自动下沉，（继承与scrollview，符合其特性）
self.automaticallyAdjustsScrollViewInsets = NO;
// 分割线颜色
_myTableView.separatorColor = [UIColor redColor];

// 通过tableview找到cell
UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];


// 设置cell点击以后是否变灰，如果参数设成NONE就不变，否则就变
cell.selectionStyle = UITableViewCellSelectionStyleNone;
// cell的附属view的类型（如果附属view里有btn，那么这个view的点击事件就会独立出来）
// 代理有事件响应方法
cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
// 自定义附属view
//        cell.accessoryView

// 脚标题行高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

// 自定义头标题的view（view的会替换自带的头标题view）
// frame设置无效，位置固定，宽度固定和table一样，高度通过代理方法设置
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
// 设置小节数，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// cell被点击时促发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 让cell被选中变灰的状态，恢复成没变灰的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 与上相反，一般不用
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
// 如果cell的附属view里有btn，那么这个view的点击事件会独立出来
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

#pragma -编辑相关

// 刷新，重新加载数据
[_myTableView reloadData];

// 每次点击都改变tv的编辑状态
// 修改删除按钮上的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
// 允许编辑,编辑相关的按钮（删除，插入）点击时触发
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 通过位置先删除对应的数据模型
        [[_dataArr objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        Person *person = [[Person alloc] init];
        // 在数据对应位置插入数据
        [[_dataArr objectAtIndex:indexPath.section] insertObject:person atIndex:indexPath.row];
        // 在对应的位置插入一个cell（会自动匹配刚刚插入的数据）
        [_myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}
// 设置cell的编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
// 返回删除和插入按位或（其实即使3），就是多选删除
//return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

// 移动单元格
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 通过移动前的位置找到将要移动的数据模型
    Person *person = [[_dataArr objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    // 把数据源删除
    [[_dataArr objectAtIndex:sourceIndexPath.section] removeObject:person];
    // 插入源位置
    [[_dataArr objectAtIndex:destinationIndexPath.section] insertObject:person atIndex:destinationIndexPath.row];
}

// self.editButtonItem的点击事件
// UIViewController自带的方法
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // 必须调用一次父类的（类似viewDidLoad）
    [super setEditing:editing animated:YES];
    [_myTableView setEditing:editing animated:YES];
}

// 索引条
// 默认情况下点击索引里的第几个，tv就会跳到第几段
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (int i = 'A'; i <= 'Z'; i++) {
        [titleArr addObject:[NSString stringWithFormat:@"%c", i]];
    }
    
    return titleArr;
}

// 索引颜色
//@property(nonatomic, retain) UIColor *sectionIndexColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;                   // color used for text of the section index
//@property(nonatomic, retain) UIColor *sectionIndexBackgroundColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;         // the background color of the section index while not being touched
//@property(nonatomic, retain) UIColor *sectionIndexTrackingBackgroundColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR; // the background color of the section index while it is being touched


#pragma mark - UICollectionView

// 网格视图需要一个布局来支撑自己
UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
// 设置滚动方向（默认就是垂直方向）
layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
// 注册
[_myCollection registerClass:[MyCell class] forCellWithReuseIdentifier:@"cell"];
[_myCollection registerClass:[MyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 网格视图的cell必须提前注册
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"第%d个", indexPath.row];
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.row]];
    return cell;
}
// 设置单个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
// 设置cell的分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
// 设置cell之间水平最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
// 设置分段内部cell之间垂直最小间隔
// 滑动方向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
// 设置分段之间的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
// 设置段头或者段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 判断是段头还是短尾
    //    if (kind == UICollectionElementKindSectionFooter)
    MyView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
}

// 设置段头的大小（如果collectionView是垂直方向滑动，那么宽度会被忽略，系统会自动匹配成collectionView的宽度）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - UIToolbar

// 工具栏（在工具栏上可以放导航专用按钮）
UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
[self.view addSubview:tb];
UIBarButtonItem *editBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(editClick:)];
// UIBarButtonSystemItemFlexibleSpace专用按钮占位符
// 在工具栏展示一些专用按钮
tb.items = @[editBtn, refreshBtn];

#pragma mark - UISearchBar

_sb = [[UISearchBar alloc] initWithFrame:frame];
// 整个表格视图可以拥有一个头view
_myTableView.tableHeaderView = _sb;

// 搜索控制器（将_sb和页面关联起来)
_sdc = [[UISearchDisplayController alloc] initWithSearchBar:_sb contentsController:self];
_sdc.delegate = self;
// 给搜索控制器自带的tableView设置代理
_sdc.searchResultsDataSource = self;
_sdc.searchResultsDelegate = self;

// 只要_sb里的文字发生了改变，都会执行该方法
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_resultArr removeAllObjects];
    for (NSArray *arr in _myDataArr) {
        for (NSString *str in arr) {
            NSRange range = [str rangeOfString:searchString];
            if (range.length > 0) {
                [_resultArr addObject:str];
            }
        }
    }
    return YES;
}


#pragma mark - 定时器和延时调用

//创建定时器，每隔几秒就运行某个函数一次
NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(run) userInfo:nil repeats:YES];

// 相当于上面一行
_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

//取消定时器（定时器取消后，必去重新初始化）
[_timer invalidate];
// self会在2秒以后执行runLater:方法，同时把sender作为参数
[self performSelector:@selector(runLater:) withObject:sender afterDelay:0.5];

#pragma mark - 常用基本控件
#pragma mark UISlider
// 滑尺控件
UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 60, 240, 90)];
[self.view addSubview:slider];

// 滑尺一般情况下我们是监控ValueChanged事件
// 可以添加多个监听事件
[slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
// ValueChanged事件对应的消息在滑动过程中是否接收
slider.continuous = NO;

// 最小和最大记录的值（记录范围）
slider.maximumValue = 10;
slider.minimumValue = 0;
// 通过代码设置滑块的值
slider.value = 5;

// 左右线条的颜色
slider.maximumTrackTintColor = [UIColor blackColor];
slider.minimumTrackTintColor = [UIColor greenColor];

// 设置小圆圈（拇指）图片
[slider setThumbImage:[UIImage imageNamed:@"gerenzhuye"] forState:UIControlStateNormal];

#pragma mark UISegmentedControl

// 使用数组初始化分段选择器（可以是字符串，也可以是图片，图片默认被渲染）
UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"111", [[UIImage imageNamed:@"gerenzhuye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],@"222", nil]];
segmentControl.frame = CGRectMake(40, 200, 240, 60);
[segmentControl addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
// 删除一个分段
[segmentControl removeSegmentAtIndex:1 animated:YES];
// 插入一个分段（可以是字符串或者图片）
[segmentControl insertSegmentWithTitle:@"333" atIndex:2 animated:YES];
// 设置默认点击分段
segmentControl.selectedSegmentIndex = 1;
// 设置渲染色
segmentControl.tintColor = [UIColor redColor];

// 获取分段的位置编号
// 获取分段的标题
sc.selectedSegmentIndex;
[sc titleForSegmentAtIndex:sc.selectedSegmentIndex];

#pragma mark UISwitch

// 开关控件，大小是固定的51*31，自己设定无效
UISwitch *open = [[UISwitch alloc] initWithFrame:CGRectMake(40, 80, 100, 100)];
// 拇指，关闭时边框，打开时背景的颜色
open.thumbTintColor = [UIColor redColor];
open.tintColor = [UIColor blackColor];
open.onTintColor = [UIColor blueColor];
// 默认打开状态
open.on = YES;

#pragma mark UIActivityIndicatorView

// 使用某种风格初始化活动指示器（自带大小）
UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
// 开始旋转
[indicator startAnimating];
// 一般都是放置在屏幕正中间
indicator.center = self.view.center;
// 设置小菊花颜色
indicator.color = [UIColor yellowColor];

// 用系统提供的单例方法获取到程序刚运行时创建的UIApplication对象
// 系统状态栏自带的旋转小菊花
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

#pragma mark UIWebView

// 将字符串转成网址类对象
NSURL *url = [NSURL URLWithString:str];
// 使用一个网址生成一个网络请求
NSURLRequest *request = [NSURLRequest requestWithURL:url];
// 让一个网页视图开始加载一个网络请求
[webView loadRequest:request];
// 允许页面缩放
webView.scalesPageToFit = YES;

- (void)reload;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

#pragma mark UIStepper

// 计步器，大小固定94*29，设置大小无效
UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(40, 60, 200, 40)];

// 计步器每次改变的大小
stepper.stepValue = 30;
// 设置最小和最大的记录
stepper.minimumValue = 10;
stepper.maximumValue = 300;
// 设置渲染色
stepper.tintColor = [UIColor redColor];
// 设置加号和减号的图片
[stepper setIncrementImage:[UIImage imageNamed:@"haoyou"] forState:UIControlStateNormal];
[stepper setDecrementImage:[UIImage imageNamed:@"liaotian"] forState:UIControlStateNormal];

#pragma mark UIProgressView

// 进度条（展示用的）高度固定位2
UIProgressView *pv = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 300, 280, 80)];
[pv setProgress:(sender.value-10)/290.0 animated:YES];

#pragma mark  UIAlertView

// alertView的点击事件（必须遵守协议，成为代理才能响应）
// 如果一个页面有多个av,在点击事件里，需要先通过av的tag值区分出点击的是哪一个av，然后再通过buttonIndex区分出点击了av的哪一个按钮
UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"标题" message:@"信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"其他",@"其他2", nil];
[av show];
// 代理一般实现方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
// 添加文本输入框
av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;

#pragma mark UIActionSheet

// 创建一个事件列表
UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"dt" otherButtonTitles:@"qq", @"weixin", @"weibo", nil];
// 展示的view必须是出现在window里的
[as showInView:self.view];
