//
//  SFCustomPicker.h
//  LunchAd
//
//  Created by Lurich on 2018/5/21.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ClickedOkBtn)(NSString *selectedStr);

@interface SFCustomPicker : NSObject

@property (nonatomic,copy) NSArray<NSString *> *pickerDataArray;
@property (nonatomic,copy) NSString  *titleStr;

@property (nonatomic,strong) ClickedOkBtn clickedOkBtn;

+ (SFCustomPicker *)sharedInstance;

- (void)show;

- (void)dismiss;

@end
