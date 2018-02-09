
/*!
 *  @header BAKit.h
 *          BABaseProject
 *
 *  @brief  BAKit
 *
 *  @author 博爱
 *  @copyright    Copyright © 2016年 博爱. All rights reserved.
 *  @version    V1.0
 */

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

/*
 
 *********************************************************************************
 *
 * 在使用BAKit的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ     : 可以添加SDAutoLayout群 497140713 在这里找到我(博爱1616【137361770】)
 * 微博    : 博爱1616
 * Email  : 137361770@qq.com
 * GitHub : https://github.com/boai
 * 博客园  : http://www.cnblogs.com/boai/
 * 博客    : http://boai.github.io
 
 *********************************************************************************
 
 */

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

/*! 本地通知回调 */
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"去看直播...(用于测试阶段)"message:notMess delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"确定",nil];
    [alert show];
    // 图标上的数字减1
    //    application.applicationIconBadgeNumber -= 1;
    //    NSLog(@"didReceiveLocalNotification");
    
    
    // 更新显示的badge个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
}

/*! 代理方法 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is : %li",(long)buttonIndex);
    
    switch (buttonIndex)
    {
            // 取消
        case 0:
            return;
            break;
            // 确定
        case 1:
            [self moveToVC];
            break;
            
        default:
            break;
    }
    
}

// 实现跳转
- (void)moveToVC
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
}

@end
