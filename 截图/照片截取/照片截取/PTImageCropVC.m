//
//  ImageCropViewController.m
//  ptcommon
//
//  Created by 李超 on 16/6/8.
//  Copyright © 2016年 PTGX. All rights reserved.
//

#import "PTImageCropVC.h"
#import "UIImage+Helper.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//箭头的宽度
#define ARROWWIDTH 44
//箭头的高度
#define ARROWHEIGHT 44
//两个相邻箭头之间的最短距离
#define ARROWMINIMUMSPACE 30
//箭头单边的宽度
#define ARROWBORDERWIDTH 5

@interface PTImageCropVC () {
    UIView* m_bgView;
    UIImageView* m_bgImage;
    UIView* m_cropView; //透明区域的视图
    
    UIImageView* m_pointImage1;
    UIImageView* m_pointImage2;
    UIImageView* m_pointImage3;
    UIImageView* m_pointImage4;
    
    CGPoint m_startPoint1;
    CGPoint m_startPoint2;
    CGPoint m_startPoint3;
    CGPoint m_startPoint4;
    CGPoint m_startPointCropView;
    CGFloat m_imageScale;
    
    UIPanGestureRecognizer* m_panView;
    UIPanGestureRecognizer* m_panPoint1;
    UIPanGestureRecognizer* m_panPoint2;
    UIPanGestureRecognizer* m_panPoint3;
    UIPanGestureRecognizer* m_panPoint4;
}
@property (nonatomic, strong) UIImage* image;
@property (nonatomic) CGFloat cropScale;
@property (nonatomic, copy) void (^completeBlock)(UIImage* image);
@property (nonatomic, copy) void (^cancelBlock)(id sender);
@end

@implementation PTImageCropVC

#pragma mark-- lifecycle --
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self loadImage];
    [self updateCropViewFrame];
}

- (void)dealloc
{
    [m_cropView removeGestureRecognizer:m_panView];
    [m_pointImage1 removeGestureRecognizer:m_panPoint1];
    [m_pointImage2 removeGestureRecognizer:m_panPoint2];
    [m_pointImage3 removeGestureRecognizer:m_panPoint3];
    [m_pointImage4 removeGestureRecognizer:m_panPoint4];
}

#pragma mark-- public method --

/**
 *  @author fangbmian, 16-06-12 09:06:49
 *
 *  初始化
 *
 *  @param image         被裁剪照片
 *  @param cropScale     裁剪比例（高/宽）
 *  @param complentBlock 完成回调
 *  @param cancelBlock   取消回调
 *
 *  @return self
 */
- (instancetype)initWithImage:(UIImage*)image withCropScale:(CGFloat)cropScale complentBlock:(void (^)(UIImage* image))complentBlock cancelBlock:(void (^)(id sender))cancelBlock
{
    self = [super init];
    if (self) {
        self.image = [image fixOrientation]; // 注意该处
        self.cropScale = cropScale;
        self.completeBlock = complentBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

#pragma mark-- private method --
- (void)initLayout
{
    m_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    [m_bgImage setImage:self.image];
    [self.view addSubview:m_bgImage];
    
    m_bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [m_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [self.view addSubview:m_bgView];
    
    m_cropView = [UIView new];
    m_panView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCropView:)];
    [m_cropView addGestureRecognizer:m_panView];
    [m_bgView addSubview:m_cropView];
    
    m_panPoint1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCorner:)];
    m_pointImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROWWIDTH, ARROWHEIGHT)];
    [m_pointImage1 setImage:[UIImage imageNamed:@"ic_left_top_point"]];
    [m_pointImage1 addGestureRecognizer:m_panPoint1];
    [self.view addSubview:m_pointImage1];
    
    m_panPoint2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCorner:)];
    m_pointImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROWWIDTH, ARROWHEIGHT)];
    [m_pointImage2 setImage:[UIImage imageNamed:@"ic_right_top_point"]];
    
    [m_pointImage2 addGestureRecognizer:m_panPoint2];
    [self.view addSubview:m_pointImage2];
    
    m_panPoint3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCorner:)];
    m_pointImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROWWIDTH, ARROWHEIGHT)];
    [m_pointImage3 setImage:[UIImage imageNamed:@"ic_right_top_point"]];
    m_pointImage3.transform = CGAffineTransformMakeRotation(M_PI);
    [m_pointImage3 addGestureRecognizer:m_panPoint3];
    [self.view addSubview:m_pointImage3];
    
    m_panPoint4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCorner:)];
    m_pointImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROWWIDTH, ARROWHEIGHT)];
    [m_pointImage4 setImage:[UIImage imageNamed:@"ic_left_top_point"]];
    m_pointImage4.transform = CGAffineTransformMakeRotation(M_PI);
    [m_pointImage4 addGestureRecognizer:m_panPoint4];
    [self.view addSubview:m_pointImage4];
    
    // todo 临时使用
    UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [barView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:barView];
    
    UIButton* rltButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 20, 100, 44)];
    [rltButton setTitle:@"取消" forState:UIControlStateNormal];
    [rltButton addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rltButton];
    
    UIButton* comBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 112, 20, 100, 44)];
    [comBtn setTitle:@"完成" forState:UIControlStateNormal];
    [comBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:comBtn];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"照片编辑";
    [barView addSubview:titleLabel];
}

