//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Cloudox on 2017/3/6.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *logBtn;

- (void)notHas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 输出类的属性列表、方法列表、成员变量列表、协议列表
    [self logInfo];
    
    // 调用不存在的方法
    self.logBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 20)];
    [self.logBtn setTitle:@"测 试" forState:UIControlStateNormal];
    [self.logBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.logBtn addTarget:self action:@selector(notHas) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logBtn];
    
    // 关联对象
    static char associatedObjectKey;
    objc_setAssociatedObject(self, &associatedObjectKey, @"我就是要关联的字符串对象内容", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *theString = objc_getAssociatedObject(self, &associatedObjectKey);
    NSLog(@"关联对象：%@", theString);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"notFind!");
    // 给本类动态添加一个方法
    if ([NSStringFromSelector(sel) isEqualToString:@"notHas"]) {
        class_addMethod(self, sel, (IMP)runAddMethod, "v@:*");
    }
    return YES;
}

// 要动态添加的方法
 void runAddMethod(id self, SEL _cmd, NSString *string) {
     NSLog(@"动态添加一个方法来提示%@",string);
}

// 输出类的一些信息
- (void)logInfo {
    unsigned int count;// 用于记录列表内的数量，进行循环输出
    
    // 获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property --> %@", [NSString stringWithUTF8String:propertyName]);
    }
    
    // 获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i=0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method --> %@", NSStringFromSelector(method_getName(method)));
    }
    
    // 获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i=0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar --> %@", [NSString stringWithUTF8String:ivarName]);
    }
    
    // 获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i=0; i < count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol --> %@", [NSString stringWithUTF8String:protocolName]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
