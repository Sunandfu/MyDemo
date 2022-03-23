//
//  NSObject+CJLKVO.m
//  CJLCustom
//
//  Created by - on 2020/10/28.
//  Copyright © 2020 CJL. All rights reserved.
//

#import "NSObject+CJLKVO.h"
#import <objc/message.h>

static NSString *const kCJLKVOPrefix = @"CJLKVONotifying_";
static NSString *const kCJLKVOAssociateKey = @"kCJLKVO_AssociateKey";


#pragma mark 信息model类
@interface CJLKVOInfo : NSObject

@property(nonatomic, weak) NSObject *observer;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, assign) NSKeyValueObservingOptions options;

@property(nonatomic, copy) LGKVOBlock handleBlock;

//构造方法
- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block;

@end
@implementation CJLKVOInfo

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options{
    if (self = [super init]) {
        _observer = observer;
        _keyPath = keyPath;
        _options = options;
    }
    return self;
}

- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block{
    if (self = [super init]) {
        _observer = observer;
        _keyPath = keyPath;
        _handleBlock = block;
    }
    return self;
    
}

@end

#pragma mark 自定义KVO分类
@implementation NSObject (CJLKVO)
#pragma mark - 注册观察者 - 响应式编程
- (void)cjl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}
- (void)cjl_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    //1、验证是否存在setter方法
    [self judgeSetterMethodFromKeyPath:keyPath];
    
    //保存信息
    /*//- 仅保存一个信息
    if (!objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey))) {
         objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey), observer, OBJC_ASSOCIATION_RETAIN);
    }
    */
    //- 保存多个信息
    CJLKVOInfo *info = [[CJLKVOInfo alloc] initWithObserver:observer forKeyPath:keyPath options:options];
    //使用数组存储 -- 也可以使用map
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    if (!mArray) {//如果mArray不存在，则重新创建
        mArray = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [mArray addObject:info];
    
    
   
    
    //判断automaticallyNotifiesObserversForKey方法返回的布尔值
    BOOL isAutomatically = [self cjl_performSelectorWithMethodName:@"automaticallyNotifiesObserversForKey:" keyPath:keyPath];
    if (!isAutomatically) return;
    
    //2、动态生成子类、
    /*
        2.1 申请类
        2.2 注册
        2.3 添加方法
     */
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    //3、isa指向
    object_setClass(self, newClass);
    //4、父类 setter
    //5、观察者去响应
    
    //获取sel
    SEL setterSel = NSSelectorFromString(setterForGetter(keyPath));
    //获取setter实例方法
    Method method = class_getInstanceMethod([self class], setterSel);
    //方法签名
    const char *type = method_getTypeEncoding(method);
    //添加一个setter方法
    class_addMethod(newClass, setterSel, (IMP)cjl_setter, type);
    
}

#pragma mark - 注册观察者 - 函数式编程
- (void)cjl_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(LGKVOBlock)block{
    
    //1、验证是否存在setter方法
    [self judgeSetterMethodFromKeyPath:keyPath];
    
    //保存信息
    /*//- 仅保存一个信息
    if (!objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey))) {
         objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey), observer, OBJC_ASSOCIATION_RETAIN);
    }
    */
    //- 保存多个信息
    CJLKVOInfo *info = [[CJLKVOInfo alloc] initWithObserver:observer forKeyPath:keyPath handleBlock:block];
    //使用数组存储 -- 也可以使用map
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    if (!mArray) {//如果mArray不存在，则重新创建
        mArray = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [mArray addObject:info];
    
    //判断automaticallyNotifiesObserversForKey方法返回的布尔值
    BOOL isAutomatically = [self cjl_performSelectorWithMethodName:@"automaticallyNotifiesObserversForKey:" keyPath:keyPath];
    if (!isAutomatically) return;
    
    //2、动态生成子类、
    /*
        2.1 申请类
        2.2 注册
        2.3 添加方法
     */
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    //3、isa指向
    object_setClass(self, newClass);
    //4、父类 setter
    //5、观察者去响应
    
    //获取sel
    SEL setterSel = NSSelectorFromString(setterForGetter(keyPath));
    //获取setter实例方法
    Method method = class_getInstanceMethod([self class], setterSel);
    //方法签名
    const char *type = method_getTypeEncoding(method);
    //添加一个setter方法
    class_addMethod(newClass, setterSel, (IMP)cjl_setter, type);
    
    //进行方法交换
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////         [NSObject cjl_hookOrigInstanceMenthod:NSSelectorFromString(@"dealloc") newInstanceMenthod:@selector(myDealloc)];
//        Method oriMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
//        Method swiMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"myDealloc"));
//        method_exchangeImplementations(oriMethod, swiMethod);
//    });
  
    
}

#pragma mark - 移除观察者 - 响应式编程
- (void)cjl_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    //清空数组
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    if (mArray.count <= 0) {
        return;
    }
    
    for (CJLKVOInfo *info in mArray) {
        if ([info.keyPath isEqualToString:keyPath]) {
            [mArray removeObject:info];
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    if (mArray.count <= 0) {
        //isa指回父类
        Class superClass = [self class];
        object_setClass(self, superClass);
    }
}


#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath
{
    Class superClass = object_getClass(self);
    SEL setterSelector = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSelector);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"CJLKVO - 没有当前%@的setter方法", keyPath] userInfo:nil];
    }
    
}

