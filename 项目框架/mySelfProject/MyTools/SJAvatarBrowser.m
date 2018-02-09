//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
@interface SJAvatarBrowser()

@end
CGRect oldframe;
CGPoint oldCenter;

CGFloat currentScale;
CGFloat beganScale;
CGFloat changeScale;

static UIImage *imageViewDetail;
@implementation SJAvatarBrowser
+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)showImageDetail:(UIImage *)avatarImageView{
    imageViewDetail = avatarImageView;
    UIImage *image=avatarImageView;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIScrollView *backgroundView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.tag =1001;
//    oldframe=[avatarImageView convertRect:[UIScreen mainScreen].bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=100;
    imageView.userInteractionEnabled = YES;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]
                                         
                                         initWithTarget:self action:@selector(scaleImage:)];
    
    [imageView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        oldframe = imageView.frame;
        oldCenter = imageView.center;
        backgroundView.alpha=1;
        currentScale = 1;
//        beganScale = 1;
    } completion:^(BOOL finished) {
        
    }];
}


+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
+ (void) scaleImage:(UIPinchGestureRecognizer*)gesture

{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIScrollView *view = (UIScrollView *)[window viewWithTag:1001];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    
    // 如果捏合手势刚刚开始
    if (gesture.state == UIGestureRecognizerStateBegan)
        
    {
        beganScale = gesture.scale;
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
        
    {
        changeScale = gesture.scale;
        if (changeScale>beganScale) {
            currentScale += 0.1;
            if (currentScale>2) {
                currentScale = 2;;
            }
        }else{
            currentScale -= 0.1;
            if (currentScale<=0.5) {
                currentScale = 0.5;
            }
        }
        beganScale = changeScale;

        imageView.transform = CGAffineTransformMakeScale(currentScale, currentScale);
        view.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height);
        CGFloat offsetWidth = imageView.bounds.size.width>kMainScreenWidth?(imageView.bounds.size.width-kMainScreenWidth)/2:0;
        CGFloat offsetHeight = imageView.bounds.size.height>kMainScreenHeight?(imageView.bounds.size.height-kMainScreenHeight)/2:0;

        if (currentScale>1) {
            view.contentOffset = CGPointMake(offsetWidth, offsetHeight);
        }
        CGPoint center = imageView.center;
        center.x = (currentScale-1)>0?oldCenter.x+offsetWidth:oldCenter.x;
        center.y = (currentScale-1)>0?oldCenter.y+offsetHeight:oldCenter.y;
        imageView.center = center;
        
    }
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        view.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height);

    }
    
    
    
}


@end
