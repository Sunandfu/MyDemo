# 一句话完成调用

该API和UITableView的API是差不多的

- **快速集成**
- **使用简单**
- **API仿UITableView的API哦**
- ***内存消耗超低**
- **容易扩展**

-------------------
### 看看效果图
![这里写图片描述](http://img.blog.csdn.net/20160515160443913)


## 快速继承

- github    `https://github.com/7General/HZDropDwonMneuList`
 

```
// 添加代码
self.dropMenu = [DropDownMenuList show:CGPointMake(0, 64) andHeight:44];
self.dropMenu.delegate = self;
self.dropMenu.dataSource = self;
[self.view addSubview:self.dropMenu];
```


## HZDropDownMenuList的代理
```objc
@protocol DropDownMenuListDataSouce <NSObject>
@required
// 设置显示列的内容
-(NSMutableArray *)menuNumberOfRowInColumn;
// 设置多少行显示
-(NSInteger)menu:(DropDownMenuList *)menu numberOfRowsInColum:(NSInteger)column;
// 设置显示没行的内容
-(NSString *)menu:(DropDownMenuList *)menu titleForRowAtIndexPath:(HZIndexPath *)indexPath;


@optional
// 每行图片
-(NSString *)menu:(DropDownMenuList *)menu imageNameForRowAtIndexPath:(HZIndexPath *)indexPath;

@end
```

```objc
@protocol DropDownMenuListDelegate <NSObject>
@optional
// 点击每一行的效果
- (void)menu:(DropDownMenuList *)segment didSelectRowAtIndexPath:(HZIndexPath *)indexPath;
// 点击没一列的效果
- (void)menu:(DropDownMenuList *)segment didSelectTitleAtColumn:(NSInteger)column;

@end
```
关注洲洲哥的公众号，提高装逼技能就靠他了

![这里写图片描述](http://img.blog.csdn.net/20160426092941254)


