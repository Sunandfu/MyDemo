# JinnPopMenu
A PopMenu for iOS by jinnchang.
# Preview
![image](https://github.com/jinnchang/JinnPopMenu/blob/master/Preview/preview.gif)
# Usage
```objective-c
#import "JinnPopMenu.h"
```
* JinnPopMenuItem
```objc
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor;
- (instancetype)initWithIcon:(UIImage *)icon;
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                         icon:(UIImage *)icon;
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                selectedTitle:(NSString *)selectedTitle
           selectedTitleColor:(UIColor *)selectedTitleColor;
- (instancetype)initWithIcon:(UIImage *)icon
                selectedIcon:(UIImage *)selectedIcon;
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                selectedTitle:(NSString *)selectedTitle
           selectedTitleColor:(UIColor *)selectedTitleColor
                         icon:(UIImage *)icon
                 selectedIcon:(UIImage *)selectedIcon;             
```
* JinnPopMenu
```objc
NSArray *popMenuItems = @[popMenuItem1, popMenuItem2, popMenuItem3];
JinnPopMenu *popMenu = [[JinnPopMenu alloc] initWithPopMenuItems:popMenuItems];
[popMenu setDelegate:self];
[self.view addSubview:popMenu];
[popMenu showAnimated:YES];
```
* JinnPopMenuDelegate
```objc
- (void)itemSelectedAtIndex:(NSInteger)index popMenu:(JinnPopMenu *)popMenu;
```
# Blog
http://blog.csdn.net/jinnchang