#pragma mark - 动态生成子类
- (Class)createChildClassWithKeyPath:(NSString *)keyPath
{
    //获取原本的类名
    NSString  *oldClassName = NSStringFromClass([self class]);
    //拼接新的类名
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kCJLKVOPrefix,oldClassName];
    //获取新类
    Class newClass = NSClassFromString(newClassName);
    //如果子类存在，则直接返回
    if (newClass) return newClass;
    //2.1 申请类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    //2.2 注册
    objc_registerClassPair(newClass);
    //2.3 添加方法
    
    SEL classSel = @selector(class);
    Method classMethod = class_getInstanceMethod([self class], classSel);
    const char *classType = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSel, (IMP)cjl_class, classType);
    
    //添加dealloc 方法
    SEL deallocSel = NSSelectorFromString(@"dealloc");
    Method deallocMethod = class_getInstanceMethod([self class], deallocSel);
    const char *deallocType = method_getTypeEncoding(deallocMethod);
    class_addMethod(newClass, deallocSel, (IMP)cjl_dealloc, deallocType);
    
    return newClass;
}

#pragma mark - 重写setter方法，向父类发消息（响应式编程 / 函数式编程）
static void cjl_setter(id self, SEL _cmd, id newValue){
    NSLog(@"来了:%@",newValue);
    
    //此时应该有willChange的代码
    
    //往父类LGPerson发消息 - 通过objc_msgSendSuper
    //通过系统强制类型转换自定义objc_msgSendSuper
    void (*cjl_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    //定义一个结构体
    struct objc_super superStruct = {
        .receiver = self, //消息接收者 为 当前的self
        .super_class = class_getSuperclass(object_getClass(self)), //第一次快捷查找的类 为 父类
    };
    //调用自定义的发送消息函数
    cjl_msgSendSuper(&superStruct, _cmd, newValue);
    
    //此时应该有didChange的代码
    
    //让vc去响应
    //--- 仅保存一个信息的获取
   /*
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    //获取observer
    id observer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    //判断
    if (observer && [observer respondsToSelector:@selector(cjl_observeValueForKeyPath:ofObject:change:context:)]) {
        //消息发送
        [observer cjl_observeValueForKeyPath:keyPath ofObject:self change:@{keyPath: newValue} context:NULL];
    }
    */
    //--- 保存多个信息的获取
     /*-- 响应式编程
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    for (CJLKVOInfo *info in mArray) {
        NSMutableDictionary<NSKeyValueChangeKey, id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
        if ([info.keyPath isEqualToString:keyPath]) {
            
            if (info.options & NSKeyValueObservingOptionNew){
                [change setValue:newValue forKey:NSKeyValueChangeNewKey];
            }else {
                [change setValue:@"CJL旧值" forKey:NSKeyValueChangeOldKey];
                [change setValue:newValue forKey:NSKeyValueChangeNewKey];
            }
            
            //消息发送
            if (info.observer && [info.observer respondsToSelector:@selector(cjl_observeValueForKeyPath:ofObject:change:context:)]) {
                [info.observer cjl_observeValueForKeyPath:info.keyPath ofObject:self change:change context:NULL];
            }
        }
    }
    */
    
    /*---函数式编程*/
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keyPath];
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCJLKVOAssociateKey));
    for (CJLKVOInfo *info in mArray) {
        NSMutableDictionary<NSKeyValueChangeKey, id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
        if ([info.keyPath isEqualToString:keyPath] && info.handleBlock) {
            
           info.handleBlock(info.observer, keyPath, oldValue, newValue);
        }
    }
}

#pragma mark - 重写class方法，为了与系统类对外保持一致
Class cjl_class(id self, SEL _cmd){
    //在外界调用class返回CJLPerson类
    return class_getSuperclass(object_getClass(self));//通过[self class]获取会造成死循环
}

#pragma mark - 重写dealloc方法
//- (void)myDealloc{
//    [self myDealloc];
//    NSLog(@"来了");
//    Class superClass = [self class];
//    object_setClass(self, superClass);
//}

void cjl_dealloc(id self, SEL _cmd){
    NSLog(@"来了 %@", __func__);
    Class superClass = [self class];
    object_setClass(self, superClass);
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

#pragma mark -  动态调用类方法，返回调用方法的返回值
/// @param methodName 方法名
/// @param keyPath 观察属性
- (BOOL)cjl_performSelectorWithMethodName:(NSString *)methodName keyPath:(id)keyPath {

    if ([[self class] respondsToSelector:NSSelectorFromString(methodName)]) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL i = [[self class] performSelector:NSSelectorFromString(methodName) withObject:keyPath];
        return i;
#pragma clang diagnostic pop
    }
    return NO;
}

#pragma mark - 方法交换封装
+ (BOOL)cjl_hookOrigInstanceMenthod:(SEL)oriSEL newInstanceMenthod:(SEL)swizzledSEL {
    Class cls = self;
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    if (!swiMethod) {
        return NO;
    }
    if (!oriMethod) {
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, swiMethod);
    }
    return YES;
}
@end
