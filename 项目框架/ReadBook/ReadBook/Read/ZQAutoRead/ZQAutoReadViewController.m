//
//  ZQAutoReadViewController.m
//  ZQAutoReadBook
//
//  Created by zzq on 2018/9/29.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQAutoReadViewController.h"
#import "ZQAutoReadToolBar.h"
#import "SFConstant.h"

@interface ZQAutoReadViewController ()<AutoReadToolBarDelegate>

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) CAShapeLayer  *shapeLayer;
@property (nonatomic, strong) UIImageView  *backImage;
@property (nonatomic, strong) UIImageView  *shadowImage;

@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign) CGFloat speed;

@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, strong) ZQAutoReadToolBar *toolBar;
@property (nonatomic, strong) UIView *tapView;

@end

@interface ZQAutoReadViewController ()

@end

@implementation ZQAutoReadViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _speed = [[NSUserDefaults standardUserDefaults] integerForKey:KeyBookAutoReadSpeed];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_backImage];
    
    _shapeLayer = [CAShapeLayer layer];
    _backImage.layer.mask = _shapeLayer;
    
    _shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    _shadowImage.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_shadowImage];
    
    [self addToolBar];
}

- (void)addToolBar {
    [self.view addSubview:self.tapView];
    [self.view addSubview:self.toolBar];
    
    CGFloat toolH = CGRectGetHeight(self.toolBar.frame);
    self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, toolH);    
    self.tapView.frame = self.view.bounds;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.tapView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pangesture:)];
    [self.tapView addGestureRecognizer:pan];
}


- (void)updateWithView:(UIImage *)image {
    _shapeLayer.path = [UIBezierPath bezierPathWithRect:self.view.frame].CGPath;
    self.backImage.image = image;
}

- (void)startAuto {
    if (_link == nil) {
        // 启动定时调用
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrent:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

-(void)getCurrent:(CADisplayLink *)displayLink{
    if(_topY >= self.view.frame.size.height) {
        _topY = 0;
        self.shadowImage.center = CGPointMake(self.view.center.x, self.shadowImage.bounds.size.height/2);
        
        [_link invalidate];
        _link = nil;
        
        [_delegate finishReadPage:self];
        return;
    }
    _topY += self.speed/5.0;
    [self setCurrentShadowLayer];
    [self setCurrentMaskLayer];
}

- (void)setCurrentMaskLayer {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, _topY);
    CGPathAddLineToPoint(path, nil, self.view.frame.size.width, _topY);
    CGPathAddLineToPoint(path, nil, self.view.frame.size.width, self.view.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path);
    
    _shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)setCurrentShadowLayer {
    [UIView animateWithDuration:0.1 animations:^{
        CGPoint pos = self.shadowImage.center;
        pos.y += self.speed/5.0;
        self.shadowImage.center = pos;
    }];
}


- (void)singleTap {
    _isPaused ^= 1;
    [_link setPaused:_isPaused];
    [UIView animateWithDuration:0.25 animations:^{
        if(self.isPaused) {
            //显示
            CGRect frame = self.toolBar.frame;
            CGFloat h = CGRectGetHeight(self.toolBar.frame);
            frame.origin.y -= h;
            self.toolBar.frame = frame;
            self.toolBar.alpha = 1;
        }
        else {
            //隐藏
            CGRect frame = self.toolBar.frame;
            CGFloat h = CGRectGetHeight(self.toolBar.frame);
            frame.origin.y += h;
            self.toolBar.frame = frame;
            self.toolBar.alpha = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - autoReadToolBarDelegate
- (void)speedUp:(CGFloat)speed {
    _speed = speed;
    [[NSUserDefaults standardUserDefaults] setInteger:speed forKey:KeyBookAutoReadSpeed];
}

- (void)speedLow:(CGFloat)speed {
    _speed = speed;
    [[NSUserDefaults standardUserDefaults] setInteger:speed forKey:KeyBookAutoReadSpeed];
}

- (void)endAutoRead {
    [_link invalidate];
    _link = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyBookEndAutoRead object:nil];
}

#pragma mark - getter && setter
- (ZQAutoReadToolBar *)toolBar {
    if(!_toolBar) {
        _toolBar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZQAutoReadToolBar class]) owner:self options:nil].firstObject;
        _toolBar.alpha = 0;
        _toolBar.delegate = self;
        _toolBar.speed = [[NSUserDefaults standardUserDefaults] integerForKey:KeyBookAutoReadSpeed];
    }
    return _toolBar;
}

- (UIView *)tapView {
    if(!_tapView) {
        _tapView = [UIView new];
        _tapView.backgroundColor = [UIColor clearColor];
    }
    return _tapView;
}

#pragma mark - 拖拽手势
- (void)pangesture:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _isPaused ^= 1;
        [_link setPaused:_isPaused];
    }
    if (gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateEnded) {
        _isPaused ^= 1;
        [_link setPaused:_isPaused];
    }
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[gesture translationInView:[UIApplication sharedApplication].keyWindow];

    CGFloat centerY = _topY+point.y;
    CGFloat viewHalfH = self.shadowImage.bounds.size.height/2;
    //确定特殊的centerY
    if (centerY - viewHalfH < 0 ) {
        centerY = viewHalfH;
    }
//    if (centerY + viewHalfH > KHeight - tabbar.size.height) {
//        centerY = KHeight - viewHalfH - tabbar.size.height;
//    }
    
    _topY = centerY;
    self.shadowImage.center = CGPointMake(self.view.center.x, centerY);
    [self setCurrentMaskLayer];
    
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [gesture setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
}

@end
