//
//  LSYPickerButtomView.h
//  AlbumPicker
//
//  Created by okwei on 15/7/27.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYPickerButtomViewDelegate <NSObject>
-(void)previewButtonClick;
-(void)sendButtonClick;
@end
@interface LSYPickerButtomView : UIView
@property (nonatomic,weak) id<LSYPickerButtomViewDelegate> delegate;
-(void)setSendNumber:(int)number;
@end

@interface LSYSendButton : UIButton
-(void)setSendNumber:(int)number;
@end