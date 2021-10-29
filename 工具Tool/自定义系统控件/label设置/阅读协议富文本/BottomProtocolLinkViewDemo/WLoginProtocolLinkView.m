//
//  WLoginProtocolLinkView.m
//  WLogin_Lite
//
//  Created by liupenghui on 2021/9/15.
//

#define kLoginSDKAgreeViewTopMargin       6 // 协议文本距离本view上下高度 不要轻易设置哈

#define kLoginSDKProtocolCheckBoxSize     27 //按钮大小。 不要轻易设置哈

#define kLoginSDKProtocolLeftGap          30 //协议最长约束的左右边界

#define kLoginSDKProtocolWidth           [UIScreen mainScreen].bounds.size.width - (kLoginSDKProtocolLeftGap * 2) //协议加复选框 最大宽度

#define kLoginSDKProtocolTextWidth       kLoginSDKProtocolWidth - kLoginSDKProtocolCheckBoxSize //限制协议内容宽度

#define kLoginSDKProtocolLinkSign        @"和" //协议连接符号

#define kLoginSDKProtocolFontTitle       @"已阅读并同意" //头文案

#define kLoginSDKProtocolFontTail        @"，运营商将对您提供的手机号进行验证" //尾文案

#import "WLoginProtocolLinkView.h"

#import <Masonry/Masonry.h>


@implementation WLoginProtocolLinkModel

// 在这里转化
+ (WLoginProtocolLinkModel *)initWitDic:(NSDictionary *)infoDic{
    WLoginProtocolLinkModel * model = [[WLoginProtocolLinkModel alloc]init];
    model.title = infoDic[@"title"]?:@"";
    model.link = infoDic[@"link"]?:@"";
    return model;
}

+ (NSArray *)linkItemArrayWith:(NSArray *)linkInfoArray{
    NSMutableArray * itemArr = [NSMutableArray array];
    [linkInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemArr addObject:[WLoginProtocolLinkModel initWitDic:(NSDictionary *)obj]];
    }];
    return [itemArr copy];
}

@end


@implementation WLoginProtocolLinkViewConfig

+ (instancetype)sharedInstance {
    
    static WLoginProtocolLinkViewConfig * _sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WLoginProtocolLinkViewConfig alloc] init];
    });
    //设置默认配置
    _sharedInstance.lineSpacing = 6;
    _sharedInstance.checkBoxNormalImg = [UIImage imageNamed:@"agree_select_off"];
    _sharedInstance.checkBoxSelectImg = [UIImage imageNamed:@"agree_select_on"];
    _sharedInstance.protocolContentBackGroundColor = [UIColor clearColor];
    _sharedInstance.backGroundColor = [UIColor clearColor];
    _sharedInstance.protocolContentTextColor = [UIColor grayColor];
    _sharedInstance.protocolNormalTextColor = [UIColor blueColor];
    
    return _sharedInstance;
}


@end


@interface WLoginProtocolLinkView()

/** 复为本显示框 */
@property (nonatomic, strong) UITextView *agreementTextView;

@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) NSTextStorage *textStorage;
/** 复选框 */
@property (nonatomic, strong) UIButton *checkboxBtn;

/** 字体样式 */
@property (nonatomic, strong) NSMutableParagraphStyle *commonParaStyle;

//配置类
@property (nonatomic, strong) WLoginProtocolLinkViewConfig * config;

//按钮点击回调
@property (nonatomic, copy) void (^checkBtnClickCallBack)(BOOL checkBoxClic);

//点击协议回调
@property (nonatomic, copy) void (^protocolTapCallBack)(NSInteger protocolTapIndex,NSString * protocolTapLink);

@property (nonatomic, copy) WLoginProtocolLinkView * (^viewFrame)(CGRect);

@end

@implementation WLoginProtocolLinkView


+ (WLoginProtocolLinkView *)initWLoginProtocolLinkViewConfig:(WLoginProtocolLinkViewConfig * _Nullable)configer
                                            WithProtocolList:(NSArray *)protocolList
                                       checkBtnClickCallBack:(void(^)(BOOL checkBtnSelected))checkBtnClickCallBack
                                         protocolTapCallBack:(void(^)( NSInteger protocolTapIndex, NSString *  _Nullable protocolTapLink))protocolTapCallBack {
    WLoginProtocolLinkView * linkView = [[WLoginProtocolLinkView alloc]init];
    linkView.backgroundColor = [WLoginProtocolLinkViewConfig sharedInstance].backGroundColor;
    linkView.config = configer;
    // 配置类赋值在 协议列表之前
    linkView.protocoListArr = protocolList;
    linkView.checkBtnClickCallBack = checkBtnClickCallBack;
    linkView.protocolTapCallBack = protocolTapCallBack;
    return linkView;
}



