//
//  ViewController.m
//  StarRating
//
//  Created by iMac on 16/12/27.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSStarRatingView.h"


@interface ViewController ()<StarRatingViewDelegate>

@end

@implementation ViewController {
    UILabel *scoreLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width-60, 25)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor lightGrayColor];
    scoreLabel.font =  [UIFont systemFontOfSize:20];
    [self.view addSubview:scoreLabel];
    
    WSStarRatingView *starRatingView = [[WSStarRatingView alloc] initWithFrame:CGRectMake(30, 200, self.view.frame.size.width-60, 50) numberOfStar:5];
//    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
    
    CGFloat score = 0.9+(arc4random_uniform(10)/100.0);
    [starRatingView setScore:score withAnimation:YES completion:^(BOOL finished) {
        scoreLabel.text = [NSString stringWithFormat:@"%0.1f分",score * 5 ];
    }];
    

}

- (void)starRatingView:(WSStarRatingView *)view score:(float)score
{
    scoreLabel.text = [NSString stringWithFormat:@"%0.1f分",score * 5 ];
    
}


@end