- (void)loadImage
{
    CGRect frame = m_bgImage.frame;
    CGPoint center = CGPointMake(SCREENWIDTH / 2.0, (SCREENHEIGHT - 64) / 2.0 + 64);
    CGFloat wscale = self.image.size.width / CGRectGetWidth(m_bgImage.frame);
    CGFloat hscale = self.image.size.height / CGRectGetHeight(m_bgImage.frame);
    
    frame.size.height = self.image.size.height / MAX(wscale, hscale);
    frame.size.width = self.image.size.width / MAX(wscale, hscale);
    
    m_imageScale = MAX(wscale, hscale);
    m_bgImage.frame = frame;
    m_bgImage.center = center;
    m_bgImage.contentMode = UIViewContentModeScaleToFill;
    [m_bgImage setNeedsUpdateConstraints];
}

- (void)updateCropViewFrame
{
    if (_cropScale == 0 || _cropScale == 1) {
        m_cropView.frame = CGRectMake(0, 0, ARROWMINIMUMSPACE + 2 * ARROWWIDTH, ARROWMINIMUMSPACE + 2 * ARROWWIDTH);
    }
    else if (_cropScale < 1) {
        m_cropView.frame = CGRectMake(0, 0, (ARROWMINIMUMSPACE + 2 * ARROWWIDTH) / _cropScale, ARROWMINIMUMSPACE + 2 * ARROWWIDTH);
    }
    else {
        m_cropView.frame = CGRectMake(0, 0, ARROWMINIMUMSPACE + 2 * ARROWWIDTH, (ARROWMINIMUMSPACE + 2 * ARROWWIDTH) * _cropScale);
    }
    
    m_cropView.center = m_bgImage.center;
    [self resetAllArrows];
    [self resetCropMask];
}

/**
 *  @author fangbmian, 16-06-12 13:06:42
 *
 *  根据当前裁剪区域的位置和尺寸将黑色蒙板的相应区域抠成透明
 */
- (void)resetCropMask
{
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:m_bgView.bounds];
    UIBezierPath* clearPath = [[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(m_cropView.frame), CGRectGetMinY(m_cropView.frame), CGRectGetWidth(m_cropView.frame), CGRectGetHeight(m_cropView.frame))] bezierPathByReversingPath];
    [path appendPath:clearPath];
    
    CAShapeLayer* shapeLayer = (CAShapeLayer*)m_bgView.layer.mask;
    if (!shapeLayer) {
        shapeLayer = [CAShapeLayer layer];
        [m_bgView.layer setMask:shapeLayer];
    }
    shapeLayer.path = path.CGPath;
}

/**
 *  @author fangbmian, 16-06-12 13:06:05
 *
 *  设置角的位置
 *
 *  @param arrow arrow
 */