+ (WLoginProtocolLinkView *)initWithProtocolList:(NSArray *)protocolList
                           checkBtnClickCallBack:(void(^)(BOOL checkBtnSelected))checkBtnClickCallBack
                             protocolTapCallBack:(void(^)(NSInteger protocolTapIndex,NSString *  _Nullable protocolTapLink))protocolTapCallBack {
    return [WLoginProtocolLinkView initWLoginProtocolLinkViewConfig:nil WithProtocolList:protocolList checkBtnClickCallBack:checkBtnClickCallBack protocolTapCallBack:protocolTapCallBack];
}

+ (WLoginProtocolLinkView *)makeCustomView:(void(^)(WLoginProtocolLinkView * customView))custom{
    WLoginProtocolLinkView * linkView = [WLoginProtocolLinkView new];
    
    [linkView makeCustomView:^(WLoginProtocolLinkView *linkView) {
        linkView.viewFrame(CGRectMake(0, 0, 100, 100));
    }];
    [linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
//    [linkView makeCustomView:^(WLoginProtocolLinkView *linkView) {
//        linkView.viewFrame().
//    }];
    return linkView;
}

- (WLoginProtocolLinkView *)makeCustomView:(void(^)(WLoginProtocolLinkView *linkView))linkViewBlock{
    if (linkViewBlock) {
        linkViewBlock(self);
    }
    return self;
}

- (WLoginProtocolLinkView * (^)(CGRect))viewFrame{
    
    WLoginProtocolLinkView * (^frame)(CGRect) = ^(CGRect frame){
        self.frame = frame;
        return self;
    };
    return frame;
}


- (instancetype)init {
    if (self == [super init]) {
        //问本显示框
        [self addSubview:self.agreementTextView];
        
        //布局类
        [self.layoutManager addTextContainer:self.textContainer];
        [self.textStorage addLayoutManager:self.layoutManager];
        
        //初始化按钮
        [self addSubview:self.checkboxBtn];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];

    //保持按钮和文案水平居中
    CGFloat checkBtnX = ([UIScreen mainScreen].bounds.size.width - ([self contentListSize].width + kLoginSDKProtocolCheckBoxSize))/2;
    self.checkboxBtn.frame = CGRectMake(checkBtnX, 0, kLoginSDKProtocolCheckBoxSize, kLoginSDKProtocolCheckBoxSize);
    self.agreementTextView.frame = CGRectMake(CGRectGetMaxX(self.checkboxBtn.frame), kLoginSDKAgreeViewTopMargin, [self contentListSize].width, [self contentListSize].height);
}

#pragma mark -- 文本布局

// 更新文本
- (void)upLoadText {
    
    NSDictionary *commonAttrDict = @{NSForegroundColorAttributeName:[WLoginProtocolLinkViewConfig sharedInstance].protocolContentTextColor,NSFontAttributeName:[UIFont systemFontOfSize:11],NSParagraphStyleAttributeName:self.commonParaStyle};
    
    NSDictionary *commonLinkDict = @{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[WLoginProtocolLinkViewConfig sharedInstance].protocolNormalTextColor,NSParagraphStyleAttributeName:self.commonParaStyle};
    
    //开头文案
    NSMutableAttributedString *mAttrText = [[NSMutableAttributedString alloc]initWithString:kLoginSDKProtocolFontTitle attributes:commonAttrDict];
    [self.textStorage setAttributedString:mAttrText];
    
    [self.protocoListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WLoginProtocolLinkModel * model = (WLoginProtocolLinkModel *)obj;
        NSString * protocolName =  model.title?:@"";
        NSAttributedString *agreementText = [[NSAttributedString alloc] initWithString:protocolName attributes:commonLinkDict];
        [self.textStorage appendAttributedString:agreementText];
        //遍历非最后一个 添加符号
        if (idx != self.protocoListArr.count - 1) {
            [self.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:kLoginSDKProtocolLinkSign attributes:commonAttrDict]];
        }
        
    }];
    
    NSAttributedString *tailText = [[NSAttributedString alloc] initWithString:kLoginSDKProtocolFontTail attributes:commonAttrDict];
    [self.textStorage appendAttributedString:tailText];
    
}


