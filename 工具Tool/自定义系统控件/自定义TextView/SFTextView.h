//
//  SFTextView.h
//  TestAdA
//
//  Created by lurich on 2020/11/27.
//  Copyright © 2020 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SFTextViewDelegate <NSObject>

- (void)sf_textViewDidChange:(UITextView *)textView;

- (BOOL)sf_textViewShouldBeginEditing:(UITextView *)textView;

@end

@interface SFTextView : UITextView

@property (nonatomic, assign) id<SFTextViewDelegate> sf_delegate;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic) CGFloat placeholderHeight;

@end

NS_ASSUME_NONNULL_END
