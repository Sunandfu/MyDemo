
#pragma mark 修改textFieldplaceholder字体颜色和大小
textField.placeholder = @"username is in here!";
[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
[textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"]

#pragma mark 默认选中第一个cell
NSInteger selectedIndex = 0;
NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];

[_leftSiftTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

#pragma mark 设置btn上的字左对齐
timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

timeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);

#pragma mark 改变UILable字体大小，使内容自适应
1.方法一：
lab.adjustsFontSizeToFitWidth=YES;
2.方法二：
label.numberOfLines = 0;
label.lineBreakMode = NSLineBreakByWordWrapping;

#pragma mark 关于右划返回上一级
//自定义leftBarButtonItem后无法启用系统自带的右划返回可以再设置以下代码

self.navigationController.interactivePopGestureRecognizer.delegate = self;

#pragma mark 去掉导航栏下边的黑线
[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

#pragma mark tableView头部视图下拉放大效果
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.HeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, HeadImgHeight)];
    self.HeadImgView.image = [UIImage imageNamed:@"eee"];
    
    [self.tableView addSubview:self.HeadImgView];
    
    // 与图像高度一样防止数据被遮挡
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, HeadImgHeight)];
}

/**
 *  重写这个代理方法就行了，利用contentOffset这个属性改变frame
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        self.HeadImgView.frame = CGRectMake(offsetY/2, offsetY, Width - offsetY, HeadImgHeight - offsetY);  // 修改头部的frame值就行了
    }
    
    /* 往上滑动contentOffset值为正，大多数都是监听这个值来做一些事 */
}
#pragma mark iOS 7 转场动画
// 遵守代理  UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.animate;//自定义动画
    }else{
        return nil;
    }
    
}

#pragma mark 毛玻璃效果
UIToolbar *blurView = [[UIToolbar alloc] init];
blurView.barStyle = UIBarStyleDefault;
blurView.frame = self.view.bounds;
[webView addSubview:blurView];

##窗口中有多个responder,如何快速释放键盘
一：[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
二：[self.view endEditing:YES];

##如何去除UITableView中Group样式cell的边框
一： UIView *tempView = [[UIView alloc] init];
[cell setBackgroundView:tempView];
[cell setBackgroundColor:[UIColor clearColor]];
二：tableView.separatorColor=[UIColor clearColor];

##如何解决colorWithPatternImage设置view背景色太占内存问题
self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@”main_landscape.jpg”]];
切换成self.view.layer.contents =[UIImage imageNamed:@”name.png”].CGImage;

##App升级后如何删除NSUserDefaults全部数据
//APP升级后，UserDefaults中原有的plist是不会删除的，除非用户卸载APP
NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

##如何修改图片颜色
//先设置图片的渲染模式为UIImageRenderingModeAlwaysTemplate，再设置tintcolor
self.imageView.image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
self.imageView.tintColor = [UIColor redColor];

##[UIScreen mainScreen].bounds获取屏幕大小不对的问题
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208),[[UIScreen mainScreen] currentMode].size) : NO)
//在设置父视图的时候，只对父视图的透明度进行更改，而不影响它上面子视图的透明度。
父视图.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

在标准模式下
6+：
[[UIScreen mainScreen] currentMode].size为{1242，2208}
[UIScreen mainScreen].bounds.size为{414，736}

6:
[[UIScreen mainScreen] currentMode].size为{750，1334}
[UIScreen mainScreen].bounds.size为{375，667}

#pragma mark Xcode 统计代码行数
//如果要统计ios开发代码，包括头文件的，终端命令进入项目目录下，命令如下

列出每个文件的行数
find . -name "*.m" -or -name "*.h" -or -name "*.xib" -or -name "*.c" |xargs wc -l

列出代码行数总和
find . -name "*.m" -or -name "*.h" -or -name "*.xib" -or -name "*.c" |xargs grep -v "^$"|wc -l

1备注1 grep -v "^$"是去掉空行
注释也统计在代码量之内，毕竟也一个字一个字码出来的


#pragma mark - NSParagraphStyleAttributeName 段落的风格
 /*
 NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
 paragraphStyle.lineSpacing = 10;// 字体的行间距
 paragraphStyle.firstLineHeadIndent = 20.0f;//首行缩进
 paragraphStyle.alignment = NSTextAlignmentJustified;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
 paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
 paragraphStyle.headIndent = 20;//整体缩进(首行除外)
 paragraphStyle.tailIndent = 20;//
 paragraphStyle.minimumLineHeight = 10;//最低行高
 paragraphStyle.maximumLineHeight = 20;//最大行高
 paragraphStyle.paragraphSpacing = 15;//段与段之间的间距
 paragraphStyle.paragraphSpacingBefore = 22.0f;//段首行空白空间，前一段的底部到这一段的顶部之间的距离
 paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;//从左到右的书写方向（一共➡️三种）
 paragraphStyle.lineHeightMultiple = 15;// Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height.
 paragraphStyle.hyphenationFactor = 1;//连字属性 在iOS，唯一支持的值分别为0和1
 
 NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 */
#pragma mark - 创建毛玻璃特效
//  创建需要的毛玻璃特效类型
UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//  毛玻璃view 视图
UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//添加到要有毛玻璃特效的控件中
effectView.frame = self.view.bounds;
[self.view addSubview:effectView];
//设置模糊透明度
effectView.alpha = 0.9;

//获取当前屏幕显示的viewcontroller
//  当前控制器含有导航栏
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
        else
            result = window.rootViewController;
            
            return result;
}
//  当前控制器不含导航栏
- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}






