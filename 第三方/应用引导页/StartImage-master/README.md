# StartImage
APP启动图，APP启动广告


# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/imageadasdadsadasd.png)


# How To Use

```ruby
#import "WSLaunchAD.h"
#import "ViewController.h"

#define kScreen_Bounds  [UIScreen mainScreen].bounds
#define kScreen_Height  [UIScreen mainScreen].bounds.size.height
#define kScreen_Width   [UIScreen mainScreen].bounds.size.width


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];

    //  1.设置启动页广告图片的url
    NSString *imgUrlString =@"http://imgstore.cdn.sogou.com/app/a/100540002/714860.jpg";

    //  GIF
    //  NSString *imgUrlString = @"http://img1.imgtn.bdimg.com/it/u=473895314,616407725&fm=206&gp=0.jpg";

    //  2.初始化启动页广告
    [WSLaunchAD initImageWithAttribute:6.0 showSkipType:SkipShowTypeAnimation setLaunchAd:^(WSLaunchAD *launchAd) {
    __block WSLaunchAD *weakWS = launchAd;

    //如果选择 SkipShowTypeAnimation 需要设置动画跳过按钮的属性
    [weakWS setAnimationSkipWithAttribute:[UIColor redColor] lineWidth:3.0 backgroundColor:nil textColor:nil];
    [weakWS.bottomImgView addSubview:[self bottomImageView]];

    [launchAd setWebImageWithURL:imgUrlString options:WSWebImageDefault result:^(UIImage *image, NSURL *url) {

        //  3.异步加载图片完成回调(设置图片尺寸)
        weakWS.launchAdViewFrame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-80);
        } adClickBlock:^{

            //  4.点击广告回调
            NSString *url = @"https://www.baidu.com";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
    }];

    //设置window 根控制器
    [self.window makeKeyAndVisible];

    return YES;
}

- (UIImageView *)bottomImageView {

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    imageV.userInteractionEnabled = YES;


    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, self.window.frame.size.height - 75, self.window.frame.size.width -40, 60)];
    label1.textColor = [UIColor colorWithRed:80/255.0 green:147/255.0 blue:235/255.0 alpha:1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"Zws-China";
    label1.font = [UIFont systemFontOfSize:35];
    [imageV addSubview:label1];

    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.window.frame.size.height - 20, self.window.frame.size.width, 20)];
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:10];
    label2.text = @"@2016 sinfotek Co.Ltd";
    [imageV addSubview:label2];
    
    return imageV;
}



```