- (void)resetArrowsFollow:(UIView*)arrow
{
    CGFloat borderMinX = CGRectGetMinX(m_bgImage.frame);
    CGFloat borderMaxX = CGRectGetMaxX(m_bgImage.frame);
    CGFloat borderMinY = CGRectGetMinY(m_bgImage.frame);
    CGFloat borderMaxY = CGRectGetMaxY(m_bgImage.frame);
    if (arrow == m_pointImage1) {
        
        if (_cropScale == 0) {
            m_pointImage2.center = CGPointMake(m_pointImage2.center.x, m_pointImage1.center.y);
            m_pointImage3.center = CGPointMake(m_pointImage1.center.x, m_pointImage3.center.y);
            return;
        }
        
        CGPoint leftTopPoint = CGPointMake(CGRectGetMinX(m_pointImage1.frame) + ARROWBORDERWIDTH, CGRectGetMinY(m_pointImage1.frame) + ARROWBORDERWIDTH);
        CGRect frame = m_cropView.frame;
        CGFloat maxX = CGRectGetMaxX(frame);
        CGFloat maxY = CGRectGetMaxY(frame);
        
        if (_cropScale >= 1) {
            frame.size.height = MIN(MAX(maxX - leftTopPoint.x, 2 * ARROWWIDTH + ARROWMINIMUMSPACE) * _cropScale, maxY - borderMinY);
            frame.size.width = frame.size.height / _cropScale;
        }
        else {
            frame.size.width = MIN(MAX(maxY - leftTopPoint.y, 2 * ARROWHEIGHT + ARROWMINIMUMSPACE) / _cropScale, maxX - borderMinX);
            frame.size.height = frame.size.width * _cropScale;
        }
        frame.origin.x = maxX - frame.size.width;
        frame.origin.y = maxY - frame.size.height;
        m_cropView.frame = frame;
        
        [self resetAllArrows];
    }
    else if (arrow == m_pointImage2) {
        
        if (_cropScale == 0) {
            m_pointImage1.center = CGPointMake(m_pointImage1.center.x, m_pointImage2.center.y);
            m_pointImage4.center = CGPointMake(m_pointImage2.center.x, m_pointImage4.center.y);
            return;
        }
        
        CGPoint rightTopPoint = CGPointMake(CGRectGetMaxX(m_pointImage2.frame) - ARROWBORDERWIDTH, CGRectGetMinY(m_pointImage2.frame) + ARROWBORDERWIDTH);
        CGRect frame = m_cropView.frame;
        CGFloat minX = CGRectGetMinX(frame);
        CGFloat maxY = CGRectGetMaxY(frame);
        
        if (_cropScale >= 1) {
            frame.size.height = MIN(MAX(rightTopPoint.x - minX, 2 * ARROWWIDTH + ARROWMINIMUMSPACE) * _cropScale, maxY - borderMinY);
            frame.size.width = frame.size.height / _cropScale;
        }
        else {
            frame.size.width = MIN(MAX(maxY - rightTopPoint.y, 2 * ARROWHEIGHT + ARROWMINIMUMSPACE) / _cropScale, borderMaxX - minX);
            frame.size.height = frame.size.width * _cropScale;
        }
        
        frame.origin.y = maxY - frame.size.height;
        m_cropView.frame = frame;
        
        [self resetAllArrows];
    }
    else if (arrow == m_pointImage3) {
        
        if (_cropScale == 0) {
            m_pointImage1.center = CGPointMake(m_pointImage3.center.x, m_pointImage1.center.y);
            m_pointImage4.center = CGPointMake(m_pointImage4.center.x, m_pointImage3.center.y);
            return;
        }
        
        CGPoint leftBottomPoint = CGPointMake(CGRectGetMinX(m_pointImage3.frame) + ARROWBORDERWIDTH, CGRectGetMaxY(m_pointImage3.frame) - ARROWBORDERWIDTH);
        CGRect frame = m_cropView.frame;
        CGFloat maxX = CGRectGetMaxX(frame);
        CGFloat minY = CGRectGetMinY(frame);
        
        if (_cropScale >= 1) {
            frame.size.height = MIN(MAX(maxX - leftBottomPoint.x, 2 * ARROWWIDTH + ARROWMINIMUMSPACE) * _cropScale, borderMaxY - minY);
            frame.size.width = frame.size.height / _cropScale;
        }
        else {
            frame.size.width = MIN(MAX(leftBottomPoint.y - minY, 2 * ARROWHEIGHT + ARROWMINIMUMSPACE) / _cropScale, maxX - borderMinX);
            frame.size.height = frame.size.width * _cropScale;
        }
        
        frame.origin.x = maxX - frame.size.width;
        m_cropView.frame = frame;
        
        [self resetAllArrows];
    }
    else if (arrow == m_pointImage4) {
        
        if (_cropScale == 0) {
            m_pointImage2.center = CGPointMake(m_pointImage4.center.x, m_pointImage2.center.y);
            m_pointImage3.center = CGPointMake(m_pointImage3.center.x, m_pointImage4.center.y);
            return;
        }
        
        CGPoint rightBottomPoint = CGPointMake(CGRectGetMaxX(m_pointImage4.frame) - ARROWBORDERWIDTH, CGRectGetMaxY(m_pointImage4.frame) - ARROWBORDERWIDTH);
        CGRect frame = m_cropView.frame;
        CGFloat minX = CGRectGetMinX(frame);
        CGFloat minY = CGRectGetMinY(frame);
        
        if (_cropScale >= 1) {
            frame.size.height = MIN(MAX(rightBottomPoint.x - minX, 2 * ARROWWIDTH + ARROWMINIMUMSPACE) * _cropScale, borderMaxY - minY);
            frame.size.width = frame.size.height / _cropScale;
        }
        else {
            frame.size.width = MIN(MAX(rightBottomPoint.y - minY, 2 * ARROWHEIGHT + ARROWMINIMUMSPACE) / _cropScale, borderMaxX - minX);
            frame.size.height = frame.size.width * _cropScale;
        }
        m_cropView.frame = frame;
        
        [self resetAllArrows];
    }
}

