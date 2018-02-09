//
//  TabBarAndNavagation.h
//  人云通
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTabBarAndNavagation: NSObject
@property (nonatomic,strong,)id item;
@property (nonatomic,strong,)UIColor *color;
@property (nonatomic,assign)SEL action;
- (void)initWithItem:(id)item color:(UIColor *)color action:(SEL)action;
@end

typedef void (^ZHBarItem)(ZHTabBarAndNavagation *item);

@interface TabBarAndNavagation : NSObject
/**设置tabBarItem的选中图片为原图,不进行渲染*/
+ (void)setOriginalImageFortabBarItem:(NSInteger)index toTarget:(UIViewController *)aTarget;

/**设置NavagationBar背景图片*/
+ (void)setBackImage:(NSString *)imageName ForNavagationBar:(UIViewController *)aTarget;

/**设置NavagationBar (title) 的字体颜色 */
+ (void)setTitleColor:(UIColor *)color forNavagationBar:(UIViewController *)aTarget;

/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setLeftBarButtonItemTitle:(NSString *)title TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setRightBarButtonItemTitle:(NSString *)title TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setLeftBarButtonItemSystemItem:(UIBarButtonSystemItem)SystemItem TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setRightBarButtonItemSystemItem:(UIBarButtonSystemItem)SystemItem TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setLeftBarButtonItemImageName:(NSString *)imageName TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setRightBarButtonItemImage:(NSString *)imageName TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setLeftBarButtonItemCustom:(UIView *)customVIew TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar (Left或Right) Button*/
+ (UIBarButtonItem *)setRightBarButtonItemCustom:(UIView *)customVIew TintColor:(UIColor *)color target:(UIViewController *)target action:(SEL)action;
/**设置NavagationBar Title 和 TabBar Title 的不同名字*/
+ (void)setNavagationBarTitle:(NSString *)navagationBarTitle tabBarTitle:(NSString *)tabBartitle target:(UIViewController *)target;

/**从StoryBoard中根据标识符获取UIViewController*/
+ (UIViewController *)getViewControllerFromStoryBoardWithIdentity:(NSString *)Identity;
/**pushViewController从StoryBoard中根据标识符获取*/
+ (void)pushViewController:(NSString *)viewController toTarget:(id)target pushHideTabBar:(BOOL)pushHide backShowTabBar:(BOOL)backShow;
/**pushViewController自己纯手写代码获取*/
+ (void)pushViewControllerNoStroyBoard:(UIViewController *)viewController toTarget:(id)target  pushHideTabBar:(BOOL)pushHide backShowTabBar:(BOOL)backShow;

/**设置NavagationBar (Left或Right) Button*/
+ (void)setLeftItem:(ZHBarItem)leftBarItem rightItem:(ZHBarItem)rightBarItem target:(UIViewController *)target;

@end