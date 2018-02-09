# UIWebView+YBProgress
* 最简单的傻瓜式webview自动加载进度条库

# 用法
- 导入` UIWebView+YBProgress.h` & ` UIWebView+YBProgress.m` 进工程即可生效
- 也可以用`- (void)yb_addProgressViewUsingBlock:(void (^) (float progress))progressBack;` 方法自己加载，获取实时的progress

# 注意
因为此库设置了`delegate`，如果您重设了`delegate`，那么会失效

此库最低支持`iOS 6.0`

如果您在使用中发现任何bug或者有更好建议，欢迎联系本人email  lyb5834@126.com