/**
 *  @author fangbmian, 16-06-12 13:06:33
 *
 *  根据当前裁剪区域的位置重新设置所有角的位置
 */
- (void)resetAllArrows
{
    m_pointImage1.center = CGPointMake(CGRectGetMinX(m_cropView.frame) - ARROWBORDERWIDTH + ARROWWIDTH / 2.0, CGRectGetMinY(m_cropView.frame) - ARROWBORDERWIDTH + ARROWHEIGHT / 2.0);
    m_pointImage2.center = CGPointMake(CGRectGetMaxX(m_cropView.frame) + ARROWBORDERWIDTH - ARROWWIDTH / 2.0, CGRectGetMinY(m_cropView.frame) - ARROWBORDERWIDTH + ARROWHEIGHT / 2.0);
    m_pointImage3.center = CGPointMake(CGRectGetMinX(m_cropView.frame) - ARROWBORDERWIDTH + ARROWWIDTH / 2.0, CGRectGetMaxY(m_cropView.frame) + ARROWBORDERWIDTH - ARROWHEIGHT / 2.0);
    m_pointImage4.center = CGPointMake(CGRectGetMaxX(m_cropView.frame) + ARROWBORDERWIDTH - ARROWWIDTH / 2.0, CGRectGetMaxY(m_cropView.frame) + ARROWBORDERWIDTH - ARROWHEIGHT / 2.0);
    [self.view layoutIfNeeded];
}

/**
 *  @author fangbmian, 16-06-12 13:06:19
 *
 *  根据当前所有角的位置重新设置裁剪区域的位置
 */
- (void)resetCropView
{
    m_cropView.frame = CGRectMake(CGRectGetMinX(m_pointImage1.frame) + ARROWBORDERWIDTH, CGRectGetMinY(m_pointImage1.frame) + ARROWBORDERWIDTH, CGRectGetMaxX(m_pointImage2.frame) - CGRectGetMinX(m_pointImage1.frame) - ARROWBORDERWIDTH * 2, CGRectGetMaxY(m_pointImage3.frame) - CGRectGetMinY(m_pointImage1.frame) - ARROWBORDERWIDTH * 2);
}

#pragma mark-- Gesture --
/**
 *  @author fangbmian, 16-06-12 13:06:59
 *
 *  移动裁剪区域的手势处理
 *
 *  @param panGesture panGesture
 */
- (void)moveCropView:(UIPanGestureRecognizer*)panGesture
{
    CGFloat minX = CGRectGetMinX(m_bgImage.frame);
    CGFloat maxX = CGRectGetMaxX(m_bgImage.frame) - CGRectGetWidth(m_cropView.frame);
    CGFloat minY = CGRectGetMinY(m_bgImage.frame);
    CGFloat maxY = CGRectGetMaxY(m_bgImage.frame) - CGRectGetHeight(m_cropView.frame);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        m_startPointCropView = [panGesture locationInView:m_bgView];
        m_pointImage1.userInteractionEnabled = NO;
        m_pointImage2.userInteractionEnabled = NO;
        m_pointImage3.userInteractionEnabled = NO;
        m_pointImage4.userInteractionEnabled = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        m_pointImage1.userInteractionEnabled = YES;
        m_pointImage2.userInteractionEnabled = YES;
        m_pointImage3.userInteractionEnabled = YES;
        m_pointImage4.userInteractionEnabled = YES;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint endPoint = [panGesture locationInView:m_bgView];
        CGRect frame = panGesture.view.frame;
        frame.origin.x += endPoint.x - m_startPointCropView.x;
        frame.origin.y += endPoint.y - m_startPointCropView.y;
        frame.origin.x = MIN(maxX, MAX(frame.origin.x, minX));
        frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
        panGesture.view.frame = frame;
        m_startPointCropView = endPoint;
    }
    [self resetCropMask];
    [self resetAllArrows];
}

