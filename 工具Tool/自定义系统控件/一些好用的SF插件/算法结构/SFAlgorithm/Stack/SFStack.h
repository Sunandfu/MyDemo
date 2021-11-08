//
//  SFStack.h
//  ApiTestDemo
//
//  Created by lurich on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFStack : NSObject

//栈里的元素个数
- (NSInteger)size;
//入栈
- (void)pushObject:(id)anObject;
//出栈
- (id)pop;
//清空栈里的元素
- (void)clear;
//判断栈是否为空
- (BOOL)isEmpty;
//获取栈顶的元素
- (id)peek;

@end

NS_ASSUME_NONNULL_END
