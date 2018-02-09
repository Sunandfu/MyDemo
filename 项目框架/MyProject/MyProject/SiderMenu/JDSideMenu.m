//
//  JDSideMenu.m
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import "JDSideMenu.h"

// constants
const CGFloat JDSideMenuMinimumRelativePanDistanceToOpen = 0.33;
const CGFloat JDSideMenuDefaultMenuWidth = 260.0;
const CGFloat JDSideMenuDefaultDamping = 0.5;

// animation times
const CGFloat JDSideMenuDefaultOpenAnimationTime = 1.2;
const CGFloat JDSideMenuDefaultCloseAnimationTime = 0.4;

@interface JDSideMenu () {
    CGFloat speedf;//滑动的速度
    CGFloat scalef;
}
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation JDSideMenu

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _contentController = contentController;
        _menuController = menuController;
        
        _menuWidth = JDSideMenuDefaultMenuWidth;
        _tapGestureEnabled = YES;
        _panGestureEnabled = YES;
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    speedf = 0.5;
    self.navigationController.navigationBarHidden = YES;
    // add childcontroller
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    // add subviews
    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.contentController.view];
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];
    
    // 添加手势
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.containerView addGestureRecognizer:self.tapRecognizer];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [self.containerView addGestureRecognizer:self.panRecognizer];
}

- (void)setBackgroundImage:(UIImage*)image;
{
    if (!self.backgroundView && image) {
        self.backgroundView = [[UIImageView alloc] initWithImage:image];
        self.backgroundView.frame = self.view.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:self.backgroundView atIndex:0];
    } else if (image == nil) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    } else {
        self.backgroundView.image = image;
    }
}

#pragma mark controller replacement

- (void)setContentController:(UIViewController*)contentController
                     animted:(BOOL)animated;
{
    if (contentController == nil) return;
    UIViewController *previousController = self.contentController;
    _contentController = contentController;
    
    // add childcontroller
    [self addChildViewController:self.contentController];
    
    // add subview
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // animate in
    __weak typeof(self) blockSelf = self;
    CGFloat offset = JDSideMenuDefaultMenuWidth + (self.view.frame.size.width-JDSideMenuDefaultMenuWidth)/2.0;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime/2.0 animations:^{
        blockSelf.containerView.transform = CGAffineTransformMakeTranslation(offset, 0);
    } completion:^(BOOL finished) {
        // move to container view
        [blockSelf.containerView addSubview:self.contentController.view];
        [blockSelf.contentController didMoveToParentViewController:blockSelf];
        
        // remove old controller
        [previousController willMoveToParentViewController:nil];
        [previousController removeFromParentViewController];
        [previousController.view removeFromSuperview];
        
        [blockSelf showMainView];
    }];
}

#pragma mark Animation

- (void)tapRecognized:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        [self.menuController.view removeFromSuperview];
        [UIView commitAnimations];
        scalef = 0;
        
    }
}

- (void)panRecognized:(UIPanGestureRecognizer*)rec
{
    CGPoint point = [rec translationInView:self.view];
    
    scalef = (point.x*speedf+scalef);
    
    //根据视图位置判断是左滑还是右边滑动
    if (rec.view.frame.origin.x>0){
        rec.view.center = CGPointMake(rec.view.center.x + point.x*speedf,rec.view.center.y);
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        [self addMenuControllerView];
        
    }
    if (rec.view.frame.origin.x<=0){
        rec.view.center = CGPointMake(rec.view.center.x,rec.view.center.y);
        if (scalef<0) {
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        } else {
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        }
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
    }
    
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (scalef>140*speedf){
            [self showLeftView];
        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }
}
//恢复位置
-(void)showMainView{
    [UIView beginAnimations:nil context:nil];
    self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.containerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    
    [self.menuController.view removeFromSuperview];
    [UIView commitAnimations];
}

//显示左视图
-(void)showLeftView{
    [UIView beginAnimations:nil context:nil];
    self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    self.containerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2+180,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
}
- (void)addMenuControllerView;
{
    if (self.menuController.view.superview == nil) {
        CGRect menuFrame, restFrame;
        CGRectDivide(self.view.bounds, &menuFrame, &restFrame, self.menuWidth, CGRectMinXEdge);
        self.menuController.view.frame = menuFrame;
        self.menuController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = self.menuController.view.backgroundColor;
        if (self.backgroundView) [self.view insertSubview:self.menuController.view aboveSubview:self.backgroundView];
        else [self.view insertSubview:self.menuController.view atIndex:0];
    }
}

#pragma mark State

- (BOOL)isMenuVisible;
{
    return !CGAffineTransformEqualToTransform(self.containerView.transform,
                                              CGAffineTransformIdentity);
}

@end
