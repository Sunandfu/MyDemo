//
//  ViewController.m
//  XuShiWu
//
//  Created by xsw on 15/12/23.
//  Copyright © 2015年 xsw. All rights reserved.
//

#import "ViewController.h"
#import "AFSoundManager.h"

#define ITEM_SPACING 200
#define IMG_NUMBER  6

@interface ViewController (){
    UILocalNotification* Bnot;
    BOOL OFF;
}

@end

@implementation ViewController

@synthesize carousel;
@synthesize wrap;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        wrap = YES;
    }
    return self;
}

#pragma mark ->
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.titleImg.layer setMasksToBounds:YES];
    [self.titleImg.layer setCornerRadius:20.0];
    
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeCustom;
    
    [self SoundManager];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


- (IBAction)switchCarouselType:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"图片类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"type1", @"type2", @"type3", @"type4", @"type5", @"type6", @"type7", @"type8", nil];
    [sheet showInView:self.view];
}


#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    carousel.type = buttonIndex;
    [UIView commitAnimations];
    
}

#pragma mark -
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return IMG_NUMBER;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index{
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]]];
    
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel{
    return IMG_NUMBER;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carouse{
    return wrap;
}



#pragma mark -> 音乐播放
- (void)SoundManager{
    OFF = NO;
    [self playLocalFile];
    [self oFFType];
    [self.typeButton addTarget:self action:@selector(oFFType) forControlEvents:UIControlEventTouchUpInside];
}

- (void)oFFType{
    if (OFF == YES) {  //播放
        OFF = NO;
        [self pauseAudio];
        self.Img_type.image = [UIImage imageNamed:@"喇叭11.png"];

    }else{  //暂停
        OFF = YES;
        [self resumeAudio];
        self.Img_type.image = [UIImage imageNamed:@"喇叭22.png"];
    }
}

-(void)pauseAudio {
    [[AFSoundManager sharedManager]pause];
}
-(void)resumeAudio {
    [[AFSoundManager sharedManager]resume];
}

-(void)playLocalFile {
    [[AFSoundManager sharedManager]startPlayingLocalFileWithName:@"111.mp3" andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"mm:ss"];
    }];
}

-(UIImage *)invertImage:(UIImage *)originalImage {
    UIGraphicsBeginImageContext(originalImage.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    [originalImage drawInRect:imageRect];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, originalImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  originalImage.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, originalImage.size.width, originalImage.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

@end
