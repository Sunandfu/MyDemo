# AutherCode
验证码，手机验证码,不区分大小写验证码

# PhotoShoot
![image](https://github.com/Zws-China/.../blob/master/image/image/yanzhengma.gif)


# How To Use

```ruby
#import "WSAuthCode.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


WSAuthCode *wsCode = [[WSAuthCode alloc]initWithFrame:CGRectMake(50, 100, kScreenWidth-200, 40)];
[self.view addSubview:wsCode];

[wsCode reloadAuthCodeView]; //刷新验证码


//验证是否匹配
BOOL isOk = [wsCode startAuthWithString:textF.text];
if (isOk) {
    NSLog(@"验证码正确");
}else{
    NSLog(@"验证码错误");
}


```