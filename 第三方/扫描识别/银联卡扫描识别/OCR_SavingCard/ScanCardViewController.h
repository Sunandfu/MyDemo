//
//  ScanCardViewController.h
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^passValue)(NSString* cardNo);
@interface ScanCardViewController : UIViewController
- (void)passValue:(passValue)block;
@end
