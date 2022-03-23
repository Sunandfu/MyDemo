//
//  ViewController.m
//  HFPermissionChecker
//
//  Created by hui hong on 2019/1/24.
//  Copyright © 2019 hui hong. All rights reserved.
//

#import "ViewController.h"
#import "HFPermissionChecker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeNotification completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeLocation completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeMicrophone completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeCamera completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
    
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypePhoto completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
    
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeContacts completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
    
//    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeCalendar completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
//        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
//    }];
    
    [HFPermissionChecker permissionChecker:HFPermissionCheckerTypeReminder completeBlock:^(BOOL allowed, HFPermissionStatus status, HFPermissionCheckerType permissionType) {
        NSLog(@"allowed is %@, status is %@, permissionType is %@", @(allowed), @(status), @(permissionType));
    }];
}


@end
