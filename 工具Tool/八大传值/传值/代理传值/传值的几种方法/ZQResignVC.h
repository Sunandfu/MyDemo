//
//  ZQResignVC.h
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/28.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQResignVCDelegate <NSObject>

-(void)sendMessage:(NSString *)userName withPassword:(NSString *)password;

@end

@interface ZQResignVC : UIViewController
@property(nonatomic,assign)id<ZQResignVCDelegate> delegate;
@end
