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

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface ViewController ()


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIStoryboard *storyBoard;
@property (nonatomic, strong) NSArray *demoArray;
@property (nonatomic, strong) NSDictionary *demoDict;

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
    } else {
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:idfa delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (NSArray *)demoArray
{
    if (!_demoArray) {
        _demoArray = @[@"Banner",
                       @"插屏",
                       @"原生广告",
                       @"开屏广告",
                       @"原生模板广告",
                       @"原生视频模板广告",
                       @"获取IDFA"];
    }
    return _demoArray;
}

- (NSDictionary *)demoDict
{
    if (!_demoDict) {
        _demoDict = @{@"Banner": [BannerViewController class],
                      @"插屏": [InterstitialViewController class],
                      @"原生广告": [NativeViewController class],
                      @"开屏广告": [SplashViewController class],
                      @"原生模板广告": [NativeExpressAdViewController class],
                      @"原生视频模板广告": [NativeExpressVideoAdViewController class],
                      @"获取IDFA": @"",
                      };
    }
    return _demoDict;
}

@end
