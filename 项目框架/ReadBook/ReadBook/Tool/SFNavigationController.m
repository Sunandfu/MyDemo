//
//  SFNavigationController.m
//  ReadBook
//
//  Created by lurich on 2020/5/18.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFNavigationController.h"

@interface SFNavigationController ()

@end

@implementation SFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;;
}

@end
