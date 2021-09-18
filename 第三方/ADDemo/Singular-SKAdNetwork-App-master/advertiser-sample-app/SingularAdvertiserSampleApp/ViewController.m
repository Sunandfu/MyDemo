//
//  ViewController.m
//  SingularAdvertiserSampleApp
//
//  Created by Eyal Rabinovich on 25/06/2020.
//

#import "ViewController.h"

//重要提示：在“构建阶段”选项卡中添加AppTrackingTransparency.framework。
#import <AppTrackingTransparency/ATTrackingManager.h>

//别忘了导入此文件以访问SKAdnetwork框架
#import <StoreKit/SKAdNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showTrackingConsentDialog:(id)sender {
    //在调用跟踪同意对话框之前检查操作系统版本，该对话框仅在iOS 14及更高版本中可用
    if (@available(iOS 14, *)) {
        //如果跟踪授权状态不是“未确定”，则表示已显示“跟踪同意”对话框。
        //“trackingAuthorizationStatus”保留跟踪同意对话框的结果，只能通过iOS设置屏幕进行更改。
        //跟踪同意对话框每次安装只显示一次，这意味着调用'requestTrackingAuthorizationWithCompletionHandler'将不会再次显示该对话框。
        if ([ATTrackingManager trackingAuthorizationStatus] != ATTrackingManagerAuthorizationStatusNotDetermined){
            [self alertTrackingConsentIsAlreadySet];
        }
        
        //在显示“跟踪同意”对话框之前，您需要将“隐私-跟踪使用说明”添加到应用程序的info.plist中。
        //如果不添加它，将引发异常。
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            //这里我们得到了对话框的结果
            //如果调用了两次“requestTrackingAuthorizationWithCompletionHandler”，则将调用两次完成处理程序，但第一次将显示对话框。
            //第二次调用此方法时，将使用“trackingAuthorizationStatus”返回的值调用完成处理程序`
        }];
    } else {
        //无需在早期版本中显示该对话框
    }
}

- (IBAction)updateConversionValueClick:(id)sender {
    //一旦第一次调用“RegisterAppforadNetworkAttribute”
    //（请查看AppDelegate.m以了解有关“RegisterAppForadNetworkAttribute”的解释），
    //将打开一个24小时窗口，以更新属性数据的转换值。
    //使用'UpdateVersionValue'，我们可以添加一个值（0-63之间的数字）与属性通知一起发送。每次调用此方法时，我们都会启动一个新的24小时窗口，直到通知延迟。
    //请注意，调用'UpdateVersionValue'仅在首次调用'RegisterAppForadNetworkAttribute'后的前24小时内有效。
    //24小时后的任何呼叫都不会更新归属通知中的转换值。
    [SKAdNetwork updateConversionValue:3];
    [self alertConversionValueUpdated];
}

- (IBAction)showSingularClick:(id)sender {
    NSURL* singular = [NSURL URLWithString:@"https://www.singular.net?utm_medium=sample-app&utm_source=sample-app-advertiser"];
    
    if( [[UIApplication sharedApplication] canOpenURL:singular]){
        [[UIApplication sharedApplication] openURL:singular options:[[NSDictionary alloc] init] completionHandler:nil];
    }
}

- (void)alertConversionValueUpdated {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"转换值更新！"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertTrackingConsentIsAlreadySet {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法显示对话框"
                                                                   message:@"无法显示跟踪同意对话框，因为它已显示。"
                                                                           @"若要再次查看此对话框，请删除并重新安装此应用。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
