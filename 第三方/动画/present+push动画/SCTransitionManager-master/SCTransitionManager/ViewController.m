//
//  ViewController.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/5.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "ViewController.h"
#import "SCPushTransition.h"
#import "SCPresentTransition.h"
#import "SCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Main VC";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    imageView.frame = CGRectMake(0, 64, 50, 50);
    [self.view addSubview:imageView];
    _avatarView = imageView;
}

- (IBAction)zoomPresent:(id)sender {
    SCViewController *vc = [[SCViewController alloc] init];
    vc.title = @"Second VC";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.view.backgroundColor = [UIColor orangeColor];
    
    [SCPresentTransition presentViewController:nav sourceView:self.avatarView targetView:vc.avatarView animated:YES completion:^{
        NSLog(@"zoomPresent done!!");
    }];
}

- (IBAction)normalPresent:(id)sender {
    SCViewController *vc = [[SCViewController alloc] init];
    vc.title = @"Second VC";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.view.backgroundColor = [UIColor orangeColor];
    
    [SCPresentTransition presentViewController:nav animated:YES completion:^{
        NSLog(@"normalPresent done!!");
    }];
}

- (IBAction)zoomPush:(id)sender {
    SCViewController *vc = [[SCViewController alloc] init];
    vc.title = @"Second VC";
    vc.view.backgroundColor = [UIColor orangeColor];
    [SCPushTransition pushViewController:vc sourceView:self.avatarView targetView:vc.avatarView animated:YES completion:^{
        NSLog(@"zoomPush done!!");
    }];
}

- (IBAction)normalPush:(id)sender {
    SCViewController *vc = [[SCViewController alloc] init];
    vc.title = @"Second VC";
    vc.view.backgroundColor = [UIColor orangeColor];

    SCViewController *vc2 = [[SCViewController alloc] init];
    vc2.title = @"Third VC";
    vc2.view.backgroundColor = [UIColor greenColor];
    
    [SCPushTransition pushViewControllers:@[vc, vc2] animated:YES completion:^{
        NSLog(@"done!!!!!!!");
    }];
}

@end
