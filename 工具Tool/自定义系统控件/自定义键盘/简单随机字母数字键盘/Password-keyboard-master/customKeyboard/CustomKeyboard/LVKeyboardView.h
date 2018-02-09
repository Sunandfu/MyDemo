
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "LVKeyboardAccessoryBtn.h"

@class LVKeyboardView;
@protocol LVKeyboardDelegate <NSObject>

@optional
/** 点击了数字按钮 */
- (void)keyboard:(LVKeyboardView *)keyboard didClickButton:(UIButton *)button;
/** 点击删除按钮 */
- (void)keyboard:(LVKeyboardView *)keyboard didClickDeleteBtn:(UIButton *)deleteBtn;
/** 点击return按钮 */
- (void)keyboard:(LVKeyboardView *)keyboard didClickReturnBtn:(UIButton *)returnBtn;

@end

@interface LVKeyboardView : UIView

@property (nonatomic, assign) id<LVKeyboardDelegate> delegate;

@end
