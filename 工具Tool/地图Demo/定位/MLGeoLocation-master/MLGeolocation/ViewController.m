//
//  ViewController.m
//  MLGeolocation
//
//  Created by user on 16/5/6.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "ViewController.h"
#import "MLGeolocation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开启IP定位之前必须实现
    //[[MLGeolocation geolocation] setIPAddress:@"" withAK:@""];
    
//    [[MLGeolocation geolocation] getCurrentCor:@"" block:^(CGFloat corLat, CGFloat corLon) {
//        NSLog(@"%lf %lf", corLat, corLon);
//    } error:^(NSError *error) {
//        
//    }];
    
    [[MLGeolocation geolocation] getCurrentLocations:^(NSDictionary *curLoc) {
        NSLog(@"%@", curLoc);
    } isIPOrientation:NO error:^(NSError *error) {
        
    }];
    
    
//    [[MLGeolocation geolocation] getCurrentAddress:^(NSMutableDictionary *citys) {
//        NSLog(@"%@", citys);
//    } error:^(NSError *error) {
//        
//    }];
    
//    [[MLGeolocation geolocation] getLocAddress:@"" withLon:@"" address:^(NSMutableDictionary *citys) {
//        NSLog(@"%@", citys);
//    } error:^(NSError *error) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[MLGeolocation geolocation] getCurrentAddress:^(NSMutableDictionary *citys) {
        NSLog(@"%@", citys);
    } error:^(NSError *error) {

    }];
}
@end
