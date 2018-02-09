# SHMenu
一个轻量级菜单控件,100行代码


* 代码简洁
* 动画顺畅，可设置锚点
* 支持自定义内容控制器

<img src="http://d2.freep.cn/3tb_160415153116wuil562651.gif" />

# 如何使用
```objc
/** 自定义内容控制器 */
MenuContentViewController *menuVC = [[MenuContentViewController alloc] init];
/** x,y可不指定 */
SHMenu *menu = [[SHMenu alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
menu.contentVC = menuVC;
menu.anchorPoint = CGPointMake(1, 0);
menu.contentOrigin = CGPointMake(0, 8);
[menu showFromPoint:CGPointMake(100, 100)];
```

# 联系方式
* QQ: 1097288750