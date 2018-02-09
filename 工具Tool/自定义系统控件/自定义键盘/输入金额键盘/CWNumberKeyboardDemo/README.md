# CWNumberKeyboardDemo


### Imitation of 闲鱼app in which prices of keyboard input control, source Alipay digital keyboard.
模仿闲鱼里面价格输入的键盘控件，图片来源支付宝内数字键盘。

### ScreenShot

![ScreenShot](https://github.com/chenwei910101/CWNumberKeyboardDemo/blob/master/ScreenShot/screenshot.gif)


### How to use
- import CWNumberKeyboard  folder
- import CWNumberKeyboard.h  folder
```objective-c
#import "CWNumberKeyboard.h"
```
- use
```objective-c
if (!_numberKb) {
        _numberKb = [[CWNumberKeyboard alloc] init];
        [self.view addSubview:_numberKb];
    }
    [_numberKb setHidden:NO];
    [_numberKb showNumKeyboardViewAnimateWithPrice:self.mPriceLabel.text andBlock:^(NSString *priceString) {
        self.mPriceLabel.text = priceString;
    }];
```


