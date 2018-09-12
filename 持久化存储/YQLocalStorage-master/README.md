# YQLocalStorage
###iOS SQLIte的封装，简单易用，带线程管理

- 本SQLite的封装的目的 是为了包装出一套更**简单易用**的数据库管理类出来，所以在有些方面会有一些限制（后面会提到），目前功能并不能说有多强大，但绝对**简单易用**，并且功能绝对够用。

---
#### 集成
-直接拖到工程中使用，或者pod 'YQLocalStorage'

```objective-c
#import "YQLocalStorage.h"
```
---
### Example Code:
### 创建/打开数据库：
- 首先确定你的数据库想存储的位置和名字
- 类似'a/b/c.sqlite'

```objective-c
YQLocalStorage *DB = [YQLocalStorage storageWithPath:@"****.sqlite"];

self.DB = DB;
```

---

### 准备好要用的表：
- 检查一遍你的表结构，如果没有就会创建
- 比如，现在要创建‘person’表，里面需要存储‘name’,'age'等信息：

```objective-c
    [self.DB checkOrCreatTableWithName:@"person"
                                  keys:@[@"name",@"age",@"sex",@"groupx",@"aaa",@"bbb"]
                                 block:^(BOOL successed, NSString * _Nullable reason)
    {
        NSLog(@"检查结果回调 :: %d,%@",successed,reason);
    }];
```
#### 说明：
- 不要传"id","creattime", "updatetime",这三个默认就有，你只需要关心你真正需要的数据。
- 只需要提供键值名称，键值类型全部使用NSString存储，遇到数字用NSNumer存也可以存的进去。
- 如果表之前没有被创建过，则会创建一次。
- 如果表已经存在，但是表的键值对和你这一次检查的不一样，那么会把以前的表删掉，然后重新创建。
- app每次运行初始化的时候都最好先检查一遍表结构，不然可能导致查询的时候出现一些小问题。
- 目前规则不够灵活，所以只建议用在小型数据存储需求上。

---

### 存储数据：

- 传入表名、需要存储的数据 即可

```objective-c
    [self.DB insertObjectWithTableName:@"person"
                            data:@{@"name":@"yangqi",
                                         @"age":@"20",
                                         @"groupx":@"freak",
                                         @"sex":@"man"
                                         }
                                 block:^(BOOL successed, NSString * _Nullable reason)
    {
        NSLog(@"保存回调 : %d,%@",successed,reason);
    }];

```

---

- **你不用担心线程问题**，我都帮你做好了
- 比如一次性存50条

```objective-c
    for (int i=0; i<50; i++) {
            NSLog(@"in loop : %d",i);
            [self.DB insertObjectWithTableName:@"person"
                                          data:@{@"name":[NSString stringWithFormat:@"yangqi%d",i],
                                                 @"age":[NSString stringWithFormat:@"%d",i+100],
                                                 @"groupx":@"freak",
                                                 @"sex":@"man"
                                                 }
                                         block:^(BOOL successed, NSString * _Nullable reason) {
                                             NSLog(@"block %d result : %d , %@",i,successed,reason);
                                         }];
        }
        
        //运行结果将是
        /*
        in loop : 0
        in loop : 1
        .
        .
        in loop : 50
        block 0 result...
        block 1 result...
        .
        .
        block 50 result...
        */ 
```

---

### 查询数据：
- 查询结果基于"YQLSSearchResultItem"类
- "YQLSSearchResultItem" 里面会包含ID、创建时间和修改时间，后面单独介绍

##### 查询API说明

- tableName : 表名
- condition : 查询条件，传nil代表不需要查询条件。要传的话类似于" age < 60 and name = 'yangqi' "
- keys : 需要查询的键值，传nil代表需要所有的key（依赖之前做的表检查），传'@[]'代表只需要ID、创建时间、修改时间，传类似'@[@"name",@"age",...]'最后取出来的结果就除了ID、创建修改时间以外 包含 你传的所需要的key。

