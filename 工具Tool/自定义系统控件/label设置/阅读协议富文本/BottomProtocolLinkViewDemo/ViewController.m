//
//  ViewController.m
//  BottomProtocolLinkViewDemo
//
//  Created by liupenghui on 2021/9/18.
//

#define isIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//状态栏高度
#define StatusBarHeight (IS_iPhoneX ? 44.f : 20.f)

#define NavBarHeight                (iPhoneX ? 88.0f : 64.0f)
#define TabBarSafeBottomMargin      (iPhoneX ? 34.0f : 0)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#define iPhoneXX  (SCREEN_HEIGHT == 812.0f || SCREEN_HEIGHT == 896.0f || SCREEN_HEIGHT == 844.0f || SCREEN_HEIGHT == 926.0f)

#import "ViewController.h"

#import "WLoginProtocolLinkView.h"

@interface ViewController ()

/** <#name#> */
@property (nonatomic, strong) WLoginProtocolLinkView *wbProtocolLinkView;

/** <#name#> */
@property (nonatomic, strong) UITextField * textF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textF =  [[UITextField alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 80)];
    self.textF.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.textF];
    
    [self prepareNotificationEvent];
    
    NSArray * array = @[
        @{
            @"title":@"《用户协议》",
            @"link":@"www.baidu.com"
        },
        @{
            @"title":@"《隐私政策》",
            @"link":@"www.baidu.com"
        },
        @{
            @"title":@"《运营商服务协议》",
            @"link":@"www.baidu.com"
        }
    ];
    //以此方式存储协议 传进去即可
    //self.view.backgroundColor = [UIColor orangeColor];
    
    WLoginProtocolLinkView * linkView = [WLoginProtocolLinkView initWithProtocolList:[WLoginProtocolLinkModel linkItemArrayWith:array] checkBtnClickCallBack:^(BOOL checkBtnSelected) {
        NSLog(@"%d",checkBtnSelected);
    } protocolTapCallBack:^(NSInteger protocolTapIndex, NSString * _Nullable protocolTapLink) {
        NSLog(@"%ld---%@",protocolTapIndex,protocolTapLink);
    }];
    [self.view addSubview:linkView];
    self.wbProtocolLinkView = linkView;
    
    NSLog(@"------------%d-----------",iPhoneXX);
    
    NSLog(@"------------%p----%p-------",[linkView class],[WLoginProtocolLinkView class]);
    self.wbProtocolLinkView.frame = [self keyboardHiddenProtocolLinkFrame];
    
    
    NSArray * array3 = @[
    ];
//    linkView.protocoListArr = [WLoginProtocolLinkModel linkItemArrayWith:array3];
//    linkView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [linkView protocolLinkViewHeight]);
    // Do any additional setup after loading the view.
}

- (void)prepareNotificationEvent {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘动画结束时的frame
    NSTimeInterval timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型
    int height = keyboardRect.size.height;
    
    //your animation code
    __weak __typeof(self)weakself = self;
    [UIView animateWithDuration:timeInterval delay:0 options:curve animations:^{
        weakself.wbProtocolLinkView.frame = [weakself keyboardShowKeyBoardHeight:height];
        [weakself.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSLog(@"动画完成");
    }];
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = aNotification.userInfo;
    NSTimeInterval timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型
    //your animation code
    __weak __typeof(self)weakself = self;
    [UIView animateWithDuration:timeInterval delay:0 options:curve animations:^{
        weakself.wbProtocolLinkView.frame = [weakself keyboardHiddenProtocolLinkFrame];
        [weakself.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSLog(@"动画完成");
    }];
}


//当键盘出现或改变时调用
- (CGRect)keyboardShowKeyBoardHeight:(CGFloat )keyBoardHeight {
    return  CGRectMake(0, SCREEN_HEIGHT - keyBoardHeight - [self.wbProtocolLinkView protocolLinkViewHeight] , SCREEN_WIDTH, [self.wbProtocolLinkView protocolLinkViewHeight]);
}

//当键退出时调用
- (CGRect)keyboardHiddenProtocolLinkFrame {
    return  CGRectMake(0, SCREEN_HEIGHT - (iPhoneXX?22:0) - [self.wbProtocolLinkView protocolLinkViewHeight] , SCREEN_WIDTH, [self.wbProtocolLinkView protocolLinkViewHeight]);
}

float wbBaseBottomProtocolLinkOffset(void) {
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {
            return  49.0f;
        }
    }
    return 0;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textF resignFirstResponder];
}

@end
