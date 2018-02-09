# TYCircleMenu
滚轮式菜单

A circle menu in the style of wheel. 

###实现效果（Examples)
默认设置

![](default_type.gif)

设置可见数量，点击后隐藏

![](custom_type.gif)


###Waht you can do 
1, 点击按钮，显示或隐藏菜单
(click the button, show or hide menus)

2，点击具体项，获取该项的index,进而做后续操作
(Click on the specific item, gets the index of the item, and follow-up actions)

3，自定义菜单个数，无上限
(The number of custom menus, no limit)

4，自定义可见的菜单数量
(Number of custom visible menus)

5，自定义菜单图标和标题
（Custom menu icons, and the title）

###Usage
####Initialize
```objective-c
	NSArray *imageNames = @[@"test_0",@"test_1",@"test_2"];
    NSArray *titles     = @[@"one",@"two",@"three"];
    //itemOffset是第一个菜单项距离左边界的距离
    TYCircleMenu *menu = [[TYCircleMenu alloc]initWithRadious:240 itemOffset:20 imageArray:imageNames titleArray:titles menuDelegate:self];
    //以下设置为可选
    menu.visibleNum = 3;     //设置可见的菜单数量，默认是4个
    menu.isDismissWhenSelected = YES;   //点击菜单项，是否隐藏菜单，默认不隐藏
    //添加到当前视图
    [self.view addSubview:menu];
   ```

####implement protocol method
```objective-c
- (void)selectMenuAtIndex:(NSInteger)index {
    NSLog(@"选中:%zd",index);
}
```

##License
This project is under MIT License. See LICENSE file for more information.