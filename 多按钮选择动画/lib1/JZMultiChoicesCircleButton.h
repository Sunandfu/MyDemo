//
//  JZMultiChoicesCircleButton.h
//  JZMultiChoicesCircleButton
//
//  Created by Fincher Justin on 15/11/3.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZMultiChoicesCircleButton : UIView

@property (nonatomic,strong) NSNumber *CircleRadius;
@property (nonatomic,strong) UIColor *CircleColor;
@property (nonatomic,strong) UIViewController *ResponderUIVC;

- (instancetype)initWithCenterPoint:(CGPoint)Point
                         ButtonIcon:(UIImage*)Icon
                        SmallRadius:(CGFloat)SRadius
                          BigRadius:(CGFloat)BRadius
                       ButtonNumber:(NSInteger)Number
                         ButtonIcon:(NSArray *)ImageArray
                         ButtonText:(NSArray *)TextArray
                       ButtonTarget:(NSArray *)TargetArray
                        UseParallex:(BOOL)isParallex
                  ParallaxParameter:(CGFloat)Parallex
              RespondViewController:(UIViewController *)VC;

- (void)SuccessCallBackWithMessage:(NSString *)String;
- (void)FailedCallBackWithMessage:(NSString *)String;


@end
/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 NSArray *IconArray = @[@"SendRound",@"CompleteRound",@"CalenderRound",@"MarkRound"];
 NSArray *TextArray = @[@"Send",@"Complete",@"Calender",@"Mark"];
 NSArray *TargetArray = @[@"ButtonOne",@"ButtonTwo",@"ButtonThree",@"ButtonFour"];
 
 NewBTN = [[JZMultiChoicesCircleButton alloc] initWithCenterPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height / 2 ) ButtonIcon:[UIImage imageNamed:@"send"] SmallRadius:30.0f BigRadius:120.0f ButtonNumber:4 ButtonIcon:IconArray ButtonText:TextArray ButtonTarget:TargetArray UseParallex:NO ParallaxParameter:100 RespondViewController:self];
 [self.view addSubview:NewBTN];
 
 }
 
 - (void)ButtonOne
 {
 NSLog(@"BUtton 1 Seleted");
 [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
 }
 - (void)ButtonTwo
 {
 NSLog(@"BUtton 2 Seleted");
 [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
 }
 - (void)ButtonThree
 {
 NSLog(@"BUtton 3 Seleted");
 [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(ErrorLoadData) userInfo:nil repeats:NO];
 }
 - (void)ButtonFour
 {
 NSLog(@"BUtton 4 Seleted");
 [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ErrorLoadData) userInfo:nil repeats:NO];
 }
 
 - (void)SuccessLoadData
 {
 [NewBTN SuccessCallBackWithMessage:@"YES!"];
 }
 - (void)ErrorLoadData
 {
 [NewBTN FailedCallBackWithMessage:@"NO..."];
 }
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
 return UIStatusBarStyleLightContent;
 }

 */