 

#import <UIKit/UIKit.h>
#import "SFWebViewController.h"

@protocol YXWebViewDelegate <NSObject>

@optional
- (void)customWebViewClicked;

@end

@interface YXWebViewController : UIViewController

@property(nonatomic,copy)NSString *URLString;
@property (nonatomic, assign) BOOL show;

@property(nonatomic,assign) id<YXWebViewDelegate> delegate;

@end
