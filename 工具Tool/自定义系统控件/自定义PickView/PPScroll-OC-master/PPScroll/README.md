#PPScroll-OC
![](https://github.com/Fanish/PPScroll/blob/master/%E6%88%AA%E5%9B%BE0.png?raw=true)

####说明：使用了Masonry是为了方便的构建界面，可以直接将PPScroll拖入项目中使用。



##基本使用方法:
```
PPScroll *picker = [[PPScroll alloc]initWithFrame:frame];
picker.delegate = self;
[self.view addSubview:picker];
```
##代理:
```
- (void)scroll:(PPScroll *)scroll selectedIndexDic:(NSMutableDictionary *)selectedIndexDic;//所有已选择的index
- (void)scroll:(PPScroll *)scroll index:(NSInteger)index;//目标行的index
```

