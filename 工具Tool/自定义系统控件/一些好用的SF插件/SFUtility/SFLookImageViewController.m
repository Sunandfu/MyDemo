//
//  SFLookImageViewController.m
//  SFVideoPlayer
//
//  Created by Lurich on 2022/5/29.
//

#import "SFLookImageViewController.h"

#define SF_ScreenW    [UIScreen mainScreen].bounds.size.width
#define SF_ScreenH    [UIScreen mainScreen].bounds.size.height

@interface SFLookImageViewController ()

@property (nonatomic, assign) CGFloat imgBili;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SFLookImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.imgBili = self.image.size.width / self.image.size.height;
    // Do any additional setup after loading the view.
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SF_ScreenW, SF_ScreenH)];
    [backScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)]];
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.oldImageFrame];
    imageView.image = self.image;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.multipleTouchEnabled = YES;
    [backScrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *oneClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageView:)];
    oneClick.numberOfTapsRequired = 1;
    oneClick.numberOfTouchesRequired  =1;
    [imageView addGestureRecognizer:oneClick];
    UITapGestureRecognizer *twoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageView:)];
    twoClick.numberOfTapsRequired = 2;
    twoClick.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:twoClick];
    [oneClick requireGestureRecognizerToFail:twoClick];
    
    UIPanGestureRecognizer *panClick = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [imageView addGestureRecognizer:panClick];
    [oneClick requireGestureRecognizerToFail:panClick];
    
    UIRotationGestureRecognizer *rotaClick = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotaImageView:)];
    [imageView addGestureRecognizer:rotaClick];
    
    UIPinchGestureRecognizer *pinchClick = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageView:)];
    [imageView addGestureRecognizer:pinchClick];
    
#ifdef DEBUG
    UILongPressGestureRecognizer *longPressClick = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImageView:)];
    [imageView addGestureRecognizer:longPressClick];
#else

#endif
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //337/ 478;
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.bounds = CGRectMake(0, 0, SF_ScreenH * self.imgBili, SF_ScreenH);
        self.imageView.center = CGPointMake(SF_ScreenW/2.0, SF_ScreenH/2.0);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    } completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
}
- (void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = self.oldImageFrame;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        NSLog(@"finished");
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
- (void)removeImageView:(UIGestureRecognizer *)gesture{
    if (gesture.view.frame.size.width > SF_ScreenW) {
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:0.5f]; // 动画时长
        /** 固定一倍 */
        gesture.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        gesture.view.center=CGPointMake(SF_ScreenW/2.0, SF_ScreenH/2.0);
        [UIView commitAnimations]; // 提交动画
    } else {
        [self removeView];
    }
}
- (void)enlargeImageView:(UITapGestureRecognizer *)gesture{
    if (gesture.view.frame.size.height <= SF_ScreenH ) {
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:0.5f]; // 动画时长
        /** 固定宽度撑满 */
        CGFloat sfbl = SF_ScreenW / (SF_ScreenH * self.imgBili);
        gesture.view.transform = CGAffineTransformMake(sfbl, 0, 0, sfbl, 0, 0);
        [UIView commitAnimations]; // 提交动画
    } else {
        [UIView beginAnimations:nil context:nil]; // 开始动画
        [UIView setAnimationDuration:0.5f]; // 动画时长
        /** 固定一倍 */
        gesture.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        [UIView commitAnimations]; // 提交动画
    }
}
-(void)moveImageView:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self.view];
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGFloat centerX = gesture.view.center.x+point.x;
    CGFloat centerY = gesture.view.center.y+point.y;
    CGFloat viewHalfH = gesture.view.frame.size.height;
    CGFloat viewHalfW = gesture.view.frame.size.width;
    gesture.view.center=CGPointMake(centerX, centerY);
    [gesture setTranslation:CGPointZero inView:self.view];
    CGFloat maxX = viewHalfW / 2.0;
    CGFloat minX = SF_ScreenW - maxX;
    if (viewHalfW < SF_ScreenW) {
        minX = maxX = SF_ScreenW/2.0;
    }
    CGFloat maxY = viewHalfH / 2.0;
    CGFloat minY = SF_ScreenH - maxY;
    if (viewHalfH < SF_ScreenH) {
        maxY = minY = SF_ScreenH/2.0;
    }
    if (centerY > maxY) {
        centerY = maxY;
    }
    if (centerX > maxX) {
        centerX = maxX;
    }
    if (centerY < minY) {
        centerY = minY;
    }
    if (centerX < minX) {
        centerX = minX;
    }
    CGFloat originY = gesture.view.frame.origin.y;
    if (centerY > maxY) {
        if (viewHalfH > SF_ScreenH) {
        } else {
            CGFloat bili = 1 - originY / (SF_ScreenH * 2 / 3.0);
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:bili];
            gesture.view.transform = CGAffineTransformMakeScale(bili/2.0+0.5, bili/2.0+0.5);
        }
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if (originY >= (SF_ScreenH/2)) {
                if (viewHalfH <= SF_ScreenH) {
                    [self removeImageView:gesture];
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        gesture.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
                        gesture.view.center=CGPointMake(SF_ScreenW/2.0, SF_ScreenH/2.0);
                    }];
                }
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    gesture.view.center=CGPointMake(centerX, centerY);
                    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
                    if (viewHalfH <= SF_ScreenH) {
                        gesture.view.transform = CGAffineTransformIdentity;
                    }
                }];
            }
        }
    } else {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.5 animations:^{
                gesture.view.center=CGPointMake(centerX, centerY);
            }];
        }
    }
}
-(void)rotaImageView:(UIRotationGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
}
-(void)scaleImageView:(UIPinchGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.view.frame.size.height <= SF_ScreenH ) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /** 固定一倍 */
            gesture.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            self.imageView.center = CGPointMake(SF_ScreenW/2.0, SF_ScreenH/2.0);
            [UIView commitAnimations]; // 提交动画
        }
        else if (gesture.view.frame.size.width > SF_ScreenW * 2) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /** 固定2倍 */
            CGFloat sfbl = SF_ScreenW * 2 / (SF_ScreenH * self.imgBili);
            gesture.view.transform = CGAffineTransformMake(sfbl, 0, 0, sfbl, 0, 0);
            self.imageView.center = CGPointMake(SF_ScreenW/2.0, SF_ScreenH/2.0);
            [UIView commitAnimations]; // 提交动画
        }
    }
}
- (void)longPressImageView:(UILongPressGestureRecognizer *)gesture{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存图片？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了保存图片");
        UIImageView *imageView = (UIImageView *)gesture.view;
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
