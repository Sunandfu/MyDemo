//
//  ViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-10-31.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import "ViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <objc/runtime.h>

#import "BannerViewController.h"
#import "InterstitialViewController.h"
#import "SplashViewController.h"
#import "NativeViewController.h"
#import "NativeExpressAdViewController.h"
#import "NativeExpressVideoAdViewController.h"
#import "RewardVideoViewController.h"
#import "UnifiedNativeAdViewController.h"

@interface ViewController ()


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIStoryboard *storyBoard;


@end

@implementation ViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.demoArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = self.demoDict[self.demoArray[indexPath.row]];
    if (class_isMetaClass(object_getClass(item))) {
        UIViewController *vc = [self.storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass(item)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([item isKindOfClass:[NSString class]]) {
        UIViewController *vc = [[NSClassFromString(item) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *idfaCopyedMsg = [NSString stringWithFormat:@"%@\n 已经复制到你的粘贴板",idfa];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:idfaCopyedMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        sync idfa to pasteboard
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = idfa;
        [alert show];
    }
}

#pragma mark - property getter
- (UIStoryboard *)storyBoard
{
    if (!_storyBoard) {
        _storyBoard = [UIStoryboard storyboardWithName:@"GDTStoryboard" bundle:nil];
    }
    return _storyBoard;
}

- (NSMutableArray *)demoArray
{
    if (!_demoArray) {
        _demoArray = [@[@"Banner",
                        @"插屏",
                        @"原生广告",
                        @"开屏广告",
                        @"原生模板广告",
                        @"原生视频模板广告",
                        @"激励视频广告",
                        @"自渲染2.0",
                        @"获取IDFA"] mutableCopy];
    }
    return _demoArray;
}

- (NSMutableDictionary *)demoDict
{
    if (!_demoDict) {
        _demoDict = [@{@"Banner": [BannerViewController class],
                       @"插屏": [InterstitialViewController class],
                       @"原生广告": [NativeViewController class],
                       @"开屏广告": [SplashViewController class],
                       @"原生模板广告": [NativeExpressAdViewController class],
                       @"原生视频模板广告": [NativeExpressVideoAdViewController class],
                       @"激励视频广告": [RewardVideoViewController class],
                       @"自渲染2.0": [UnifiedNativeAdViewController class],
                       @"获取IDFA": @(1),
                       } mutableCopy];
    }
    return _demoDict;
}

@end
