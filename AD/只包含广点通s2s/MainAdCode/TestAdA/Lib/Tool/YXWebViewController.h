 

#import <UIKit/UIKit.h>

@protocol YXWebViewDelegate <NSObject>
@optional
- (void)backClicked; 
@end



@interface YXWebViewController : UIViewController
@property(nonatomic,copy)NSString *URLString;

@property(nonatomic,assign) id<YXWebViewDelegate> delegate;

@end
