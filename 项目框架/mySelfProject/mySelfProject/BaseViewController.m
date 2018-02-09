//
//  BaseViewController.m
//  JinJiangInn
//
//  Created by xie aki on 12-11-2.
//  Copyright (c) 2012年 JJInn. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"


#define kWarinngViewTag     5556

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    
    
}

-(NSString *) getCurrentClassName{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return className;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.firstLoad = NO;
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViewBackgroundColor];
	[self initNavigationLeftButton:nil];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appEnterForground:(NSNotification *)notification
{
    
}

#pragma mark- common menthod
-(void)initViewBackgroundColor{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(float)tableViewMaxHeight{
    float viewHeight=[[UIScreen mainScreen] bounds].size.height;
    //44=navigation height , 20=status height.
    float maxHeight = viewHeight  - 44  - 20;
    return  maxHeight;
}

-(void)backButtonTouchEvents{
    if (self.modal)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTouchEvents{

}

//left button
-(void)initNavigationLeftButton:(NSString*)_buttonImage{
    
    if (self.isModal) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents)];
        
        UIImage *bgImage = [UIImage imageNamed:@"nav_back"];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:bgImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:bgImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsCompact];
        
        UIImage *buttonImage = [UIImage imageNamed:@"nav_back"];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents)];
        self.navigationItem.leftBarButtonItem = backButton;
        
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:kFontOrangeColor];
        
        
        
    }else{
        UIViewController *rootViewController = [self.navigationController.viewControllers firstObject];
        
        if ([rootViewController isKindOfClass:[self class]]) {
            //do nothing
            return;
        }
        
        if (!_buttonImage) {
            if (self.modal)
                _buttonImage = @"nav_back";
            else
                _buttonImage = @"nav_back";
        }
        
        [self.navigationItem hidesBackButton];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (_buttonImage) {
            UIImage *backimg = [UIImage imageNamed:_buttonImage];
            [btn setImage:backimg forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 60, 44);
            float leftEdge = (45-backimg.size.width)*0.5-10;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -leftEdge, 0, 0)];
            [btn setTitle:@"" forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"返回" forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(backButtonTouchEvents) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -23;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:btn]];
    }
    
    
    
    
}

-(void)initNavigationRightButton:(NSString*)_btTitle btWidth:(float)_btWidth{
    if (self.navigationItem.rightBarButtonItem == nil){
        float btWidth = 60.0f;
        if (_btWidth > 0) {
            btWidth = _btWidth;
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setBackgroundImage:[[UIImage imageNamed:@"nav_bar_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)] forState:UIControlStateNormal];
        [backBtn setTitle:_btTitle forState:UIControlStateNormal];
    
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        [backBtn addTarget:self action:@selector(rightButtonTouchEvents) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, btWidth, 32);
        self.navRightItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backBtn]];
        self.navigationItem.rightBarButtonItems = self.navRightItems;
        self.rightButton = backBtn;
        
    }
}
//autolayout
-(CGRect)customeLayout:(CGRect)rect{
    float x = rect.origin.x;

    rect.origin.x = x;

    return rect;
}



//为空的时候显示
-(void)loadEmptyView:(NSString*)noteText{
    if (self.emptyView == nil) {
        self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        float imageW = 80;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, kScaleNum(100), imageW, imageW)];
        iconImageView.image = [UIImage imageNamed:@"sad"];
        [self.emptyView addSubview:iconImageView];
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScaleNum(190), SCREEN_WIDTH, 21)];
        noteLabel.text = noteText;
        noteLabel.font = [UIFont systemFontOfSize:14];
        noteLabel.textAlignment = NSTextAlignmentCenter;
        noteLabel.textColor = [UIColor grayColor];
        [self.emptyView addSubview:noteLabel];
    }
    [self.view addSubview:self.emptyView];
    
}

//根据内容获取label宽度
-(float)getLabelDWidth:(UILabel*)label content:(NSString*)content{
    CGSize labelSize = [content sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    return labelSize.width;
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

-(void)showMessageTwoButton:(NSString*)_titleTxt message:(NSString*)_message delegate:(id)_delegate tag:(int)_tag title1:(NSString*)_title1 title2:(NSString*)_title2{
    if (!_message || ![_message length]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_titleTxt
                                                    message:_message
                                                   delegate:_delegate
                                          cancelButtonTitle:_title1
                                          otherButtonTitles:_title2,nil];
    alert.tag = _tag;
    [alert show];
}
-(void)addItemWithCustomView:(NSArray *)arry isLeft:(BOOL)isLeft{
    NSMutableArray *item=[[NSMutableArray alloc]init];
    for (UIView *view in arry) {
        UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
        [item addObject:buttonItem];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems=item;
    }else{
        self.navigationItem.rightBarButtonItems=item;
    }
}

@end
