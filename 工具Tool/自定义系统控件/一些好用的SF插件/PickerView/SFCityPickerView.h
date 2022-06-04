//
//  SFCityPickerView.h
//  城市选择
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *provinceStr,NSString *cityStr,NSString *districtStr);

@interface SFCityPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) MyBlock finishBlock;

- (void)show;

@end