/**
 *  @author fangbmian, 16-06-12 13:06:18
 *
 *  移动四个角的手势处理
 *
 *  @param panGesture panGesture
 */
- (void)moveCorner:(UIPanGestureRecognizer*)panGesture
{
    CGPoint* startPoint = NULL;
    CGFloat minX = CGRectGetMinX(m_bgImage.frame) - ARROWBORDERWIDTH;
    CGFloat maxX = CGRectGetMaxX(m_bgImage.frame) - ARROWWIDTH + ARROWBORDERWIDTH;
    CGFloat minY = CGRectGetMinY(m_bgImage.frame) - ARROWBORDERWIDTH;
    CGFloat maxY = CGRectGetMaxY(m_bgImage.frame) - ARROWHEIGHT + ARROWBORDERWIDTH;
    
    if (panGesture.view == m_pointImage1) {
        startPoint = &m_startPoint1;
        maxY = CGRectGetMinY(m_pointImage3.frame) - ARROWHEIGHT - ARROWMINIMUMSPACE;
        maxX = CGRectGetMinX(m_pointImage2.frame) - ARROWWIDTH - ARROWMINIMUMSPACE;
    }
    else if (panGesture.view == m_pointImage2) {
        startPoint = &m_startPoint2;
        maxY = CGRectGetMinY(m_pointImage4.frame) - ARROWHEIGHT - ARROWMINIMUMSPACE;
        minX = CGRectGetMaxX(m_pointImage1.frame) + ARROWMINIMUMSPACE;
    }
    else if (panGesture.view == m_pointImage3) {
        startPoint = &m_startPoint3;
        minY = CGRectGetMaxY(m_pointImage1.frame) + ARROWMINIMUMSPACE;
        maxX = CGRectGetMinX(m_pointImage4.frame) - ARROWWIDTH - ARROWMINIMUMSPACE;
    }
    else if (panGesture.view == m_pointImage4) {
        startPoint = &m_startPoint4;
        minY = CGRectGetMaxY(m_pointImage2.frame) + ARROWMINIMUMSPACE;
        minX = CGRectGetMaxX(m_pointImage3.frame) + ARROWMINIMUMSPACE;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        *startPoint = [panGesture locationInView:m_bgView];
        m_cropView.userInteractionEnabled = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        m_cropView.userInteractionEnabled = YES;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint endPoint = [panGesture locationInView:m_bgView];
        CGRect frame = panGesture.view.frame;
        frame.origin.x += endPoint.x - startPoint->x;
        frame.origin.y += endPoint.y - startPoint->y;
        frame.origin.x = MIN(maxX, MAX(frame.origin.x, minX));
        frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
        panGesture.view.frame = frame;
        *startPoint = endPoint;
    }
    [self resetArrowsFollow:panGesture.view];
    [self resetCropView];
    [self resetCropMask];
}

#pragma mark-- button click--
- (void)returnBtnClick:(id)sender
{
    if (self.cancelBlock)
        self.cancelBlock(nil);
}

- (void)completeBtnClick:(id)sender
{
    if (self.completeBlock) {
        CGRect cropAreaInImageView = [m_bgView convertRect:m_cropView.frame toView:m_bgImage];
        CGRect cropAreaInImage;
        cropAreaInImage.origin.x = cropAreaInImageView.origin.x * m_imageScale;
        cropAreaInImage.origin.y = cropAreaInImageView.origin.y * m_imageScale;
        cropAreaInImage.size.width = cropAreaInImageView.size.width * m_imageScale;
        cropAreaInImage.size.height = cropAreaInImageView.size.height * m_imageScale;
        
        UIImage* cropImage = [self.image imageAtRect:cropAreaInImage];
        self.completeBlock(cropImage);
    }
}

@end
