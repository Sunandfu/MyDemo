//
//  GlobalUtil.m
//  TvBuy
//
//  Created by qianhe on 14/6/25.
//  Copyright (c) 2014年 Beijing CHSY E-Business Co., Ltd. All rights reserved.
//

#import "GlobalUtil.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#define kShowHudDelayed 0.5

@implementation GlobalUtil

#pragma mark 判断是否有网络
+(BOOL)networkIsPing
{
    /*监测网络状态*/
    
    BOOL isServerAvailable = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if (([reachability connectionRequired]) || (NotReachable == reachability.currentReachabilityStatus)) {
        isServerAvailable = NO;
        
    } else if((ReachableViaWiFi == reachability.currentReachabilityStatus) || (ReachableViaWWAN == reachability.currentReachabilityStatus)){
        isServerAvailable = YES;
    }
    
    //    NSString *hostName = @"www.baidu.com";
    //    Reachability *hostReach = [Reachability reachabilityWithHostName:hostName];
    //    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    //    if (netStatus == NotReachable)
    //    {
    //        return NO;
    //    }
    //    return YES;
    return isServerAvailable;
    //    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)networkIsWIFI{
    BOOL isServerAvailable = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if (([reachability connectionRequired]) || (NotReachable == reachability.currentReachabilityStatus)) {
        isServerAvailable = NO;
        
    } else if((ReachableViaWiFi == reachability.currentReachabilityStatus)){
        isServerAvailable = YES;
    }
    return YES;
}

#pragma mark 正则匹配手机号

+ (BOOL)validateMobileNumber:(NSString *)string
{
    static NSString *tempStr = @"^((\\+86)?|\\(\\+86\\))0?1[34578]\\d{9}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)validatePostCodeNumber:(NSString *)string
{
    static NSString *tempStr = @"^[1-9]\\d{5}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)validatePassword:(NSString *)string
{
    
    static NSString *tempStr = @"^[^\\s\u4e00-\u9fa5]{6,16}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
}

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    if ([msg isEqualToString:@"接口调用失败，请联系技术人员"]) {
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (BOOL)isEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (str == nil || [str length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)showDelayProgressHudOnViewController:(UIViewController *)mainViewController withType:(MBProgressHUDNative )hudType
{
    double delayInSeconds = kShowHudDelayed;
    
    __block UIViewController* bself = mainViewController;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([mainViewController respondsToSelector:@selector(requestFinished)] && ![mainViewController performSelector:@selector(requestFinished)] ) {
            [MBProgressHUD showHUDAddedTo:bself.view animated:YES andType:hudType];
        }
    });
}

+( MBProgressHUD *)showMBProgressHudOnView:(UIView *)view withTitle:(NSString *)title
{
    if ([title isEqualToString:@"接口调用失败，请联系技术人员"])
    {
        return nil;
    }
    if ([title isEqualToString:@"请稍候..."])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES andType:MBProgressHUDNativeYES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = title;
        hud.userInteractionEnabled = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
        return hud;
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES andType:MBProgressHUDNativeYES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = title;
        hud.margin = 10.f;
        hud.tag = 100000;
        hud.userInteractionEnabled = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        return nil;
    }
    return nil;
}

+ (void)hideProgressHudOfView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideProgressHud:(UIViewController *)mainViewController
{
    [MBProgressHUD hideHUDForView:mainViewController.view animated:YES];
}

+ ( MBProgressHUD *)showMBProgressHudOnController:(UIViewController *)viewController withTitle:(NSString *)title
{
    if ([title isEqualToString:@"接口调用失败，请联系技术人员"])
    {
        return nil;
    }
    if ([title isEqualToString:@"请稍候..."])
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES andType:MBProgressHUDNativeYES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = title;
        hud.userInteractionEnabled = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
        return hud;
        
    }
    if (viewController && viewController.view) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES andType:MBProgressHUDNativeYES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = title;
        hud.margin = 10.f;
        hud.tag = 100000;
        hud.userInteractionEnabled = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
        [hud hide:YES afterDelay:2];
        return nil;
        
    }
    else
    {
        return nil;
        
    }
    
}


+ (void)showCompleteOnController:(UIViewController *)viewController andTitle:(NSString *)title
{
    if ([title isEqualToString:@"接口调用失败，请联系技术人员"]) {
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated:YES andType:MBProgressHUDNativeYES];
    [viewController.navigationController.view addSubview:hud];
    
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = title;
    hud.userInteractionEnabled = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

+ (void)showLoadingOnController:(UIViewController *)viewController andTitle:(NSString *)title
{
    if ([title isEqualToString:@"接口调用失败，请联系技术人员"]) {
    }
    double delayInSeconds = kShowHudDelayed;
    
    __block UIViewController* bself = viewController;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([viewController respondsToSelector:@selector(requestFinished)] && ![viewController performSelector:@selector(requestFinished)] ) {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:viewController.navigationController.view andType:MBProgressHUDNativeYES];
            [bself.navigationController.view addSubview:hud];
            hud.labelText = title;
            hud.minSize = CGSizeMake(135.f, 135.f);
            [hud show:YES];
        }
    });
}

-(void)requestFinished
{

}


+ (void)callAndBack:(NSString *)phoneNum {
    //    NSString *phoneNum = @"10086";// 电话号码
    
    //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    //NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phoneNum];
    
    //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}


//是否是纯数字
+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"(/^[0-9]*$/)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
    
}

//身份证号码校验
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


//姓名验证
+ (BOOL)checkUserName:(NSString *)userName{
    //不能含有数字标点
    NSString *regex=@"^[A-Za-z /\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"不能含有数字或标点符号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    // 不能字母+汉字
    NSString *regex1 = @"^(([A-Za-z]+)[\u4e00-\u9fa5]+)$";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    if ([predicate1 evaluateWithObject:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"字母后面不能加汉字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;

}
+ (NSDictionary *)analyzeRequestDataOfJSON:(id)responseObject{
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
    return dic;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
@end
