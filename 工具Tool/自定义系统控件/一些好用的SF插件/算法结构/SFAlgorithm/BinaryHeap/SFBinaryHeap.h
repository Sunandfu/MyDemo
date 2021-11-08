//
//  SFBinaryHeap.h
//  algorithm
//
//  Created by lurich on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import "SFComparator.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBinaryHeap : NSObject

+ (instancetype _Nonnull )heapWithArray:(NSArray *)array ComparatorBlock:(_Nullable SFComparatorBlock)comparatorBlock;
+ (instancetype _Nonnull )heapWithArray:(NSArray *)array Comparator:(_Nullable id<SFComparator>)comparator;

- (BOOL)isEmpty;
- (void)clear;
- (id)get;
- (void)addObject:(id)obj;
- (id)remove;
- (id)replaceObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
