
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import "AdCompViewDelegate.h"

@interface AdCompView : UIView

@property (nonatomic, weak) id<AdCompViewDelegate> delegate;

@property (nonatomic, strong) CLLocation*			   location;
@property (nonatomic, strong) NSObject*                 adData;
@property (nonatomic, assign) BOOL   isReady;      //插屏是否注备好

@end
