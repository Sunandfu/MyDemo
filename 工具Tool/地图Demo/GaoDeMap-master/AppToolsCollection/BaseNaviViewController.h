//
//  BaseNaviViewController.h
//  khqyKhqyIphone
//
//  Created by 林英伟 on 15/11/1.
//
//

#import <UIKit/UIKit.h>

#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

#import "APIKey.h"
#import "NaviManager.h"
#import "CommentDefine.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SharedMapView.h"
#import "MANaviAnnotationView.h"
@interface BaseNaviViewController : UIViewController <MAMapViewDelegate,AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic,strong)  UIActivityIndicatorView *activityIndicatorView;
- (void)returnAction;

@end
