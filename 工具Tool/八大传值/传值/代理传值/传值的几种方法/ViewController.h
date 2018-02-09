//
//  ViewController.h
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>

-(void)ViewControllerSendMessage:(NSString *)userName withPassword:(NSString *)password;

@end

@interface ViewController : UIViewController
@property(nonatomic,assign)id<ViewControllerDelegate>delegate;

@end

