//
//  CLMainViewController.h
//  my2048
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define kOneLabelwidth 67.5
#define kOneLabelHeight 65
#define kPlaceX @"X"
#define kPlaceY @"Y"
#define kHaveSameNumberLabel 10
#define kHaveNoLabel 20
#define kHaveDifferentLabel 30

#define kRight 1
#define kLeft 2
#define kUp 3
#define kDown 4

@interface CLMainViewController : BaseViewController<UIAlertViewDelegate>
{
    SystemSoundID swipSoundID;
}
@property (nonatomic,strong) NSMutableArray *currentExistArray;
@property (nonatomic,strong) NSMutableArray *emptyPlaceArray;
@property (nonatomic,strong) NSArray *labelArray;
//@property (nonatomic,strong) NSArray *testArray;

@property(nonatomic)BOOL  R_1;
@property(nonatomic)BOOL  R_2;
@property(nonatomic)BOOL  R_3;
@property(nonatomic)BOOL  R_4;

@property(nonatomic)BOOL  C_1;
@property(nonatomic)BOOL  C_2;
@property(nonatomic)BOOL  C_3;
@property(nonatomic)BOOL  C_4;

@property(nonatomic)BOOL canBornNewLabel;
@property(nonatomic)BOOL isOver;
@end