```objective-c
- (void)searchStorageWithTableName:(NSString *)tableName
                         condition:(nullable NSString *)condition
                              Keys:(nullable NSArray<NSString *>*)keysArr
                             block:(nullable void(^)(BOOL successed,NSArray<YQLSSearchResultItem *> *_Nullable result))block;
```
- Example

```objective-c
//condition:nil代表不设查询条件
//key:nil代表取出所有key
[self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL successed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
        //NSLog(@"search : %@",result);
        for (int i=0;i<result.count ; i++) {
            YQLSSearchResultItem *item = result[i];
            //ID,创建时间(时间戳)，修改时间（时间戳）
            NSLog(@"%ld,%f,%f",item.ID,item.creatTime,item.updateTime);
            //存储的数据,是一个字典，类似{"name":"yangqi",@"age":@"20",...}
            NSLog(@"%@",item.data);
        }
    }];
```

---

#### 修改、删除、计数 
- 修改、删除API在“YQLocalStorage.h”文件中都有说明，规则基本大同小异，这里不做过多说明
- 我已经管理好了线程，block回调可以置空。

---

#### 自带串行线程管理说明
- 应用举例

```objective-c
    //打开数据库
    self.DB = [YQLocalStorage storageWithPath:@"temp.sqlite"];
    
    //准备表,回调传nil
    [self.DB checkOrCreatTableWithName:@"person"
                                  keys:@[@"name",@"age",@"sex",@"groupx",@"aaa",@"bbb"]
                                 block:nil];
    
    //直接插入，回调传nil
    [self.DB insertObjectWithTableName:@"person"
                                  data:@{@"name":@"yangqi",
                                         @"age":@"20",
                                         @"groupx":@"freak",
                                         @"sex":@"man"
                                         }
                                 block:nil];
                                 
   //直接开始查询，等回调响应的时候，能查到上一步存的数据
   [self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL successed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
            NSLog(@"search : %@",result);
        }];
        
   //直接删除所有数据
   [self.DB deleteObjectWithTableName:@"person" condition:nil block:^(BOOL successed, NSString * _Nullable reason) {
            NSLog(@"delete : %d , %@",successed,reason);
        }];
    //再直接查询一次，数据为空。
    [self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL successed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
            NSLog(@"search : %@",result);
        }];
    //连续写50条，紧接着直接查询
   for (int i=0; i<50; i++) {
       NSLog(@"in loop : %d",i);
       [self.DB insertObjectWithTableName:@"person"
                                          data:@{@"name":[NSString stringWithFormat:@"yangqi%d",i],
                                                 @"age":[NSString stringWithFormat:@"%d",i+100],
                                                 @"groupx":@"freak",
                                                 @"sex":@"man"
                                                 }
                                         block:^(BOOL successed, NSString * _Nullable reason) {
                                             NSLog(@"block %d result : %d , %@",i,successed,reason);
                                         }];
        }
   //search
   [self.DB searchStorageWithTableName:@"person" condition:nil Keys:nil block:^(BOOL successed, NSArray<YQLSSearchResultItem *> * _Nullable result) {
            NSLog(@"search : %@",result);
        }];
    
    //主线程打印,这一句会最先打印
    NSLog(@"main queue here");
```
- 最先打印出来的是最后的“NSLog(@"main queue here");”这一句的打印
- 所有的操作，都是后台线程去操作的，所以最先打印"main queue here",再去做SQL的所有操作，所以**永远不会阻塞主线程**
- YQLocalStorage里的操作都是串行的线程，所以先打印完“main queue here”之后，调用的操作，都是串行触发的，**可以保证API调用的顺序性执行**。

---

### YQLSSearchResultItem说明

- 查询出来的Item自带了ID，creatTime，updateTime
- data为查询出来的数据内容，类型为Dictionary
- 数据修改的时候，可以直接执行 item.data = @{...} ，它就会自己把新的data更新到数据库。
- 可以执行[item reloadFromLS],来根据自己的ID重新从数据库加载一次自己的数据。
- 可以执行[item deleteMyself],来把数据库中自己对应的那一条数据给删除掉。