#pragma mark -- 布局元素计算
// 计算文本高度
- (CGSize)contentListSize {
    CGRect textRect = [self.textStorage boundingRectWithSize:CGSizeMake(kLoginSDKProtocolTextWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(textRect.size.width, textRect.size.height);
}

// 获取背景是图高度
- (CGFloat)protocolLinkViewHeight {
    return  [self contentListSize].height + kLoginSDKAgreeViewTopMargin*2;
}

// 获取背景是图宽度
- (CGFloat)protocolLinkViewWidth {
    if (([self contentListSize].width + kLoginSDKProtocolCheckBoxSize) <= kLoginSDKProtocolWidth) {
        return [self contentListSize].width + kLoginSDKProtocolCheckBoxSize;
    }
    return  kLoginSDKProtocolWidth + kLoginSDKProtocolCheckBoxSize;
}

- (void)setCheckBoxSelected:(BOOL)selected {
    self.checkboxBtn.selected = selected;
}

- (BOOL)checkBoxIsSelected {
    return self.checkboxBtn.selected;
}


#pragma mark -- 事件

// 协议隐私政策复选框
- (void)checkboxBtnClick:(UIButton *)checkBoxBtn {
    self.checkboxBtn.selected = !self.checkboxBtn.selected;
    if(self.checkBtnClickCallBack){
        self.checkBtnClickCallBack(self.checkboxBtn.selected);
    }
}

// 协议点击
- (void)agreementTextViewTouchClick:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]){
        UITapGestureRecognizer *tapGes = (UITapGestureRecognizer *)sender;
        CGPoint point = [tapGes locationInView:self.agreementTextView];
        // 取得当前点击是第几个文字
        NSInteger locgly = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.textContainer];
        
        NSInteger loginProtocolLength = [kLoginSDKProtocolFontTitle length];
        
        //确定点击的是第几个协议
        __block long clickPositionPoint = loginProtocolLength;
        
        [self.protocoListArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WLoginProtocolLinkModel * model = self.protocoListArr[idx];
            NSString * protocolName = model.title?:@"";
            NSString * protocolLink = model.link?:@"";
            if (!protocolName.length) {
                protocolLink = @"";
            }
            if (!protocolLink.length) {
                protocolName = @"";
            }
            long protocolAndSignLength = ([kLoginSDKProtocolLinkSign length] + protocolName.length);
            
            if (idx != self.protocoListArr.count - 1) {
                clickPositionPoint += protocolAndSignLength;
            }else{
                clickPositionPoint += protocolName.length;
            }
            if (locgly >= clickPositionPoint - protocolAndSignLength && locgly < clickPositionPoint) {
                if(self.protocolTapCallBack){
                    self.protocolTapCallBack(idx,protocolLink);
                }
            }
            
        }];
    }
}


#pragma mark -- 重新设置协议和

-(void)setProtocoListArr:(NSArray *)protocoListArr {
    if(_protocoListArr != protocoListArr){
        _protocoListArr = protocoListArr;
    }
    //重新更新文本布局
    [self upLoadText];
}


#pragma mark -- 懒加载
- (NSTextContainer *)textContainer {
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kLoginSDKProtocolTextWidth, MAXFLOAT)];
        _textContainer.lineFragmentPadding = 0;
    }
    return _textContainer;
}

- (NSLayoutManager *)layoutManager {
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
    }
    return _layoutManager;
}

- (NSTextStorage *)textStorage {
    if(!_textStorage){
        _textStorage = [[NSTextStorage alloc] init];
    }
    return _textStorage;
}

//文本属性
- (NSMutableParagraphStyle *)commonParaStyle {
    if (!_commonParaStyle) {
        _commonParaStyle =  [[NSMutableParagraphStyle alloc] init];
        _commonParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
        _commonParaStyle.lineSpacing = [WLoginProtocolLinkViewConfig sharedInstance].lineSpacing;
        [_commonParaStyle setAlignment:NSTextAlignmentCenter];
    }
    return _commonParaStyle;
}

//文本控件
- (UITextView *)agreementTextView {
    if (!_agreementTextView) {
        _agreementTextView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:self.textContainer];
        _agreementTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _agreementTextView.textContainerInset = UIEdgeInsetsZero;
        _agreementTextView.textAlignment = NSTextAlignmentCenter;
        _agreementTextView.showsVerticalScrollIndicator = NO;
        _agreementTextView.showsHorizontalScrollIndicator = NO;
        _agreementTextView.scrollEnabled = NO;
        _agreementTextView.editable = NO;
        _agreementTextView.selectable = NO;
        _agreementTextView.backgroundColor = [WLoginProtocolLinkViewConfig sharedInstance].protocolContentBackGroundColor;
        // 点击事件
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementTextViewTouchClick:)];
        [_agreementTextView addGestureRecognizer:tapGes];
    }
    return _agreementTextView;
}

- (UIButton *)checkboxBtn{
    if (!_checkboxBtn) {
        _checkboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkboxBtn setImage:[WLoginProtocolLinkViewConfig sharedInstance].checkBoxNormalImg forState:UIControlStateNormal];
        [_checkboxBtn setImage:[WLoginProtocolLinkViewConfig sharedInstance].checkBoxSelectImg forState:UIControlStateSelected];
        [_checkboxBtn addTarget:self action:@selector(checkboxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkboxBtn;;
}

@end
