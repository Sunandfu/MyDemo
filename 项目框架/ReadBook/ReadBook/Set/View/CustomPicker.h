//
//  CustomPicker.h
//  MyPickerViewController
//
//  Created by 常新 顾 on 13-4-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface CustomPicker : NSObject

@property (nonatomic,retain) NSArray<NSDictionary *> *pickerDataArray;
@property (nonatomic,retain) UIPickerView  *pickerView;
@property (nonatomic,assign) id delegate;

+ (CustomPicker *)sharedInstance;

- (void)show;

- (void)dismiss;

- (void)updateFrame:(CGSize)size;

@end

@protocol CustomPickerDelegate <NSObject>

- (void)finishChoose:(CustomPicker *)myPicker;

@end
