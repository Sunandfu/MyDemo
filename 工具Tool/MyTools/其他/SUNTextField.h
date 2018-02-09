//
//  SUNTextField.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-8-21.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUNTextField : UITextField
{
    UILabel *_customerLeftView;
    UIColor *_placeHolderColor;
    CGFloat _cornerRadius;
    UIColor *_backgroundColor;
}

@property (nonatomic, strong) UILabel *customerLeftView;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;
/*
 *******************************************************
 UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, self.textFieldName.frame.size.height)];
 leftView.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
 leftView.textColor = [UIColor colorWithRed:99/225.0f green:102/225.0f blue:103/225.0f alpha:1.0f];
 leftView.text = @"姓名";
 leftView.font = [UIFont boldSystemFontOfSize:17];
 leftView.textAlignment = UITextAlignmentCenter;
 self.textFieldName.customerLeftView = leftView;
 self.textFieldName.leftViewMode = UITextFieldViewModeAlways;
 self.textFieldName.backgroundColor = [UIColor whiteColor];
 self.textFieldName.cornerRadius = 6.0f;
 *******************************************************
 */
@end
