//
//  SFBaseViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/21.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBaseViewController.h"
#import "BaiduMobStatForSDK.h"

@interface SFBaseViewController ()

@end

@implementation SFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self updateFrameWithSize:self.view.bounds.size];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateFrameWithSize:size];
}
- (void)updateFrameWithSize:(CGSize)size{
    if (size.width>size.height) {
        
    } else {
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BaiduMobStatForSDK defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",[self class]] withAppId:@"718527995f"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BaiduMobStatForSDK defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",[self class]] withAppId:@"718527995f"];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@===%s",self.class,__func__);
}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
        if (isFollSys) {
            if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
                if (previousTraitCollection.userInterfaceStyle==UIUserInterfaceStyleLight) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySelectNight];
                } else {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeySelectNight];
                }
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
                self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
            }
        } else {
            BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
            if (isNignt) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
            } else {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            }
        }
    }
}
/**
 
 if (@available(iOS 13.0, *)) {
     headerView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
         BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
         if (isFollSys) {
             if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark) {
                 return [UIColor blackColor];
             } else {
                 return [UIColor whiteColor];
             }
         } else {
             BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
             if (isNignt) {
                 return [UIColor blackColor];
             } else {
                 return [UIColor whiteColor];
             }
         }
     }];
 } else {
     // Fallback on earlier versions
     headerView.backgroundColor = [UIColor whiteColor];
 };
 */

@end
