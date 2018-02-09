//
//  MLEmojiLabel.h
//  MLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TTTAttributedLabel.h"


typedef NS_OPTIONS(NSUInteger, MLEmojiLabelLinkType) {
    MLEmojiLabelLinkTypeURL = 0,
    MLEmojiLabelLinkTypeEmail,
    MLEmojiLabelLinkTypePhoneNumber,
    MLEmojiLabelLinkTypeAt,
    MLEmojiLabelLinkTypePoundSign,
};


@class MLEmojiLabel;
@protocol MLEmojiLabelDelegate <NSObject>

@optional
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type;


@end

@interface MLEmojiLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式

@property (nonatomic, weak) id<MLEmojiLabelDelegate> emojiDelegate; //点击连接的代理方法

@property (nonatomic, copy) NSString *emojiText; //设置处理文字
/*****************示例代码*********************
 导入 #import "MLEmojiLabel.h"
 遵守 MLEmojiLabelDelegate 代理
 @property (nonatomic, strong) UIImageView *textBackImageView;
 @property (nonatomic, strong) MLEmojiLabel *emojiLabel;
 
 [self.view addSubview:self.textBackImageView];
 self.emojiLabel = [[MLEmojiLabel alloc]initWithFrame:CGRectMake(50, 100, 250, 10)];
 self.emojiLabel.emojiDelegate = self;
 self.emojiLabel.isNeedAtAndPoundSign = YES;
 [self.view addSubview:self.emojiLabel];
 //下面两行是自定义表情正则和图像plist的例子
 _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
 _emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
 [_emojiLabel setEmojiText:@"[微笑][白眼][NO][白眼][OK][愉快]---[冷汗][投降][抓狂][害羞]"];
 
 [self.emojiLabel setEmojiText:@"网址https://github.com/molon/MLEmojiLabel 阿苏打@用户 哈哈哈哈#话题# 电话18120136012 邮箱18120136012@qq.com"];
 
 CGRect backFrame = self.emojiLabel.frame;
 backFrame.origin.x -= 18;
 backFrame.size.width += 18+10+5;
 backFrame.origin.y -= 13;
 backFrame.size.height += 13+13+7;
 self.textBackImageView.frame = backFrame;
 
 - (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
 {
 switch(type){
 case MLEmojiLabelLinkTypeURL:
 NSLog(@"点击了链接%@",link);
 break;
 case MLEmojiLabelLinkTypePhoneNumber:
 NSLog(@"点击了电话%@",link);
 break;
 case MLEmojiLabelLinkTypeEmail:
 NSLog(@"点击了邮箱%@",link);
 break;
 case MLEmojiLabelLinkTypeAt:
 NSLog(@"点击了用户%@",link);
 break;
 case MLEmojiLabelLinkTypePoundSign:
 NSLog(@"点击了话题%@",link);
 break;
 default:
 NSLog(@"点击了不知道啥%@",link);
 break;
 }
 }
 - (UIImageView *)textBackImageView
 {
 if (!_textBackImageView) {
 UIImageView *imageView = [[UIImageView alloc]init];
 imageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg_ios7"]resizableImageWithCapInsets:UIEdgeInsetsMake(28, 18, 25, 10)] ;
 imageView.contentMode = UIViewContentModeScaleToFill;
 imageView.backgroundColor = [UIColor clearColor];
 imageView.clipsToBounds = YES;
 
 _textBackImageView = imageView;
 }
 return _textBackImageView;
 }
 */
@end
