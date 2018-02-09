
# PPScroll

### Odd row

![](http://i4.piimg.com/006965a99d046dd4.png)

### Even row

![](http://i4.piimg.com/5f83e3b98aff3c65.png)

Another Version：[PPScroll-Swift](https://github.com/CharlieCB/PPScroll-Swift) 

##Usage:
```
PPScroll *picker = [[PPScroll alloc]initWithFrame:frame];
picker.delegate = self;
[self.view addSubview:picker];
```
##Delegate:
```
- (void)scroll:(PPScroll *)scroll selectedIndexDic:(NSMutableDictionary *)selectedIndexDic;//所有已选择的index
- (void)scroll:(PPScroll *)scroll index:(NSInteger)index;//目标行的index
```

