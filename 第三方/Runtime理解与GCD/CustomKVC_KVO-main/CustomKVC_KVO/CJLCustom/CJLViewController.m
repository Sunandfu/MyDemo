//
//  CJLViewController.m
//  CJLCustom
//
//  Created by - on 2020/10/29.
//  Copyright © 2020 CJL. All rights reserved.
//

#import "CJLViewController.h"
#import "CJLPerson.h"
#import "NSObject+CJLKVO.h"
#import <objc/runtime.h>

@interface CJLViewController ()
@property (nonatomic, strong)CJLPerson *person;
@end

@implementation CJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.person = [[CJLPerson alloc] init];
    
//    [self.person addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
    
//    [self.person cjl_addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionOld) context:NULL];
//    [self.person cjl_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    [self.person cjl_addObserver:self forKeyPath:@"nickName" handleBlock:^(id observer, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"nickName: %@ - %@", oldValue, newValue);
    }];
    
    [self.person cjl_addObserver:self forKeyPath:@"name" handleBlock:^(id observer, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"name: %@ - %@", oldValue, newValue);
    }];
    
//    self.person.nickName = @"CJL";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.nickName = [NSString stringWithFormat:@"%@+", self.person.nickName];
    self.person.name = [NSString stringWithFormat:@"%@$", self.person.name];
}

- (void)cjl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;{
    NSLog(@"%@", change);
}

- (void)dealloc
{
    NSLog(@"vc 走了");
//    [self.person removeObserver:self forKeyPath:@"nickName"];
//    [self.person removeObserver:self forKeyPath:@"name"];
}


@end
