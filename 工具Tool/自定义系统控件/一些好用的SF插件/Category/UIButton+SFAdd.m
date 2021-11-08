//
//  UIButton+SFAdd.m
//  TransferPlatform
//
//  Created by lurich on 2021/9/16.
//

#import "UIButton+SFAdd.h"
#import <objc/runtime.h>

static char sf_topNameKey;
static char sf_rightNameKey;
static char sf_bottomNameKey;
static char sf_leftNameKey;

NSInteger SFCountDownNumber;

#define angleValue(angle) ((angle) * M_PI / 180.0)
@implementation UIButton (SFAdd)

- (void)sf_ImagePosition:(SFBtnPosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case SFBtnPositionImageLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case SFBtnPositionImageRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case SFBtnPositionImageTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case SFBtnPositionImageBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

- (void)sf_startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color titleColor:(UIColor *)titleColor countTitleColor:(UIColor *)ctColor{
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title forState:UIControlStateNormal];
                [weakSelf setTitleColor:titleColor forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            NSInteger allTime = (int)timeLine + 1;
            NSInteger seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = color;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                [weakSelf setTitleColor:ctColor forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
- (void)sf_beginWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color titleColor:(UIColor *)titleColor countTitleColor:(UIColor *)ctColor{
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut == timeLine) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title forState:UIControlStateNormal];
                [weakSelf setTitleColor:titleColor forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            NSInteger allTime = (int)timeLine + 1;
            NSInteger seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = color;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                [weakSelf setTitleColor:ctColor forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut++;
        }
    });
    dispatch_resume(_timer);
}
- (void)sf_imgaeScale:(UIView *)view{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.values = @[@(1.2),@(0.8),@(1.2)];
    anima.repeatCount = MAXFLOAT;
    anima.duration = 1;
    [view.layer addAnimation:anima forKey:@"daxiao"];
}


#pragma mark- 利用 **runtime** 具体的设置内边距
-(void)sf_setEnLargeEdge:(CGFloat)distance
{
    objc_setAssociatedObject(self, &sf_topNameKey, [NSNumber numberWithFloat:distance], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_rightNameKey, [NSNumber numberWithFloat:distance], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_bottomNameKey, [NSNumber numberWithFloat:distance], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_leftNameKey, [NSNumber numberWithFloat:distance], OBJC_ASSOCIATION_COPY_NONATOMIC);

}
// 设置可点击范围到按钮上、右、下、左的距离
-(void)sf_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &sf_topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &sf_leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);

}
//--------------------------------------------------------------------------------------------------------
-(CGRect)sf_enlargedRect
{
    NSNumber *topEdge=objc_getAssociatedObject(self, &sf_topNameKey);
    NSNumber *rightEdge=objc_getAssociatedObject(self, &sf_rightNameKey);
    NSNumber *bottomEdge=objc_getAssociatedObject(self, &sf_bottomNameKey);
    NSNumber *leftEdge=objc_getAssociatedObject(self, &sf_leftNameKey);
    if(topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x-leftEdge.floatValue,
                          self.bounds.origin.y-topEdge.floatValue,
                          self.bounds.size.width+leftEdge.floatValue+rightEdge.floatValue,
                          self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}
// 设置可点击范围到按钮上、右、下、左的距离
-(BOOL)sf_pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect=[self sf_enlargedRect];
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point)?YES:NO;
}

@end
