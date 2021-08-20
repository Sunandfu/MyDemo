# ZMAddressBook
iOS通讯录操作, 对通讯录进行添加,删除,修改,查询等操作.

博客地址: http://blog.csdn.net/zeng_zhiming/article/details/70141316


```Objective-C

/**
 获取通讯录联系人列表
 
 @param personSort 排序方式
 @param completionBlock 完成回调
 code 等于1成功,否则失败
 personArray 成功返回ZMPersonModel数组, 失败返回nil
 msg 成功或者失败消息
 */
- (void)getAddressBookWithSort:(PersonSort)personSort completionBlock:(void (^)(int code, NSArray<ZMPersonModel *> *personArray, NSString *msg))completionBlock;


/**
 根据RecordID查找联系人
 
 @param recordID 联系人ID
 @return ZMPersonModel对象
 */
- (ZMPersonModel *)getPersonWithRecordID:(ABRecordID)recordID;


/**
 根据Name查找联系人
 
 @param name 查找关键字
 @return ZMPersonModel数组
 */
- (NSArray<ZMPersonModel *> *)getPersonsWithName:(NSString *)name;


/**
 添加联系人到通讯录
 
 @param personModel ZMPersonModel对象
 @return 添加结果
 */
- (BOOL)addPerson:(ZMPersonModel *)personModel;


/**
 批量添加联系到通讯录
 
 @param personArray ZMPersonModel数组
 @return 添加结果
 */
- (BOOL)addPersons:(NSArray<ZMPersonModel *> *)personArray;


/**
 更新联系人
 
 @param personModel ZMPersonModel对象
 @return 更新结果
 */
- (BOOL)updatePerson:(ZMPersonModel *)personModel;


/**
 删除联系人
 
 @param personModel ZMPersonModel对象
 @return 删除结果
 */
- (BOOL)removePerson:(ZMPersonModel *)personModel;


/**
 根据RecordID删除联系人
 
 @param recordID 联系人ID
 @return 删除结果
 */
- (BOOL)removePersonWithRecordID:(ABRecordID)recordID;


```
