//
//  WSAuthCode.h
//  AuthCode验证码
//
//  Created by iMac on 16/9/19.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

//取材库类型
typedef enum {
    BlendWordAndNumbers, //混合
    OnlyNumbers,         //只有数字
    OnlyWord ,           //只有字母
} AllWordArraytypes;

//字符间距
typedef enum  {
    WordSpacingTypeNone,   //没有间距(0)
    WordSpacingTypeSmall,  //间距较小(10)
    WordSpacingTypeMedium, //间距中等(20)
    WordSpacingTypeBig,    //间距较大(40)
} WordSpacingTypes;


@interface WSAuthCode : UIView

/******************基本功能************************/

//取材库类型(默认为BlendWordAndNumbers类型)
@property(nonatomic,assign)AllWordArraytypes allWordArraytype;

//验证码字符串
@property(nonatomic,strong)NSString *authCodeString;




/******************扩展功能************************/


//验证码的位数,默认为4位
@property(nonatomic,assign)NSInteger authCodeNumber;

//干扰线的条数,默认为2条
@property(nonatomic,assign)NSInteger disturbLineNumber;

//验证码的字体大小,默认为17号
@property(nonatomic,assign)NSInteger fontSize;

//验证码的字符间距,默认为中等
@property(nonatomic,assign)WordSpacingTypes wordSpacingType;

/*
 验证码字符串在SDauthCode的位置大小信息
 默认设置是  x --> 0
 y   --> SDauthCode高度的1/4
 witch --> SDauthCode的宽度
 height  --> SDauthCode高度的3/4
 */
@property(nonatomic,assign)CGRect authCodeRect;



/**
 @author Don9
 
 重写了系统的initWithFrame方法.
 
 @param frame 本地验证码的尺寸和大小
 
 @return  只要输入尺寸大小就可以直接创建出一个本地验证码View
 
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 @author Don9
 
 @param frame        验证码view的frame信息
 @param allWordArray 文字库类型
 
 @return 通过一个输入一个文字库参数的形式创建一个验证码View
 */
-(instancetype)initWithFrame:(CGRect)frame allWordArraytype:(AllWordArraytypes )allWordArraytype;



/**
 @author Don9
 
 刷新条形码的方法
 */
-(void)reloadAuthCodeView;


//开始验证   string是输入的字符串
- (BOOL)startAuthWithString:(NSString *)string;

@end
