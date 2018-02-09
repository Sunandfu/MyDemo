# LikeButton
快手点赞，喜欢，封装按钮

# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/222.gif)


# How To Use

```ruby

宏定义
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height  

#import "LikeButton.h"


LikeButton *btn = [[LikeButton alloc]initWithFrame:CGRectMake(kScreenWidth-20-50, kScreenHeight-20-50, 50, 50)];
[btn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
[btn setBackgroundImage:[UIImage imageNamed:@"btn_high"] forState:UIControlStateHighlighted];
[self.view addSubview:btn];
[btn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];

- (void)likeAction:(LikeButton *)btn {
NSLog(@"点击了按钮");
[btn wsShowInView:self.view];
}



```