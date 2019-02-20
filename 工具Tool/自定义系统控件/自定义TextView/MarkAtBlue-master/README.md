# MarkAtBlue

app中的社交功能通常需要实现新浪微博输入“@名字”时高亮类似的功能，先看一下"@名字"高亮的规则：
- 输入@之后的文字全部高亮
- 非文字字符间隔终止高亮

##### 效果图
![@名字高亮效果图](https://github.com/tom555cat/pictures/raw/master/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20Max%20-%202018-10-26%20at%2018.15.51.png)




##### 背景知识
通过TextKit来实现这一功能，看一下TextKit的结构[[1]][1]:
![TextKit结构图](https://raw.githubusercontent.com/tom555cat/pictures/master/TextKit-395e9e4e.png)

###### NSTextStorage
按照MVC的思路，NSTextStorage属于Model范畴。NSTextStorage继承自NSMutableAttributed，保存了text和text的attributes；NSTextStorage与NSMutableAttributed的区别在于当自己的内容发生变化时会发出通知。

###### UITextView
按照MVC的思路，UITextView属于View范畴。
UITextView的功能有两项：
- view视图展示功能
- 处理用户交互

###### NSTextContainer
NSTextContainer描述了文字显示的区域，通常是一个矩形。

###### NSLayoutManager
按照MVC的思路，NSLayoutManager属于Control范畴，在TextKit中是把Model和View联合起来的核心组件，它的功能包括：
- 监听NSTextStorage中text或者attribute变化通知，触发布局。
- 将NSTextStorage中的text和attribute绘制在UITextView上。

##### 实现方案
文字输入组件为UITextView，在输入的过程中，将符合高亮规则的文字range和高亮颜色attribute添加到UITextView的textStorage属性中。仅此而已，UITextView的textStorage发生变化时，会发出通知，而NSLayoutManager监听通知会处理剩下的事情。

具体的代码包括重写UITextView的delegate的"- (void)textViewDidChange:(UITextView *)"方法：
```
- (void)textViewDidChange:(UITextView *)textView
{
    // 设置高亮
    [self markAtBlue: textView.text];
}
```
还有通过正则表达式找出符合高亮规则的文字，并将attribute添加到textView.textStorage中。
```
- (void)markAtBlue:(NSString *)text
{
    NSString *sendString = text;
    [self.inputView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, sendString.length)];
    [self.inputView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, sendString.length)];
    
    NSError *error = nil;
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:@"@[\u4e00-\u9fa5a-zA-Z0-9_-]+" options:NSRegularExpressionCaseInsensitive error:&error];
    [atPersionRE enumerateMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.location != NSNotFound) {
            [self.inputView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:60/255.0 green:150/255.0 blue:255/255.0 alpha:1/1.0] range:result.range];
        }
    }];
}
```

##### 源码地址
https://github.com/tom555cat/MarkAtBlue.git

##### 参考文献
[[1]: Getting to Know TextKit](https://www.objc.io/issues/5-ios7/getting-to-know-textkit/)

[1]: https://www.objc.io/issues/5-ios7/getting-to-know-textkit/
