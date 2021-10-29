//
//  WLoginProtocolLinkView.h
//  WLogin_Lite
//
//  Created by liupenghui on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark -- 模型类

@interface WLoginProtocolLinkModel : NSObject

//标题
@property (nonatomic, copy) NSString *title;

//链接
@property (nonatomic, copy) NSString *link;


+ (WLoginProtocolLinkModel *)initWitDic:(NSDictionary *)infoDic;

+ (NSArray *)linkItemArrayWith:(NSArray *)linkInfoArray;

@end


#pragma mark -- 配置类

@interface WLoginProtocolLinkViewConfig : NSObject

+ (instancetype)sharedInstance;


//行高
@property (nonatomic, assign) CGFloat lineSpacing;

/** 复选框未选中图片 */
@property (nonatomic, strong) UIImage *checkBoxNormalImg;

/** 复选框选中图片 */
@property (nonatomic, strong) UIImage *checkBoxSelectImg;

/** 协议文本背景颜色 */
@property (nonatomic, strong) UIColor *protocolContentBackGroundColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *backGroundColor;

/** 协议文本颜色 */
@property (nonatomic, strong) UIColor *protocolContentTextColor;

/** 普通文本颜色 */
@property (nonatomic, strong) UIColor *protocolNormalTextColor;


@end



#pragma mark -- 内容View

@interface WLoginProtocolLinkView : UIView


/** 重新设置协议列表  注意 重新设置完协议之后  本身宽高发生变化需要重新设置frame*/
@property (nonatomic, strong) NSArray *protocoListArr;

+ (WLoginProtocolLinkView *)initWLoginProtocolLinkViewConfig:(WLoginProtocolLinkViewConfig * _Nullable)configer
                                            WithProtocolList:(NSArray *)protocolList
                                       checkBtnClickCallBack:(void(^)(BOOL checkBtnSelected))checkBtnClickCallBack
                                         protocolTapCallBack:(void(^)(NSInteger protocolTapIndex,NSString * _Nullable protocolTapLink))protocolTapCallBack;


/// 初始化方法  设置frame之前一定要调用此方法
/// @param protocolList  协议列表
/// @param checkBtnClickCallBack 点击复选框回调事件
/// @param protocolTapCallBack 点击协议回调事件;

+ (WLoginProtocolLinkView *)initWithProtocolList:(NSArray *)protocolList
                           checkBtnClickCallBack:(void(^)(BOOL checkBtnSelected))checkBtnClickCallBack
                             protocolTapCallBack:(void(^)(NSInteger protocolTapIndex,NSString * _Nullable protocolTapLink))protocolTapCallBack;


/// 初始化协议内容计算本身高度
- (CGFloat)protocolLinkViewHeight;

/// 初始化协议内容计算本身宽度
- (CGFloat)protocolLinkViewWidth;

/// 设置复选框选中状态
/// @param selected YES 选中 NO 不选中
- (void)setCheckBoxSelected:(BOOL)selected;

/// 获取复选框选中状态
- (BOOL)checkBoxIsSelected;

@end

NS_ASSUME_NONNULL_END
